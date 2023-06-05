SET @in_txJobId := 'Geração Manual';
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
WHERE a.idProjectMoment = 353
GROUP BY a.idNetwork
	  , a.idSchool
	  , a.coGrade
	  , a.idSchoolYear
	  , a.idClass
	  , a.idProfessor
	  , b.idProjectTrack
	  
	  
select * 
from Professor p
	inner join LektoUser l on p.idUserProfessor = l.idUser
where idProfessor = 5236	  

select *
from School
where idSchool = 391;

select * from Class where idClass = 11669

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

SELECT PrMo.idNetwork
	, PrMo.idSchool
	, PrMo.coGrade
	, PrMo.idSchoolYear
	, PrMo.idClass
	, PrMo.idProfessor
	, Trac.idProjectTrack
	, PrMo.dtProcessed
	, PrMo.dtSchedule	
	, PrMo.coMomentStatus
	, GROUP_CONCAT( PrMo.idProjectMoment ORDER BY PrMo.idProjectMoment) AS Momentos
FROM ProjectMoment PrMo
	INNER JOIN ProjectTrackStage TrSt
		   ON TrSt.idProjectTrackStage = PrMo.idProjectTrackStage
		  AND TrSt.coGrade			 = PrMo.coGrade
	INNER JOIN ProjectTrack Trac
		   ON Trac.idProjectTrack = TrSt.idProjectTrack
		  AND Trac.coGrade	      = TrSt.coGrade	
	INNER JOIN (
			 SELECT a.*
			 	 , b.idProjectTrack
			 FROM ProjectMoment a
			   	 INNER JOIN ProjectTrackStage b
			 	 	    ON b.idProjectTrackStage = a.idProjectTrackStage
			 		   AND b.coGrade = a.coGrade
			 WHERE a.idProjectMoment = @in_idProjectMoment	
			 ) Mome
		   ON Mome.idNetwork = PrMo.idNetwork
		  AND Mome.idSchool = PrMo.idSchool
		  AND Mome.coGrade = PrMo.coGrade
		  AND Mome.idSchoolYear = PrMo.idSchoolYear
		  AND Mome.idClass = PrMo.idClass		  
		  AND Mome.idProfessor = PrMo.idProfessor
		  AND Mome.idProjectTrack = Trac.idProjectTrack
GROUP BY PrMo.idNetwork
	  , PrMo.idSchool
	  , PrMo.coGrade
	  , PrMo.idSchoolYear
	  , PrMo.idClass
	  , PrMo.dtSchedule
	  , PrMo.idProfessor
	  , Trac.idProjectTrack
	  , PrMo.dtProcessed
	  , PrMo.coMomentStatus;
		  
	


		
START TRANSACTION;

DELETE ProjectMomentGroup
FROM ProjectMomentGroup
	INNER JOIN ProjectMomentStage
		   ON ProjectMomentStage.idNetwork = ProjectMomentGroup.idNetwork
		  AND ProjectMomentStage.idSchool = ProjectMomentGroup.idSchool
		  AND ProjectMomentStage.coGrade = ProjectMomentGroup.coGrade
		  AND ProjectMomentStage.idSchoolYear = ProjectMomentGroup.idSchoolYear
		  AND ProjectMomentStage.idClass = ProjectMomentGroup.idClass
		  AND ProjectMomentStage.idProjectMomentStage = ProjectMomentGroup.idProjectMomentStage
     INNER JOIN ProjectMoment
	        ON ProjectMoment.idProjectMoment = ProjectMomentStage.idProjectMoment
		  AND ProjectMoment.idNetwork = ProjectMomentStage.idNetwork
		  AND ProjectMoment.idSchool = ProjectMomentStage.idSchool
		  AND ProjectMoment.coGrade = ProjectMomentStage.coGrade
		  AND ProjectMoment.idSchoolYear = ProjectMomentStage.idSchoolYear
		  AND ProjectMoment.idClass = ProjectMomentStage.idClass										   		  
