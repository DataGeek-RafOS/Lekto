DROP PROCEDURE IF EXISTS spuSegmentDistribution;

DELIMITER $$

CREATE 
DEFINER=`root`@`%`
PROCEDURE spuSegmentDistribution (IN  
                                     in_idClass INT
                                   , in_idSegment INT
                                   , in_dtAgendaStage01 DATE
                                   , in_dtAgendaStage02 DATE                                   
                                   , in_dtAgendaStage03 DATE                                                                      
                                   , in_dtAgendaStage04 DATE                                                                                                         
                                   , in_SchoolClassStateHash VARCHAR(256)
                                   , in_jobId VARCHAR(36)
                                   )
     BEGIN

          # Definicao das variaveis
          DECLARE _vStage INT;
          DECLARE _vSegment INT;
          DECLARE _idAgenda INT;
          DECLARE _idMoment INT;
          DECLARE _idProject INT;		
          DECLARE _idCard INT;				
          DECLARE _idTheme INT;		
          DECLARE _idTutor INT;
          DECLARE _idMomentCard INT;		
		DECLARE _dtAgenda DATE;
          DECLARE _dtTimeStart TIME;
          DECLARE _dtTimeEnd TIME;
		DECLARE _projectCounter INT DEFAULT 1;		
          DECLARE _StudentsInClass SMALLINT;
          DECLARE _usersForProject SMALLINT;
          DECLARE _usersLeftOver SMALLINT;
          DECLARE _minUsersForCard SMALLINT;
          DECLARE _projectsInSegment TINYINT  DEFAULT 0;
          DECLARE _projectScoreOrder TINYINT  DEFAULT 0;
		DECLARE _stageMoment TINYINT DEFAULT 0;

          # Criacao das tabelas temporarias
          DROP TABLE IF EXISTS tabClass;

          CREATE TEMPORARY TABLE tabClass
          (
          idApprentice int
          );

          DROP TABLE IF EXISTS tabSegmentInfo;

          CREATE TEMPORARY TABLE tabSegmentInfo
          (
          idProject INT,
          idCard INT,
		idTheme INT,
          txType CHAR(1), # Categoria ou Habilidade
          idType INT,      # id das tabelas
		nuOrder SMALLINT
          );

          # Levanta os alunos da turma e performance por card
          DROP TABLE IF EXISTS tabStudentInfo;

          CREATE TEMPORARY TABLE tabStudentInfo
          (
          idApprentice INT,
          idProject    INT,
          idCard       INT,
          txType       CHAR(1),
          idType       INT,
          Performance  DECIMAL(5, 2),
          Frequency    SMALLINT
          );

          # Monta a tabela de calculo para alocação   
          DROP TABLE IF EXISTS tabUserScoreHistory;

          CREATE TEMPORARY TABLE tabUserScoreHistory
          (
          idApprentice        INT,
          idProject           INT,
          SkillPerformance    DECIMAL,
          SkillFrequency      DECIMAL,
          CategoryPerformance DECIMAL,
          CategoryFrequency   DECIMAL,
          ScoreOrder          SMALLINT
          );

          # Monta a tabela de calculo para alocação   
          DROP TABLE IF EXISTS tabProjectUser;

          CREATE TEMPORARY TABLE tabProjectUser
          (
          idProject     INT,
          idApprentice  INT
          );

          # Tabela de controle de "vagas" para cada projeto  
          DROP TABLE IF EXISTS tabProjectSlots;

          CREATE TEMPORARY TABLE tabProjectSlots
          (
          idProject INT,
          allocation INT,
          slots SMALLINT,
		sequence SMALLINT
          );
		
		# Tabela de momentos gerados
          DROP TABLE IF EXISTS tabMomentProcessed;

          CREATE TEMPORARY TABLE tabMomentProcessed
          (
          idMoment INT,
		idTheme INT
          );		

          # Persiste temporariamente os dados de ALUNOS da turma para reuso
          INSERT INTO tabClass
               (
               idApprentice
               )
               SELECT Apprentice.idApprentice
               FROM Apprentice
               WHERE Apprentice.idClass = in_idClass;

          # Recupera o número de alunos na turma e valida se alcança o número minimo
          SET _StudentsInClass = (SELECT COUNT(*) FROM tabClass);

          IF (_StudentsInClass < 3)
          THEN
               SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'A turma precisa de no mínimo 3 alunos.';
          END IF;

          # Número de projetos configurados na trilha
          SELECT COUNT(DISTINCT Project.idProject)
               INTO _projectsInSegment
          FROM Segment
               INNER JOIN Project
                    ON Project.idSegment = Segment.idSegment
               INNER JOIN ProjectStage
                    ON ProjectStage.idProject = Project.idProject
          WHERE Segment.idSegment = in_idSegment;

          # Definicao: 
          #    1. Quantidade de projetos alocados
          #    2. Alunos por projeto
          #    3. Restantes que serão alocados no último projeto
          SET _usersForProject = (SELECT _StudentsInClass / _projectsInSegment);  

          SET _usersLeftOver = MOD(_studentsInClass, _projectsInSegment);

          # Validacao de configuracoes da turma
          SELECT Stage.idStage
               INTO _vStage
          FROM School
               INNER JOIN SchoolGrade
                    ON SchoolGrade.idSchool = School.idSchool
               INNER JOIN Grade
                    ON Grade.idGrade = SchoolGrade.idGrade
               INNER JOIN GradeStage
                    ON GradeStage.idGrade = Grade.idGrade
               INNER JOIN Stage
                    ON Stage.idStage = GradeStage.idStage
               INNER JOIN SchoolClass
                    ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
          WHERE SchoolClass.idSchoolClass = in_idClass;

          IF _vStage <> 3
          THEN
               SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'A turma informada não está cadastrada para o ensino fundamental II.';
          END IF;
		
          # Persiste os dados (atividades / habilidades ) da trilha (segment) para reuso
          INSERT INTO tabSegmentInfo
               (
               idProject,
               idCard,
			idTheme,
               txType,
               idType,
			nuOrder			
               )
               SELECT Project.idProject
                    , ProjectStage.idCard
				, CardSkill.idTheme
                    , 'H' AS txType
                    , CardSkill.idDimension AS idType
				, ROW_NUMBER() OVER (ORDER BY Project.idProject) AS nuOrder				
               FROM Segment
                    INNER JOIN Project 
                         ON Project.idSegment = Segment.idSegment
                    INNER JOIN ProjectStage
                         ON ProjectStage.idProject = Project.idProject
                    INNER JOIN vwCardSkill CardSkill
                            ON CardSkill.idCard = ProjectStage.idCard
               WHERE Segment.idSegment = in_idSegment;
		
          # Persiste os dados ( atividades / habilidades ) da trilha (segment) para reuso
          INSERT INTO tabSegmentInfo
               (
               idProject,
               idCard,
			idTheme,
               txType,
               idType,
			nuOrder
               )
               SELECT Project.idProject
                    , ProjectStage.idCard
				, CardCategory.idTheme
                    , 'C' AS txType
                    , CardCategory.idLearningTool AS idType
				, ROW_NUMBER() OVER (ORDER BY Project.idProject) AS nuOrder
               FROM Segment
                    INNER JOIN Project
                            ON Project.idSegment = Segment.idSegment
                    INNER JOIN ProjectStage
                            ON ProjectStage.idProject = Project.idProject
                    INNER JOIN vwCardCategory CardCategory
                            ON CardCategory.idCard = ProjectStage.idCard
               WHERE Segment.idSegment = in_idSegment;
			
			   
          # Vinculacao de todos alunos da turma para todas a as atividades
          ## Simulacao de FULL OUTER JOIN ( MySQL sem suporte atualmente )
          INSERT INTO tabStudentInfo
               (
               idApprentice,
               idProject, 
               idCard,
               txType,
               idType
               )
               SELECT Class.idApprentice,
                      SegmentInfo.idProject,
                      SegmentInfo.idCard,
                      SegmentInfo.txType,
                      SegmentInfo.idType
               FROM tabClass Class
                    CROSS JOIN tabSegmentInfo SegmentInfo;

          # Monta a tabela de score de usuários com ordenação / Realiza a definição de rankings
            INSERT INTO tabUserScoreHistory
                 (
                 idApprentice,
                 idProject,
                 SkillPerformance,
                 SkillFrequency,
                 CategoryPerformance,
                 CategoryFrequency,
                 ScoreOrder
                 )

           WITH cteUserScore
             AS (
               SELECT StudentInfo.idApprentice
                    , StudentInfo.idProject
                    , StudentInfo.idType
                    , StudentInfo.txType
                    
                    # , CASE WHEN StudentInfo.txType = 'H' THEN CardSkill.txDimension ELSE CardCategory.txLearningTool END
                    
                    , SUM(COALESCE(Rating.nuScore, 0)) AS Score
                    , SUM(CASE WHEN Rating.nuScore IS NOT NULL THEN 1 ELSE 0 END) AS Frequency
               FROM tabStudentInfo AS StudentInfo
                    LEFT JOIN Card
                           ON Card.idCard = StudentInfo.idCard
                    LEFT JOIN vwCardSkill AS CardSkill
                           ON CardSkill.idCard = Card.idCard
                          AND CardSkill.idDimension = StudentInfo.idType
                          AND StudentInfo.txType = 'H'
                    LEFT JOIN vwCardCategory AS CardCategory
                           ON CardCategory.idCard = Card.idCard
                          AND CardCategory.idLearningTool = StudentInfo.idType
                          AND StudentInfo.txType = 'C'
                    LEFT JOIN ApprenticeMoment
                           ON ApprenticeMoment.idApprentice = StudentInfo.idApprentice
                    LEFT JOIN MomentCard 
                           ON MomentCard.idMomentCard = ApprenticeMoment.idMomentCard
                          AND MomentCard.idCard = Card.idCard
                    LEFT JOIN ApprenticeScore
                           ON ApprenticeScore.idApprenticeMoment = ApprenticeMoment.idApprenticeMoment
                    LEFT JOIN Rating
                           ON Rating.coRating = ApprenticeScore.coRating
                GROUP BY StudentInfo.idApprentice
                       , StudentInfo.idProject
                       , StudentInfo.idType
                       , StudentInfo.txType  
                       # , CASE WHEN StudentInfo.txType = 'H' THEN CardSkill.txDimension ELSE CardCategory.txLearningTool END 
                )
 
           SELECT idApprentice 
                , idProject
                , Ranking.SkillPerformance
                , Ranking.SkillFrequency
                , Ranking.CategoryPerformance
                , Ranking.CategoryFrequency
                , ROW_NUMBER() OVER ( PARTITION BY idApprentice
                                      ORDER BY SUM(SkillFrequency) ASC
                                             , SUM(CategoryFrequency) ASC
                                             , SUM(CategoryPerformance) - SUM(SkillPerformance) DESC ) AS ScoreOrder
           FROM (     -- Define o Ranking para cada card realizado para o aluno
                SELECT UserScore.idApprentice 
                     , UserScore.idProject
                     , AVG(CASE WHEN UserScore.txType = 'H' THEN UserScore.Score ELSE 0 END) AS SkillPerformance
                     , SUM(CASE WHEN UserScore.txType = 'H' THEN UserScore.Frequency ELSE 0 END) AS SkillFrequency
                     , AVG(CASE WHEN UserScore.txType = 'C' THEN UserScore.Score ELSE 0 END) AS CategoryPerformance
                     , SUM(CASE WHEN UserScore.txType = 'C' THEN UserScore.Frequency ELSE 0 END) AS CategoryFrequency
                FROM cteUserScore AS UserScore
                GROUP BY UserScore.idApprentice
                       , UserScore.idProject
                ORDER BY UserScore.idApprentice, UserScore.idProject
                ) AS Ranking
           GROUP BY Ranking.idApprentice
                  , Ranking.idProject;

          # Define o número de vagas para cada projeto
          INSERT INTO tabProjectSlots
               (
               idProject,
               allocation,
               slots,
			sequence
               )
          SELECT idProject
               , 0 # SUM(CASE WHEN ScoreOrder = 1 THEN 1 ELSE 0 END) AS allocation
               , _usersForProject + CASE WHEN _usersLeftOver >= ROW_NUMBER() OVER (ORDER BY COUNT(1) DESC) 
                                         THEN 1 
                                         ELSE 0
                                    END AS slots
			, ROW_NUMBER() OVER (ORDER BY idProject ASC) AS sequence
		FROM tabUserScoreHistory
		GROUP BY idProject
		ORDER BY idProject;
		
		IF _projectsInSegment > 4
          THEN
               SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = 'A trilha não pode conter mais que 4 projetos.';
          END IF;
				

          # Processo de alocação de aprendizes nos projetos          
          loopAllocation: WHILE _projectCounter <= _projectsInSegment
                          DO     

                              INSERT INTO tabProjectUser
                                   (
                                   idProject,
                                   idApprentice
                                   )
						SELECT Alloc.idProject
							, Alloc.idApprentice
						FROM (
                                SELECT idProject
                                     , idApprentice
                                     , ROW_NUMBER() OVER (PARTITION BY idProject ORDER BY ScoreOrder ASC, idApprentice ASC) Ranking
                                 FROM tabUserScoreHistory
							) Alloc
                                   INNER JOIN tabProjectSlots ProjectSlots
                                           ON ProjectSlots.idProject = Alloc.idProject
                              WHERE Alloc.Ranking <= (ProjectSlots.slots - ProjectSlots.allocation);
						
						# Atualiza os contadores de alocação
                              UPDATE tabProjectSlots AS ProjectSlots
                              INNER JOIN (
                                         SELECT idProject
                                              , COUNT(1) AS Allocation
                                         FROM tabProjectUser
                                         GROUP BY idProject
                                         ) AS Allocated
                                      ON Allocated.idProject = ProjectSlots.idProject
                              SET ProjectSlots.allocation = Allocated.allocation
						WHERE ProjectSlots.slots <> 0;
						
						# Exclusão de alunos já alocados em algum projeto
						DELETE FROM tabUserScoreHistory
						WHERE idProject = _projectCounter;
						
						SET _projectCounter =_projectCounter + 1;

                          END WHILE;

		# Processo de alocação de aprendizes nos projetos          
          loopMoment: WHILE _projectsInSegment > _stageMoment
                      DO     
						
					SET _stageMoment = _stageMoment + 1;
					
					# Define a data do momento a ser gerado
					SELECT CASE WHEN _stageMoment = 1 THEN in_dtAgendaStage01
							  WHEN _stageMoment = 2 THEN in_dtAgendaStage02
							  WHEN _stageMoment = 3 THEN in_dtAgendaStage03
							  WHEN _stageMoment = 4 THEN in_dtAgendaStage04
					END
					INTO _dtAgenda;

					# Busca o tema da atividade
					SELECT DISTINCT SegmentInfo.idTheme
					INTO _idTheme
					FROM tabSegmentInfo SegmentInfo
						LEFT JOIN tabMomentProcessed Moments
							  ON Moments.idTheme = SegmentInfo.idTheme
					WHERE Moments.idTheme IS NULL
					ORDER BY SegmentInfo.idTheme ASC
					LIMIT 1;
					
					# Realiza a criacao do momento
					CALL spuCreateMoment( in_idClass
									, _dtAgenda
									, in_schoolClassStateHash
									, in_jobId
									, _idTheme
									, _idMoment );
									
					# Vincula o moment as atividades do project na sequencia informada
					INSERT INTO MomentCard 
						( idMoment
						, idCard 
						)
					SELECT DISTINCT 
						  _idMoment
						, Card.idCard
					FROM ProjectStage
						INNER JOIN Card
							   ON Card.idCard = ProjectStage.idCard
						INNER JOIN Theme
							   ON Theme.idTheme = Card.idTheme
					WHERE Theme.idTheme = _idTheme;
					
					SET _idMomentCard = LAST_INSERT_ID();
					
					# Insere os momentos gerados para busca posterior
					INSERT INTO tabMomentProcessed (idMoment, idTheme)
					VALUES (_idMoment, _idTheme );
									
                      END WHILE;		
				  
				  
			# Vincula aprendizes ao momento
			INSERT INTO ApprenticeMoment
				(
				idApprentice,
				idMomentCard,
				inAttendance
				)
			SELECT ProjectUser.idApprentice
				, MomentCard.idMomentCard
				, NULL AS inAttendance
			FROM tabMomentProcessed Moment
				INNER JOIN MomentCard 
					   ON MomentCard.idMoment = Moment.idMoment
				INNER JOIN Card
					   ON Card.idCard = MomentCard.idCard
				INNER JOIN ProjectStage
					   ON ProjectStage.idCard = Card.idCard
				INNER JOIN tabProjectUser ProjectUser
					   ON ProjectUser.idProject = ProjectStage.idProject
			ORDER BY MomentCard.idMomentCard ASC
				  , ProjectUser.idApprentice ASC
				  , Card.idCard ASC;
		  
          # debug
		/*
          SELECT 'Tabelas temporárias criadas' AS debug
          UNION
          SELECT CONCAT('Num. de alunos na turma: ', _StudentsInClass)
          UNION
          SELECT CONCAT('Projetos na trilha: ', _projectsInSegment)
          UNION
          SELECT CONCAT('Alunos por projeto: ', _usersForProject)
          UNION
          SELECT CONCAT('Alunos sem alocação: ', _usersLeftOver)
          UNION
          SELECT 'A turma é do Fundamental II'
          UNION
          SELECT 'Busca as habilidades das atividades definidas para a trilha'
          UNION
          SELECT 'Busca as categorias das atividades definidas para a trilha'
          UNION
          SELECT 'Monta a matriz da turma e cards';				
		*/
		
	# Retorno de dados para o MongoDB
	SELECT Apprentice.idApprentice
		, Segment.idSegment AS SegmentName
		, Segment.txName
		, Project.txName AS ProjectName
		, ProjectStage.idCard AS CardStage
		, Card.txTitle
		, Card.txCard
		, Moment.idMoment
		, Moment.coMomentStatus
		, Apprentice.idClass
	FROM Segment
		INNER JOIN Project 
			   ON Project.idSegment = Segment.idSegment
		INNER JOIN ProjectStage
			   ON ProjectStage.idProject = Project.idProject
		INNER JOIN Card
			   ON Card.idCard = ProjectStage.idCard
		INNER JOIN MomentCard
			   ON MomentCard.idCard = Card.idCard
		INNER JOIN Moment
			   ON Moment.idMoment = MomentCard.idMoment
		INNER JOIN ApprenticeMoment
			   ON ApprenticeMoment.idMomentCard = MomentCard.idMomentCard
		INNER JOIN Apprentice
			   ON Apprentice.idApprentice = ApprenticeMoment.idApprentice
	WHERE Moment.idMoment IN ( SELECT idMoment FROM tabMomentProcessed );		

