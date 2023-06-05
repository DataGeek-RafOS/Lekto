CREATE DEFINER=`root`@`%` PROCEDURE `spuCardDistribution`(IN _idClass INT)
BEGIN
	
	DECLARE `minimumNotFound` CONDITION FOR SQLSTATE '45000';
	DECLARE MESSAGE_TEXT VARCHAR(200);
	DECLARE _studentsInClass INT DEFAULT 0;
	DECLARE _minimumUsersForCard INT DEFAULT 3;
	
	## Get Students by Class
	CREATE TEMPORARY TABLE IF NOT EXISTS tabClassUsers
	SELECT SchoolClass.idSchoolClass   AS idClass
		, SchoolClass.txName 	     AS Class
		, SchoolGrade.idGrade 		AS idGrade
		, Grade.txGrade 			AS txGrade
		, SchoolClass.inStatus 		AS ClassStatus
		, LektoUser.txName 			AS UserName
		, Apprentice.idApprentice 	AS idApprentice
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
	
	SET _studentsInClass = (
					   SELECT COUNT(DISTINCT idApprentice) 
					   FROM tabClassUsers
					   );

	select _studentsInClass;

	IF ( _studentsInClass < _minimumUsersForCard )
	 THEN		 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A turma precisa de no mínimo 3 alunos.';
	 END IF;	
	 
	WITH cteThemeAppearance AS
		(
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
		)
	SELECT DISTINCT
		  Theme.idTheme
		, ThemeConfiguration.txTheme
		, COALESCE(ThemeAppearance.Appearance, 0) AS Appearance
	FROM Theme
			#
		INNER JOIN
		ThemeConfiguration
			ON ThemeConfiguration.idThemeConfiguration = Theme.idThemeConfiguration
			#	
		INNER JOIN
		Card
			ON Card.idTheme = Theme.idTheme
		INNER JOIN
		CardGrade
			ON CardGrade.idCard = Card.idCard
		INNER JOIN
		tabClassUsers
			ON tabClassUsers.idGrade = CardGrade.idGrade
		LEFT JOIN
		cteThemeAppearance AS ThemeAppearance
			ON ThemeAppearance.idTheme = Theme.idTheme
	ORDER BY Appearance DESC;

	# Get Themes
	#SELECT tabClassUsers.txGrade
	#	, ThemeConfiguration.txTheme
	#	, Card.idCard		
	#	, Card.txTitle
	#	, tabClassUsers.UserName
	#FROM Theme
	#	INNER JOIN 
	#	ThemeConfiguration
	#		ON ThemeConfiguration.idThemeConfiguration = Theme.idThemeConfiguration
	#	INNER JOIN 
	#	Card
	#		ON Card.idTheme = Theme.idTheme
	#	INNER JOIN 
	#	CardGrade
	#		ON CardGrade.idCard = Card.idCard
	#	INNER JOIN 
	#	MomentCard									
	#		ON MomentCard.idCard = Card.idCard
	#	INNER JOIN 
	#	ApprenticeMoment
	#		ON  ApprenticeMoment.idMomentCard = MomentCard.idMomentCard
	#	INNER JOIN 
	#	tabClassUsers
	#		ON  tabClassUsers.idApprentice = ApprenticeMoment.idApprentice
	#		AND tabClassUsers.idGrade = CardGrade.idGrade;
							
     # Get Skills (Competencia)								
	SELECT tabClassUsers.UserName
		, Skill.txSkill
		, COUNT(1) AS Frequency
		, AVG(COALESCE(ApprenticeScore.coRating, 0)) AS AvgPerformance
	FROM tabClassUsers
		INNER JOIN 
		ApprenticeMoment
			ON ApprenticeMoment.idApprentice = tabClassUsers.idApprentice			
		INNER JOIN 
		MomentCard									
			ON MomentCard.idMomentCard = ApprenticeMoment.idMomentCard	
		INNER JOIN 
		Card
			ON Card.idCard = MomentCard.idCard	
		LEFT JOIN 
		CardEvidence
			ON CardEvidence.idCard = Card.idCard	
		LEFT JOIN 
		Evidence
			ON Evidence.idEvidence = CardEvidence.idEvidence
		LEFT JOIN 
		Dimension
				ON Dimension.idDimension = Evidence.idDimension
		LEFT JOIN 
		Skill
			ON Skill.idSkill = Dimension.idSkill
		LEFT JOIN 
		ApprenticeScore
			ON ApprenticeScore.idEvidence = Evidence.idEvidence
			AND ApprenticeScore.idApprenticeMoment = ApprenticeMoment.idApprenticeMoment
	GROUP BY tabClassUsers.UserName
	       , Skill.txSkill;			
				
     # Get Learning Tools (Categoria)								
	SELECT tabClassUsers.UserName
		, LearningTool.txLearningTool
		, COUNT(1) AS Frequency
		, AVG(COALESCE(ApprenticeScore.coRating, 0)) AS AvgPerformance		
	FROM tabClassUsers
		INNER JOIN 
		ApprenticeMoment
			ON ApprenticeMoment.idApprentice = tabClassUsers.idApprentice			
		INNER JOIN 
		MomentCard									
			ON MomentCard.idMomentCard = ApprenticeMoment.idMomentCard	
		INNER JOIN 
		Card
			ON Card.idCard = MomentCard.idCard	
		LEFT JOIN 
		CardLearningTool
			ON CardLearningTool.idCard = Card.idCard					
		LEFT JOIN 
		LearningTool
			ON LearningTool.idLearningTool = CardLearningTool.idLearningTool
		LEFT JOIN 
		CardEvidence
			ON CardEvidence.idCard = Card.idCard	
		LEFT JOIN 
		Evidence
			ON Evidence.idEvidence = CardEvidence.idEvidence				
		LEFT JOIN 
		ApprenticeScore
			ON ApprenticeScore.idEvidence = Evidence.idEvidence
			AND ApprenticeScore.idApprenticeMoment = ApprenticeMoment.idApprenticeMoment				
	GROUP BY tabClassUsers.UserName
	       , LearningTool.txLearningTool;			
								
				

END