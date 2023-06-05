START TRANSACTION;

DROP TABLE IF EXISTS tabLektoUser;

CREATE TEMPORARY TABLE tabLektoUser (idUser INT);

INSERT INTO tabLektoUser (idUser)
SELECT lt.idUser
FROM LektoUserType lt
	INNER JOIN LektoUser lu
	        ON lu.idUser = lt.idUser
	INNER JOIN SchoolNetwork sn
		   ON sn.idSchoolNetwork = lt.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11
AND   lt.coUserType = 'SNRF';		   


DELETE lt
FROM LektoUserType lt
	INNER JOIN LektoUser lu
	        ON lu.idUser = lt.idUser
	INNER JOIN SchoolNetwork sn
		   ON sn.idSchoolNetwork = lt.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11
AND   lt.coUserType = 'SNRF';		   



# Aprendizes
DELETE a
FROM Apprentice a
     INNER JOIN
     SchoolClass sc
        ON a.idClass = sc.idSchoolClass
     INNER JOIN
     SchoolGrade sg 
        ON sc.idSchoolGrade = sg.idSchoolGrade
     INNER JOIN
     School s 
        ON sg.idSchool = s.idSchool
     INNER JOIN
     SchoolNetwork sn 
        ON s.idSchoolNetwork = sn.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11;


# Tutores
DELETE lu
FROM LektoUser lu
     INNER JOIN
     SchoolClass sc
        ON lu.idUser = sc.idTutor
     INNER JOIN
     SchoolGrade sg 
        ON sc.idSchoolGrade = sg.idSchoolGrade
     INNER JOIN
     School s 
        ON sg.idSchool = s.idSchool
     INNER JOIN
     SchoolNetwork sn 
        ON s.idSchoolNetwork = sn.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11;

# Turmas
DELETE sc
FROM SchoolClass sc
     INNER JOIN
     SchoolGrade sg 
        ON sc.idSchoolGrade = sg.idSchoolGrade
     INNER JOIN
     School s 
        ON sg.idSchool = s.idSchool
     INNER JOIN
     SchoolNetwork sn 
        ON s.idSchoolNetwork = sn.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11;

# Séries
DELETE sg
FROM SchoolGrade sg 
     INNER JOIN
     School s 
        ON sg.idSchool = s.idSchool
     INNER JOIN
     SchoolNetwork sn 
        ON s.idSchoolNetwork = sn.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11;

# Escola
DELETE s
FROM School s 
     INNER JOIN
     SchoolNetwork sn 
        ON s.idSchoolNetwork = sn.idSchoolNetwork
WHERE sn.idSchoolNetwork = 11;

# Usuários (Aprendizes)
DELETE lu
FROM LektoUser lu
     INNER JOIN
     tabLektoUser tm
        ON lu.idUser = tm.idUser
WHERE lu.idAuth0 IS NULL ;

ROLLBACK;
COMMIT;
	  