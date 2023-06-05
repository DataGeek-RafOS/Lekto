# Leitura dos dados
SELECT * FROM tmp2_SESC_Escola;
SELECT * FROM tmp1_SESC_Usuario;
SELECT * FROM tmp3_SESC_Responsavel WHERE CPFUsuario IS NULL;
SELECT * FROM tmp4_SESC_SeriesTurmas;
SELECT * FROM tmp5_SESC_AlunosTurmas WHERE CNPJEscola IS NULL;

# Higienização inicial
DELETE FROM tmp2_SESC_Escola WHERE CNPJ IS NULL;
DELETE FROM tmp1_SESC_Usuario WHERE CPF IS NULL OR CPF = '' OR CPF = '-';
SELECT * FROM tmp3_SESC_Responsavel;
SELECT * FROM tmp4_SESC_SeriesTurmas;
SELECT * FROM tmp5_SESC_AlunosTurmas;

# Higienização - coUserType
SELECT CNPJ, coUserType, COUNT(1)
FROM tmp1_SESC_Usuario
GROUP BY CNPJ, coUserType;

UPDATE tmp1_SESC_Usuario
   SET coUserType = CASE WHEN Tipo = 'RES' THEN 'PAIS'
					WHEN Tipo = 'TUTOR' THEN 'TUTO'
					WHEN Tipo = 'ALUNO' THEN 'ALNO'
					ELSE coUserType
				END;

# Inclusao de estado civil SELECT EstadoCivil, COUNT(1)
FROM tmp1_SESC_Usuario
GROUP BY EstadoCivil;

UPDATE tmp1_SESC_Usuario
SET EstadoCivil = CASE WHEN EstadoCivil = 'Casado(a)' THEN 'Casado'
	      			 WHEN EstadoCivil = 'Divorciado(a)' THEN 'Divorciado'
	      			 WHEN EstadoCivil = 'Solteiro(a)' THEN 'Solteiro'											 
	      			 WHEN EstadoCivil = 'Viúvo(a)' THEN 'Viúvo'				
	      			 WHEN EstadoCivil = 'Separado(a)' THEN 'Separado'					 
	      			 ELSE EstadoCivil
	        END
					
INSERT INTO MaritalStatus (coMaritalStatus, txName) VALUES ('SEP', 'Separado');
INSERT INTO MaritalStatus (coMaritalStatus, txName) VALUES ('NAI', 'Não Informado');
INSERT INTO MaritalStatus (coMaritalStatus, txName) VALUES ('OUT', 'Outro');


SELECT DISTINCT EstadoCivil
FROM tmp1_SESC_Usuario sesc
WHERE NOT EXISTS ( SELECT 1 FROM MaritalStatus WHERE MaritalStatus.txName = sesc.EstadoCivil )
AND EstadoCivil IS NOT NULL;

# Estados
SELECT * FROM District WHERE coDistrictCode = '--'
#--	
	INSERT INTO District (coDistrictCode, txName) VALUES ('--', '<Não Informada>');
#--


# Cidades
INSERT INTO City (coDistrictCode, txName)
SELECT DISTINCT UF, UPPER(NomeCidade)
FROM tmp1_SESC_Usuario sesc
WHERE UF IS NOT NULL 
AND   NomeCidade IS NOT NULL
AND NOT EXISTS ( SELECT 1 FROM City WHERE sesc.UF = City.coDistrictCode AND sesc.NomeCidade = City.txName);	

# Higienização - Séries - Importar somente 1º ao 9º ano do ensino fundamental
DELETE
FROM tmp4_SESC_SeriesTurmas sesc
WHERE NomeSerie LIKE '%CRECHE%'
OR    NomeSerie LIKE '%PRE%'
OR    NomeSerie LIKE '%MÉDIO%';

SELECT CNPJEscola, NomeSerie
FROM tmp4_SESC_SeriesTurmas
GROUP BY CNPJEscola, NomeSerie;

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


# Exclusão de usuários que não devem ser cadastrados (Fora do 1 ao 9 ano)
DELETE aluno
FROM tmp1_SESC_Usuario aluno
		 INNER JOIN
		 tmp5_SESC_AlunosTurmas turma
				ON turma.CPFAluno = aluno.CPF
WHERE aluno.coUserType = 'ALNO'				
AND ( NomeSerie LIKE '%CRECHE%' OR    NomeSerie LIKE '%PRE%' OR    NomeSerie LIKE '%MÉDIO%' )				


SELECT CNPJEscola, NomeSerie, COUNT(1)
FROM tmp1_SESC_Usuario aluno
		 INNER JOIN
		 tmp5_SESC_AlunosTurmas turma
				ON turma.CPFAluno = aluno.CPF
