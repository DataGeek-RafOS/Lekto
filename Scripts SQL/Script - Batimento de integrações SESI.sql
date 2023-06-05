SELECT uni_uf
		 , idunidade
		 , uni_nome
		 , COUNT(1)
FROM relatorio_lekto_291222
WHERE perfil = 'ESTUDANTE'
GROUP BY uni_uf
		 , idunidade
		 , uni_nome
		 with ROLLUP
ORDER BY 1, 3;
	   
		 
SELECT
	* -- 7710
FROM
	relatorio_lekto_291222 relatorio 
WHERE
	perfil = 'ESTUDANTE' AND uni_uf = 'PA'
	AND NOT EXISTS (
	SELECT
		1 
	FROM
		LektoUser
		INNER JOIN LektoUserType ON LektoUserType.idUser = LektoUser.idUser
		INNER JOIN School ON School.idSchool = LektoUserType.idSchool
		INNER JOIN Address ON Address.idAddress = School.idAddress
		INNER JOIN District ON District.coDistrictCode = Address.coDistrictCode
		INNER JOIN SchoolNetwork ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork 
	WHERE
		LektoUserType.coUserType = 'ALNO' 
		AND SchoolNetwork.txName = 'SESI' 
		AND LektoUser.inStatus = 1 
		AND LektoUser.txCodeOrigin = relatorio.idUsuario 
	) 




 
SELECT uni_uf, perfil, count(1)
FROM
	relatorio_lekto_291222 relatorio 
WHERE
	uni_uf = 'PA'
group by uni_uf, perfil;

select * from relatorio_lekto_291222 relatorio 


SELECT coUserType, COUNT(1)
FROM relatorio_lekto_291222 relatorio
		 INNER JOIN LektoUser usuario
			       ON usuario.txCodeOrigin = relatorio.idusuario
		 LEFT JOIN LektoUserType tipo
				     ON tipo.idUser = usuario.idUser
WHERE perfil = 'ESTUDANTE'

AND   NOT EXISTS ( SELECT 1 
									 FROM LektoUser	
									 		  INNER JOIN LektoUserType
									 			 			  ON LektoUserType.idUser = LektoUser.idUser
									 		  INNER JOIN School
									 			 			  ON School.idSchool = LektoUserType.idSchool
									 		  INNER JOIN Address
									 			 			  ON Address.idAddress = School.idAddress
									 		  INNER JOIN District
									 			 			  ON District.coDistrictCode = Address.coDistrictCode						 
									 		  INNER JOIN SchoolNetwork
									 						  ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork
									 WHERE LektoUserType.coUserType = 'ALNO'						 
									 AND   SchoolNetwork.txName = 'SESI'
									 AND   LektoUser.inStatus = 1	
									 AND   LektoUser.txCodeOrigin = relatorio.idUsuario )
GROUP BY coUserType									 
		 		 
		 
		 
		 
SELECT District.coDistrictCode AS Estado
		 , School.txName AS `Unidade Escolar` 
		 , COUNT(Apprentice.idApprentice) AS `Quantidade de Alunos`
FROM SchoolNetwork
	   INNER JOIN School
			 ON School.idSchoolNetwork = SchoolNetwork.idSchoolNetwork
	   INNER JOIN Address
	           ON Address.idAddress = School.idAddress
	   INNER JOIN District
                ON District.coDistrictCode = Address.coDistrictCode
	   INNER JOIN SchoolGrade
	           ON SchoolGrade.idSchool = School.idSchool
	   INNER JOIN Grade
			 ON Grade.idGrade = SchoolGrade.idGrade
	   INNER JOIN SchoolClass
	           ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
	   INNER JOIN Apprentice
	           ON Apprentice.idClass = SchoolClass.idSchoolClass
	   INNER JOIN LektoUser
	           ON LektoUser.idUser = Apprentice.idUser
WHERE SchoolNetwork.txName LIKE '%SESI%'
AND   LektoUser.inStatus = 1
GROUP BY District.coDistrictCode
	     , School.txName WITH ROLLUP
