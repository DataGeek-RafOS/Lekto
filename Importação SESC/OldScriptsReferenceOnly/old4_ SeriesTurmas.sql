

ALTER TABLE Grade MODIFY COLUMN txGrade VARCHAR(100) NOT NULL;		

## Importacao Series/Turmas
SELECT *  -- 1402
FROM tmp4_SESC_SeriesTurmas sesc;


## De acordo com o João, seria só do 1º ao 9º ano do ensino fundamental
DELETE sesc
FROM tmp4_SESC_SeriesTurmas sesc
WHERE NomeSerie LIKE '%CRECHE%'
OR    NomeSerie LIKE '%PRE%'
OR    NomeSerie LIKE '%MÉDIO%';


UPDATE tmp4_SESC_SeriesTurmas
	 SET NomeSerie = CASE WHEN NomeSerie = '1º ANO - ENSINO FUNDAMENTAL' THEN '1º ANO'  
												WHEN NomeSerie = '1º ANO - EF' THEN '1º ANO' 
												WHEN NomeSerie = '2º ANO - ENSINO FUNDAMENTAL' THEN '2º ANO'  
												WHEN NomeSerie = '2º ANO - EF' THEN '2º ANO' 
												WHEN NomeSerie = '3º ANO - ENSINO FUNDAMENTAL' THEN '3º ANO'  
												WHEN NomeSerie = '3º ANO - EF' THEN '3º ANO' 
												WHEN NomeSerie = '4º ANO - ENSINO FUNDAMENTAL' THEN '4º ANO'  
												WHEN NomeSerie = '4º ANO - EF' THEN '4º ANO' 
												WHEN NomeSerie = '5º ANO - ENSINO FUNDAMENTAL' THEN '5º ANO'  
												WHEN NomeSerie = '5º ANO - EF' THEN '5º ANO' 
												WHEN NomeSerie = '6º ANO - ENSINO FUNDAMENTAL' THEN '6º ANO'  
												WHEN NomeSerie = '6º ANO - EF' THEN '6º ANO' 
												WHEN NomeSerie = '7º Ano - ENSINO FUNDAMENTAL' THEN '7º ANO'  
												WHEN NomeSerie = '7º ANO - EF' THEN '7º ANO' 
												WHEN NomeSerie = '8º ANO - EF' THEN '8º ANO' 
												WHEN NomeSerie = '9º ANO - EF' THEN '9º ANO' 		 
												ELSE NomeSerie
									END;





# Grades
INSERT INTO Grade (txGrade)
SELECT DISTINCT NomeSerie
FROM tmp4_SESC_SeriesTurmas sesc
WHERE NOT EXISTS ( SELECT 1 
			    FROM Grade
			    WHERE txGrade = sesc.NomeSerie );
    
			    
# SchoolGrades
INSERT INTO SchoolGrade
(
  idSchool
, idGrade
, inStatus
, dtInserted
)
SELECT DISTINCT
	  scho.idSchool	, idGrade
	, 1 AS inStatus
	, NOW() AS dtInserted
FROM tmp4_SESC_SeriesTurmas sesc
	INNER JOIN
	School scho
		ON scho.txCnpj = sesc.CNPJEscola
	INNER JOIN
	Grade grad
		ON grad.txGrade = sesc.NomeSerie
WHERE NOT EXISTS ( SELECT 1 
									 FROM SchoolGrade 
									 WHERE SchoolGrade.idSchool = scho.idSchool 
									 AND SchoolGrade.idGrade = grad.idGrade );




# SchoolClass
INSERT INTO SchoolClass
(
  idSchoolGrade
, txName
, inStatus
, dtInserted
, useBeacon
, idTutor
)
SELECT DISTINCT
	  scgr.idSchoolGrade
	, sesc.NomeTurma AS txName
	, 1 AS inStatus
	, NOW() AS dtInserted
	, 0 AS useBeacon
	, NULL AS idTutor