WHERE aluno.coUserType = 'ALNO'				
GROUP BY CNPJEscola, NomeSerie
		 



# Endereço de usuários
INSERT INTO Address 
( 
  idCity
, txAddressLine1
, txAddressLine2
, txZipcode
, txNeighborhood
, dtInserted
)
SELECT DISTINCT
	  City.idCity AS idCity
	, Endereco1 AS txAddressLine1
	, Endereco2 AS txAddressLine2
	, CEP AS txZipcode
	, NomeCidade AS txNeighborhood
	, NOW() AS dtInserted
FROM tmp1_SESC_Usuario sesc
	INNER JOIN
	City
		ON sesc.UF = City.coDistrictCode 
		AND sesc.NomeCidade = City.txName
WHERE sesc.Endereco1 IS NOT NULL
AND  LENGTH(CEP) <= 9
AND  NOT EXISTS ( SELECT 1 
								  FROM Address
									WHERE Address.txAddressLine1 = sesc.Endereco1
									AND Address.txAddressLine2 = sesc.Endereco2 )





# Usuários (inclusão)
INSERT INTO LektoUser
(
  txName
, inStatus
, idAuth0
, txImagePath
, dtInserted
, inDeleted
, txEmail
, txNickname
, txPhone
, txCpf
, dtBirthdate
, idAddress
, idCityPlaceOfBirth
, coMaritalStatus
, isLgpdTermsAccepted
)
SELECT DISTINCT 
	  Nome AS txName
	, 1 AS inStatus
	, NULL AS idAuth0
	, NULL AS txImagePath
	, NOW() AS dtInserted
	, 0 AS inDeleted
	, Email AS txEmail
	, Apelido AS txNickname
	, RIGHT(REGEXP_REPLACE(Telefone, '[^0-9]+', ''), 11) AS txPhone
	, CPF AS txCpf
	, CONCAT(RIGHT(DataNascimento, 4), '-', SUBSTR(DataNascimento,4,2), '-', LEFT(DataNascimento, 2)) AS dtBirthdate
	, addr.idAddress
	, NULL AS idCityPlaceOfBirth
	, coMaritalStatus
	, 1 AS isLgpdTermsAccepted
FROM tmp1_SESC_Usuario sesc
	LEFT JOIN
	Address addr
			ON addr.txAddressLine1 = sesc.Endereco1
			AND addr.txAddressLine2 = sesc.Endereco2
	LEFT JOIN
	MaritalStatus mars		
			ON mars.txName = sesc.EstadoCivil		
WHERE NOT EXISTS (  
								 SELECT 1 
								 FROM LektoUser
								 WHERE LektoUser.txCpf = sesc.CPF );
			
			
			
# Escolas
	# Endereço das escolas
INSERT INTO Address 
( 
  idCity
, txAddressLine1
, txAddressLine2
, txZipcode
, txNeighborhood
, dtInserted
)
SELECT City.idCity AS idCity
	, Endereco1 AS txAddressLine1
	, Endereco2 AS txAddressLine2
	, CEP AS txZipcode
	, NomeCidade AS txNeighborhood
	, NOW() AS dtInserted
FROM tmp2_SESC_Escola sesc
		 INNER JOIN
		 City
					 ON City.coDistrictCode = sesc.UF 
					 AND City.txName = sesc.NomeCidade
AND  NOT EXISTS ( SELECT 1 
								  FROM Address
									WHERE Address.txAddressLine1 = sesc.Endereco1
									AND Address.txAddressLine2 = sesc.Endereco2 );	
									

## Rede já existe?
SELECT * FROM SchoolNetwork;
	INSERT INTO SchoolNetwork (txName, dtinserted) VALUES ('SESC/DF', NOW());


## Inclusao das escolas
INSERT INTO School
(
  txName
, inStatus
, dtInserted
, idSchoolNetwork
, IdMediaInfoLogo
, idAddress
, txTradingName
, txCnpj
, txStateRegistration
, txMunicipalRegistration
, inDeleted
)
SELECT Nome AS txName
	, 1 AS inStatus
	, NOW() AS dtInserted
	, (SELECT idSchoolNetwork FROM SchoolNetwork WHERE txName = 'SESC/DF') AS idSchoolNetwork
	, NULL IdMediaInfoLogo
	, addr.idAddress AS idAddress
	, Razão_Social AS txTradingName
	, CNPJ AS txCnpj
	, Registro_Estadual AS txStateRegistration
	, Registro_Municipal AS txMunicipalRegistration
	, 0 AS inDeleted
FROM tmp2_SESC_Escola sesc
		 INNER JOIN
		 Address addr
					 ON addr.txAddressLine1 = sesc.Endereco1
					 AND addr.txAddressLine2 = sesc.Endereco2
