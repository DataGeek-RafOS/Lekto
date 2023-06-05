SELECT SchoolNetwork.txName AS `Rede`
	   , School.txName AS `Unidade Escolar`
	   , AppUser.idUser AS `ID Usuário Lekto`
		 , AppUser.txName AS `Nome`
		 , Grade.txGrade AS `Ano`
		 , SchoolClass.txName AS `Turma`
		 , ClassShift.txClassShift AS `Turno`
		 , Stage.txName AS `Segmento`
		 , IF(AppUser.inStatus = 1, "ATIVO", "INATIVO") AS `Status do cadastro`
FROM SchoolNetwork
  	 INNER JOIN
		 School
				ON School.idSchoolNetwork = SchoolNetwork.idSchoolNetwork
		 INNER JOIN
		 SchoolGrade
				ON SchoolGrade.idSchool = School.idSchool
		 INNER JOIN
		 Grade
			  ON Grade.idGrade = SchoolGrade.idGrade
		 INNER JOIN
		 SchoolClass
				ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
		 INNER JOIN
		 Apprentice
				ON Apprentice.idClass = SchoolClass.idSchoolClass
		 INNER JOIN
		 LektoUser AppUser
				ON AppUser.idUser = Apprentice.idUser
		 LEFT JOIN
		 ClassShift
			  ON ClassShift.coClassShift = Apprentice.coClassShift
	   LEFT JOIN
		 GradeStage
			  ON GradeStage.idGrade = Grade.idGrade
		 LEFT JOIN
		 Stage
			  ON Stage.idStage = GradeStage.idStage				
WHERE School.inDeleted = 0
AND   SchoolGrade.inStatus = 1
AND   SchoolClass.inStatus = 1
AND   AppUser.inDeleted = 0 				
AND   GradeStage.inStatus = 1
AND   Stage.inStatus = 1
				

