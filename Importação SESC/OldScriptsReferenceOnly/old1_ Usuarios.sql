/*
ALTER TABLE tmp1_SESC_Usuario CHANGE `Data Nascimento` DataNascimento VARCHAR(255);
ALTER TABLE tmp1_SESC_Usuario CHANGE `Estado Civil` EstadoCivil VARCHAR(255); 
ALTER TABLE tmp1_SESC_Usuario CHANGE `Nome da Cidade` NomeCidade VARCHAR(255);
ALTER TABLE tmp1_SESC_Usuario CHANGE `Endereço 1` Endereco1 VARCHAR(255);
ALTER TABLE tmp1_SESC_Usuario CHANGE `Endereço 2` Endereco2 VARCHAR(255);

DESC LektoUser;
desc tmp1_SESC_Usuario;

select * from tmp1_SESC_Usuario; ## 1402
*/




/* Inclusao de distrito nao informado */
SELECT * FROM District WHERE coDistrictCode = '--'
--	
	INSERT INTO District (coDistrictCode, txName) VALUES ('--', '<Não Informada>');
--

/* Remove usuarios sem CPF */
DELETE FROM tmp1_SESC_Usuario WHERE CPF = '-';

/* Inclusao das cidades */
INSERT INTO City (coDistrictCode, txName)
SELECT DISTINCT UF, UPPER(NomeCidade)
FROM tmp1_SESC_Usuario sesc
WHERE UF IS NOT NULL 
AND NOT EXISTS ( SELECT 1 FROM City WHERE sesc.UF = City.coDistrictCode AND sesc.NomeCidade = City.txName);	


/* Tem duplicados? */
SELECT coDistrictCode, txName, COUNT(1)
FROM City
GROUP BY coDistrictCode, txName
HAVING COUNT(1) > 1;



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
									



/* Inclusao de usuarios */

DELETE FROM tmp1_SESC_Usuario sesc WHERE Nome IS NULL;

DELETE FROM tmp1_SESC_Usuario WHERE CPF IN ( '09587630114', '01846614120', '06390443102');

START TRANSACTION;
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
WHERE NOT EXISTS (  SELECT 1 
				FROM LektoUser
				WHERE LektoUser.txCpf = sesc.CPF );
			
COMMIT;


## Validação
SELECT *
FROM LektoUser
WHERE dtInserted > '2022-07-30 00:00';