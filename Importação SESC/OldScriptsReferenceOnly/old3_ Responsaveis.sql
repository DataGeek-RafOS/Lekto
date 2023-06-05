

# Responsavel

SELECT *
FROM Relationship

# DESC Relationship;

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
			AND Relationship.idUserBound = Resp.idUser)
		;
		

## Vinculo de perfis de usuários

SELECT * 
FROM UserType;
		
SELECT *
FROM tmp1_SESC_Usuario;

## Primeiro atualizar a escola dos usuários - Campo CNPJ
SELECT COUNT(1) FROM tmp1_SESC_Usuario; -- 4430

SELECT CNPJ, COUNT(1) 
FROM tmp1_SESC_Usuario 
GROUP BY CNPJ; -- 4430

SELECT * FROM tmp2_SESC_Escola;

UPDATE tmp1_SESC_Usuario
	SET CNPJ = '03288908000726'
WHERE CNPJ IS NULL;




ALTER TABLE tmp1_SESC_Usuario ADD coUserType CHAR(4) NULL;

		