WHERE ProjectMoment.idNetwork		 	= @in_idNetwork
AND   ProjectMoment.idSchool		 	= @in_idSchool
AND   ProjectMoment.coGrade		 	= @in_coGrade
AND   ProjectMoment.idSchoolYear	 	= @in_idSchoolYear
AND   ProjectMoment.idClass		 	= @in_idClass
AND   ProjectMoment.idProfessor	 	= @in_idProfessor
AND   ProjectMoment.idProjectMoment IN (658,659,660,661);

DELETE ProjectMomentStage
FROM ProjectMomentStage
     INNER JOIN ProjectMoment
	        ON ProjectMoment.idProjectMoment = ProjectMomentStage.idProjectMoment
		  AND ProjectMoment.idNetwork = ProjectMomentStage.idNetwork
		  AND ProjectMoment.idSchool = ProjectMomentStage.idSchool
		  AND ProjectMoment.coGrade = ProjectMomentStage.coGrade
		  AND ProjectMoment.idSchoolYear = ProjectMomentStage.idSchoolYear
		  AND ProjectMoment.idClass = ProjectMomentStage.idClass										   		  
WHERE ProjectMoment.idNetwork		 	= @in_idNetwork
AND   ProjectMoment.idSchool		 	= @in_idSchool
AND   ProjectMoment.coGrade		 	= @in_coGrade
AND   ProjectMoment.idSchoolYear	 	= @in_idSchoolYear
AND   ProjectMoment.idClass		 	= @in_idClass
AND   ProjectMoment.idProfessor	 	= @in_idProfessor
AND   ProjectMoment.idProjectMoment IN (658,659,660,661);

UPDATE ProjectMoment
SET coMomentStatus = 'AGEN', dtProcessed = NULL, txJobId = null 
WHERE idProjectMoment IN (658,659,660,661);

COMMIT	;	


CALL `spuCreateProjectMoment`
(
  @in_idNetwork   	 	
, @in_idSchool  		
, @in_coGrade   		
, @in_idSchoolYear  	
, @in_idClass       	
, @in_idProfessor   	
, @in_idProjectTrack 	
, @in_txJobId       		
);			



SELECT ProjectMoment.idProjectMoment AS Momento
	, ProjectStage.nuOrder AS EtapaProjeto 
	, ProjectMomentStage.idProjectMomentStage AS MomentoGerado
	, ProjectMoment.coMomentStatus
	, GROUP_CONCAT( ProjectMomentGroup.idStudent ORDER BY ProjectMomentGroup.idStudent) AS Alunos
FROM ProjectMoment 
	INNER JOIN ProjectTrackStage
		   ON ProjectTrackStage.idProjectTrackStage = ProjectMoment.idProjectTrackStage
	LEFT JOIN ProjectMomentStage 
		   ON  ProjectMomentStage.idProjectMoment = ProjectMoment.idProjectMoment
		  AND ProjectMomentStage.idNetwork = ProjectMoment.idNetwork
		  AND ProjectMomentStage.idSchool = ProjectMoment.idSchool
		  AND ProjectMomentStage.coGrade = ProjectMoment.coGrade
		  AND ProjectMomentStage.idSchoolYear = ProjectMoment.idSchoolYear
		  AND ProjectMomentStage.idClass = ProjectMoment.idClass
	LEFT JOIN ProjectMomentGroup 
		   ON  ProjectMomentGroup.idProjectMomentStage = ProjectMomentStage.idProjectMomentStage
		  AND ProjectMomentGroup.idNetwork = ProjectMomentStage.idNetwork
		  AND ProjectMomentGroup.idSchool = ProjectMomentStage.idSchool
		  AND ProjectMomentGroup.coGrade = ProjectMomentStage.coGrade
		  AND ProjectMomentGroup.idSchoolYear = ProjectMomentStage.idSchoolYear
		  AND ProjectMomentGroup.idClass = ProjectMomentStage.idClass
	LEFT JOIN ProjectStage
		   ON ProjectStage.idProjectStage = ProjectMomentStage.idProjectStage
		  AND ProjectStage.coGrade = ProjectMomentStage.coGrade
