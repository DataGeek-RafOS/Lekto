SET @in_txJobId := 'Geração Manual';



SELECT @in_idNetwork := a.idNetwork
	, @in_idSchool := a.idSchool
	, @in_coGrade := a.coGrade
	, @in_idSchoolYear := a.idSchoolYear
	, @in_idClass := a.idClass
	, @in_idProfessor := a.idProfessor
	, @id_LessonTrack := b.idLessonTrack
	, @in_idLessonMoment := MIN(idLessonMoment) 
FROM LessonMoment a
	INNER JOIN LessonTrackGroup b
		   ON b.idLessonTrackGroup = a.idLessonTrackGroup
WHERE a.idLessonMoment = 353
GROUP BY a.idNetwork
	  , a.idSchool
	  , a.coGrade
	  , a.idSchoolYear
	  , a.idClass
	  , a.idProfessor
	  , b.idLessonTrackGroup
	  
/*
SELECT @in_idNetwork := a.idNetwork
	, @in_idSchool := a.idSchool
	, @in_coGrade := a.coGrade
	, @in_idSchoolYear := a.idSchoolYear
	, @in_idClass := a.idClass
	, @in_idProfessor := a.idProfessor
	, @in_idProjectTrack := b.idProjectTrack
	, @in_idProjectMoment := MIN(idProjectMoment) 
FROM ProjectMoment a
	INNER JOIN ProjectTrackStage b
		   ON b.idProjectTrackStage = a.idProjectTrackStage
		  AND b.coGrade = a.coGrade
WHERE a.coMomentStatus = 'PEND'
AND   a.txJobId NOT LIKE 'Gera%'
GROUP BY a.idNetwork
	  , a.idSchool
	  , a.coGrade
	  , a.idSchoolYear
	  , a.idClass
	  , a.idProfessor
	  , b.idProjectTrack
HAVING SUM(CASE WHEN coMomentStatus = 'PEND' THEN 1 ELSE 0 END) = 4
ORDER BY 1, 2, 3, 4, 5, 6
LIMIT 1;
*/

SELECT LeMo.idNetwork
	, LeMo.idSchool
	, LeMo.coGrade
	, LeMo.idSchoolYear
	, LeMo.idClass
	, LeMo.idProfessor
	, LeMo.idLessonTrackGroup
	, LeMo.dtProcessed
	, LeMo.dtSchedule	
	, LeMo.coMomentStatus
	, GROUP_CONCAT( LeMo.idLessonMoment ORDER BY LeMo.idLessonMoment) AS Momentos
FROM LessonMoment LeMo
	INNER JOIN LessonTrackGroup TrGr
		   ON TrGr.idLessonTrackGroup = LeMo.idLessonTrackGroup
	INNER JOIN (
			 SELECT a.*, b.idLessonTrack
			 FROM LessonMoment a
				INNER JOIN LessonTrackGroup b
					   ON b.idLessonTrackGroup = a.idLessonTrackGroup			 
			 WHERE a.idLessonMoment = @in_idLessonMoment	
			 ) Mome
		   ON Mome.idNetwork 	= LeMo.idNetwork
		  AND Mome.idSchool 	= LeMo.idSchool
		  AND Mome.coGrade 		= LeMo.coGrade
		  AND Mome.idSchoolYear 	= LeMo.idSchoolYear
		  AND Mome.idClass 		= LeMo.idClass		  
		  AND Mome.idProfessor 	= LeMo.idProfessor
		  AND Mome.idLessonTrack = TrGr.idLessonTrack
GROUP BY LeMo.idNetwork
	  , LeMo.idSchool
	  , LeMo.coGrade
	  , LeMo.idSchoolYear
	  , LeMo.idClass
	  , LeMo.idProfessor
	  , LeMo.idLessonTrackGroup
	  , LeMo.dtProcessed
	  , LeMo.dtSchedule	
	  , LeMo.coMomentStatus;
		  


		
START TRANSACTION;