FROM tmp4_SESC_SeriesTurmas sesc
	INNER JOIN
	School scho
		ON scho.txCnpj = sesc.CNPJEscola
	INNER JOIN
	Grade grad
		ON grad.txGrade = sesc.NomeSerie
	INNER JOIN
	SchoolGrade scgr
		ON scgr.idSchool = scho.idSchool
		AND scgr.idGrade = grad.idGrade
  LEFT JOIN  LektoUser lusr
			ON lusr.txCpf = sesc.CPFTutor
WHERE NOT EXISTS (
									SELECT 1 
									FROM SchoolClass
									WHERE SchoolClass.idSchoolGrade = scgr.idSchoolGrade
									AND   SchoolClass.txName = sesc.NomeTurma);
		


 ### CREATE TEMPORARY TABLE tabDelSChoolClass
 ### SELECT distinct idSchoolClass
 ### FROM tmp4_SESC_SeriesTurmas sesc
 ### 	INNER JOIN
 ### 	School scho
 ### 		ON scho.txCnpj = sesc.CNPJEscola
 ### 	INNER JOIN
 ### 	Grade grad
 ### 		ON grad.txGrade = sesc.NomeSerie
 ### 	INNER JOIN
 ### 	SchoolGrade scgr
 ### 		ON scgr.idSchool = scho.idSchool
 ### 		AND scgr.idGrade = grad.idGrade
 ### 	INNER JOIN
 ### 	SchoolClass
 ### 			ON SchoolClass.idSchoolGrade = scgr.idSchoolGrade;
 ### 
 ### DELETE FROM SchoolClass
 ### WHERE idSchoolClass IN ( SELECT idSchoolClass FROM tabDelSChoolClass );
 
 
 -- SELECT * FROM SchoolClass WHERE dtInserted >= '2022-07-30 00:00'
			
## WeekDays / TimeTable
SELECT DISTINCT 
	  DiasAula, HoraInicio, HoraTermino
FROM tmp4_SESC_SeriesTurmas;

SELECT * FROM Weekday;

CREATE TEMPORARY TABLE TimeTableSESC AS
(
SELECT 2 AS idWeekDay, '07:30' AS dtStart, '11:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 3 AS idWeekDay, '07:30' AS dtStart, '11:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 4 AS idWeekDay, '07:30' AS dtStart, '11:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 5 AS idWeekDay, '07:30' AS dtStart, '11:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 6 AS idWeekDay, '07:30' AS dtStart, '11:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 2 AS idWeekDay, '13:30' AS dtStart, '17:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 3 AS idWeekDay, '13:30' AS dtStart, '17:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 4 AS idWeekDay, '13:30' AS dtStart, '17:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 5 AS idWeekDay, '13:30' AS dtStart, '17:50' AS dtEnd, NOW() AS dtInserted
 UNION
SELECT 6 AS idWeekDay, '13:30' AS dtStart, '17:50' AS dtEnd, NOW() AS dtInserted
)

INSERT INTO Timetable (idWeekday, dtStart, dtEnd, dtInserted)
SELECT idWeekday, dtStart, dtEnd, dtInserted
FROM TimeTableSESC sesc
WHERE NOT EXISTS ( SELECT 1
			    FROM Timetable tita
			    WHERE tita.idWeekday = sesc.idWeekday
			    AND tita.dtStart = sesc.dtStart
			    AND tita.dtEnd = sesc.dtEnd );


# SchoolClassTimeTable - Precisa?

#SELECT School.txName
#	, Grade.txGrade
#	, SchoolClass.txName
#FROM School
#	INNER JOIN
#	SchoolNetwork
#		ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork
#	INNER JOIN
#	SchoolGrade 
#		ON SchoolGrade.idSchool = School.idSchool
#	INNER JOIN
#	Grade
#		ON Grade.idGrade = SchoolGrade.idGrade
#	LEFT JOIN
#	SchoolClass
#		ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
#WHERE SchoolNetwork.txName = 'SESC/DF';
	

	