ORDER BY 1, 2;

SELECT
	District.coDistrictCode AS Estado,
	School.txName AS `Unidade Escolar`,
	COUNT(*) AS `Quantidade de Alunos` 
FROM
	LektoUser
	INNER JOIN LektoUserType 
		   ON LektoUserType.idUser = LektoUser.idUser
	INNER JOIN School 
		   ON School.idSchool = LektoUserType.idSchool
	INNER JOIN Address 
	        ON Address.idAddress = School.idAddress
	INNER JOIN District 
	        ON District.coDistrictCode = Address.coDistrictCode
	INNER JOIN SchoolNetwork 
	        ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork 
WHERE LektoUserType.coUserType = 'ALNO' 
AND 	 SchoolNetwork.txName = 'SESI' 
AND 	 LektoUser.inStatus = 1 
GROUP BY
	  District.coDistrictCode
	  School.txName 
ORDER BY
	1,
	2;
		
		
		
-- Busca de usuários do ES
SELECT relatorio.uni_uf
	, relatorio.idunidade
	, relatorio.uni_nome
	, relatorio.perfil
	, relatorio.idusuario
	, relatorio.usa_nome
	, LektoUser.txName
	, LektoUser.idUser
	, LektoUserType.idLektoUserType
	, LektoUserType.idUser
	, LektoUserType.coUserType
	, LektoUserType.idSchool
	, LektoUserType.idSchoolNetwork
	, LektoUserType.dtInserted
	, LektoUserType.inDeleted
	, LektoUserType.coDistrictCode
	, LektoUserType.inStatus
	, Apprentice.idApprentice
FROM relatorio_lekto_291222 relatorio 
	INNER JOIN LektoUser
		   ON LektoUser.txCodeOrigin = relatorio.idusuario
	INNER JOIN LektoUserType
		   ON LektoUserType.idUser = LektoUser.idUser
     LEFT JOIN  Apprentice
	        ON Apprentice.idUser = LektoUser.idUser
WHERE perfil = 'ESTUDANTE'
AND   uni_uf IN ( 'AC', 'AP', 'CE', 'DF', 'ES', 'MA', 'MS', 'PA', 'SE')
AND   NOT EXISTS ( SELECT 1 
			    FROM LektoUser inUser
				    INNER JOIN LektoUserType
					       ON LektoUserType.idUser = LektoUser.idUser
				    INNER JOIN School
					       ON School.idSchool = LektoUserType.idSchool
				    INNER JOIN Address
					       ON Address.idAddress = School.idAddress
				    INNER JOIN District
						  ON District.coDistrictCode = Address.coDistrictCode						 
				    INNER JOIN SchoolNetwork
					       ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork
				 WHERE LektoUserType.coUserType = 'ALNO'						 
				 AND   SchoolNetwork.txName = 'SESI'
				 AND   inUser.idUser = LektoUser.idUser )


SELECT COUNT(1) FROM relatorio_lekto_291222 -- 49.901

SELECT COUNT(1) 
FROM relatorio_lekto_291222 
WHERE perfil = 'ESTUDANTE' -- 21.489 
AND   uni_uf IN ( 'AC', 'AP', 'CE', 'DF', 'ES', 'MA', 'MS', 'PA', 'SE')


SELECT
	District.coDistrictCode AS Estado,
	LektoUserType.coUserType,
	COUNT(*) AS `Quantidade de Alunos` 
FROM
	LektoUser
	INNER JOIN LektoUserType 
		   ON LektoUserType.idUser = LektoUser.idUser
	INNER JOIN School 
		   ON School.idSchool = LektoUserType.idSchool
	INNER JOIN Address 
	        ON Address.idAddress = School.idAddress
	INNER JOIN District 
	        ON District.coDistrictCode = Address.coDistrictCode
	INNER JOIN SchoolNetwork 
	        ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork 
WHERE  SchoolNetwork.txName = 'SESI' 
GROUP BY
	  District.coDistrictCode, LektoUserType.coUserType
ORDER BY
	1;
	
	
	
