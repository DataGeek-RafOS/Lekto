### Inclusão de escolas

## Higienização

#ALTER TABLE tmp_SESC_Escola CHANGE `Endereço 1` Endereco1 VARCHAR(255);
#ALTER TABLE tmp_SESC_Escola CHANGE `Endereço 2` Endereco2 VARCHAR(255);
#ALTER TABLE tmp_SESC_Escola CHANGE `Nome da    Cidade` NomeCidade VARCHAR(255);

## Inclusão das cidades

INSERT INTO City (coDistrictCode, txName) 
SELECT DISTINCT UF, NomeCidade 
FROM tmp2_SESC_Escola sesc
WHERE NOT EXISTS ( SELECT 1 FROM City WHERE City.coDistrictCode = sesc.UF AND City.txName = sesc.NomeCidade );

## Inclusao dos enderecos das escolas
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

# Validação

SELECT *
FROM School
	INNER JOIN
	SchoolNetwork
		ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork
	INNER JOIN
	Address
		ON Address.idAddress = School.idAddress
WHERE SchoolNetwork.txName = 'SESC/DF';



