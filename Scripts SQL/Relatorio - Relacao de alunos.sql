SELECT LektoUser.idUser AS `ID Aluno`
	, LektoUser.txName AS `Nome Aluno`
	, District.txName AS `Departamento Regional`
	, Stage.txName AS `Etapa de ensino`
	, Grade.txGrade AS `Série/ano`
FROM LektoUser	
	INNER JOIN Apprentice
		   ON Apprentice.idUser = LektoUser.idUser
	INNER JOIN SchoolClass
		   ON SchoolClass.idSchoolClass = Apprentice.idClass		
	INNER JOIN SchoolGrade
	        ON SchoolGrade.idSchoolGrade = SchoolClass.idSchoolGrade
	INNER JOIN Grade
		   ON Grade.idGrade = SchoolGrade.idGrade		
	INNER JOIN GradeStage
		   ON GradeStage.idGrade = Grade.idGrade
	INNER JOIN Stage
	        ON Stage.idStage = GradeStage.idStage	
	INNER JOIN School
	   ON School.idSchool = SchoolGrade.idSchool		  
	INNER JOIN SchoolNetwork
	   ON SchoolNetwork.idSchoolNetwork = School.idSchoolNetwork	
	INNER JOIN Address
		   ON Address.idAddress = School.idAddress	  
	LEFT JOIN  District
		   ON District.coDistrictCode = Address.coDistrictCode		   
WHERE LektoUser.inDeleted = 0
AND   LektoUser.inStatus = 1
AND   SchoolClass.inStatus = 1
AND   SchoolGrade.inStatus = 1
AND   Stage.inStatus = 1
AND   School.inStatus = 1
AND   SchoolNetwork.txName = 'SESI'
ORDER BY District.txName, LektoUser.idUser;