/* Script para debugging

START TRANSACTION;

CALL spuSegmentDistribution(68, 1, '2023-01-01', '2023-01-02', '2023-01-03', '2023-01-04', 'hashtesteFundII', '54E95881-D3A2-4946-B138-DA730E286A89');                               

SELECT Segment.idSegment AS SegmentName
     , Segment.txName
     , Project.idProject
     , Project.txName AS ProjectName
     , ProjectStage.idCard AS CardStage
     , Card.txTitle
     , Card.txCard
     , Moment.idMoment
     , Moment.coMomentStatus
     , ApprenticeMoment.idApprentice
     , Apprentice.idApprentice
     , Apprentice.idClass
FROM Segment
     INNER JOIN Project 
             ON Project.idSegment = Segment.idSegment
     INNER JOIN ProjectStage
             ON ProjectStage.idProject = Project.idProject
     LEFT JOIN  Card
             ON Card.idCard = ProjectStage.idCard
     LEFT JOIN  MomentCard
             ON MomentCard.idCard = Card.idCard
     LEFT JOIN  Moment
             ON Moment.idMoment = MomentCard.idMoment
     LEFT JOIN  ApprenticeMoment
             ON ApprenticeMoment.idMomentCard = MomentCard.idMomentCard
     LEFT JOIN  Apprentice
             ON Apprentice.idApprentice = ApprenticeMoment.idApprentice
WHERE Project.idSegment = 1
AND  Apprentice.idClass = 115;

ROLLBACK;        



SELECT idSchoolClass, COUNT(1)
FROM School
	INNER JOIN SchoolGrade
		ON SchoolGrade.idSchool = School.idSchool
	INNER JOIN Grade
		ON Grade.idGrade = SchoolGrade.idGrade
	INNER JOIN GradeStage
		ON GradeStage.idGrade = Grade.idGrade
	INNER JOIN Stage
		ON Stage.idStage = GradeStage.idStage
	INNER JOIN SchoolClass
		ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
	INNER JOIN Apprentice
			ON Apprentice.idClass = SchoolClass.idSchoolClass
WHERE Stage.idStage = 3	
GROUP BY idSchoolClass;


ROLLBACK;        



                      
*/


END$$

DELIMITER ;


