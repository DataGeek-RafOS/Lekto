SELECT School.txName AS `Nome da ESCOLA`
	, SchoolClass.txName AS `Nome da TURMA`
	, Grade.txGrade AS `Série da TURMA`
	, LektoUser.txName AS `Professor Vinculado`
	, LektoUser.txEmail AS `E-mail do PROFESSOR Vinculado`
FROM SchoolNetwork
     INNER JOIN
     School
          ON School.idSchoolNetwork = SchoolNetwork.idSchoolNetwork
	INNER JOIN
	SchoolGrade
		on School.idSchool = SchoolGrade.idSchool
	INNER JOIN
	Grade
		ON Grade.idGrade = SchoolGrade.idGrade
	INNER JOIN
	SchoolClass
		ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
	INNER JOIN
	LektoUser
		ON LektoUser.idUser = SchoolClass.idTutor
WHERE School.inStatus = 1
AND   School.inDeleted = 0
AND   SchoolGrade.inStatus = 1
AND   SchoolClass.inStatus = 1
AND   LektoUser.inStatus = 1
AND   LektoUser.inDeleted = 0
AND   SchoolNetwork.txName LIKE '%SESC%'
ORDER BY School.txName	
	  , SchoolClass.txName 
	  , Grade.txGrade
	  , LektoUser.txName;