WHERE NOT EXISTS ( SELECT 1 FROM School WHERE School.txCnpj = sesc.CNPJ);
									


## Tipos de usuários
INSERT INTO LektoUserType
(
  idUser
, coUserType
, idSchool
, idSchoolNetwork
, dtInserted
, coDistrictCode
)
SELECT DISTINCT 
      leus.idUser
	, sesc.coUserType
	, scho.idSchool AS idSchool
	, scne.idSchoolNetwork AS idSchoolNetwork
	, NOW() AS dtInserted
	, sesc.UF
FROM tmp1_SESC_Usuario sesc
		 INNER JOIN
		 LektoUser leus
					ON leus.txCpf = sesc.CPF
		 INNER JOIN
		 School scho
					ON scho.txCnpj = sesc.CNPJ
		 INNER JOIN
		 SchoolNetwork scne
					ON scne.idSchoolNetwork = scho.idSchoolNetwork
WHERE NOT EXISTS ( SELECT 1
			    FROM LektoUserType
			    WHERE LektoUserType.idUser = leus.idUser
			    AND   LektoUserType.coUserType = sesc.coUserType
			    AND   LektoUserType.idSchool = scho.idSchool
			    AND   LektoUserType.idSchoolNetwork = scne.idSchoolNetwork)


# Relação entre usuários
INSERT INTO Relationship
(
  idUser
, idUserBound
, coRelationType
, dtInserted
, inDeleted
)
SELECT Appr.idUser
	, Resp.idUser AS idUserBound
	, 'RESP' AS coRelationType 
	, NOW() AS dtInserted
	, 0 AS inDeleted
FROM tmp3_SESC_Responsavel sesc
		 INNER JOIN
		 LektoUser Appr
					ON Appr.txCpf = sesc.CPFUsuario
		 LEFT JOIN
		 LektoUser Resp
					ON Resp.txCpf = sesc.CPFResponsavel
WHERE Resp.idUser IS NOT NULL 
AND NOT EXISTS ( SELECT 1 
			FROM Relationship 
			WHERE Relationship.idUser = Appr.idUser 
			AND Relationship.idUserBound = Resp.idUser);	
		
# Cadastro de sériesINSERT INTO Grade (txGrade)
SELECT DISTINCT NomeSerie
FROM tmp4_SESC_SeriesTurmas sesc
WHERE NOT EXISTS ( SELECT 1 
									 FROM Grade
									 WHERE txGrade = sesc.NomeSerie );

# Cadastro de séries nas escolas do SESC
INSERT INTO SchoolGrade
(
  idSchool
, idGrade
, inStatus
, dtInserted
)
SELECT DISTINCT
	  scho.idSchool
	, idGrade
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
									 
									 

# Cadastro de turmas
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
		 LEFT JOIN
		 LektoUser lusr
		 		ON lusr.txCpf = sesc.CPFTutor
WHERE NOT EXISTS (
									SELECT 1 
									FROM SchoolClass
									WHERE SchoolClass.idSchoolGrade = scgr.idSchoolGrade
									AND   SchoolClass.txName = sesc.NomeTurma);									 

## Higienização de Turmas
DELETE
FROM tmp5_SESC_AlunosTurmas sesc
WHERE NomeSerie LIKE '%CRECHE%'
OR    NomeSerie LIKE '%PRE%'
OR    NomeSerie LIKE '%MÉDIO%';

SELECT CNPJEscola, NomeSerie, COUNT(1)
FROM tmp5_SESC_AlunosTurmas
GROUP BY CNPJEscola, NomeSerie;

UPDATE tmp5_SESC_AlunosTurmas
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


# Alunos e Turmas
INSERT INTO Apprentice
(
  idUser
, idClass
, idBeacon
, coClassShift
)
SELECT DISTINCT
	  leus.idUser
	, clss.idSchoolClass AS idClass
	, NULL AS idBeacon
	, NULL AS coClassShift
FROM tmp5_SESC_AlunosTurmas sesc
	INNER JOIN
	School scho
		ON scho.txCnpj = sesc.CNPJEscola
	INNER JOIN
	Grade grad
		ON grad.txGrade = sesc.NomeSerie
	INNER JOIN
	SchoolGrade scgr
		ON scgr.idGrade = grad.idGrade AND scgr.idSchool = scho.idSchool
	INNER JOIN
	SchoolClass clss
		ON clss.idSchoolGrade = clss.idSchoolGrade
		AND clss.txName = sesc.NomeTurma
	INNER JOIN
	LektoUser leus
		ON leus.txCpf = sesc.CPFAluno
WHERE NOT EXISTS ( SELECT 1 
									 FROM Apprentice
									 WHERE Apprentice.idUser = leus.idUser
									 AND   Apprentice.idClass = clss.idSchoolClass );
									 
									 
									 

