
DROP PROCEDURE IF EXISTS `spuCreateProjectMoment`;

CREATE DEFINER=`root`@`%` PROCEDURE `spuCreateProjectMoment`( IN in_idNetwork 	 	INT
											        , in_idSchool  	 	INT
											        , in_coGrade   	 	CHAR(4)
											        , in_idSchoolYear  	SMALLINT
												   , in_idClass       	INT
												   , in_idProfessor   	INT
												   , in_idProjectTrack 	INT
												   , in_txJobId       	VARCHAR(36)
												   , in_Debugging        TINYINT 
												)
CreateProjectMoment: BEGIN

	/* Regras:
	- A turma será dividida em 3 grupos
	- Um dos projetos é eliminado	
	- Cada grupo vai trabalhar em todas as etapas do projeto
	*/
	
	# Declaracao de variaveis
     DECLARE va_SQLState           VARCHAR(1000);
     DECLARE va_SQLMessage         VARCHAR(1000);
		
	DECLARE va_NumStudents 		INT;				# Quantidade de alunos na turma			  
	DECLARE va_NumProjects 		TINYINT DEFAULT 3; 	# Quantidade de projetos selecionados para o passo 2
	DECLARE va_studentPerGroup 	TINYINT;			# Quantidade de estudantes por grupo
	DECLARE va_Logging            TINYINT DEFAULT 0;  # Criacao de Log de distribuicao
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING 
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		va_SQLState = RETURNED_SQLSTATE, va_SQLMessage = MESSAGE_TEXT;
		
          SELECT JSON_ARRAYAGG(JSON_OBJECT('error_message', CONCAT('Um erro ocorreu durante a operação [State: ', COALESCE(va_SQLState, 'N/A') , '] com a mensagem [', COALESCE(va_SQLMessage, 'N/A'), ']'))) AS Errors; 
		ROLLBACK;
		RESIGNAL;
	END;

	SET in_Debugging = IFNULL(in_Debugging, 0);
	
	# Tabela de projetos selecionados no momento
	DROP TABLE IF EXISTS tabProject;
	
	CREATE TEMPORARY TABLE tabProject
	(
	  idProject INT NOT NULL
	, coGrade   CHAR(4) NOT NULL
	, nuGroup   TINYINT NOT NULL
	);		
	
	# Tabela de dados de momento
	DROP TABLE IF EXISTS tabProjectMoment;
	
	CREATE TEMPORARY TABLE tabProjectMoment
	(
	  idProjectMoment 	INT NOT NULL
	, idNetwork 	 	INT NOT NULL
	, idSchool  	 	INT NOT NULL
	, coGrade   	 	CHAR(4) NOT NULL
	, idSchoolYear 	INT NOT NULL
	, idClass	 		INT NOT NULL
	, nuPlacement   	TINYINT NOT NULL DEFAULT 0
	, idProjectStage	INT NOT NULL
	, nuStageGroup		TINYINT NOT NULL
	);	
		
	# Carga dos alunos da turma
	DROP TABLE IF EXISTS tabStudentGroup;

	CREATE TEMPORARY TABLE tabStudentGroup
	(
	  idNetwork		INT NOT NULL
	, idSchool		INT NOT NULL
	, coGrade			CHAR(4) NOT NULL
	, idSchoolYear		INT NOT NULL
	, idClass			INT NOT NULL
	, idUserStudent     INT NOT NULL	
	, idStudent   		INT NOT NULL
	, nuPlacement 		TINYINT NOT NULL DEFAULT 0
	);	
	
	# Carga dos alunos remanescentes para distribuicao
	DROP TABLE IF EXISTS tabGroupAdjustment;

	CREATE TEMPORARY TABLE tabGroupAdjustment
	(
	  idNetwork		INT NOT NULL
	, idSchool		INT NOT NULL
	, coGrade			CHAR(4) NOT NULL
	, idSchoolYear		INT NOT NULL
	, idClass			INT NOT NULL
	, idUserStudent     INT NOT NULL	
	, idStudent   		INT NOT NULL
	, nuPlacement 		TINYINT NOT NULL DEFAULT 0
	);	
	
	# Número de alunos na turma
	SET va_NumStudents := ( SELECT COUNT(DISTINCT idStudent) 
					    FROM StudentClass StCl
					    WHERE StCl.idNetwork		= in_idNetwork
					    AND   StCl.idSchool		= in_idSchool
					    AND   StCl.coGrade		= in_coGrade
					    AND   StCl.idSchoolYear	= in_idSchoolYear
					    AND   StCl.idClass		= in_idClass );	

	# Aborta se a turma tiver menos que 5 alunos
	IF va_NumStudents < 5
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'A turma deve ter mais que 5 alunos para distribuição. O erro ocorreu na Stored Procedure: spuCreateProjectMoment.';	
	END IF;

	# Escolha dos projetos envolvidos no momento ( descarta 1 dos 4 projetos )
	INSERT INTO tabProject
			( idProject, coGrade, nuGroup )
	SELECT idProject
		, coGrade
		, ROW_NUMBER() OVER ( ORDER BY nuGroup ASC) AS nuGroup
	FROM (
		SELECT Proj.idProject
			, Proj.coGrade
			, ROW_NUMBER() OVER ( ORDER BY RAND()) AS nuGroup
		FROM ProjectTrack Trac
			INNER JOIN ProjectTrackGroup TrGr
				ON TrGr.idProjectTrack = Trac.idProjectTrack
				AND TrGr.coGrade 		 = Trac.coGrade
				AND TrGr.coComponent    = Trac.coComponent
			INNER JOIN ProjectComponent PrCo
				ON PrCo.idProject   = TrGr.idProject
				AND PrCo.coGrade 	   = TrGr.coGrade
				AND PrCo.coComponent = TrGr.coComponent
			INNER JOIN Project Proj
				ON Proj.idProject = PrCo.idProject
				AND Proj.coGrade   = PrCo.coGrade 
		WHERE Trac.idProjectTrack = in_idProjectTrack
		ORDER BY nuGroup
		LIMIT va_NumProjects
		) Projects;	
		
	## Debugging
	IF in_Debugging = 1
	THEN	
		SELECT 'tabProject', idProject FROM tabProject;		
	END IF;
		
	# Recupera os dados do momento
	INSERT INTO tabProjectMoment
			(
			  idProjectMoment
			, idNetwork 	 	
			, idSchool  	 	
			, coGrade   	 	
			, idSchoolYear 	
			, idClass	 	
			, nuPlacement
			, idProjectStage
			, nuStageGroup				
			)
	SELECT PrMo.idProjectMoment
		, PrMo.idNetwork
		, PrMo.idSchool
		, PrMo.coGrade
		, PrMo.idSchoolYear
		, PrMo.idClass
		, Proj.nuGroup AS nuPlacement
		, Stag.idProjectStage
		, Stag.nuOrder AS nuStageGroup
	FROM ProjectMoment PrMo
		INNER JOIN ProjectTrackStage TrSt
			   ON TrSt.idProjectTrackStage = PrMo.idProjectTrackStage
			  AND TrSt.coGrade			 = PrMo.coGrade
		INNER JOIN ProjectTrack Trac
			   ON Trac.idProjectTrack = TrSt.idProjectTrack
			  AND Trac.coGrade	      = TrSt.coGrade	
		INNER JOIN ProjectTrackStage PrTS
			   ON PrTS.idProjectTrackStage = PrMo.idProjectTrackStage
			  AND PrTS.coGrade 			 = PrMo.coGrade
		INNER JOIN ProjectStageGroup pStG
			   ON pStG.idProjectTrackStage = PrTS.idProjectTrackStage
		INNER JOIN ProjectStage Stag
			   ON Stag.idProjectStage = pStG.idProjectStage
		INNER JOIN tabProject Proj
			   ON Proj.idProject = Stag.idProject
			  AND Proj.coGrade = Stag.coGrade
	WHERE PrMo.idNetwork 	 = in_idNetwork
	AND   PrMo.idSchool  	 = in_idSchool
	AND   PrMo.coGrade   	 = in_coGrade
	AND   PrMo.idSchoolYear 	 = in_idSchoolYear
	AND   PrMo.idClass	 	 = in_idClass
	AND   PrMo.idProfessor 	 = in_idProfessor
	AND   Trac.idProjectTrack = in_idProjectTrack
	ORDER BY Stag.nuOrder;

	# Momento encontrado?
	IF ( SELECT COUNT(*) FROM tabProjectMoment ) = 0
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'O momento informado não foi encontrado no banco de dados. O erro ocorreu na Stored Procedure: spuCreateProjectMoment.';	
	END IF;
	
	## Debugging
	IF in_Debugging = 1
	THEN	
		SELECT 'tabProjectMoment', idProjectMoment, nuPlacement, idProjectStage, nuStageGroup FROM tabProjectMoment;	
	END IF;
	
	# Já existe registro na ProjectMomentStage para o momento informado?
	IF EXISTS ( SELECT *
			  FROM tabProjectMoment PrMo
			  WHERE EXISTS ( SELECT * 
						  FROM ProjectMomentStage MoSt
						  WHERE MoSt.idNetwork 	  = PrMo.idNetwork		
						  AND   MoSt.idSchool  	  = PrMo.idSchool
						  AND   MoSt.coGrade   	  = PrMo.coGrade
						  AND   MoSt.idSchoolYear 	  = PrMo.idSchoolYear
						  AND   MoSt.idClass	 	  = PrMo.idClass
						  AND   MoSt.idProjectMoment = PrMo.idProjectMoment )
			  LIMIT 1
	    ) 
	THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'O momento informado já possui etapas criadas. O erro ocorreu na Stored Procedure: spuCreateProjectMoment.';			
	END IF;
	
	## Logging
	IF va_Logging = 1
	THEN
		
		INSERT INTO ProjectMomentLog
				(
			       idProjectMoment      
			     , idNetwork            
			     , idSchool             
			     , coGrade              
			     , idSchoolYear         
			     , idClass              
			     , dtInserted           
			     , txLog                
				)
		SELECT DISTINCT
			  idProjectMoment
			, idNetwork 	 	
			, idSchool  	 	
			, coGrade   	 	
			, idSchoolYear 	
			, idClass	
			, NOW()
			, JSON_OBJECT('Alunos na turma para distribuicao', va_NumStudents)
		FROM tabProjectMoment;
	
	END IF;	
		
	# Numero de estudantes por grupo (para cada passo)
	SET va_studentPerGroup := ( SELECT FLOOR(va_NumStudents / va_NumProjects) );
	
	# Carga de dados dos alunos da turma - 3 Grupos distintos
	INSERT INTO tabStudentGroup
			( 
			  idNetwork		
			, idSchool		
			, coGrade			
			, idSchoolYear		
			, idClass			
			, idUserStudent     
			, idStudent 
			, nuPlacement
			)
	SELECT idNetwork		
		, idSchool		
		, coGrade			
		, idSchoolYear		
		, idClass			
		, idUserStudent     
		, idStudent
		, CEILING( ROW_NUMBER() OVER ( ORDER BY RAND() ) / va_studentPerGroup ) AS nuPlacement
	FROM StudentClass StCl
	WHERE StCl.idNetwork	= in_idNetwork
	AND   StCl.idSchool		= in_idSchool
	AND   StCl.coGrade		= in_coGrade
	AND   StCl.idSchoolYear	= in_idSchoolYear
	AND   StCl.idClass		= in_idClass
	AND   StCl.inStatus      = 1;
	
	## Debugging
	IF in_Debugging = 1
	THEN	
		SELECT 'tabStudentGroup', nuPlacement, GROUP_CONCAT( idStudent ORDER BY idStudent) AS StudentGroup 
		FROM tabStudentGroup 
		GROUP BY nuPlacement 
		ORDER BY 1, 2;	
	END IF;
	
	# Recupera os alunos fora dos grupos definidos para realizar a distribuicao equalitaria 
	IF MOD(va_NumStudents, va_NumProjects) > 0 
	THEN

		# Obs.: Update com ROW_NUMBER() nao permitido
		INSERT INTO tabGroupAdjustment
				( 
				  idNetwork		
				, idSchool		
				, coGrade			
				, idSchoolYear		
				, idClass			
				, idUserStudent     
				, idStudent 
				, nuPlacement
				)
		SELECT idNetwork		
			, idSchool		
			, coGrade			
			, idSchoolYear		
			, idClass			
			, idUserStudent     
			, idStudent 
			, ROW_NUMBER() OVER ( ORDER BY RAND() ) AS nuPlacement
		FROM tabStudentGroup
		WHERE nuPlacement > va_NumProjects;
		
		UPDATE tabStudentGroup AS Grup
			  INNER JOIN tabGroupAdjustment AS Adju
					ON Adju.idNetwork = Grup.idNetwork
				    AND Adju.idSchool  = Grup.idSchool
				    AND Adju.coGrade  = Grup.coGrade				    
				    AND Adju.idSchoolYear  = Grup.idSchoolYear				    
				    AND Adju.idClass  = Grup.idClass				    
				    AND Adju.idUserStudent  = Grup.idUserStudent				    
				    AND Adju.idStudent  = Grup.idStudent
		   SET Grup.nuPlacement = Adju.nuPlacement;

		## Debugging
		IF in_Debugging = 1
		THEN	
			SELECT nuPlacement, idStudent FROM tabGroupAdjustment ORDER BY 1, 2;	
		END IF;

	END IF;

	# Inicio da transacao
	START TRANSACTION;	
		
		# Carga das etapas dos momentos do projeto
		INSERT INTO ProjectMomentStage
				(
				  idProjectMoment      
				, idNetwork            
				, idSchool             
				, coGrade              
				, idSchoolYear         
				, idClass       
				, idProjectStage       
				, nuStageGroup         
				, dtInserted           
				)
		SELECT PrMo.idProjectMoment
			, PrMo.idNetwork
			, PrMo.idSchool
			, PrMo.coGrade
			, PrMo.idSchoolYear
			, PrMo.idClass
			, PrMo.idProjectStage
			, PrMo.nuStageGroup
			, NOW() AS dtInserted
		FROM tabProjectMoment PrMo
		ORDER BY PrMo.nuStageGroup
			  , PrMo.idProjectStage;		
			  
		## Debugging
		IF in_Debugging = 1
		THEN	
			SELECT 'ProjectMomentStage', idProjectStage, nuStageGroup FROM tabProjectMoment;			  
		END IF;

		# Carga do grupo de alunos nas etapas
		INSERT INTO ProjectMomentGroup
				(
				  idNetwork            
				, idSchool             
				, coGrade              
				, idSchoolYear         
				, idClass              
				, idProjectStage 
				, idProjectMomentStage
				, idUserStudent        
				, idStudent            
				, dtInserted           
				)
		SELECT MoSt.idNetwork            
			, MoSt.idSchool             
			, MoSt.coGrade              
			, MoSt.idSchoolYear         
			, MoSt.idClass              
			, PrMo.idProjectStage 
			, MoSt.idProjectMomentStage
			, Stud.idUserStudent        
			, Stud.idStudent            
			, NOW() AS dtInserted  
		FROM ProjectMomentStage MoSt
			INNER JOIN tabProjectMoment PrMo
				   ON PrMo.idProjectMoment 	= MoSt.idProjectMoment
				  AND PrMo.idNetwork 		= MoSt.idNetwork
				  AND PrMo.idSchool 		= MoSt.idSchool
				  AND PrMo.coGrade 			= MoSt.coGrade
				  AND PrMo.idSchoolYear 		= MoSt.idSchoolYear
				  AND PrMo.idClass 			= MoSt.idClass	
				  AND PrMo.idProjectStage 	= MoSt.idProjectStage						  
			INNER JOIN tabStudentGroup Stud
				   ON Stud.idNetwork 	= PrMo.idNetwork
				  AND Stud.idSchool 	= PrMo.idSchool		
				  AND Stud.coGrade 		= PrMo.coGrade		
				  AND Stud.idSchoolYear 	= PrMo.idSchoolYear								    
				  AND Stud.idClass 		= PrMo.idClass								    			  
		WHERE Stud.nuPlacement = PrMo.nuPlacement; # Batimento do grupo da etapa com o grupo de alunos		
		
		## Debugging
		IF in_Debugging = 1
		THEN	
			SELECT PrMo.idProjectMoment
				, PrMo.idProjectStage 
				, MoSt.idProjectMomentStage
				, GROUP_CONCAT( idStudent ORDER BY idStudent) AS StudentGroup          
			FROM ProjectMomentStage MoSt
				INNER JOIN tabProjectMoment PrMo
					   ON PrMo.idProjectMoment 	= MoSt.idProjectMoment
					  AND PrMo.idNetwork 		= MoSt.idNetwork
					  AND PrMo.idSchool 		= MoSt.idSchool
					  AND PrMo.coGrade 			= MoSt.coGrade
					  AND PrMo.idSchoolYear 		= MoSt.idSchoolYear
					  AND PrMo.idClass 			= MoSt.idClass	
					  AND PrMo.idProjectStage 	= MoSt.idProjectStage						  
				INNER JOIN tabStudentGroup Stud
					   ON Stud.idNetwork 	= PrMo.idNetwork
					  AND Stud.idSchool 	= PrMo.idSchool		
					  AND Stud.coGrade 		= PrMo.coGrade		
					  AND Stud.idSchoolYear 	= PrMo.idSchoolYear								    
					  AND Stud.idClass 		= PrMo.idClass								    			  
			WHERE Stud.nuPlacement = PrMo.nuPlacement
			GROUP BY PrMo.idProjectStage
				  , MoSt.idProjectMomentStage
			ORDER BY idProjectMoment
				  , StudentGroup; # Batimento do grupo da etapa com o grupo de alunos		
		END IF;

		# Atualiza a situacao e o job de processamento dos momentos das aulas
		UPDATE ProjectMoment PrMo
			  INNER JOIN ProjectTrackStage TrSt
					ON TrSt.idProjectTrackStage = PrMo.idProjectTrackStage
				    AND TrSt.coGrade		   = PrMo.coGrade
		   SET PrMo.coMomentStatus = 'PEND'
			, PrMo. dtProcessed   = NOW()
			, PrMo.txJobId	       = in_txJobId
		WHERE PrMo.idNetwork 	 = in_idNetwork
		AND   PrMo.idSchool  	 = in_idSchool
		AND   PrMo.coGrade   	 = in_coGrade
		AND   PrMo.idSchoolYear 	 = in_idSchoolYear
		AND   PrMo.idClass	 	 = in_idClass
		AND   PrMo.idProfessor 	 = in_idProfessor
		AND   TrSt.idProjectTrack = in_idProjectTrack;
		  
     COMMIT;

	## Logging
	IF va_Logging = 1
	THEN
		
		INSERT INTO ProjectMomentLog
				(
			       idProjectMoment      
			     , idNetwork            
			     , idSchool             
			     , coGrade              
			     , idSchoolYear         
			     , idClass              
			     , dtInserted           
			     , txLog                
				)
		SELECT DISTINCT
			  PrMo.idProjectMoment 
			, PrMo.idNetwork 	 	
			, PrMo.idSchool  	 	
			, PrMo.coGrade   	 	
			, PrMo.idSchoolYear 	
			, PrMo.idClass	
			, NOW() AS dtInserted
			, GROUP_CONCAT( Grup.idStudent )
		FROM ProjectMoment PrMo
			INNER JOIN ProjectTrackStage TrSt
				   ON TrSt.idProjectTrackStage  = PrMo.idProjectTrackStage
				  AND  TrSt.coGrade = PrMo.coGrade
			LEFT JOIN ProjectMomentStage MoSt
				   ON MoSt.idProjectMoment 	= PrMo.idProjectMoment
				  AND MoSt.idNetwork 		= PrMo.idNetwork
				  AND MoSt.idSchool 		= PrMo.idSchool
				  AND MoSt.coGrade 			= PrMo.coGrade
				  AND MoSt.idSchoolYear 		= PrMo.idSchoolYear
				  AND MoSt.idClass 			= PrMo.idClass
			LEFT JOIN ProjectMomentGroup Grup
				   ON Grup.idNetwork 			= MoSt.idNetwork
				  AND Grup.idSchool 			= MoSt.idSchool
				  AND Grup.coGrade 				= MoSt.coGrade
				  AND Grup.idSchoolYear 			= MoSt.idSchoolYear
				  AND Grup.idClass 				= MoSt.idClass
				  AND Grup.idProjectStage		= MoSt.idProjectStage
				  AND Grup.idProjectMomentStage 	= MoSt.idProjectMomentStage
			LEFT JOIN ProjectStage Stag
				   ON Stag.idProjectStage = MoSt.idProjectStage
				  AND Stag.coGrade 		 = MoSt.coGrade
		WHERE PrMo.idNetwork	  = @in_idNetwork
		AND   PrMo.idSchool		  = @in_idSchool
		AND   PrMo.coGrade		  = @in_coGrade
		AND   PrMo.idSchoolYear	  = @in_idSchoolYear
		AND   PrMo.idClass		  = @in_idClass
		AND   PrMo.idProfessor	  = @in_idProfessor
		AND   TrSt.idProjectTrack  = @in_idProjectTrack
		GROUP BY PrMo.idProjectMoment 
			  , PrMo.idNetwork 	 	
			  , PrMo.idSchool  	 	
			  , PrMo.coGrade   	 	
			  , PrMo.idSchoolYear 	
			  , PrMo.idClass	
			  , MoSt.idProjectMomentStage ;
	
	END IF;	

END	
	
	
/*

SET @in_idNetwork 		:= 6;
SET @in_idSchool  		:= 33;
SET @in_coGrade   		:= 'F2A8';
SET @in_idSchoolYear  	:= 2;
SET @in_idClass       	:= 11;
SET @in_idProfessor   	:= 6;
SET @in_idProjectTrack 	:= 1;
SET @in_txJobId       	:= 'Manual Teste Personalizacao';

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

*/		
	