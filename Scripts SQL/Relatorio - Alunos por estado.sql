# Estado - Unidade Escolar - Ano - Turmas - Quantidade de Alunos


SELECT District.coDistrictCode AS Estado
	, School.txName AS `Unidade Escolar` 
	, Grade.txGrade AS `Ano`
	, SchoolClass.txName AS `Turmas`
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
WHERE SchoolNetwork.txName LIKE '%SESI%'
GROUP BY District.coDistrictCode
	  , School.txName
	  , Grade.txGrade
	  , SchoolClass.txName;

