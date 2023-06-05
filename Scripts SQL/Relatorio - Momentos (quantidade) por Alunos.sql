SELECT SchoolNetwork.txName AS `Rede`
	, School.txName AS `Escola`
	, SchoolClass.txName AS `Turma`
	, LektoUser.txName AS `Aluno`
	, COUNT(DISTINCT Moment.idMoment) AS `Quantidade de Momentos Gerados`
FROM SchoolNetwork
	INNER JOIN
	School
		ON School.idSchoolNetwork = SchoolNetwork.idSchoolNetwork
	INNER JOIN
	SchoolGrade
		ON SchoolGrade.idSchool = School.idSchool
	INNER JOIN
	SchoolClass
		ON SchoolClass.idSchoolGrade = SchoolGrade.idSchoolGrade
	INNER JOIN
	Apprentice
		ON Apprentice.idClass = SchoolClass.idSchoolClass
	INNER JOIN
	LektoUser
		ON LektoUser.idUser = Apprentice.idUser
	LEFT JOIN
	ApprenticeMoment
		ON ApprenticeMoment.idApprentice = Apprentice.idApprentice
	LEFT JOIN
	MomentCard
		ON MomentCard.idMomentCard = ApprenticeMoment.idMomentCard
	LEFT JOIN
	Moment
		ON Moment.idMoment = MomentCard.idMoment
WHERE School.inDeleted = 0
AND   SchoolGrade.inStatus = 1
AND   SchoolClass.inStatus = 1
AND   SchoolNetwork.txName LIKE '%SESC%'
AND   Moment.dtStart BETWEEN '2022-11-01' AND '2022-11-30'
GROUP BY SchoolNetwork.txName
       , School.txName
	  , SchoolClass.txName
	  , LektoUser.txName
ORDER BY SchoolNetwork.txName
	  , School.txName
	  , SchoolClass.txName
	  , LektoUser.txName;


