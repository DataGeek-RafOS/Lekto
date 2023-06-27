DROP PROCEDURE IF EXISTS `spuDataIntegration`;

CREATE DEFINER=`root`@`%` PROCEDURE `spuDataIntegration`( IN in_idNetwork INT, in_jsonData JSON)
DataIntegration: BEGIN

	# Declaracao de variaveis
     DECLARE va_SQLState           VARCHAR(1000);
     DECLARE va_SQLMessage         VARCHAR(1000);
	DECLARE va_idLektoUser 		INT;
	DECLARE va_isStudent          VARCHAR(5);
	DECLARE va_idStudent		INT;
	DECLARE va_userBirthDate      CHAR(10);
	DECLARE va_idSchoolYear       INT;
	DECLARE va_CodeOriginUser 	VARCHAR(36);
	DECLARE va_ProfileFound		INT;
	DECLARE va_ProfileDeleted	TINYINT;
	DECLARE va_ProfileStatus		TINYINT;
	DECLARE va_ProfileExists      TINYINT DEFAULT 0;
	DECLARE va_RegionalNotFound   VARCHAR(50);
     DECLARE va_StageNotFound      VARCHAR(50);
     DECLARE va_GradeNotFound      VARCHAR(50);
	DECLARE va_EmailFound		VARCHAR(600);
	DECLARE va_inDebug            TINYINT(1) DEFAULT 0;
	DECLARE va_txDebug			VARCHAR(2000);
	DECLARE va_idDebugGroup 		INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING 
	BEGIN
		GET DIAGNOSTICS CONDITION 1
		va_SQLState = RETURNED_SQLSTATE, va_SQLMessage = MESSAGE_TEXT;
		
          SELECT JSON_ARRAYAGG(JSON_OBJECT('error_message', CONCAT('Um erro ocorreu durante a operação [State: ', COALESCE(va_SQLState, 'N/A') , '] com a mensagem [', COALESCE(va_SQLMessage, 'N/A'), ']'))) AS Errors; 
		ROLLBACK;
		RESIGNAL;
	END;

     ## Parametros
	SET va_CodeOriginUser := ( SELECT in_jsonData ->> '$.codeOrigin' AS isStudent );	

	SET va_isStudent := ( SELECT LOWER(in_jsonData ->> '$.profiles.isStudent') AS isStudent ); 

	SET va_userBirthDate :=  ( SELECT in_jsonData ->> '$.birthdate' AS dtBirthDate );
	
	IF LOWER(va_userBirthDate) = 'null'
	THEN 
		SET va_userBirthDate = null;
	END IF;
					    
	SET va_idSchoolYear := ( SELECT idSchoolYear 
					     FROM SchoolYear	
					     WHERE idNetwork = in_idNetwork 
					     AND NOW() BETWEEN SchoolYear.dtStartPeriod AND SchoolYear.dtEndPeriod );
	
	IF va_inDebug = 1
	THEN
		SET va_idDebugGroup := COALESCE(( SELECT MAX(idGroup) FROM IntegrationLog ), 0) + 1;
		
		INSERT INTO IntegrationLog 
			( idGroup, idNetwork, userCodeOrigin, txDescription, txMessage ) 
			VALUES 
			(va_idDebugGroup, in_idNetwork, va_CodeOriginUser, 'Payload', COALESCE(in_jsonData, ''));
	END IF;
	
	# Tabelas temporarias
	
	## Tabela de erros
	DROP TABLE IF EXISTS tabErrorLog;

	CREATE TEMPORARY TABLE tabErrorLog ( txMessage VARCHAR(1000) NOT NULL );

     ## Tabela de dados da escola do payload   
	DROP TABLE IF EXISTS tabSchool;

	CREATE TEMPORARY TABLE tabSchool
	(
	  txName 		VARCHAR(200) NOT NULL
	, txCodeOrigin VARCHAR(36) NULL
	, coDistrict   CHAR(2) NOT NULL
	);
	
	## Tabela de relacionamentos
	DROP TABLE IF EXISTS tabRelationship;
	
	CREATE TEMPORARY TABLE tabRelationship
	(
	  txName 			VARCHAR(120)
	, txEmail			VARCHAR(120)
	, txCodeOrigin 	VARCHAR(36) 
	, coRelationType	CHAR(4) 
	, txCpf			CHAR(11)
	);
	
     ## Tabela da estrutura academica
	DROP TABLE IF EXISTS tabUserPayload;
	
	CREATE TEMPORARY TABLE tabUserPayload
	(
       codeOriginUser    VARCHAR(36)
	, codeOriginSchool 	VARCHAR(36) 
	, coStage 		CHAR(4)	
	, coGrade 		CHAR(4)
	, coClassShift      CHAR(3)
	, ClassName 		VARCHAR(100)
	, ClassCodeOrigin 	VARCHAR(36)
	, ClassEnabled 	TINYINT	
	);	
	
	## Tabela de emails enviados no payload para validacao
	DROP TABLE IF EXISTS tabEmailPayload;
	
	CREATE TEMPORARY TABLE tabEmailPayload
	( 
	  txEmail 	VARCHAR(120) NOT NULL 
     , txCodeOrigin VARCHAR(36) NOT NULL
	);	
	
	## Tabela de escolas vinculadas ao administrador escolar
	DROP TABLE IF EXISTS tabSchoolManager;
	
	CREATE TEMPORARY TABLE tabSchoolManager
	( 
	txCodeSchool VARCHAR(36) NOT NULL 
	);			
	
	## Tabela de regionais vinculadas ao administrador de regional	
	DROP TABLE IF EXISTS tabProfileRegional;
	
	CREATE TEMPORARY TABLE tabProfileRegional
	( 
	coDistrict CHAR(2) NOT NULL 
	);					
	
	## Tabela de escolas vinculadas ao professor
	DROP TABLE IF EXISTS tabSchoolProfessor;
	
	CREATE TEMPORARY TABLE tabSchoolProfessor
	(
	  txCodeSchool VARCHAR(36) NOT NULL
	);		
	
	## Dados do estudante
	DROP TABLE IF EXISTS tabStudent;
	
	CREATE TEMPORARY TABLE tabStudent
	(
	  idNetwork      	INT NOT NULL
	, idSchool       	INT NOT NULL
	, coGrade        	CHAR(4) NOT NULL
	, idUserStudent  	INT NOT NULL
	);			

	## Inicio da transacao
	START TRANSACTION;
	
	## Recupera os dados da escola (payload)
	INSERT INTO tabSchool
	(
	  txName
	, txCodeOrigin
	, coDistrict
	)
	SELECT txName
		, txCodeOrigin
		, coDistrict
	FROM JSON_TABLE ( in_jsonData, '$.schools[*]' COLUMNS (
												 txName 		VARCHAR(200) PATH '$.name'
											    , txCodeOrigin 	VARCHAR(36) PATH '$.codeOrigin'
											    , coDistrict 	CHAR(2) PATH '$.district'
											    ) ) AS Schools;	
											    
	## Recupera os dados do usuário (payload)	
	INSERT INTO tabUserPayload
	(
       codeOriginUser
	, codeOriginSchool 
	, coStage 
	, coGrade 
	, coClassShift 
	, className 
	, classCodeOrigin 
	, classEnabled 		
	)
	SELECT va_CodeOriginUser
          , CodeOriginSchool 
		, coStage 
		, CONCAT(coStage, 'A', coGrade)
		, coClassShift 
		, className 
		, classCodeOrigin 
		, CASE WHEN LOWER(ClassEnabled) = 'true' THEN 1 ELSE 0 END AS ClassEnabled
	FROM JSON_TABLE ( in_jsonData, '$.profiles.student[*]' COLUMNS (
				  								          codeOriginSchool VARCHAR(36) PATH '$.class.codeOriginSchool'
				  								        , coStage CHAR(4) PATH '$.class.stage'		
				  								        , coGrade CHAR(4) PATH '$.class.grade'		
				  								        , coClassShift CHAR(3) PATH '$.class.classShift'
				  								        , ClassName VARCHAR(50) PATH '$.class.name'
				  								        , ClassCodeOrigin VARCHAR(36) PATH '$.class.codeOrigin'
				  								        , ClassEnabled CHAR(5) PATH '$.class.enabled'					   					    
				  								        ) ) AS Classes;	

     ## Recupera relacionamentos (payload)
	INSERT INTO tabRelationship
	(
	  txName 			
	, txEmail			
	, txCodeOrigin 	
	, coRelationType	
	, txCpf			
	)
	SELECT txName 			
		, txEmail			
		, txCodeOrigin 	
		, coRelationType	
		, txCpf			
	FROM JSON_TABLE
		( in_jsonData, '$.relationships[*]' 
					COLUMNS
					(
					  txName 			VARCHAR(120) PATH '$.name'
					, txEmail			VARCHAR(120) PATH '$.email'
					, txCodeOrigin 	VARCHAR(36) PATH '$.codeOrigin'					 
					, coRelationType 	CHAR(4) PATH '$.relationType'
					, txCpf			CHAR(11) PATH '$.document'
					)
	    ) AS Relationship;	

	## Carga de dados do professor    
	INSERT INTO tabSchoolProfessor 
	(
	  txCodeSchool
	)
	SELECT txCodeSchool
	FROM JSON_TABLE ( in_jsonData, '$.profiles.professor[*]'  COLUMNS ( txCodeSchool VARCHAR(36) PATH '$' ) ) AS ProfileSchool;		    
	
	## Carga de todos os emails enviados no payload
	INSERT INTO tabEmailPayload
			( 
			  txEmail
			, txCodeOrigin 
			)
	SELECT txEmail, txCodeOrigin
	FROM (
		SELECT NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.email')), 'null') AS txEmail
			, JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.codeOrigin')) AS txCodeOrigin
		UNION ALL
		SELECT COALESCE(txEmail, 'null'), txCodeOrigin FROM tabRelationship 
		) Email
	WHERE txEmail <> 'null';
		
	/*********************/
	/* Validacoes Gerais */ 
	
	# Verifica se a rede existe
	IF va_CodeOriginUser IS NULL OR va_CodeOriginUser = ''
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		VALUES ( 'Não foi possível identificar o código do usuário no payload enviado.' );
	END IF;	
	