WHERE ProjectMoment.idNetwork		 	= @in_idNetwork
AND   ProjectMoment.idSchool		 	= @in_idSchool
AND   ProjectMoment.coGrade		 	= @in_coGrade
AND   ProjectMoment.idSchoolYear	 	= @in_idSchoolYear
AND   ProjectMoment.idClass		 	= @in_idClass
AND   ProjectMoment.idProfessor	 	= @in_idProfessor
AND   ProjectTrackStage.idProjectTrack  = @in_idProjectTrack
GROUP BY 	 ProjectMoment.idProjectMoment 
	, ProjectStage.nuOrder 
	, ProjectMoment.coMomentStatus
	, ProjectMomentStage.idProjectMomentStage ;

SELECT * FROM ProjectMomentLog WHERE idProjectMoment = 353;		




SELECT Mome.idProjectMoment
	, ClassStudents
	, MomentStudents
FROM ProjectMoment Mome
	INNER JOIN ( SELECT StCl.idNetwork
				   , StCl.idSchool
				   , StCl.coGrade
				   , StCl.idSchoolYear
				   , StCl.idClass
				   , COUNT(StCl.idStudent) AS ClassStudents
			   FROM Class Clas
				   INNER JOIN StudentClass StCl
				           ON StCl.idClass = Clas.idClass
						AND StCl.idNetwork = Clas.idNetwork
						AND StCl.idSchool = Clas.idSchool
						AND StCl.coGrade = Clas.coGrade
						AND StCl.idSchoolYear = Clas.idSchoolYear
			   WHERE StCl.inStatus = 1
			   GROUP BY StCl.idNetwork
				     , StCl.idSchool
				     , StCl.coGrade
				     , StCl.idSchoolYear
					, StCl.idClass
			 ) AS Clas				
		   ON Mome.idClass		= Clas.idClass
		  AND Mome.idNetwork	= Clas.idNetwork
		  AND Mome.idSchool		= Clas.idSchool
		  AND Mome.coGrade		= Clas.coGrade
		  AND Mome.idSchoolYear  = Clas.idSchoolYear
	INNER JOIN ( SELECT MoSt.idProjectMoment
				   , MoSt.idNetwork
				   , MoSt.idSchool
				   , MoSt.coGrade
				   , MoSt.idSchoolYear
				   , MoSt.idClass
				   , COUNT(DISTINCT Grup.idStudent) MomentStudents
			   FROM ProjectMomentStage MoSt
				   INNER JOIN ProjectMomentGroup Grup
					      ON Grup.idNetwork			= MoSt.idNetwork
						AND Grup.idSchool			= MoSt.idSchool
						AND Grup.coGrade			= MoSt.coGrade
						AND Grup.idSchoolYear		= MoSt.idSchoolYear
						AND Grup.idClass			= MoSt.idClass
						AND Grup.idProjectMomentStage	= MoSt.idProjectMomentStage
			   GROUP BY MoSt.idProjectMoment
				     , MoSt.idNetwork
				     , MoSt.idSchool
				     , MoSt.coGrade
				     , MoSt.idSchoolYear
				     , MoSt.idClass
			 ) AS Grup
		   ON Mome.idProjectMoment	= Grup.idProjectMoment
		  AND Mome.idNetwork		= Grup.idNetwork
		  AND Mome.idSchool			= Grup.idSchool
		  AND Mome.coGrade			= Grup.coGrade
		  AND Mome.idSchoolYear  	= Grup.idSchoolYear	
		  AND Mome.idClass  		= Grup.idClass		
WHERE MomentStudents <> ClassStudents
	