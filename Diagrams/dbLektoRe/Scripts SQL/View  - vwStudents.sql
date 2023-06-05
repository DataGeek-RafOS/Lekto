#CREATE VIEW vwStudents
#AS
SELECT Class.idNetwork
	, Class.idSchool
	, Class.coGrade
	, Class.idSchoolYear
	, Class.idClass
	, LektoUser.idUser
	, LektoUser.txName
	, LektoUser.inStatus
FROM Class
	INNER JOIN StudentClass
		   ON StudentClass.idNetwork 		= Class.idNetwork
	       AND StudentClass.idSchool  		= Class.idSchool
		  AND StudentClass.coGrade  		= Class.coGrade
		  AND StudentClass.idSchoolYear 	= Class.idSchoolYear
		  AND StudentClass.idClass   		= Class.idClass
	INNER JOIN Student
	        ON Student.idNetwork 		= StudentClass.idNetwork
		  AND Student.idSchool  		= StudentClass.idSchool
		  AND Student.coGrade		= StudentClass.coGrade
		  AND Student.idUserStudent	= StudentClass.idUserStudent
		  AND Student.idStudent 		= StudentClass.idStudent
	INNER JOIN LektoUser
	        ON LektoUser.idNetwork = Student.idNetwork
		  AND LektoUser.idUser    = Student.idUserStudent
		  
		  select * from StudentClass where idClass = 11
		  
		  select * from StudentClass