DELETE MoGr
FROM LessonMomentGroup MoGr
	INNER JOIN LessonMomentActivity MoAc
		   ON MoGr.idNetwork = MoAc.idNetwork
		  AND MoGr.idSchool = MoAc.idSchool
		  AND MoGr.coGrade = MoAc.coGrade
		  AND MoGr.idSchoolYear = MoAc.idSchoolYear
		  AND MoGr.idClass = MoAc.idClass
		  AND MoGr.idLessonMomentActivity = MoAc.idLessonMomentActivity		
	INNER JOIN LessonMoment Mome
		   ON Mome.idNetwork		= MoAc.idNetwork
		  AND Mome.idSchool			= MoAc.idSchool
		  AND Mome.coGrade			= MoAc.coGrade
		  AND Mome.idSchoolYear		= MoAc.idSchoolYear
		  AND Mome.idClass			= MoAc.idClass
		  AND Mome.idLessonMoment	= MoAc.idLessonMoment
	INNER JOIN LessonTrackGroup TrGr
		   ON TrGr.idLessonTrackGroup = Mome.idLessonTrackGroup		  
WHERE MoAc.idLessonMoment IN (353,354,355,356);

DELETE MoAc
FROM LessonMomentActivity MoAc
	INNER JOIN LessonMoment Mome
		   ON Mome.idNetwork		= MoAc.idNetwork
		  AND Mome.idSchool			= MoAc.idSchool
		  AND Mome.coGrade			= MoAc.coGrade
		  AND Mome.idSchoolYear		= MoAc.idSchoolYear
		  AND Mome.idClass			= MoAc.idClass
		  AND Mome.idLessonMoment	= MoAc.idLessonMoment
WHERE MoAc.idLessonMoment IN (353,354,355,356);

UPDATE LessonMoment
SET coMomentStatus = 'AGEN', dtProcessed = NULL, txJobId = null 
WHERE idLessonMoment IN (353,354,355,356);

COMMIT;	


CALL `spuCreateLessonMoment`
(
  @in_idNetwork 	 
, @in_idSchool  	
, @in_coGrade   	
, @in_idSchoolYear  
, @in_idClass       
, @in_idProfessor   
, @in_idLessonTrack 
, @in_txJobId       
);			


SELECT @in_idNetwork := a.idNetwork
	, @in_idSchool := a.idSchool
	, @in_coGrade := a.coGrade
	, @in_idSchoolYear := a.idSchoolYear
	, @in_idClass := a.idClass
	, @in_idProfessor := a.idProfessor
	, @id_LessonTrack := b.idLessonTrack
	, @in_idLessonMoment := MIN(idLessonMoment) 
FROM LessonMoment a
	INNER JOIN LessonTrackGroup b
		   ON b.idLessonTrackGroup = a.idLessonTrackGroup
WHERE a.idLessonMoment = 353
GROUP BY a.idNetwork
	  , a.idSchool
	  , a.coGrade
	  , a.idSchoolYear
	  , a.idClass
	  , a.idProfessor
	  , b.idLessonTrack;
	  



SELECT LeMo.idLessonMoment AS Momento
	, LeAc.nuOrder AS EtapaProjeto 
	, MoAc.idLessonMomentActivity AS MomentoGerado
	, LeMo.coMomentStatus
	, GROUP_CONCAT( Grup.idStudent ORDER BY Grup.idStudent) AS Alunos
FROM LessonMoment LeMo
	INNER JOIN LessonTrackGroup TrGr
		   ON TrGr.idLessonTrackGroup = LeMo.idLessonTrackGroup
	LEFT JOIN LessonMomentActivity MoAc	
		   ON MoAc.idNetwork		= LeMo.idNetwork
		  AND MoAc.idSchool			= LeMo.idSchool
		  AND MoAc.coGrade			= LeMo.coGrade
		  AND MoAc.idSchoolYear		= LeMo.idSchoolYear
		  AND MoAc.idClass			= LeMo.idClass
		  AND MoAc.idLessonMoment	= LeMo.idLessonMoment
	LEFT JOIN LessonActivity LeAc
		   ON LeAc.idLessonActivity = MoAc.idLessonActivity
		  AND LeAc.coGrade = MoAc.coGrade
	LEFT JOIN LessonMomentGroup Grup
		   ON Grup.idNetwork = MoAc.idNetwork
		  AND Grup.idSchool = MoAc.idSchool
		  AND Grup.coGrade = MoAc.coGrade
		  AND Grup.idSchoolYear = MoAc.idSchoolYear
		  AND Grup.idClass = MoAc.idClass
		  AND Grup.idLessonMomentActivity = MoAc.idLessonMomentActivity							 
