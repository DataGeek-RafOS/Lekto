DROP PROCEDURE IF EXISTS `spuCardDistribution`;

CREATE DEFINER=`root`@`%` PROCEDURE `spuCardDistribution`
     ( IN 
       in_idClass INT,
       in_dtAgenda DATE, 
       in_schoolClassStateHash VARCHAR(256), 
       in_jobId VARCHAR(36), 
       in_idTheme SMALLINT
     )
BEGIN

     DECLARE v_errorMessage varchar(1000);
     DECLARE v_idThemeDefined INT;
     DECLARE v_idMoment INT;
     DECLARE v_studentsInClass INT;
     DECLARE v_quantityOfCards INT DEFAULT 0;
     DECLARE v_slotsForCard INT DEFAULT 0;
     DECLARE v_apprenticesLeftOver int DEFAULT 0;     
     DECLARE v_minUsersForCard INT DEFAULT 3;
     DECLARE v_cardOrder INT DEFAULT 0;     
     DECLARE v_allocCard INT DEFAULT 0;
     DECLARE v_allocSlots SMALLINT DEFAULT 0;     



     -- DECLARE `minimumNotFound` CONDITION FOR SQLSTATE '45000';
     -- DECLARE MESSAGE_TEXT varchar(200);
     -- DECLARE _debug boolean DEFAULT FALSE;
     -- DECLARE _debugMessage varchar(1000);

     -- DECLARE _idApprentice int;
     -- DECLARE _idMoment int DEFAULT 0;
     -- DECLARE _idAgenda int DEFAULT 0;
     -- DECLARE _idTutor int DEFAULT 0;
     -- DECLARE _dtTimeStart time;
     -- DECLARE _dtTimeEnd time;
     -- DECLARE _studentsInClass int DEFAULT 0;


     -- DECLARE _finished integer DEFAULT 0;
     -- DECLARE _baseAverage int;
     -- DECLARE _cardScoreOrder smallint DEFAULT 1;
     -- DECLARE _idCardToRedistribute int;
     -- DECLARE _slotsNeeded smallint DEFAULT 0;
     -- DECLARE _moveToCard int;
     -- DECLARE _slotsAvailable smallint;
     -- DECLARE _nextScoreOrder smallint DEFAULT 1;
     -- DECLARE _loopCounter smallint DEFAULT 0;
     -- DECLARE _ScoreOrderControl smallint DEFAULT 1;
     -- DECLARE _qtUsersNotAssigned smallint DEFAULT 0;


     DROP TABLE IF EXISTS tabClass;

     CREATE TEMPORARY TABLE tabClass
     (
     idApprentice INT
     );     

     DROP TABLE IF EXISTS tabCardInfo;

     CREATE TEMPORARY TABLE tabCardInfo
     (
     idCard INT,
     txType CHAR(1), -- Categoria ou Habilidade
     idType INT      -- id das tabelas
     );

     DROP TEMPORARY TABLE IF EXISTS tabStudentInfo;

     CREATE TEMPORARY TABLE tabStudentInfo
     (
     idApprentice INT,
     idCard       INT,
     txType       CHAR(1),
     idType       INT
     );     

     # Monta a tabela de calculo de performance  
     DROP TEMPORARY TABLE IF EXISTS tabUserScoreHistory;

     CREATE TEMPORARY TABLE tabUserScoreHistory
     (
     idApprentice        INT,
     idCard              INT,
     SkillPerformance    DECIMAL,
     SkillFrequency      DECIMAL,
     CategoryPerformance DECIMAL,
     CategoryFrequency   DECIMAL,
     ScoreOrder          SMALLINT
     );

     DROP TEMPORARY TABLE IF EXISTS tabCardAllocation;

     CREATE TEMPORARY TABLE tabCardAllocation
     (
     idCard     INT,
     cardOrder  SMALLINT,
     slots      SMALLINT DEFAULT 0
     );

     DROP TEMPORARY TABLE IF EXISTS tabMomentCard;

     CREATE TEMPORARY TABLE tabMomentCard
     (
          idCard       int,
          idApprentice int
     );

     DROP TEMPORARY TABLE IF EXISTS tabControlCards;

     CREATE TEMPORARY TABLE tabControlCards
     (
          idCard   int,
          Position smallint
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
     SET v_StudentsInClass = (SELECT COUNT(*) FROM tabClass);

     IF (v_StudentsInClass < 3)
     THEN
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'A turma precisa de no mínimo 3 alunos.';
     END IF;       

     ## Definicao do tema do momento
     # Verifica se algum tema foi indicado para criacao do momento
     IF in_idTheme IS NOT NULL AND in_idTheme > 0
     THEN

          IF ( SELECT COUNT(*)
               FROM Theme
                    INNER JOIN Card
                         ON Card.idTheme = Theme.idTheme
                    INNER JOIN CardGrade
                         ON CardGrade.idCard = Card.idCard
                    INNER JOIN Grade
                         ON Grade.idGrade = CardGrade.idGrade
                    INNER JOIN SchoolGrade
                         ON SchoolGrade.idGrade = Grade.idGrade
                    INNER JOIN SchoolClass
                         ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
               WHERE SchoolClass.idSchoolClass = in_idClass
               AND Theme.idTheme = in_idTheme) = 0

          THEN
               SET v_errorMessage = CONCAT('O tema (id: ', in_idTheme, ') não pode ser informado para a turma (id: ', in_idClass, ').');
               SIGNAL SQLSTATE '45000'
               SET MESSAGE_TEXT = v_errorMessage;

          ELSE
               SET v_idThemeDefined = in_idTheme;
			
          END IF;

     ELSE # Busca o tema com menor incidencia para a turma

          SELECT AvailThemes.idTheme INTO v_idThemeDefined
          FROM (
               SELECT Theme.idTheme
               FROM SchoolClass Class
                    INNER JOIN SchoolGrade ScGr
                            ON ScGr.idSchoolGrade = Class.idSchoolGrade
                    INNER JOIN Grade
                            ON Grade.idGrade = ScGr.idGrade
                    INNER JOIN CardGrade
                            ON CardGrade.idGrade = Grade.idGrade
                    INNER JOIN Card
                            ON Card.idCard = CardGrade.idCard   
                    INNER JOIN Theme
                            ON Theme.idTheme = Card.idTheme                                                 
               WHERE Class.idSchoolClass = in_idClass
               AND   Theme.inStatus = 1
               AND   Card.inStatus = 1  
               GROUP BY Theme.idTheme
               HAVING COUNT(1) >= 3  
               ) AvailThemes
               LEFT JOIN (
                         SELECT idTheme
                              , idLastMoment
                              , COALESCE(qtMoments, 0) AS qtMoments
                              , COALESCE(DENSE_RANK() OVER (ORDER BY idLastMoment ASC), 0) AS priority
                         FROM (
                              SELECT Moment.idSchoolClass
                                   , Moment.idTheme
                                	, MAX(Moment.idMoment) idLastMoment
                                   , COUNT(1) qtMoments
                              FROM Moment
                              WHERE Moment.idSchoolClass = in_idClass
                              GROUP BY Moment.idSchoolClass
                                     , Moment.idTheme
                              ) ClassMoments
                         ) Moments    
                      ON Moments.idTheme = AvailThemes.idTheme          
          ORDER BY COALESCE(qtMoments, 0) ASC
                 , COALESCE(priority, 0)  ASC
          LIMIT 1;

     END IF;

     INSERT INTO tabCardInfo
          (
          idCard,
          txType,
          idType
          )
          SELECT Card.idCard,
                 'H',
                 Dimension.idDimension
          FROM Theme
               INNER JOIN Card
                       ON Card.idTheme = Theme.idTheme
               INNER JOIN CardEvidence
                       ON CardEvidence.idCard = Card.idCard
               INNER JOIN Evidence
                       ON Evidence.idEvidence = CardEvidence.idEvidence
               INNER JOIN Dimension
                       ON Dimension.idDimension = Evidence.idDimension
          WHERE Theme.idTheme = v_idThemeDefined
          UNION
          SELECT Card.idCard,
                 'C',
                 LearningTool.idLearningTool
          FROM Theme
               INNER JOIN Card
                       ON Card.idTheme = Theme.idTheme
               INNER JOIN CardLearningTool
                       ON CardLearningTool.idCard = Card.idCard
               INNER JOIN LearningTool
                       ON LearningTool.idLearningTool = CardLearningTool.idLearningTool
          WHERE Theme.idTheme = v_idThemeDefined;

     IF (SELECT COUNT(1) FROM tabCardInfo) = 0
     THEN
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'Nenhuma atividade encontrada para o tema.';
     END IF;

     # Vinculacao de todos alunos da turma para todas a as atividades
     ## Simulacao de FULL OUTER JOIN ( MySQL sem suporte atualmente )
     INSERT INTO tabStudentInfo
          (
          idApprentice,
          idCard,
          txType,
          idType
          )
          SELECT Class.idApprentice
               , CardInfo.idCard
               , CardInfo.txType
               , CardInfo.idType
          FROM tabClass Class
               CROSS JOIN tabCardInfo CardInfo;     

     # Monta a tabela de score de usuários com ordenação / Realiza a definição de rankings
     INSERT INTO tabUserScoreHistory
          (
          idApprentice,
          idCard,
          SkillPerformance,
          SkillFrequency,
          CategoryPerformance,
          CategoryFrequency,
          ScoreOrder
          )

     WITH cteUserScore
       AS (
          SELECT StudentInfo.idApprentice
               , StudentInfo.idCard
               , StudentInfo.idType
               , StudentInfo.txType
               /*
               , CASE WHEN StudentInfo.txType = 'H' THEN CardSkill.txDimension ELSE CardCategory.txLearningTool END
               */
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
                 , StudentInfo.idCard
                 , StudentInfo.idType
                 , StudentInfo.txType  
                   /* , CASE WHEN StudentInfo.txType = 'H' THEN CardSkill.txDimension ELSE CardCategory.txLearningTool END */
          )

     SELECT idApprentice 
          , idCard
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
               , UserScore.idCard
               , AVG(CASE WHEN UserScore.txType = 'H' THEN UserScore.Score ELSE 0 END) AS SkillPerformance
               , SUM(CASE WHEN UserScore.txType = 'H' THEN UserScore.Frequency ELSE 0 END) AS SkillFrequency
               , AVG(CASE WHEN UserScore.txType = 'C' THEN UserScore.Score ELSE 0 END) AS CategoryPerformance
               , SUM(CASE WHEN UserScore.txType = 'C' THEN UserScore.Frequency ELSE 0 END) AS CategoryFrequency
          FROM cteUserScore AS UserScore
          GROUP BY UserScore.idApprentice
                 , UserScore.idCard
          ORDER BY UserScore.idApprentice, UserScore.idCard
          ) AS Ranking
     GROUP BY Ranking.idApprentice
            , Ranking.idCard;

     # Define a quantidade de atividades
     SELECT CASE WHEN v_studentsInClass / v_minUsersForCard > 3 THEN 3 
                 ELSE v_studentsInClass / v_minUsersForCard END
     INTO v_quantityOfCards;

     SET v_slotsForCard = FLOOR(v_studentsInClass / v_quantityOfCards);

     SET v_apprenticesLeftOver = MOD(v_studentsInClass, v_slotsForCard);

     # Cria o controle de atividades por ordenacao
     INSERT INTO tabControlCards
          (
          idCard,
          position
          )
          SELECT DISTINCT idCard, Position
          FROM ( 
               SELECT idCard
                    , ScoreOrder
                    , COUNT(1)
                    , ROW_NUMBER() OVER (ORDER BY ScoreOrder DESC, COUNT(1) ASC) position
               FROM tabUserScoreHistory
               GROUP BY idCard
                      , ScoreOrder) Cards
          ORDER BY Position ASC
          LIMIT v_quantityOfCards;

     # Descarta os resultados para atividades que não foram selecionadas
     DELETE FROM tabUserScoreHistory
     WHERE idCard NOT IN (SELECT idCard FROM tabControlCards); -- << 8<( This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'

     # Define a regra de alocacao (vagas) para cada atividade
     INSERT INTO tabCardAllocation
          (
          idCard,
          cardOrder,
          slots
          )
          SELECT idCard
               , ROW_NUMBER() OVER (ORDER BY COUNT(1) DESC) AS cardOrder
               , v_slotsForCard + CASE WHEN v_apprenticesLeftOver >= ROW_NUMBER() OVER (ORDER BY COUNT(1) DESC) 
                                       THEN 1 
                                       ELSE 0
                                  END AS slots
          FROM tabUserScoreHistory
          GROUP BY idCard;

     # Processamento de alunos por posicao (alocacao na atividade)
     WHILE v_cardOrder <= v_quantityOfCards 
     DO

          SET v_cardOrder = v_cardOrder + 1;

          SELECT idCard, slots INTO v_allocCard, v_allocSlots
          FROM tabCardAllocation
          WHERE cardOrder = v_cardOrder;

          INSERT INTO tabMomentCard
               (
               idCard, idApprentice
               )
          SELECT idCard, idApprentice
          FROM (
               SELECT idCard
                    , idApprentice
                    , ROW_NUMBER() OVER (ORDER BY ScoreOrder ASC, idApprentice ASC) AS Position
               FROM tabUserScoreHistory
               WHERE idCard = v_allocCard
               ) UserScore
          WHERE Position <= v_allocSlots;

          DELETE UserScore
          FROM tabUserScoreHistory AS UserScore
          WHERE UserScore.idCard = v_allocCard
          OR    EXISTS ( SELECT idCard
                         FROM tabMomentCard AS MomentCard
                         WHERE MomentCard.idApprentice = UserScore.idApprentice );

     END WHILE;

     # Realiza a criacao do momento
     CALL spuCreateMoment( in_idClass
                         , in_dtAgenda
                         , in_schoolClassStateHash
                         , in_jobId
                         , v_idThemeDefined
                         , v_idMoment );

     INSERT INTO MomentCard 
          ( idMoment, idCard )
     SELECT DISTINCT v_idMoment,idCard FROM tabMomentCard;

     INSERT INTO ApprenticeMoment
          (
          idApprentice,
          idMomentCard,
          inAttendance
          )
     SELECT Assignment.idApprentice
          , MomentCard.idMomentCard
          , NULL AS inAttendance
     FROM tabMomentCard AS Assignment
          INNER JOIN MomentCard
                  ON MomentCard.idCard = Assignment.idCard
     WHERE MomentCard.idMoment = v_idMoment
     ORDER BY idApprentice;

     # Retorno de informacoes para envio para o MongoDB
     SELECT Moment.idMoment
          , MomentCard.idMomentCard
          , ApprenticeMoment.idApprentice
     FROM Moment
          INNER JOIN MomentCard
                  ON MomentCard.idMoment = Moment.idMoment
          INNER JOIN ApprenticeMoment
                  ON ApprenticeMoment.idMomentCard = MomentCard.idMomentCard
     WHERE Moment.idMoment = v_idMoment
     ORDER BY MomentCard.idCard;

     # Debug
     /*
     SELECT 'Num. de alunos na turma' AS Descricao, v_StudentsInClass AS Valor
     UNION
     SELECT 'Tema selecionado', v_idThemeDefined          
     UNION
     SELECT 'Total de cards:', v_quantityOfCards
     UNION
     SELECT 'Vagas por card:', v_slotsForCard
     UNION
     SELECT 'Sobra:', v_apprenticesLeftOver       
     UNION
     SELECT 'ID do momento:', v_idMoment ;        
     */

     /*
     START TRANSACTION;

          CALL spuCardDistribution(37, '2022-12-03', 'hashtesteFundII', '54E95881-D3A2-4946-B138-DA730E286A89', NULL);                               

     ROLLBACK;
     COMMIT;

     -- Validacao
     SELECT M.idMoment
     	, M.idTheme
     	, MC.idCard
     	, COUNT(1)
     FROM Moment M
     	INNER JOIN MomentCard MC
     		ON MC.idMoment = M.idMoment
     	INNER JOIN ApprenticeMoment AM
     		ON AM.idMomentCard = MC.idMomentCard
     WHERE M.idMoment IN (4921, 4922, 4923)
     GROUP BY M.idMoment
     	, M.idTheme
     	, MC.idCard
     	
     SELECT idClass, count(1) 
     FROM Apprentice
     GROUP BY idClass
     */

END