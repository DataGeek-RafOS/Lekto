

SELECT School.txName AS `ESCOLA`
	, SchoolClass.txName AS TURMA
	, Agenda.dtAgenda AS `DATA DO MOMENTO`
	, MomentStatus.txMomentStatus AS `STATUS DO MOMENTO`
	, LektoUser.txName AS `PROFESSOR`
	, LektoUser.txPhone AS TELEFONE
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
	LektoUser
		ON LektoUser.idUser = SchoolClass.idTutor
	INNER JOIN
	Moment
		ON Moment.idSchoolClass = SchoolClass.idSchoolClass
	INNER JOIN
	MomentStatus
		ON MomentStatus.coMomentStatus = Moment.coMomentStatus
	INNER JOIN
	Agenda
		ON Agenda.idAgenda = Moment.idAgenda
WHERE SchoolNetwork.txName = 'SESC/DF'		
ORDER BY School.txName
	  , SchoolClass.txName;
