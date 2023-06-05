
-- Coluna indicando que o usuário está ativo / Nome do usuário / Perfil (só alunos) / UF / Escola
SELECT District.coDistrictCode AS UF
	, School.txName AS Escola
	, LektoUser.txName AS Usuario
	, UserType.txUserType AS Perfil
	, Stage.txName AS Etapa
	, CASE WHEN LektoUser.inStatus = 1 THEN 'Ativo' ELSE 'Inativo' END AS `Status`
FROM LektoUser
	INNER JOIN LektoUserType 
		   ON LektoUserType.idUser = LektoUser.idUser
	INNER JOIN UserType
		   ON UserType.coUserType = LektoUserType.coUserType
	INNER JOIN School 
		   ON School.idSchool = LektoUserType.idSchool
	INNER JOIN Address 
	        ON Address.idAddress = School.idAddress
	INNER JOIN District 
	        ON District.coDistrictCode = Address.coDistrictCode
	INNER JOIN SchoolNetwork 
	        ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork 
	LEFT JOIN Apprentice
	        ON Apprentice.idUser = LektoUser.idUser
	LEFT JOIN  SchoolClass
	        ON SchoolClass.idSchoolClass = Apprentice.idClass
	LEFT JOIN  SchoolGrade
	        ON SchoolGrade.idSchoolGrade = SchoolClass.idSchoolGrade
	LEFT JOIN  Grade
		   ON  Grade.idGrade = SchoolGrade.idGrade
	LEFT JOIN  GradeStage
		   ON GradeStage.idGrade = Grade.idGrade
	LEFT JOIN  Stage
	        ON Stage.idStage = GradeStage.idStage
WHERE LektoUserType.coUserType = 'ALNO' 
AND 	 SchoolNetwork.txName = 'SESI' 
AND 	 LektoUser.inStatus = 1
AND   LektoUser.inDeleted = 0
AND   District.coDistrictCode IN ( 'AC', 'AP', 'CE', 'DF', 'ES', 'MA', 'MS', 'PA', 'SE')
ORDER BY 1, 2, 3;




/* Totais


-- Coluna indicando que o usuário está ativo / Nome do usuário / Perfil (só alunos) / UF / Escola

SELECT District.coDistrictCode AS UF
	, COUNT(1) AS QuantidadeAlunos
FROM LektoUser
	INNER JOIN LektoUserType 
		   ON LektoUserType.idUser = LektoUser.idUser
	INNER JOIN UserType
		   ON UserType.coUserType = LektoUserType.coUserType
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
AND   District.coDistrictCode IN ( 'AC', 'AP', 'CE', 'DF', 'ES', 'MA', 'MS', 'PA', 'SE')

GROUP BY District.coDistrictCode WITH ROLLUP
ORDER BY 1;



*/
