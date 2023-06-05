CREATE DEFINER=`root`@`%` PROCEDURE `spuCardDistribution`(IN _idClass INT)
procCall: BEGIN

	DECLARE `minimumNotFound` CONDITION FOR SQLSTATE '45000';
	DECLARE MESSAGE_TEXT VARCHAR(200);
	DECLARE _idApprentice INT;
	DECLARE _idMoment INT DEFAULT 0;
	DECLARE _studentsInClass INT DEFAULT 0;
	DECLARE _minUsersForCard INT DEFAULT 3;
	DECLARE _slotsForCard INT DEFAULT 0;	
	DECLARE _quantityOfCards INT DEFAULT 0;
	DECLARE _idSelectedTheme INT;
	DECLARE _finished INTEGER DEFAULT 0;
	DECLARE _baseAverage INT;
	DECLARE _apprenticesLeftOver INT DEFAULT 0;
	DECLARE _cardScoreOrder SMALLINT DEFAULT 1;
	DECLARE _idCardToRedistribute INT;
	DECLARE _slotsNeeded SMALLINT DEFAULT 0;
	DECLARE _moveToCard INT;
	DECLARE _slotsAvailable SMALLINT;
	DECLARE _nextScoreOrder SMALLINT DEFAULT 1;
	DECLARE _loopCounter SMALLINT DEFAULT 0;
	DECLARE _ScoreOrderControl SMALLINT DEFAULT 1;
	DECLARE _qtUsersNotAssigned SMALLINT DEFAULT 0;
	
	# Recupera os alunos da turma informada
	# declaracao do cursor para tratamento de alunos
	DECLARE _cursorUsers CURSOR 
	FOR 
	SELECT Apprentice.idApprentice 	AS idApprentice
	FROM SchoolClass
		INNER JOIN 
		SchoolGrade
			ON SchoolGrade.idSchoolGrade = SchoolClass.idSchoolGrade
		INNER JOIN 
		Grade
			ON Grade.idGrade = SchoolGrade.idGrade															
		INNER JOIN 
		Apprentice
			ON Apprentice.idClass = SchoolClass.idSchoolClass
		INNER JOIN 
		LektoUser
			ON LektoUser.idUser = Apprentice.idUser
	WHERE SchoolClass.idSchoolClass = _idClass;
	
	DECLARE CONTINUE HANDLER 
	FOR NOT FOUND SET _finished = 1;		
	
	# Definicao do tema utilizado ( Recupera temas ordenados por volume para a turma informada)
	SELECT idTheme INTO _idSelectedTheme
	FROM (
		SELECT Moment.idTheme
			, COUNT(1) AS Appearance
		FROM Moment
			INNER JOIN
			MomentCard
				ON MomentCard.idMoment = Moment.idMoment
			INNER JOIN
			Card
				ON Card.idCard = MomentCard.idCard
			INNER JOIN
			CardGrade
				ON CardGrade.idCard = Card.idCard
			INNER JOIN
			ApprenticeMoment
				ON ApprenticeMoment.idMomentCard = MomentCard.idMomentCard
			INNER JOIN
			Apprentice
				ON Apprentice.idApprentice = ApprenticeMoment.idApprentice	
			INNER JOIN
			SchoolClass
				ON SchoolClass.idSchoolClass = Apprentice.idClass
			INNER JOIN 
			SchoolGrade
				ON  SchoolGrade.idSchoolGrade = SchoolClass.idSchoolGrade
				AND SchoolGrade.idGrade = CardGrade.idGrade
		WHERE SchoolClass.idSchoolClass = _idClass		
		GROUP BY Moment.idTheme	
		) AS Theme
	ORDER BY idTheme ASC
	LIMIT 1;		
	
	# Define qual será o momento utilizado no procedimento
	SELECT idMoment
	INTO _idMoment
	FROM Moment
		INNER JOIN
		Agenda
			ON Agenda.idAgenda = Moment.idAgenda
	WHERE idSchoolClass = _idClass
	AND   coMomentStatus IN ('PEND', 'AGUA')
	AND   Agenda.dtAgenda >= NOW()
	AND   NOT EXISTS (  SELECT 1
					FROM MomentCard
					WHERE MomentCard.idMoment = Moment.idMoment )
	LIMIT 1;
	
	IF COALESCE(_idMoment, 0) = 0
	THEN		 
		INSERT INTO Moment
				(
				  idAgenda
				, coMomentStatus
				, idTheme
				, idTutor
				, idSchoolClass
				, SchoolClassStateHash
				, dtStart
				, dtFinish
				)
			VALUES 
				(
				  721
				, 'PEND'
				, _idSelectedTheme
				, 72400
				, _idClass
				, 'SchoolClassStateHash'
				, '2023-08-25'
				, '2023-08-26'
				);
				
		SET _idMoment = LAST_INSERT_ID();		
	END IF;		

	# Selecao de cards / atividades para o tema
	DROP TABLE IF EXISTS tabCard;
	
	CREATE TEMPORARY TABLE tabCard
	(
	  idTheme INT
	, idCard  INT
	, txType  CHAR(1)
	, idType  INT
	);
	
	INSERT INTO tabCard
			( idTheme, idCard, txType, idType )
	SELECT Theme.idTheme
		, Card.idCard
		, 'H'
		, Dimension.idDimension
	FROM Theme 
		INNER JOIN
		Card
			ON Card.idTheme = Theme.idTheme
		INNER JOIN 
		CardEvidence
			ON CardEvidence.idCard = Card.idCard	
		INNER JOIN 
		Evidence
			ON Evidence.idEvidence = CardEvidence.idEvidence
		INNER JOIN 
		Dimension
			ON Dimension.idDimension = Evidence.idDimension
	WHERE Theme.idTheme = _idSelectedTheme
	AND   Theme.inStatus = 1
	AND   Card.inStatus = 1
	AND   CardEvidence.inStatus = 1
	AND   Evidence.inStatus = 1
	AND   Dimension.inStatus = 1
	
	UNION
	
	SELECT Theme.idTheme
		, Card.idCard
		, 'C'
		, LearningTool.idLearningTool
	FROM Theme 
		INNER JOIN 
		Card
			ON Card.idTheme = Theme.idTheme
		INNER JOIN 
		CardLearningTool
			ON CardLearningTool.idCard = Card.idCard	
		INNER JOIN 
		LearningTool
			ON LearningTool.idLearningTool = CardLearningTool.idLearningTool
	WHERE Theme.idTheme = _idSelectedTheme
	AND   Theme.inStatus = 1
	AND   Card.inStatus = 1
	AND   CardLearningTool.inStatus = 1;	
	
	# Recupera a lista de exposicao e performance dos alunos
	DROP TABLE IF EXISTS tabStudentInfo;
	
	CREATE TEMPORARY TABLE tabStudentInfo
	(
	  idApprentice  INT
     , idCard		 INT
	, txType	      CHAR(1)
	, idType		 INT
	, Performance   DECIMAL(5,2)
	, Frequency     SMALLINT
	);

	# Inicio da execucao do cursor
	SET _finished = 0;	
	OPEN _cursorUsers;	
	
	# Numero de alunos na turma
	SET _studentsInClass = FOUND_ROWS();

	IF ( _studentsInClass < _minUsersForCard )
	THEN		 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A turma precisa de no mínimo 3 alunos.';
	   LEAVE procCall; 
	END IF;		

	getUserScore: LOOP

		FETCH _cursorUsers INTO _idApprentice;

		IF _finished = 1 THEN 
			LEAVE getUserScore;
		END IF;
		
		# Carga de dados de habilidades do tema realizadas por aluno
		INSERT INTO tabStudentInfo
				(
				  idApprentice
				, idCard  
				, txType
				, idType
				, Performance
				, Frequency
				)
		SELECT COALESCE(UserInfo.idApprentice, _idApprentice) AS idApprentice # Simulacao FULL OUTER JOIN
			, Card.idCard
			, Card.txType
			, Card.idType
			, COALESCE(UserInfo.Score, 0) AS Performance
			, COALESCE(UserInfo.Frequency, 0) AS Frequency
		FROM tabCard AS Card			
			LEFT JOIN
			(
			SELECT Theme.idTheme
				, Card.idCard
				, Dimension.idDimension
				, ApprenticeMoment.idApprentice
				, AVG(Rating.nuScore) AS Score
				, COUNT(1) AS Frequency
			FROM ApprenticeMoment
				INNER JOIN 
				MomentCard									
					ON MomentCard.idMomentCard = ApprenticeMoment.idMomentCard	
				INNER JOIN 
				Card
					ON Card.idCard = MomentCard.idCard	
				INNER JOIN
				Theme
					ON Theme.idTheme = Card.idTheme
				INNER JOIN 
				CardEvidence
					ON CardEvidence.idCard = Card.idCard	
				INNER JOIN 
				Evidence
					ON Evidence.idEvidence = CardEvidence.idEvidence
				INNER JOIN 
				Dimension
					ON Dimension.idDimension = Evidence.idDimension	
				LEFT JOIN
				ApprenticeScore
					ON ApprenticeScore.idApprenticeMoment = ApprenticeMoment.idApprenticeMoment
				LEFT JOIN
				Rating
					ON Rating.coRating = ApprenticeScore.coRating					
			WHERE ApprenticeMoment.idApprentice = _idApprentice		
			GROUP BY Theme.idTheme
				  , Card.idCard
				  , Dimension.idDimension
				  , ApprenticeMoment.idApprentice
			) UserInfo
				ON UserInfo.idTheme = Card.idTheme
				AND UserInfo.idCard = Card.idCard
				AND (UserInfo.idDimension = Card.idType AND Card.txType = 'H'); # Habilidade
		
		# Carga de dados de categorias do tema realizadas por aluno
		INSERT INTO tabStudentInfo
				(
				  idApprentice
				, idCard  
				, txType
				, idType
				, Performance
				, Frequency
				)
		SELECT COALESCE(UserInfo.idApprentice, _idApprentice) AS idApprentice # Simulacao FULL OUTER JOIN
			, Card.idCard
			, Card.txType
			, Card.idType
			, COALESCE(UserInfo.Score, 0) AS Performance
			, COALESCE(UserInfo.Frequency, 0) AS Frequency
		FROM tabCard AS Card			
			LEFT JOIN
			(
			SELECT Theme.idTheme
				, Card.idCard
				, LearningTool.idLearningTool
				, ApprenticeMoment.idApprentice
				, AVG(Rating.nuScore) AS Score
				, COUNT(1) AS Frequency
			FROM ApprenticeMoment
				INNER JOIN 
				MomentCard									
					ON MomentCard.idMomentCard = ApprenticeMoment.idMomentCard	
				INNER JOIN 
				Card
					ON Card.idCard = MomentCard.idCard	
				INNER JOIN
				Theme
					ON Theme.idTheme = Card.idTheme					
				INNER JOIN 
				CardLearningTool
					ON CardLearningTool.idCard = Card.idCard	
				INNER JOIN 
				LearningTool
					ON LearningTool.idLearningTool = CardLearningTool.idLearningTool
				LEFT JOIN
				ApprenticeScore
					ON ApprenticeScore.idApprenticeMoment = ApprenticeMoment.idApprenticeMoment
				LEFT JOIN
				Rating
					ON Rating.coRating = ApprenticeScore.coRating					
			WHERE ApprenticeMoment.idApprentice = _idApprentice		
			GROUP BY Theme.idTheme
				  , Card.idCard
				  , LearningTool.idLearningTool
				  , ApprenticeMoment.idApprentice
			) UserInfo
				ON UserInfo.idTheme = Card.idTheme
				AND UserInfo.idCard = Card.idCard
				AND (UserInfo.idLearningTool = Card.idType AND Card.txType = 'C'); # Categoria	
				
	END LOOP getUserScore;	

	CLOSE _cursorUsers;

	# Define o número de cards que será utilizado - máximo de 3 atividades por turma
	SELECT CASE WHEN _studentsInClass / _minUsersForCard > 3 
		       THEN 3
			  ELSE _studentsInClass / _minUsersForCard
		  END
	INTO _quantityOfCards;	
	
	# Define a quantidade de alunos por atividade
	SET _slotsForCard = FLOOR(_studentsInClass / _quantityOfCards); 
	
	SET _apprenticesLeftOver = MOD(_studentsInClass, _slotsForCard);

	# Realiza a carga dos dados de execução dos cards por aluno para uso posterior
	DROP TABLE IF EXISTS tabUserScore;
	
	CREATE TEMPORARY TABLE tabUserScore
	(
	  idApprentice			INT
	, idCard				INT 
	, SkillPerformance		DECIMAL
	, SkillFrequency		DECIMAL
	, CategoryPerformance	DECIMAL
	, CategoryFrequency		DECIMAL
	, ScoreOrder			SMALLINT
	);

	INSERT INTO tabUserScore
			(
			  idApprentice			
			, idCard				
			, SkillPerformance		
			, SkillFrequency		
			, CategoryPerformance	
			, CategoryFrequency	
			, ScoreOrder	
			)
     SELECT idApprentice
	     , idCard
	     , SUM(SkillPerformance) AS SkillPerformance
	     , SUM(SkillFrequency) AS SkillFrequency
	     , SUM(CategoryPerformance) AS CategoryPerformance
	     , SUM(CategoryFrequency) AS CategoryFrequency	
	     , ROW_NUMBER() OVER ( PARTITION BY idApprentice 
					       ORDER BY SUM(SkillFrequency) ASC
							    , SUM(CategoryFrequency) ASC
							    , (SUM(CategoryPerformance) - SUM(SkillPerformance)) DESC )
     FROM (
		SELECT idApprentice
			, idCard
			, SUM( CASE WHEN txType = 'H' THEN Performance ELSE 0 END ) AS SkillPerformance
			, SUM( CASE WHEN txType = 'H' THEN Frequency ELSE 0 END ) AS SkillFrequency		
			, SUM( CASE WHEN txType = 'C' THEN Performance ELSE 0 END ) AS CategoryPerformance
			, SUM( CASE WHEN txType = 'C' THEN Frequency ELSE 0 END ) AS CategoryFrequency
		FROM tabStudentInfo
		GROUP BY idApprentice
			  , idCard
			  , txType
	    ) AS Ranking
     GROUP BY idApprentice
	       , idCard;

	# Define as atividades (cards) para o momento
	DROP TABLE IF EXISTS tabCardAllocation;
	CREATE TEMPORARY TABLE tabCardAllocation
	(
	  idCard INT
	, cardOrder SMALLINT
	, allocation SMALLINT DEFAULT 0
	, slots SMALLINT DEFAULT 0
	);
	
	INSERT INTO tabCardAllocation
			( 
			  idCard
			, cardOrder 
			, allocation
			, slots
			)
	SELECT idCard
		, ROW_NUMBER() OVER ( ORDER BY COUNT(1) DESC )
		, SUM(CASE WHEN ScoreOrder = 1 THEN 1 ELSE 0 END ) AS allocation
		, _slotsForCard + (CASE WHEN ROW_NUMBER() OVER ( ORDER BY COUNT(1) DESC ) = 1 THEN 1 ELSE 0 END) AS slots
	FROM tabUserScore
	WHERE ScoreOrder < _quantityOfCards
	GROUP BY idCard;	
	
	# Processa os usuários que já estão com as atividades definidas
	DROP TABLE IF EXISTS tabMomentCard;
	CREATE TEMPORARY TABLE tabMomentCard
	(
	  idCard INT
     , idApprentice INT
	, assigned TINYINT(1)
	);
	
	INSERT INTO tabMomentCard
			( 
			  idCard
			, idApprentice
			, assigned
			)
	SELECT CardInfo.idCard
		, idApprentice
		, CASE WHEN UserInfo.Position <= CardInfo.slots 
			THEN true 
			ELSE false 
		END AS Assigned
		#, CardInfo.cardOrder
		#, CardInfo.allocation
		#, CardInfo.slots
	FROM (
		SELECT idCard
			, idApprentice
			, ROW_NUMBER() OVER ( PARTITION BY idCard ORDER BY ScoreOrder ASC ) AS Position
		FROM tabUserScore
		WHERE ScoreOrder = _ScoreOrderControl
		) AS UserInfo
		INNER JOIN
		tabCardAllocation AS CardInfo
			ON CardInfo.idCard = UserInfo.idCard;	
	
	# Busca a atividade com vagas disponíveis
	SET _qtUsersNotAssigned = _studentsInClass - (
										  SELECT COUNT(1)
										  FROM tabMomentCard
										  WHERE assigned = 0
										);

	
	WHILE _qtUsersNotAssigned > 0 DO
	
		# Atualiza o controle de alocacao
		UPDATE tabCardAllocation
			  INNER JOIN
			  (
			  SELECT idCard
				  , COUNT(1) AS allocation
			  FROM tabMomentCard
			  WHERE assigned = 1
			  GROUP BY idCard
			  ) MomentAlloc
				ON MomentAlloc.idCard = tabCardAllocation.idCard
		   SET tabCardAllocation.allocation = MomentAlloc.idCard;
						
		# Busca os registros de aderência por habilidades e categorias 
		SET _ScoreOrderControl = _ScoreOrderControl + 1;
		
		# Inclui os alunos por ordem de aderência
		INSERT INTO tabMomentCard
				( 
				  idCard
				, idApprentice
				, assigned
				)
		SELECT CardInfo.idCard
			, idApprentice
			, CASE WHEN UserInfo.Position <= CardInfo.slots 
				THEN true 
				ELSE false 
			END AS Assigned
			#, CardInfo.cardOrder
			#, CardInfo.allocation
			#, CardInfo.slots
		FROM (
			SELECT idCard
				, idApprentice
				, ROW_NUMBER() OVER ( PARTITION BY idCard ORDER BY ScoreOrder ASC ) AS Position
			FROM tabUserScore
			WHERE ScoreOrder = _ScoreOrderControl
			) AS UserInfo
			INNER JOIN
			tabCardAllocation AS CardInfo
				ON CardInfo.idCard = UserInfo.idCard;	
				
		# Verifica se ainda existem alunos sem atividades adquadas definidas
		SET _qtUsersNotAssigned = _studentsInClass - (
											  SELECT COUNT(1)
											  FROM tabMomentCard
											  WHERE assigned = 0
											);
		
		
	END WHILE;

	# Realiza a finalização da personalização e criação do momento	
	INSERT INTO MomentCard
			(
			  idMoment
			, idCard		
			)
	SELECT DISTINCT
		  _idMoment, idCard
     FROM tabMomentCard
	WHERE assigned = 1;
			
	INSERT INTO ApprenticeMoment
			(
			  idApprentice
			, idMomentCard
			, inAttendance
			)
	SELECT Assignment.idApprentice
		, MomentCard.idMomentCard
		, 0 AS inAttendance
	FROM tabMomentCard AS Assignment
		INNER JOIN
		MomentCard 
			ON MomentCard.idCard = Assignment.idCard
	WHERE MomentCard.idMoment = _idMoment
	AND   Assignment.assigned = 1;


	/* -- Validacao

	SELECT Moment.idMoment
		, MomentCard.idCard
		, ApprenticeMoment.idApprentice
	FROM Moment
		INNER JOIN
		MomentCard
			ON MomentCard.idMoment = Moment.idMoment
		INNER JOIN
		ApprenticeMoment
			ON ApprenticeMoment.idMomentCard = MomentCard.idMomentCard
	WHERE SchoolClassStateHash = 'SchoolClassStateHash'
	ORDER BY MomentCard.idCard;

	*/
END