# aluno
SET @network := 30; # 1: stg e 6: dev
SET @json := '
{"name":"LUÍSA RODRIGUES COSTA","email":"luisa.039491@edusesc.com.br","codeOrigin":"07995416130","imagePath":null,"phone":null,"birthdate":null,"document":"07995416130","enabled":true,"schools":[{"name":"Ceilândia","codeOrigin":"CEILANDIA","district":"DF"}],"profiles":{"isNetworkAdmin":false,"isStudent":true,"regionalAdmin":[],"schoolManager":[],"professor":[],"student":[{"class":{"name":"EF9-3º ANO-A","enabled":true,"codeOrigin":"CEILANDIA3EF9-3º ANO-AF1MAT2","codeOriginSchool":"CEILANDIA","classShift":"MAT","stage":"F1","grade":3,"originalCodeOrigin":"CEILANDIA3EF9-3º ANO-AF1MAT"}}]},"relationships":[]}
';

CALL spuDataIntegration(@network, @json);


SELECT * FROM LektoUser
WHERE txEmail = 'luisa.039491@edusesc.com.br';


SELECT *
FROM LektoUser 
	INNER JOIN Student 
	        ON Student.idNetwork = LektoUser.idNetwork AND Student.idUserStudent = LektoUser.idUser
	LEFT JOIN StudentClass
	        ON  StudentClass.idNetwork		= Student.idNetwork
		   AND StudentClass.idSchool		= Student.idSchool
		   AND StudentClass.coGrade		= Student.coGrade
		   AND StudentClass.idUserStudent	= Student.idUserStudent
		   AND StudentClass.idStudent		= Student.idStudent
WHERE LektoUser.idNetwork = 30
AND LektoUser.txCodeOrigin = '07995416130';


# Professor

SET @json := '
{"name":"CAIO ERICK FELIX VIGA","email":"00000644@sesiac.org.br","codeOrigin":"2911630","birthdate":"2012-07-20","document":"03234807213","enabled":true,"schools":[{"name":"CENTRO EDUCACIONAL MARILIA SANT&#39;ANA","codeOrigin":"201","district":"AC"}],"profiles":{"isNetworkAdmin":false,"isStudent":true,"student":[{"class":{"name":"B","enabled":true,"codeOrigin":"B","codeOriginSchool":"201","classShift":"MAT","stage":"F1","grade":5}}]},"relationships":[{"name":"LUENA MARIA FELIX DEOCLECIANO","email":"vigacaio2@gmail.com","codeOrigin":"2615045","relationType":"RESP","document":"55979890220"},{"name":"FRANCISCO DE OLIVEIRA VIGA","email":"vigacaio2@gmail.com","codeOrigin":"6972431","relationType":"RESP","document":"21585709204"}]}
';

CALL spuDataIntegration(6, @json);



SELECT * FROM IntegrationLog;
-- DELETE FROM IntegrationLog;

/*
	## Tabela de erros
	CREATE TABLE IntegrationLog
	( idGroup INT
	, idNetwork INT
	, userCodeOrigin VARCHAR(36)
	, txDescription VARCHAR(200)
	, txMessage VARCHAR(2000) NOT NULL
	, dtLog DATETIME DEFAULT(NOW()) );
*/

SELECT * 
FROM LektoUser 
WHERE idNetwork = 6
AND txCodeOrigin = '10001';


SELECT * FROM StudentClass
WHERE idNetwork = 1 AND idSchool = 6 AND coGrade = 'F2A6' AND idSchoolYear = 1 and idClass = 4 AND idStudent = 27;

SELECT *  FROM Student
WHERE idNetwork = 1 AND idSchool = 6 AND coGrade = 'F2A6' AND idUserStudent = 27;


SELECT *
FROM School
WHERE idNetwork = 1 AND txCodeOrigin = '201';

SELECT UserProfile.* 
FROM UserProfile 
	INNER JOIN LektoUser 
		   ON LektoUser.idNetwork = UserProfile.idNetwork 
		  AND LektoUser.idUser = UserProfile.idUser 
WHERE LektoUser.idNetwork = 1
AND LektoUser.txCodeOrigin = '6592255';



SELECT Student.* 
FROM LektoUser 
	INNER JOIN Student 
	        ON Student.idNetwork = LektoUser.idNetwork AND Student.idUserStudent = LektoUser.idUser
WHERE LektoUser.idNetwork = 6
AND LektoUser.txCodeOrigin = '6806697';




SELECT *
FROM LektoUser 
	INNER JOIN Student 
	        ON Student.idNetwork = LektoUser.idNetwork AND Student.idUserStudent = LektoUser.idUser
	LEFT JOIN StudentClass
	        ON  StudentClass.idNetwork		= Student.idNetwork
		   AND StudentClass.idSchool		= Student.idSchool
		   AND StudentClass.coGrade		= Student.coGrade
		   AND StudentClass.idUserStudent	= Student.idUserStudent
		   AND StudentClass.idStudent		= Student.idStudent
WHERE LektoUser.idNetwork = 1
AND LektoUser.txCodeOrigin = '6406917';

SELECT * FROM Class where idNetwork = 6;

SELECT UserProfile.* 
FROM UserProfile 
	INNER JOIN LektoUser 
		   ON LektoUser.idNetwork = UserProfile.idNetwork 
		  AND LektoUser.idUser = UserProfile.idUser 
WHERE LektoUser.idNetwork = 6
AND LektoUser.txCodeOrigin = '6592255';

SELECT UserProfileSchool.* 
FROM UserProfile 
	INNER JOIN LektoUser 
		   ON LektoUser.idNetwork = UserProfile.idNetwork 
		  AND LektoUser.idUser = UserProfile.idUser 
	INNER JOIN UserProfileSchool
	        ON UserProfileSchool.idNetwork = UserProfile.idNetwork
		   AND UserProfileSchool.idUserProfile = UserProfile.idUserProfile
WHERE LektoUser.idNetwork = 6
AND LektoUser.txCodeOrigin = '6806697';

SELECT UserProfileRegional.*
FROM UserProfile 
	INNER JOIN LektoUser 
		   ON LektoUser.idNetwork = UserProfile.idNetwork 
		  AND LektoUser.idUser = UserProfile.idUser 
	INNER JOIN UserProfileRegional
		   ON UserProfileRegional.idUserProfile = UserProfile.idUserProfile
WHERE LektoUser.idNetwork = 6
AND LektoUser.txCodeOrigin = '6806697';