WHERE LeMo.idNetwork	 = @in_idNetwork
AND   LeMo.idSchool		 = @in_idSchool
AND   LeMo.coGrade		 = @in_coGrade
AND   LeMo.idSchoolYear	 = @in_idSchoolYear
AND   LeMo.idClass		 = @in_idClass
AND   LeMo.idProfessor	 = @in_idProfessor
AND   TrGr.idLessonTrack  = @in_idLessonTrack
GROUP BY LeMo.idLessonMoment 
	  , LeAc.nuOrder
	  , MoAc.idLessonMomentActivity 
	  , LeMo.coMomentStatus;





/*


SELECT LeMo.idLessonMoment AS Momento
	, LeAc.nuOrder AS EtapaAula
	, MoAc.idLessonMomentActivity AS MomentoGerado
	, LeMo.coMomentStatus
	, GROUP_CONCAT( Grup.idStudent ORDER BY Grup.idStudent) AS Alunos
FROM LessonMoment LeMo
	INNER JOIN LessonTrackGroup TrGr
		   ON TrGr.idLessonTrackGroup = LeMo.idLessonTrackGroup
	LEFT JOIN LessonMomentActivity MoAc	
		   ON MoAc.idNetwork		= LeMo.idNetwork
		  AND MoAc.idSchool			= LeMo.idSchool
		  AND MoAc.coGrade			= LeMo.coGrade
		  AND MoAc.idSchoolYear		= LeMo.idSchoolYear
		  AND MoAc.idClass			= LeMo.idClass
		  AND MoAc.idLessonMoment	= LeMo.idLessonMoment
	LEFT JOIN LessonActivity LeAc
		   ON LeAc.idLessonActivity = MoAc.idLessonActivity
		  AND LeAc.coGrade = MoAc.coGrade
	LEFT JOIN LessonMomentGroup Grup
		   ON Grup.idNetwork = MoAc.idNetwork
		  AND Grup.idSchool = MoAc.idSchool
		  AND Grup.coGrade = MoAc.coGrade
		  AND Grup.idSchoolYear = MoAc.idSchoolYear
		  AND Grup.idClass = MoAc.idClass
		  AND Grup.idLessonMomentActivity = MoAc.idLessonMomentActivity							 
WHERE LeMo.idNetwork	 = 1
AND   LeMo.idSchool		 = 308
AND   LeMo.coGrade		 = 'F1A2'
AND   LeMo.idSchoolYear	 = 1
AND   LeMo.idClass		 = 9728
AND   LeMo.idProfessor	 = 4216
AND   TrGr.idLessonTrack  = 14
GROUP BY LeMo.idLessonMoment 
	  , LeAc.nuOrder
	  , MoAc.idLessonMomentActivity 
	  , LeMo.coMomentStatus
	  
	  

CALL `spuCreateLessonMoment`
(
  1 	 
, 308  	
, 'F1A2'   	
, 1  
, 9728       
, 4216   
, 14 
, 'Geração Manual'       
);				  



SELECT * 
FROM LessonMoment LeMo
	INNER JOIN LessonMomentActivity MoAc	
		   ON MoAc.idNetwork		= LeMo.idNetwork
		  AND MoAc.idSchool			= LeMo.idSchool
		  AND MoAc.coGrade			= LeMo.coGrade
		  AND MoAc.idSchoolYear		= LeMo.idSchoolYear
		  AND MoAc.idClass			= LeMo.idClass
		  AND MoAc.idLessonMoment	= LeMo.idLessonMoment
	INNER JOIN LessonActivity LeAc
		   ON LeAc.idLessonActivity = MoAc.idLessonActivity	
	INNER JOIN LessonStep Step
		   ON Step.idLessonStep = LeAc.idLessonStep AND Step.coGrade = LeAc.coGrade
WHERE LeMo.idLessonMoment = 353		   

*/