/*
	#Solitacao: Auguimar em 03/04/2023 as 10:14 pelo Slack
	# Verifica se a rede existe
	IF ( SELECT inIntegration
		FROM Network
		WHERE idNetwork = in_idNetwork
	   ) = 0
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		VALUES ( 'A rede informada não permite o envio de dados pela integração.' );
	END IF;	   
*/	

	# Verifica se a rede existe
	IF ( SELECT COUNT(idNetwork)
		FROM Network
		WHERE idNetwork = in_idNetwork
		AND   idNetworkReference IS NULL
	   ) = 0
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		VALUES ( 'O código da rede informada não está cadastrada.' );
	END IF;

	# Valida duplicidade de emails no payload
	IF EXISTS ( SELECT txEmail, COUNT(1) AS Ocorrencia
			  FROM tabEmailPayload
			  GROUP BY txEmail
			  HAVING COUNT(1) > 1
			)
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		VALUES ( 'Existe duplicidade de endereço de e-mails informados no payload.' );
	END IF;	
	
	# Se alguma escola foi enviada, confirma se o código de origem está preenchido
	IF  ( SELECT COUNT(*) FROM tabSchool ) > 0
	THEN 
		IF ( SELECT COUNT(*) FROM tabSchool WHERE txCodeOrigin IS NULL ) > 0
		THEN 
			INSERT INTO tabErrorLog ( txMessage )
			VALUES ( 'O código de origem da escola deve ser informado no payload.' );
		END IF;		
	END IF;			
	
	# Verifica se o código de origem da turma não está cadastrada em outra escola
	IF ( SELECT COUNT(*)
		FROM tabUserPayload AS PayLo
			INNER JOIN Class 
				ON Class.txCodeOrigin = PayLo.ClassCodeOrigin
			INNER JOIN SchoolGrade AS SchGr
				ON SchGr.idNetwork = Class.idNetwork
				AND SchGr.idSchool  = Class.idSchool
				AND SchGr.coGrade   = Class.coGrade
			INNER JOIN School AS Schoo
				ON Schoo.idNetwork = SchGr.idNetwork
				AND Schoo.idSchool  = SchGr.idSchool
		WHERE Class.idNetwork = in_idNetwork
		AND   PayLo.codeOriginSchool <> Schoo.txCodeOrigin
	  ) > 0
	THEN
		INSERT INTO tabErrorLog ( txMessage )
		SELECT CONCAT('O código de origem informada para a turma já está cadastrado na rede em outra escola.' );
	END IF;		
		
	# Verifica se o email já está cadastrado (deve ser único)	
	SET va_EmailFound := ( SELECT GROUP_CONCAT(tabEmailPayload.txEmail)
					   FROM tabEmailPayload 
						   INNER JOIN LektoUser
						           ON LektoUser.txEmail = tabEmailPayload.txEmail
					   WHERE LektoUser.txCodeOrigin <> tabEmailPayload.txCodeOrigin
					   AND   LektoUser.idNetwork = in_idNetwork
					);
	
	IF va_EmailFound IS NOT NULL
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		SELECT CONCAT('O(s) endereço(s) de e-mail [', va_EmailFound, '] já está(ão) cadastrado(s) na rede com outro código de origem.' );
	END IF;	
	
	# Verifica se o email já está cadastrado (deve ser único)	
	SET va_EmailFound := ( SELECT GROUP_CONCAT(tabEmailPayload.txEmail)
					   FROM tabEmailPayload 
						   INNER JOIN LektoUser
						           ON LektoUser.txEmail = tabEmailPayload.txEmail
					   WHERE LektoUser.idNetwork <> in_idNetwork
					);
	
	IF va_EmailFound IS NOT NULL
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		SELECT CONCAT('O(s) endereço(s) de e-mail [', va_EmailFound, '] já está(ão) cadastrado(s) em outra rede.' );
	END IF;		
	
	# Verifica a existencia de cadastros de regionais
	IF ( SELECT COUNT(1) 
	     FROM tabSchool 
		WHERE coDistrict IS NOT NULL
	   )
	THEN 
     
		SET va_RegionalNotFound := ( SELECT GROUP_CONCAT(tabSchool.coDistrict)
							    FROM tabSchool
								    LEFT JOIN Network AS Regional
										 ON Regional.coDistrict = tabSchool.coDistrict
										AND Regional.idNetworkReference = in_idNetwork
							    WHERE Regional.idNetwork IS NULL
                                   );
     
          IF va_RegionalNotFound IS NOT NULL
     	THEN
     		INSERT INTO tabErrorLog ( txMessage )
     		SELECT CONCAT('A(s) regional(s) ', va_RegionalNotFound, ' enviada(s) não está(ão) cadastrada(s) no banco de dados.' );
     	END IF;		
	
	END IF;

	# Verifica se o tipo de relacionamento esta cadastrado
	IF ( SELECT COUNT(*)
		FROM tabRelationship
			LEFT JOIN RelationType
				  ON RelationType.coRelationType = tabRelationship.coRelationType
		WHERE RelationType.coRelationType IS NULL
	   ) > 0
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		VALUES ( 'Existem tipos de relacionamentos no payload que não estão cadastrados no banco de dados.' );
	END IF;	    

     # O usuario base foi enviado como responsavel?  	    
	IF ( SELECT COUNT(*) 
		FROM tabRelationship
		WHERE txCodeOrigin = va_CodeOriginUser
	   ) > 0
	THEN 
		INSERT INTO tabErrorLog ( txMessage )
		VALUES ( 'O usuário informado não pode ser enviado também como responsável. Verifique o payload de responsáveis.' );
	END IF;

     # Realiza validações de dados de cadastro academico para vinculo de aluno
     IF ( SELECT COUNT(*) FROM tabUserPayload ) > 0
     THEN 

     	# 1. Verifica se período letivo está cadastrado para a rede
     	IF va_idSchoolYear IS NULL
     	THEN 
     		INSERT INTO tabErrorLog  ( txMessage )
     		VALUES ( 'Não existe cadastro para o período letivo corrente para a rede informada.' );
     	END IF;
     
     	# Se a etapa informada não estiver cadastrada, retorna erro
          SET va_StageNotFound := ( SELECT GROUP_CONCAT(tabUserPayload.coStage)
     		                     FROM tabUserPayload
     			                     LEFT JOIN Stage 
     			                            ON Stage.coStage = tabUserPayload.coStage
                                    WHERE Stage.coStage IS NULL
                                   );
     
          IF va_StageNotFound IS NOT NULL
     	THEN
     		INSERT INTO tabErrorLog ( txMessage )
     		SELECT CONCAT('A(s) etapa(s) ', va_StageNotFound, ' enviada(s) não está cadastrada no banco de dados.' );
     	END IF;	
          	
     	# Se a série informada não estiver cadastrada, retorna erro
          SET va_GradeNotFound := ( SELECT GROUP_CONCAT(tabUserPayload.coGrade)
                                    FROM tabUserPayload
                                         LEFT JOIN Grade 
                                   	         ON Grade.coGrade = tabUserPayload.coGrade
                                   WHERE Grade.coGrade IS NULL 
                                   );
							
          IF va_GradeNotFound IS NOT NULL
     	THEN
     		INSERT INTO tabErrorLog ( txMessage )
     		SELECT CONCAT('A(s) série(s) ', va_GradeNotFound, ' enviada(s) não está cadastrada no banco de dados.');
     	END IF;		
     
     	# Se turno informada não estiver cadastrada, retorna erro
     	IF ( SELECT COUNT(*)
     		FROM tabUserPayload
     			INNER JOIN ClassShift 
     				   ON ClassShift.coClassShift = tabUserPayload.coClassShift 
     	   ) = 0
     	THEN
     	
     		INSERT INTO tabErrorLog ( txMessage )
     		VALUES ( 'O turno informado não está cadastrado no banco de dados.' );
     	END IF;	

     END IF;

     # Se nenhum erro foi encontrado, processa a integracao. Caso contrario, retorna a lista de erros
     IF ( SELECT COUNT(*)
          FROM tabErrorLog 
        ) > 0
     THEN

          SELECT JSON_ARRAYAGG(JSON_OBJECT('error_message', ErrorLog.txMessage)) AS Errors
          FROM tabErrorLog ErrorLog;

          ROLLBACK;

          LEAVE DataIntegration;

     ELSE

     	/***********************/
     	/* Cadastro de Usuario */

     	# Verifica se o usuario ja esta na base de dados
     	SET va_idLektoUser = COALESCE(( SELECT idUser  
     							  FROM LektoUser 
     							  WHERE idNetwork = in_idNetwork
     							  AND   txCodeOrigin = va_CodeOriginUser ), 0 );
     	
     	# Criacao do usuario
     	IF va_idLektoUser = 0
     	THEN 
    	
			# SELECT COLUMNS_HEADERS->>"$[1]", NULLIF(COLUMNS_HEADERS->>"$[1]",'null') IS NULL)
	
     		INSERT INTO LektoUser 
     		(
     		  idNetwork
     		, txName
     		, txImagePath
     		, txEmail
     		, txPhone
     		, txCpf
     		, dtBirthdate
     		, inStatus
     		, txCodeOrigin
     		, dtInserted
     		, dtLastUpdate
     		)
     		SELECT in_idNetwork AS idNetwork
     			, JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.name')) AS txName
     			, NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.imagePath')), 'null')  AS txImagePath		
     			, NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.email')), 'null') AS txEmail
     			, NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.phone')), 'null') AS txPhone
     			, JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.document')) AS txCpf
     			, va_userBirthDate 		
     			, CASE WHEN LOWER(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.enabled'))) = 'false' THEN 0 ELSE 1 END AS inStatus
     			, JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.codeOrigin')) AS txCodeOrigin
     			, NOW() AS dtInserted
     			, NOW() AS dtLastUpdate;
     			
     		SET va_idLektoUser := LAST_INSERT_ID();
     	
     	ELSE
     
     		UPDATE LektoUser
     		   SET txName 		= JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.name'))
     		     , txImagePath  = CASE WHEN NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.imagePath')), 'null') IS NULL
				                        OR TRIM(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.imagePath'))) = "" 
								  THEN txImagePath
								  ELSE JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.imagePath'))
						       END								  
     			, txEmail 	= NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.email')), 'null')
     			, txPhone 	= NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.phone')), 'null')
     			, txCpf 		= JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.document'))
     			, dtBirthdate 	= va_userBirthDate
     			, inStatus 	= CASE WHEN JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.enabled')) = 'false' THEN 0 ELSE 1 END 
     			, txCodeOrigin = JSON_UNQUOTE(JSON_EXTRACT(in_jsonData, '$.codeOrigin'))
     			, dtLastUpdate = NOW()
     		WHERE idNetWork = in_idNetwork
     		AND   idUser = va_idLektoUser;
     
     	END IF;	
		
     	/***********************/
     	/* Cadastro de Escolas */ 

		UPDATE School
			  INNER JOIN tabSchool 
			          ON School.txCodeOrigin = tabSchool.txCodeOrigin
			  INNER JOIN Network
					ON Network.idNetwork = School.idNetwork
			  INNER JOIN Network AS Regional
					ON Regional.idNetworkReference = Network.idNetwork
				    AND Regional.coDistrict = tabSchool.coDistrict	
		   SET School.txName = tabSchool.txName
			, School.idSubNetwork = Regional.idNetwork
			, School.inStatus = 1
		     , School.dtLastUpdate = NOW()
		WHERE School.idNetwork = in_idNetwork;			

     	INSERT INTO School
     	(
     	  idNetwork
     	, txName
     	, inStatus
     	, txCodeOrigin
		, idSubNetwork
     	, dtInserted
     	)
     	SELECT in_idNetwork AS idNetwork
     		, tabSchool.txName
     		, 1 AS inStatus
     		, tabSchool.txCodeOrigin
			, Regional.idNetwork
     		, NOW() AS dtInserted
     	FROM tabSchool 
			INNER JOIN Network AS Regional
					ON Regional.coDistrict = tabSchool.coDistrict	
     	WHERE Regional.idNetworkReference = in_idNetwork
		AND   NOT EXISTS ( SELECT 1 
     				    FROM School
     				    WHERE School.idNetwork    = in_idNetwork
     				    AND   School.txCodeOrigin = tabSchool.txCodeOrigin );

     	/**************************************/
     	/* Cadastro de vinculo da SchoolGrade */ 

          INSERT INTO SchoolGrade
          (
            idNetwork
          , idSchool
          , coGrade
          )
          SELECT DISTINCT
			  School.idNetwork
               , School.idSchool
               , Grade.coGrade
          FROM tabUserPayload 
     		INNER JOIN School
     		        ON School.txCodeOrigin = tabUserPayload.CodeOriginSchool
               INNER JOIN Grade
                       ON Grade.coGrade = tabUserPayload.coGrade
          WHERE School.idNetwork = in_idNetwork
          AND   NOT EXISTS ( SELECT SchoolGrade.idSchool
                             FROM SchoolGrade
                             WHERE SchoolGrade.idNetwork = in_idNetwork
                             AND   SchoolGrade.idSchool  = School.idSchool
                             AND   SchoolGrade.coGrade   = Grade.coGrade
                           );

     	/*******************************/
     	/* Cadastro de Relacionamentos */ 
		
		IF ( SELECT COUNT(*)
		     FROM tabRelationship
		   ) > 0
		THEN
			
			-- Atualiza se os usuários possuirem cadastro
			UPDATE LektoUser
				  INNER JOIN tabRelationship
						ON tabRelationship.txCodeOrigin = LektoUser.txCodeOrigin
			   SET LektoUser.txName 		= tabRelationship.txName
				, LektoUser.txEmail 	= tabRelationship.txEmail
				, LektoUser.txCpf 		= tabRelationship.txCpf	
				, LektoUser.dtLastUpdate = NOW()
			WHERE LektoUser.idNetwork = in_idNetwork;
		
			-- Cria os usuários na LektoUser caso ainda não existam
			INSERT INTO LektoUser 
			(
			  idNetwork
			, txName
			, txImagePath
			, txEmail
			, txPhone
			, txCpf
			, dtBirthdate
			, inStatus
			, txCodeOrigin
			, dtInserted
			)	
			SELECT in_idNetwork AS idNetwork
				, txName
				, NULL AS txImagePath
				, txEmail
				, NULL AS txPhone
				, txCpf
				, NULL AS dtBirthdate
				, 1 AS inStatus
				, txCodeOrigin
				, NOW() AS dtInserted
			FROM tabRelationship
			WHERE NOT EXISTS ( SELECT * 
						    FROM LektoUser
						    WHERE LektoUser.idNetwork = in_idNetwork
						    AND   LektoUser.txCodeOrigin = tabRelationship.txCodeOrigin
						  );
			
			# 2. Cadastro dos usuarios envolvidos no relacionamento
			INSERT INTO Relationship
			(
			  idNetwork
			, idUser
			, idUserBound
			, coRelationType
			, inDeleted
			, dtInserted
			)
			SELECT LektoUser.idNetwork
				, va_idLektoUser
				, LektoUser.idUser AS idUserBound
				, tabRelationship.coRelationType
				, 0 AS inDeleted
				, NOW() AS dtInserted
			FROM tabRelationship
				INNER JOIN LektoUser
					   ON LektoUser.txCodeOrigin = tabRelationship.txCodeOrigin
			WHERE LektoUser.idNetwork = in_idNetwork
			AND NOT EXISTS ( SELECT 1 
						  FROM Relationship
						  WHERE Relationship.idNetwork   = LektoUser.idNetwork
						  AND   Relationship.idUser      = va_idLektoUser
						  AND   Relationship.idUserBound = LektoUser.idUser );	

			-- Atualizacao caso o perfil já existe para o usuário
			UPDATE UserProfile
				  INNER JOIN LektoUser
						ON LektoUser.idNetwork = UserProfile.idNetwork
					    AND LektoUser.idUser    = UserProfile.idUser
				  INNER JOIN tabRelationship
						ON tabRelationship.txCodeOrigin = LektoUser.txCodeOrigin
			   SET UserProfile.inDeleted = 0
				, UserProfile.inStatus = 1
				, UserProfile.dtLastUpdate = NOW()
			WHERE LektoUser.idNetwork = in_idNetwork
			AND   UserProfile.coProfile = 'RESP'
			AND   ( UserProfile.inStatus = 0 OR UserProfile.inDeleted = 1 ) ;					  

			# Inclusao de perfil de Responsavel
			INSERT INTO UserProfile
			(
			  idNetwork
			, idUser
			, coProfile
			, inDeleted
			, inStatus
			, dtInserted
			)
			SELECT in_idNetwork
				, LektoUser.idUser
				, 'PAIS' AS coProfile
				, 0 AS inDeleted
				, 1 AS inStatus
				, NOW() AS dtInserted
			FROM tabRelationship
				INNER JOIN LektoUser 
					   ON LektoUser.txCodeOrigin = tabRelationship.txCodeOrigin
			WHERE LektoUser.idNetwork = in_idNetwork
			AND   NOT EXISTS ( SELECT *
						    FROM UserProfile
						    WHERE UserProfile.idNetwork = in_idNetwork
						    AND   UserProfile.idUser = LektoUser.idUser
						    AND   UserProfile.coProfile = 'PAIS'
						  ); 

		END IF;

     	/**********************/
     	/* Cadastro de Perfil */ 
		
     	/*****************/
     	/* Perfil: Aluno */ 

		-- Verifica se o usuário já possui perfil cadastrado
		SET va_ProfileExists := ( SELECT COUNT(1)
							 FROM UserProfile
							 WHERE idNetwork = in_idNetwork
							 AND   idUser    = va_idLektoUser
							 AND   coProfile = 'ALNO' 
							 FOR UPDATE );			

     	IF va_isStudent = 'true'
     	THEN
     	
     		# Possui registro cadastrado?
     		IF va_ProfileExists = 0
     		THEN
     		
     			INSERT INTO UserProfile
     			(
     			  idNetwork
     			, idUser
     			, coProfile
     			, inDeleted
     			, inStatus
     			, dtInserted
     			)
     			VALUES
     			(
     			  in_idNetwork
     			, va_idLektoUser		
     			, 'ALNO'
     			, 0
     			, 1
     			, NOW()
     			);
     		
				IF va_inDebug = 1
				THEN
					INSERT INTO IntegrationLog 
						( idGroup, idNetwork, userCodeOrigin, txDescription, txMessage ) 
					VALUES 
						( va_idDebugGroup, in_idNetwork, va_CodeOriginUser, 'Aluno', 'Perfil de aluno criado. ');
				END IF;				
			
     		ELSE
     		
     			UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 1
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ALNO';
				
				IF va_inDebug = 1
				THEN
					INSERT INTO IntegrationLog 
						( idGroup, idNetwork, userCodeOrigin, txDescription, txMessage ) 
					VALUES 
						(va_idDebugGroup, in_idNetwork, va_CodeOriginUser, 'Aluno', 'Perfil de aluno atualizado. ');
				END IF;					
     				
     		END IF;		
			
     	ELSE -- isStudent = False
		
			-- Se nao for aluno mas possuir perfil previo cadastrado, desabilita o perfil
			IF va_ProfileExists > 0
			THEN
     			
				UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 0
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ALNO';			
				
			END IF;
			 
     	END IF; # isStudent	

     	/*********************/
     	/* Perfil: Professor */      
	
		-- Verifica se o usuário já possui perfil cadastrado
		SET va_ProfileExists := ( SELECT COUNT(1)
							 FROM UserProfile
							 WHERE idNetwork = in_idNetwork
							 AND   idUser    = va_idLektoUser
							 AND   coProfile = 'TUTO' 
							 FOR UPDATE );	
		
     	IF ( SELECT COUNT(1) FROM tabSchoolProfessor ) > 0 # Escolas vinculadas ao professor no payload
     	THEN
		
     		# Usuário já tem perfil de professor na rede?
     		IF va_ProfileExists = 0
     		THEN
     		
     			INSERT INTO UserProfile
     			(
     			  idNetwork
     			, idUser
     			, coProfile
     			, inDeleted
     			, inStatus
     			, dtInserted
     			)
     			VALUES
     			(
     			  in_idNetwork
     			, va_idLektoUser		
     			, 'TUTO'
     			, 0
     			, 1
     			, NOW()
     			);
     		
				IF va_inDebug = 1
				THEN
					INSERT INTO IntegrationLog ( idGroup, idNetwork, userCodeOrigin, txDescription, txMessage ) VALUES ( va_idDebugGroup, in_idNetwork, va_CodeOriginUser, 'Professor', 'Perfil de professor criado. ');
				END IF;			
			
     		ELSE
     		
     			UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 1
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'TUTO';
				
				IF va_inDebug = 1
				THEN
					INSERT INTO IntegrationLog 
						( idGroup, idNetwork, userCodeOrigin, txDescription, txMessage ) 
					VALUES 
						(va_idDebugGroup, in_idNetwork, va_CodeOriginUser, 'Professor', 'Perfil de professor atualizado. ');
				END IF;			
				
     		END IF;			
     		
     		INSERT INTO UserProfileSchool
     		(
     		  idUserProfile
     		, idNetwork
     		, idSchool
     		, dtInserted
     		)
     		SELECT DISTINCT
				  UserProfile.idUserProfile
     			, School.idNetwork
     			, School.idSchool
     			, NOW()
     		FROM UserProfile
     			INNER JOIN School 
     				   ON School.idNetwork = UserProfile.idNetwork
     		WHERE UserProfile.idNetwork = in_idNetwork
     		AND   UserProfile.idUser    = va_idLektoUser
     		AND   UserProfile.coProfile = 'TUTO'
     		AND   School.txCodeOrigin IN ( SELECT txCodeSchool FROM tabSchoolProfessor )
			AND   NOT EXISTS ( SELECT 1 
					         FROM UserProfileSchool
						    WHERE UserProfileSchool.idNetwork 	  = School.idNetwork
						    AND   UserProfileSchool.idSchool  	  = School.idSchool
						    AND   UserProfileSchool.idUserProfile = UserProfile.idUserProfile
					       );
						  
		ELSE
		
			-- Se nao for tutor (ou nao for enviado no payload) mas possuir perfil previo cadastrado, desabilita o perfil
     		IF va_ProfileExists > 0
     		THEN		
		
     			UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 0
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'TUTO';
				
			END IF;
     	
     	END IF; 	
	
     	/*********************************/
     	/* Perfil: Administrador de Rede */ 

		-- Verifica se o usuário já possui perfil cadastrado
		SET va_ProfileExists := ( SELECT COUNT(1)
							 FROM UserProfile
							 WHERE idNetwork = in_idNetwork
							 AND   idUser    = va_idLektoUser
							 AND   coProfile = 'ADSN' 
							 FOR UPDATE );			
		
     	IF ( SELECT LOWER(in_jsonData ->> '$.profiles.isNetworkAdmin') AS isNetworkAdmin ) = 'true'
     	THEN
     	
     		IF va_ProfileExists = 0
     		THEN 
     		
     			INSERT INTO UserProfile
     			(
     			  idNetwork
     			, idUser
     			, coProfile
     			, inDeleted
     			, inStatus
     			, dtInserted
     			)
     			VALUES
     			(
     			  in_idNetwork
     			, va_idLektoUser		
     			, 'ADSN'
     			, 0
     			, 1
     			, NOW() 
     			);
     		
     		ELSE
     		
     			UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 1
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ADSN';
     				
     		END IF;
			
     	ELSE

			-- Se nao for administrador de rede (ou nao for enviado no payload) mas possuir perfil previo cadastrado, desabilita o perfil     	
     		IF va_ProfileExists > 0
     		THEN 	
			
				UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 0
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ADSN';
				
			END IF;
     		
     	END IF; # isNetworkAdmin
    	
     	/*************************************/
     	/* Perfil: Administrador de Regional */   

		-- Verifica se o usuário já possui perfil cadastrado
		SET va_ProfileExists := ( SELECT COUNT(1)
							 FROM UserProfile
							 WHERE idNetwork = in_idNetwork
							 AND   idUser    = va_idLektoUser
							 AND   coProfile = 'ADMR' 
							 FOR UPDATE );				   

     	INSERT INTO tabProfileRegional 
     	(
     	  coDistrict 
     	)
     	SELECT coDistrict
     	FROM JSON_TABLE ( in_jsonData, '$.profiles.regionalAdmin[*]'  COLUMNS ( coDistrict CHAR(2) PATH '$' ) ) AS RegionalAdmin;	
     
     	IF ( SELECT COUNT(*) FROM tabProfileRegional ) > 0
     	THEN
     	
     		# Possui registro cadastrado com o perfil Administrador de regional?
     		IF va_ProfileExists = 0 
     		THEN 
     		
     			INSERT INTO UserProfile
     			(
     			  idNetwork
     			, idUser
     			, coProfile
     			, inDeleted
     			, inStatus
     			, dtInserted
     			)
     			VALUES
     			(
     			  in_idNetwork
     			, va_idLektoUser		
     			, 'ADMR'
     			, 0
     			, 1
     			, NOW()
     			);
     		
     		ELSE
     		
     			UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 1
     				, dtLastUpdate = NOW()
     			WHERE idNetwork = in_idNetwork
     			AND   idUser    = va_idLektoUser
     			AND   coProfile = 'ADMR';
     				
     		END IF;			
     
     		INSERT INTO UserProfileRegional
     		(
     		  idUserProfile
     		, idRegionalNetwork  
     		, dtInserted
     		)
     		SELECT UserProfile.idUserProfile
     			, NetRefr.idNetwork
     			, NOW()
     		FROM UserProfile
     			INNER JOIN Network
     				   ON Network.idNetwork = UserProfile.idNetwork
     			INNER JOIN Network AS NetRefr
     				   ON NetRefr.idNetworkReference = Network.idNetwork
     			INNER JOIN tabProfileRegional
     				   ON tabProfileRegional.coDistrict = NetRefr.coDistrict
     		WHERE UserProfile.idNetwork = in_idNetwork
     		AND   UserProfile.idUser    = va_idLektoUser
     		AND   UserProfile.coProfile = 'ADMR'
			AND   NOT EXISTS ( SELECT * 
					         FROM UserProfileRegional
						    WHERE UserProfileRegional.idUserProfile     = UserProfile.idUserProfile
						    AND   UserProfileRegional.idRegionalNetwork = NetRefr.idNetwork
						  );
						  
     	ELSE 
		
			-- Se nao for administrador de regional (ou nao for enviado no payload) mas possuir perfil previo cadastrado, desabilita o perfil     	
     		IF va_ProfileExists > 0
     		THEN 	
			
				UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 0
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ADMR';			
			
			END IF;

     	END IF; 

     	/***********************************/
     	/* Perfil: Administrador de Escola */  

		-- Verifica se o usuário já possui perfil cadastrado
		SET va_ProfileExists := ( SELECT COUNT(1)
							 FROM UserProfile
							 WHERE idNetwork = in_idNetwork
							 AND   idUser    = va_idLektoUser
							 AND   coProfile = 'ADMS' 
							 FOR UPDATE );			    
     
     	INSERT INTO tabSchoolManager 
     	(
     	  txCodeSchool
     	)
     	SELECT txCodeSchool
     	FROM JSON_TABLE ( in_jsonData, '$.profiles.schoolManager[*]'  COLUMNS ( txCodeSchool VARCHAR(36) PATH '$' ) ) AS ProfileSchool;		
     	
     	IF ( SELECT COUNT(1) FROM tabSchoolManager ) > 0
     	THEN
     
     		# Possui registro cadastrado com o perfil Administrador de escola?
     		IF va_ProfileExists = 0
     		THEN
     		
     			INSERT INTO UserProfile
     			(
     			  idNetwork
     			, idUser
     			, coProfile
     			, inDeleted
     			, inStatus
     			, dtInserted
     			)
     			VALUES
     			(
     			  in_idNetwork
     			, va_idLektoUser		
     			, 'ADMS'
     			, 0
     			, 1
     			, NOW()
     			);
     		
     		ELSE
     		
     			UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 1
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ADMS';
     				
     		END IF;			
     		
     		INSERT INTO UserProfileSchool
     		(
     		  idUserProfile
     		, idNetwork
     		, idSchool
     		, dtInserted
     		)
     		SELECT DISTINCT 
				  UserProfile.idUserProfile
     			, School.idNetwork
     			, School.idSchool
     			, NOW()
     		FROM UserProfile
     			INNER JOIN School 
     				   ON School.idNetwork = UserProfile.idNetwork
     		WHERE UserProfile.idNetwork = in_idNetwork
     		AND   UserProfile.idUser    = va_idLektoUser
     		AND   UserProfile.coProfile = 'ADMS'
     		AND   School.txCodeOrigin IN ( SELECT txCodeSchool FROM tabSchoolManager )
			AND   NOT EXISTS ( SELECT UserProfileSchool.idUserProfileSchool
					         FROM UserProfileSchool
						    WHERE UserProfileSchool.idNetwork 	  = School.idNetwork
						    AND   UserProfileSchool.idSchool  	  = School.idSchool
						    AND   UserProfileSchool.idUserProfile = UserProfile.idUserProfile
					       );			
     
     	ELSE 
		
			-- Se nao for administrador de escola (ou nao for enviado no payload) mas possuir perfil previo cadastrado, desabilita o perfil     	
     		IF va_ProfileExists > 0
     		THEN 	
			
				UPDATE UserProfile
     			   SET inDeleted = 0
     			     , inStatus = 0
     				, dtLastUpdate = NOW()
     			WHERE UserProfile.idNetwork = in_idNetwork
     			AND   UserProfile.idUser    = va_idLektoUser
     			AND   UserProfile.coProfile = 'ADMS';		
				
			END IF;				
	
     	END IF; # schoolManager

     	/***********************************/
     	/* Cadastro de Estrutura academica */ 
		
     	# Se todos os cadastros estiverem corretos, cadastra a turma
		IF ( 
	 	   SELECT COUNT(1) 
	 	   FROM tabUserPayload 
	  		   INNER JOIN Class
			           ON Class.txCodeOrigin = tabUserPayload.classCodeOrigin 
		   WHERE Class.idNetwork = in_idNetwork
	        ) > 0
		THEN
		
			UPDATE Class
				  INNER JOIN tabUserPayload
				  	     ON tabUserPayload.classCodeOrigin = Class.txCodeOrigin 
			SET txName = tabUserPayload.ClassName
			  , dtLastUpdate = NOW()
			WHERE Class.idNetwork = in_idNetwork;
		
		ELSE 
		
			INSERT INTO Class
			(
			  idNetwork
			, idSchool
			, coGrade
			, idSchoolYear
			, txName
			, inStatus
			, txCodeOrigin
			, coClassShift
			, dtInserted
			)
			SELECT School.idNetwork
				, School.idSchool
				, Grade.coGrade
				, va_idSchoolYear AS idSchoolYear
				, tabUserPayload.ClassName
				, 1
				, tabUserPayload.classCodeOrigin
				, ClassShift.coClassShift
				, NOW() AS dtInserted
			FROM tabUserPayload
				INNER JOIN School
					   ON School.txCodeOrigin = tabUserPayload.CodeOriginSchool
				INNER JOIN SchoolGrade
					   ON SchoolGrade.idNetwork = School.idNetwork
					  AND SchoolGrade.idSchool  = School.idSchool
				INNER JOIN Grade
					   ON Grade.coGrade = SchoolGrade.coGrade
				INNER JOIN ClassShift 
					   ON ClassShift.coClassShift = tabUserPayload.coClassShift				  
			WHERE School.idNetwork = in_idNetwork
			AND   tabUserPayload.coGrade = Grade.coGrade;
					    
		END IF;
					    
     	/*************************/
     	/* Cadastro de Estudante */ 
		
     	IF va_isStudent = 'true'
     	THEN 
		
			# Recupera os dados academicos para tratamento do estudante
     		INSERT INTO tabStudent
					(
					  idNetwork
					, idSchool
					, coGrade
					, idUserStudent
					)			
     		SELECT SchoolGrade.idNetwork
     			, SchoolGrade.idSchool
     			, SchoolGrade.coGrade
     			, LektoUser.idUser
     		FROM tabUserPayload
                    INNER JOIN LektoUser
                            ON LektoUser.txCodeOrigin = tabUserPayload.codeOriginUser
     			INNER JOIN School
     				   ON School.idNetwork    = LektoUser.idNetwork 
					  AND School.txCodeOrigin = tabUserPayload.CodeOriginSchool
     			INNER JOIN SchoolGrade
     				   ON SchoolGrade.idNetwork = School.idNetwork
     				  AND SchoolGrade.idSchool  = School.idSchool
     				  AND SchoolGrade.coGrade   = tabUserPayload.coGrade	
			WHERE School.idNetwork = in_idNetwork;
			
			# Busca o id do estudante
			SET va_idStudent := ( SELECT DISTINCT Student.idStudent
							  FROM Student
								  INNER JOIN tabStudent
								          ON tabStudent.idNetwork 		= Student.idNetwork
									    AND tabStudent.idSchool  		= Student.idSchool
									    AND tabStudent.coGrade   		= Student.coGrade
									    AND tabStudent.idUserStudent 	= Student.idUserStudent );
			 
			# Se não for encontrado, cadastra
			IF va_idStudent IS NULL
			THEN 
					
				INSERT INTO Student
						(
						  idNetwork
						, idSchool
						, coGrade
						, idUserStudent
						, dtInserted
						)
				SELECT DISTINCT 
					  idNetwork
					, idSchool
					, coGrade
					, idUserStudent
					, NOW() AS dtInserted
				FROM tabStudent;		
				
				SET va_idStudent := LAST_INSERT_ID();
				
			END IF;
			
			-- Desativa os usuários das turmas caso a turma não seja enviada no payload
     		UPDATE StudentClass
				  INNER JOIN Student
				          ON Student.idNetwork 	= StudentClass.idNetwork
					    AND Student.idSchool  	= StudentClass.idSchool
					    AND Student.coGrade  	= StudentClass.coGrade
					    AND Student.idUserStudent = StudentClass.idUserStudent
					    AND Student.idStudent     = StudentClass.idStudent
			       INNER JOIN LektoUser
						ON LektoUser.idNetwork = Student.idNetwork
					    AND LektoUser.idUser    = Student.idUserStudent
			       INNER JOIN Class
						ON Class.idNetwork 		= StudentClass.idNetwork
					    AND Class.idSchool 		= StudentClass.idSchool
					    AND Class.coGrade 		= StudentClass.coGrade
					    AND Class.idSchoolYear 	= StudentClass.idSchoolYear
					    AND Class.idClass 		= StudentClass.idClass
			       INNER JOIN SchoolGrade
					     ON SchoolGrade.idNetwork = Class.idNetwork
					    AND SchoolGrade.idSchool  = Class.idSchool
					    AND SchoolGrade.coGrade   = Class.coGrade
				  INNER JOIN School
				          ON School.idNetwork = SchoolGrade.idNetwork
					    AND School.idSchool  = SchoolGrade.idSchool
			       LEFT JOIN tabUserPayload AS UserPayload
				          ON UserPayload.codeOriginSchool = School.txCodeOrigin
					    AND UserPayload.coGrade          = SchoolGrade.coGrade
					    AND UserPayload.classCodeOrigin  = Class.txCodeOrigin
		     SET StudentClass.inStatus = CASE WHEN UserPayload.classCodeOrigin IS NULL 
										OR UserPayload.classEnabled = 0
									   THEN 0
									   ELSE 1
								   END
			  , StudentClass.dtLastUpdate = NOW()
     		WHERE LektoUser.idNetwork    = in_idNetwork
			AND   LektoUser.txCodeOrigin = va_CodeOriginUser;
			
			-- Vincula o aluno nas turmas enviadas
			INSERT INTO StudentClass
					(
					  idNetwork
					, idSchool
					, coGrade
					, idSchoolYear
					, idClass
					, idUserStudent
					, idStudent
					, inStatus
					, dtInserted
					)
			SELECT DISTINCT
				  Class.idNetwork
				, Class.idSchool
				, Class.coGrade
				, Class.idSchoolYear
				, Class.idClass
				, tabStudent.idUserStudent
				, va_idStudent
				, 1 AS inStatus
				, NOW()
			FROM tabStudent
				INNER JOIN Class
					   ON Class.idNetwork 	= tabStudent.idNetwork
					  AND Class.idSchool 	= tabStudent.idSchool
					  AND Class.coGrade 	= tabStudent.coGrade
			WHERE Class.idSchoolYear = va_idSchoolYear
			AND   Class.txCodeOrigin IN ( SELECT classCodeOrigin FROM tabUserPayload WHERE classEnabled = 1 )
			AND   NOT EXISTS ( SELECT idStudentClass
						    FROM StudentClass
						    WHERE StudentClass.idNetwork	  = Class.idNetwork
						    AND   StudentClass.idSchool	  = Class.idSchool
						    AND   StudentClass.coGrade	  = Class.coGrade
						    AND   StudentClass.idSchoolYear  = Class.idSchoolYear	
						    AND   StudentClass.idClass	  = Class.idClass
						    AND   StudentClass.idUserStudent = tabStudent.idUserStudent	
						    AND   StudentClass.idStudent	  = va_idStudent);   

		END IF;
     
     END IF;

     COMMIT;

END