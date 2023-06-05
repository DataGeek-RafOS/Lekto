
DROP PROCEDURE IF EXISTS `spuCreateLessonMoment`;

CREATE DEFINER=`root`@`%` PROCEDURE `spuCreateLessonMoment`( IN in_idNetwork 	 INT
											       , in_idSchool  	 INT
											       , in_coGrade   	 CHAR(4)
											       , in_idSchoolYear  SMALLINT
												  , in_idClass       INT
												  , in_idProfessor   INT
												  , in_idLessonTrack INT
												  , in_txJobId       VARCHAR(36)
												  )
CreateLessonMoment: BEGIN

	# Declaracao de variaveis
     DECLARE va_SQLState           VARCHAR(1000);
     DECLARE va_SQLMessage         VARCHAR(1000);
		
	DECLARE va_NumStudents 		INT;				# Quantidade de alunos na turma			  
	DECLARE va_NumActivity 		TINYINT DEFAULT 3; 	# Quantidade de atividades selecionadas para o passo 2
	DECLARE va_studentPerGroup 	TINYINT;			# Quantidade de estudantes por grupo
	
	
	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING 
	BEGIN
		ROLLBACK;
		GET DIAGNOSTICS CONDITION 1
		va_SQLState = RETURNED_SQLSTATE, va_SQLMessage = MESSAGE_TEXT;
          SELECT CONCAT('Um erro ocorreu durante a operação [State: ', COALESCE(va_SQLState, 'N/A') , '] com a mensagem [', COALESCE(va_SQLMessage, 'N/A'), ']') As sql_error; 
		RESIGNAL;
	END;
	
	# Tabelas temporarias
	
	## Tabela de dados de momento
	DROP TABLE IF EXISTS tabLessonMoment;
	
	CREATE TEMPORARY TABLE tabLessonMoment
	(
	  idLessonMoment INT NOT NULL
	, dtProcessed    DATETIME NULL  
	);
	
     ## Tabela de dados de geracao de momentos e atividades
	DROP TABLE IF EXISTS tabMomentActivity;

	CREATE TEMPORARY TABLE tabMomentActivity
	(
	  idNetwork		INT NOT NULL
	, idSchool		INT NOT NULL
	, coGrade			CHAR(4) NOT NULL
	, idSchoolYear		INT NOT NULL
	, idClass			INT NOT NULL
	, idLesson		INT NOT NULL
	, idLessonStep		INT NOT NULL
	, nuOrderStep		TINYINT NOT NULL
	, idLessonActivity	INT NOT NULL
	, nuOrderActivity	TINYINT NOT NULL
	, idLessonMoment    INT NOT NULL
	, nuGroup			TINYINT NOT NULL DEFAULT 0
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
	, nuGroup 		TINYINT NOT NULL DEFAULT 0
	);		

	# Recupera os dados do momento
	INSERT INTO tabLessonMoment
			(
			  idLessonMoment, dtProcessed 
			)
	SELECT idLessonMoment
		, dtProcessed
	FROM LessonMoment LeMo
		INNER JOIN LessonTrackGroup LtGr
			   ON LtGr.idLessonTrackGroup = LeMo.idLessonTrackGroup
		INNER JOIN LessonTrack Trac
			   ON Trac.idLessonTrack = LtGr.idLessonTrack
	WHERE LeMo.idNetwork       = in_idNetwork
	AND   LeMo.idSchool        = in_idSchool
	AND   LeMo.coGrade         = in_coGrade
	AND   LeMo.idSchoolYear    = in_idSchoolYear
	AND   LeMo.idClass         = in_idClass
	AND   LeMo.idProfessor     = in_idProfessor
	AND   Trac.idLessonTrack   = in_idLessonTrack;
	
	# Momento encontrado?
	IF ( SELECT COUNT(*) FROM tabLessonMoment ) = 0
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'O momento informado não foi encontrado.';	
	END IF;
	
	# Algum dos momentos ja processados?
	IF EXISTS ( SELECT *
			  FROM tabLessonMoment
			  WHERE dtProcessed IS NOT NULL
			)
	THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'A trilha informada já possui momentos processados.';	
	END IF;	
	
	
	# Carga de dados dos alunos da turma
	INSERT INTO tabStudentGroup
			( 
			  idNetwork		
			, idSchool		
			, coGrade			
			, idSchoolYear		
			, idClass			
			, idUserStudent     
			, idStudent   		
			)
	SELECT idNetwork		
		, idSchool		
		, coGrade			
		, idSchoolYear		
		, idClass			
		, idUserStudent     
		, idStudent
	FROM StudentClass StCl
	WHERE StCl.idNetwork	= in_idNetwork
	AND   StCl.idSchool		= in_idSchool
	AND   StCl.coGrade		= in_coGrade
	AND   StCl.idSchoolYear	= in_idSchoolYear
	AND   StCl.idClass		= in_idClass;	
	
	# Número de alunos na turma
	SET va_NumStudents := ( SELECT COUNT(DISTINCT idStudent) FROM tabStudentGroup );
	
	# Numero de estudantes por grupo (para cada passo)
	SET va_studentPerGroup := ( SELECT CEILING(va_NumStudents / va_NumActivity) );
	
	# Definacao os grupos dos alunos da turma ( ** Ajuste nesse ponto para personalizacao )
	UPDATE tabStudentGroup
		  INNER JOIN ( SELECT idNetwork		
						, idSchool		
						, coGrade			
						, idSchoolYear		
						, idClass			
						, idUserStudent     
						, idStudent   		
						, CEILING( ROW_NUMBER() OVER ( ORDER BY RAND() ) / va_studentPerGroup ) AS nuGroup
					FROM StudentClass StCl
					WHERE StCl.idNetwork	= in_idNetwork
					AND   StCl.idSchool		= in_idSchool
					AND   StCl.coGrade		= in_coGrade
					AND   StCl.idSchoolYear	= in_idSchoolYear
					AND   StCl.idClass		= in_idClass	
				   ) stuGroup	
				ON stuGroup.idNetwork	  = tabStudentGroup.idNetwork	
			    AND stuGroup.idSchool	  = tabStudentGroup.idSchool
			    AND stuGroup.coGrade		  = tabStudentGroup.coGrade
			    AND stuGroup.idSchoolYear	  = tabStudentGroup.idSchoolYear
			    AND stuGroup.idClass		  = tabStudentGroup.idClass
			    AND stuGroup.idUserStudent  = tabStudentGroup.idUserStudent   
			    AND stuGroup.idStudent   	  = tabStudentGroup.idStudent
	SET tabStudentGroup.nuGroup = stuGroup.nuGroup ;		
	
	# Carga dos dados das aulas da trilha/ProjectMomentOrientation
	INSERT INTO tabMomentActivity
			(
			  idNetwork		
			, idSchool		
			, coGrade			
			, idSchoolYear		
			, idClass			
			, idLesson		
			, idLessonStep		
			, nuOrderStep		
			, idLessonActivity	
			, nuOrderActivity	
			, idLessonMoment
			, nuGroup
			)
	SELECT LeMo.idNetwork
		, LeMo.idSchool
		, LeMo.coGrade
		, LeMo.idSchoolYear
		, LeMo.idClass
		, Less.idLesson
		, LeSt.idLessonStep
		, LeSt.nuOrder AS nuOrderStep
		, Acti.idLessonActivity
		, Acti.nuOrder
		, LeMo.idLessonMoment
		, ROW_NUMBER() OVER ( PARTITION BY Less.idLesson, LeSt.idLessonStep ORDER BY RAND() ) AS nuGroup
	FROM LessonMoment LeMo
		INNER JOIN LessonTrackGroup LtGr
			   ON LtGr.idLessonTrackGroup = LeMo.idLessonTrackGroup
		INNER JOIN LessonTrack Trac
			   ON Trac.idLessonTrack = LtGr.idLessonTrack
		INNER JOIN LessonComponent LeCo
			   ON LeCo.idLesson    = LtGr.idLesson
			  AND LeCo.coGrade     = LtGr.coGrade
			  AND LeCo.coComponent = LtGr.coComponent
		INNER JOIN Lesson Less
			   ON Less.idLesson = LeCo.idLesson
			  AND Less.coGrade  = LeCo.coGrade
		INNER JOIN LessonStep LeSt
			   ON LeSt.idLesson = Less.idLesson
			  AND LeSt.coGrade  = Less.coGrade
		INNER JOIN LessonActivity Acti
			   ON Acti.idLessonStep = LeSt.idLessonStep
			  AND Acti.coGrade      = LeSt.coGrade
	WHERE LeMo.idNetwork	= in_idNetwork
	AND   LeMo.idSchool		= in_idSchool
	AND   LeMo.coGrade		= in_coGrade
	AND   LeMo.idSchoolYear	= in_idSchoolYear
	AND   LeMo.idClass		= in_idClass
	AND   LeMo.idProfessor	= in_idProfessor
	AND   Trac.idLessonTrack	= in_idLessonTrack;
	
	
	# Inicio da transacao
	START TRANSACTION;	

		# Realiza o cadastro das atividades para o momento das aulas
		INSERT INTO LessonMomentActivity
				(
				  idNetwork            
				, idSchool             
				, coGrade              
				, idSchoolYear         
				, idClass              
				, idLessonActivity     
				, idLessonMoment       
				, dtInserted           
				)
		   SELECT idNetwork
			   , idSchool
			   , coGrade
			   , idSchoolYear
			   , idClass
			   , idLessonActivity
			   , idLessonMoment		   
			   , NOW()
		   FROM tabMomentActivity;

		# Criação dos grupos de aluno para distribuicao entre as atividades
		INSERT INTO LessonMomentGroup	
				(
				  idUserStudent        
				, idStudent            
				, idNetwork            
				, idSchool             
				, coGrade              
				, idSchoolYear         
				, idClass              
				, idLessonMomentActivity 
				, dtInserted           
				)
		SELECT Scla.idUserStudent
			, Scla.idStudent
			, Scla.idNetwork
			, Scla.idSchool
			, Scla.coGrade
			, Scla.idSchoolYear
			, Scla.idClass
			, Lmac.idLessonMomentActivity
			, NOW() AS dtInserted
		FROM tabMomentActivity tMoA
			INNER JOIN StudentClass Scla
				   ON Scla.idNetwork	= tMoA.idNetwork
				  AND Scla.idSchool		= tMoA.idSchool
				  AND Scla.coGrade		= tMoA.coGrade
				  AND Scla.idSchoolYear	= tMoA.idSchoolYear
				  AND Scla.idClass		= tMoA.idClass
			INNER JOIN LessonMomentActivity Lmac
				   ON Lmac.idNetwork		= tMoA.idNetwork
				  AND Lmac.idSchool			= tMoA.idSchool
				  AND Lmac.coGrade			= tMoA.coGrade
				  AND Lmac.idSchoolYear		= tMoA.idSchoolYear
				  AND Lmac.idClass			= tMoA.idClass
				  AND Lmac.idLessonActivity 	= tMoA.idLessonActivity
			INNER JOIN LessonActivity LeAc
				   ON LeAc.idLessonActivity = tMoA.idLessonActivity
				  AND LeAc.coGrade 		   = tMoA.coGrade
			INNER JOIN LessonStep Step
				   ON Step.idLessonStep  = LeAc.idLessonStep
				  AND Step.coGrade 		= LeAc.coGrade
			INNER JOIN tabStudentGroup tStG
				   ON tStG.idNetwork 	= Scla.idNetwork
				  AND tStG.idSchool  	= Scla.idSchool
				  AND tStG.coGrade   	= Scla.coGrade
				  AND tStG.idSchoolYear  = Scla.idSchoolYear			  
				  AND tStG.idClass   	= Scla.idClass			  			  
				  AND tStG.idUserStudent = Scla.idUserStudent			  			  
				  AND tStG.idStudent   	= Scla.idStudent			  			  						    
		WHERE ( tMoA.nuOrderStep IN (1, 3)
		OR      tStG.nuGroup = tMoA.nuGroup ); # Batimento do grupo da etapa com o grupo de alunos	
		
		# Atualiza a situacao e o job de processamento dos momentos das aulas
		UPDATE LessonMoment LeMo
			  INNER JOIN LessonTrackGroup LtGr
			   	     ON LtGr.idLessonTrackGroup = LeMo.idLessonTrackGroup
			  INNER JOIN LessonTrack Trac
				     ON Trac.idLessonTrack = LtGr.idLessonTrack
		   SET LeMo.coMomentStatus = 'PEND'
			, LeMo.dtProcessed = NOW()
	  	     , LeMo.txJobId	    = in_txJobId
		 WHERE LeMo.idNetwork       = in_idNetwork
		 AND   LeMo.idSchool        = in_idSchool
		 AND   LeMo.coGrade         = in_coGrade
		 AND   LeMo.idSchoolYear    = in_idSchoolYear
		 AND   LeMo.idClass         = in_idClass
		 AND   LeMo.idProfessor     = in_idProfessor
		 AND   Trac.idLessonTrack   = in_idLessonTrack;
		
     COMMIT;

END	
	
	
/*
CALL `spuCreateLessonMoment`( 1, 1, 'F1A1', 1, 1, 1, 2);
*/	