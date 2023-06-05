


# Alunos e Turmas
INSERT INTO Apprentice
(
  idUser
, idClass
, idBeacon
, coClassShift
)
SELECT DISTINCT
	  leus.idUser
	, clss.idSchoolClass AS idClass
	, NULL AS idBeacon
	, NULL AS coClassShift
FROM tmp5_SESC_AlunosTurmas sesc
	INNER JOIN
	School scho
		ON scho.txCnpj = sesc.CNPJEscola
	INNER JOIN
	Grade grad
		ON grad.txGrade = sesc.NomeSerie
	INNER JOIN
	SchoolGrade scgr
		ON scgr.idGrade = grad.idGrade AND scgr.idSchool = scho.idSchool
	INNER JOIN
	SchoolClass clss
		ON clss.idSchoolGrade = clss.idSchoolGrade
		AND clss.txName = sesc.NomeTurma
	INNER JOIN
	LektoUser leus
		ON leus.txCpf = sesc.CPFAluno
WHERE NOT EXISTS ( SELECT 1 
									 FROM Apprentice
									 WHERE Apprentice.idUser = leus.idUser
									 AND   Apprentice.idClass = clss.idSchoolClass );



		