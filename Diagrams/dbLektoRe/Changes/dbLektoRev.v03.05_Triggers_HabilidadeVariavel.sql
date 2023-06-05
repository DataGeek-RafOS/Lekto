/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/14/2023 3:02:44 PM                         */
/*==============================================================*/


alter table ActionLog drop constraint FK_ActivityLog_ActivityLogType;
;

alter table ActionLogType drop constraint FK_ActionLogType_ActionLogGroup;
;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;
;

alter table LessonActivity drop constraint FK_LessonActivity_CategoryGrade;
;

alter table LessonActivity drop constraint FK_LessonActivity_EvidenceGrade;
;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;
;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;
;

alter table LessonMoment drop constraint FK_LessonMoment_LessonTrackGroup;
;

alter table LessonMoment drop constraint FK_LessonMoment_Class;
;

alter table LessonMoment drop constraint FK_LessonMoment_MomentStatus;
;

alter table LessonMoment drop constraint FK_LessonMoment_Professor;
;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;
;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;
;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;
;

alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_StudentClass;
;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;
;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;
;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;
;

alter table ProjectStage drop constraint FK_ProjectStage_Project;
;

alter table ProjectStudentDocumentation drop constraint FK_ProjectStudentDocumentation_StudentClass;
;

alter table Student drop constraint FK_Student_LektoUser;
;

alter table Student drop constraint FK_Student_SchoolGrade;
;

alter table StudentClass drop constraint FK_StudentClass_Class;
;

alter table StudentClass drop constraint FK_StudentClass_Student;
;

alter table UserProfile drop constraint FK_UserProfile_LektoUser;
;

alter table UserProfile drop constraint FK_UserProfile_ProfileType;
;

alter table UserProfileRegional drop constraint FK_UserProfileRegional_UserProfile;
;

alter table UserProfileSchool drop constraint FK_UserProfileSchool_UserProfile;
;

alter table ActionLogType
modify column idActionLogType int not null first,
   drop primary key
;

drop table if exists tmp_ActionLogType
;

rename table ActionLogType to tmp_ActionLogType
;

alter table LessonActivity
modify column idLessonActivity int not null first,
   drop primary key
;

drop table if exists tmp_LessonActivity
;

rename table LessonActivity to tmp_LessonActivity
;

alter table LessonMoment
modify column idLessonMoment int not null first,
   drop primary key
;

drop table if exists tmp_LessonMoment
;

rename table LessonMoment to tmp_LessonMoment
;

alter table Student
modify column idStudent int not null first,
   drop primary key
;

drop table if exists tmp_Student
;

rename table Student to tmp_Student
;

alter table StudentClass
modify column idStudentClass int not null first,
   drop primary key
;

drop table if exists tmp_StudentClass
;

rename table StudentClass to tmp_StudentClass
;

alter table UserProfile
modify column idUserProfile int not null first,
   drop primary key
;

drop table if exists tmp_UserProfile
;

rename table UserProfile to tmp_UserProfile
;

alter table ActionLog
   modify column idActionLogType tinyint not null
;

/*==============================================================*/
/* Table: ActionLogType                                         */
/*==============================================================*/
create table ActionLogType
(
   idActionLogType      tinyint not null,
   txAction             varchar(200) not null,
   idActionLogGroup     tinyint not null,
   dtInserted           datetime not null,
   primary key (idActionLogType)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into ActionLogType (idActionLogType, txAction, idActionLogGroup, dtInserted)
select idActionLogType, txAction, idActionLogGroup, dtInserted
from tmp_ActionLogType
;

drop table if exists tmp_ActionLogType
;

/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idLessonStep         int not null,
   txTitle              varchar(2000) not null,
   nuOrder              tinyint not null,
   idEvidence           int,
   idCategory           smallint,
   txChallenge          text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will not restore columns: txChallenge
insert into LessonActivity (idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate)
select idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, ?, dtInserted, dtLastUpdate
from tmp_LessonActivity
;

#WARNING: Drop cancelled because columns cannot be restored: txChallenge
#drop table if exists tmp_LessonActivity
#;
/*==============================================================*/
/* Table: LessonMoment                                          */
/*==============================================================*/
create table LessonMoment
(
   idLessonMoment       int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   coMomentStatus       char(4) not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   idLessonTrackGroup   int not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   dtStartMoment        datetime,
   dtEndMoment          datetime,
   txClassStateHash     varchar(256),
   txJobId              varchar(36),
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMoment),
   key AK_LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonMoment (idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idLessonTrackGroup, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idLessonTrackGroup, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_LessonMoment
;

drop table if exists tmp_LessonMoment
;

alter table ProjectStage
   modify column coGrade char(4)
;

alter table ProjectStage
   modify column idEvidenceVariable int
;

/*==============================================================*/
/* Table: Student                                               */
/*==============================================================*/
create table Student
(
   idStudent            int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idUserStudent        int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudent),
   key AK_Student (idNetwork, idSchool, coGrade, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Student (idStudent, idNetwork, idSchool, coGrade, idUserStudent, dtInserted, dtLastUpdate)
select idStudent, idNetwork, idSchool, coGrade, idUserStudent, dtInserted, dtLastUpdate
from tmp_Student
;

drop table if exists tmp_Student
;

/*==============================================================*/
/* Index: ukNCL_Student                                         */
/*==============================================================*/
create unique index ukNCL_Student on Student
(
   idNetwork,
   idSchool,
   coGrade,
   idUserStudent
)
;

/*==============================================================*/
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   idStudentClass       int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudentClass),
   key AK_StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into StudentClass (idStudentClass, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, inStatus, dtInserted, dtLastUpdate)
select idStudentClass, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, inStatus, dtInserted, dtLastUpdate
from tmp_StudentClass
;

drop table if exists tmp_StudentClass
;

/*==============================================================*/
/* Index: ukNCL_idStudent_idClass                               */
/*==============================================================*/
create unique index ukNCL_idStudent_idClass on StudentClass
(
   idNetwork,
   idSchool,
   coGrade,
   idSchoolYear,
   idUserStudent,
   idClass
)
;

/*==============================================================*/
/* Table: UserProfile                                           */
/*==============================================================*/
create table UserProfile
(
   idNetwork            int not null,
   idUserProfile        int not null auto_increment,
   idUser               int not null,
   coProfile            char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   inStatus             tinyint(1) default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idUserProfile)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into UserProfile (idNetwork, idUserProfile, idUser, coProfile, inDeleted, inStatus, dtInserted, dtLastUpdate)
select idNetwork, idUserProfile, idUser, coProfile, inDeleted, inStatus, dtInserted, dtLastUpdate
from tmp_UserProfile
;

drop table if exists tmp_UserProfile
;

/*==============================================================*/
/* Index: ukNCL_UserProfile                                     */
/*==============================================================*/
create unique index ukNCL_UserProfile on UserProfile
(
   idNetwork,
   idUser,
   coProfile
)
;

alter table ActionLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActionLogType)
      references ActionLogType (idActionLogType)
;

alter table ActionLogType add constraint FK_ActionLogType_ActionLogGroup foreign key (idActionLogGroup)
      references ActionLogGroup (idActionLogGroup)
;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict
;

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idLessonMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_LessonTrackGroup foreign key (idLessonTrackGroup)
      references LessonTrackGroup (idLessonTrackGroup) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table Student add constraint FK_Student_LektoUser foreign key (idNetwork, idUserStudent)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Student add constraint FK_Student_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict
;

alter table StudentClass add constraint FK_StudentClass_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table StudentClass add constraint FK_StudentClass_Student foreign key (idNetwork, idSchool, coGrade, idUserStudent, idStudent)
      references Student (idNetwork, idSchool, coGrade, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_ProfileType foreign key (coProfile)
      references ProfileType (coProfile) on delete restrict on update restrict
;

alter table UserProfileRegional add constraint FK_UserProfileRegional_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;


CREATE TRIGGER `tg_ad_LessonMoment` 
BEFORE DELETE ON LessonMoment
FOR EACH ROW BEGIN

	# Aluno teve trilha desocupada pelo professor {{p0}}

	INSERT INTO ActionLog
	(
	  dtAction
	, idActionLogType          
	, idNetwork
	, idUser
	, txVariables
	)
	SELECT NOW()
		, 7
		, StudentClass.idNetwork
		, StudentClass.idUserStudent
		, JSON_OBJECT('@p0', OLD.idUserProfessor)
	FROM LessonMoment 
		INNER JOIN Class 
			   ON Class.idClass      = LessonMoment.idClass
			  AND Class.idNetwork    = LessonMoment.idNetwork
			  AND Class.idSchool     = LessonMoment.idSchool
			  AND Class.coGrade      = LessonMoment.coGrade
			  AND Class.idSchoolYear = LessonMoment.idSchoolYear
		INNER JOIN StudentClass  
			   ON StudentClass.idClass      = Class.idClass 
			  AND StudentClass.idNetwork    = Class.idNetwork 
			  AND StudentClass.idSchool     = Class.idSchool 
			  AND StudentClass.coGrade      = Class.coGrade 
			  AND StudentClass.idSchoolYear = Class.idSchoolYear
	WHERE LessonMoment.idLessonMoment = OLD.idLessonMoment;
	
END ;


CREATE TRIGGER `tg_ai_LessonMoment` 
AFTER INSERT ON LessonMoment 
FOR EACH ROW BEGIN

	INSERT INTO ActionLog
		(
		  dtAction
		, idActionLogType          
		, idNetwork
		, idUser
		, txVariables
		)
	SELECT NOW()
		, 8 AS idActionLogtype 	# Aluno tem momento de aulas {{p0}} geradas a turma
		, StCl.idNetwork
		, StCl.idUserStudent
		, JSON_OBJECT('@p0', NEW.idLessonMoment)
	FROM LessonMoment AS LeMo
		INNER JOIN Class AS Clas
			   ON Clas.idClass 		= LeMo.idClass
			  AND Clas.idNetwork 	= LeMo.idNetwork
			  AND Clas.idSchool 	= LeMo.idSchool
			  AND Clas.coGrade 		= LeMo.coGrade
			  AND Clas.idSchoolYear 	= LeMo.idSchoolYear
		INNER JOIN StudentClass StCl
			   ON StCl.idClass 		= Clas.idClass
			  AND StCl.idNetwork 	= Clas.idNetwork
			  AND StCl.idSchool 	= Clas.idSchool
			  AND StCl.coGrade 		= Clas.coGrade
			  AND StCl.idSchoolYear 	= Clas.idSchoolYear
	WHERE LeMo.idLessonMoment = NEW.idLessonMoment;

	
END ;


CREATE TRIGGER `tg_au_LessonMoment` 
AFTER UPDATE ON LessonMoment
FOR EACH ROW BEGIN

	DECLARE _idActionLogType TINYINT;
	
     IF NEW.dtStartMoment <> OLD.dtStartMoment OR NEW.dtEndMoment <> OLD.dtEndMoment 
     THEN 

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          SELECT NOW()
               , 5 
               , StudentClass.idNetwork
               , StudentClass.idUserStudent
               , JSON_OBJECT('@p0', NEW.idUserProfessor)
          FROM LessonMoment 
               INNER JOIN Class 
                       ON Class.idClass      = LessonMoment.idClass
                      AND Class.idNetwork    = LessonMoment.idNetwork
                      AND Class.idSchool     = LessonMoment.idSchool
                      AND Class.coGrade      = LessonMoment.coGrade
                      AND Class.idSchoolYear = LessonMoment.idSchoolYear
               INNER JOIN StudentClass  
                       ON StudentClass.idClass      = Class.idClass 
                      AND StudentClass.idNetwork    = Class.idNetwork 
                      AND StudentClass.idSchool     = Class.idSchool 
                      AND StudentClass.coGrade      = Class.coGrade 
                      AND StudentClass.idSchoolYear = Class.idSchoolYear
          WHERE idLessonMoment = NEW.idLessonMoment;

     END IF;		
	
	IF OLD.coMomentStatus <> NEW.coMomentStatus
	THEN	

		# Aluno tem momento de aulas {{p0}} liberadas para a turma
		IF  OLD.coMomentStatus = 'AGEN' # Aula Agendada
		AND NEW.coMomentStatus = 'PEND' # Planejamento Pendente
		THEN 
			SET _idActionLogType = 8;
		END IF;		

		# Aluno tem sua aula da data {{p0}} com planejamento confirmado pelo professor {{p1}}
		IF  OLD.coMomentStatus = 'PEND' # Planejamento Pendente
		AND NEW.coMomentStatus = 'AUPL' # Aula Planejada
		THEN 
			SET _idActionLogType = 9;
		END IF;
		
		# Aluno tem sua aula na data {{p0}} iniciada pelo professor {{p1}}
		IF  OLD.coMomentStatus = 'AUPL' # Aula Planejada
		AND NEW.coMomentStatus = 'INIC' # Aula Iniciada
		THEN 
			SET _idActionLogType = 10;
		END IF;
		
		# Aluno tem sua aula na data {{p0}} encerrada pelo professor {{p1}}
		IF  OLD.coMomentStatus = 'INIC' # Aula Iniciada
		AND NEW.coMomentStatus = 'AVPE' # Avaliacao Pendente
		THEN 
			SET _idActionLogType = 12;
		END IF;		
		
		# Aluno tem sua aula na data {{p0}} com avaliacao confirmada pelo professor {{p1}}
		IF  OLD.coMomentStatus = 'AVPE' # Avaliacao Pendente
		AND NEW.coMomentStatus = 'FINA' # Aula Finalizada
		THEN 
			SET _idActionLogType = 13;
		END IF;		

		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, _idActionLogType AS idActionLogtype
			, StCl.idNetwork
			, StCl.idUserStudent
			, JSON_OBJECT('@p0', NOW(), 'Professor', NEW.idUserProfessor)
		FROM LessonMoment AS LeMo
			INNER JOIN Class AS Clas
				   ON Clas.idClass 		= LeMo.idClass
				  AND Clas.idNetwork 	= LeMo.idNetwork
				  AND Clas.idSchool 	= LeMo.idSchool
				  AND Clas.coGrade 		= LeMo.coGrade
				  AND Clas.idSchoolYear 	= LeMo.idSchoolYear
			INNER JOIN StudentClass StCl
				   ON StCl.idClass 		= Clas.idClass
				  AND StCl.idNetwork 	= Clas.idNetwork
				  AND StCl.idSchool 	= Clas.idSchool
				  AND StCl.coGrade 		= Clas.coGrade
				  AND StCl.idSchoolYear 	= Clas.idSchoolYear
		WHERE LeMo.idLessonMoment = NEW.idLessonMoment;
	
	END IF;
	
END ;


CREATE TRIGGER `tg_au_LessonMomentGroup` 
AFTER UPDATE ON LessonMomentGroup 
FOR EACH ROW BEGIN

	# Aluno foi excluido da aula na data {{p0}} pelo professor {{p1}}
	IF OLD.inAttendance = 1 AND New.inAttendance = 0
	THEN	
	
		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, 11
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
		FROM LessonMomentGroup Grup
			INNER JOIN LessonMomentActivity Acti
				   ON Acti.idNetwork			    = Grup.idNetwork
				  AND Acti.idSchool			    	= Grup.idSchool
				  AND Acti.coGrade				    = Grup.coGrade
				  AND Acti.idSchoolYear			    = Grup.idSchoolYear
				  AND Acti.idClass				    = Grup.idClass
				  AND Acti.idLessonMomentActivity  = Grup.idLessonMomentActivity
		     INNER JOIN LessonMoment Mome
				   ON Mome.idNetwork	 = Acti.idNetwork
				  AND Mome.idSchool		 = Acti.idSchool
				  AND Mome.coGrade		 = Acti.coGrade
				  AND Mome.idSchoolYear	 = Acti.idSchoolYear
				  AND Mome.idClass		 = Acti.idClass
				  AND Mome.idLessonMoment = Acti.idLessonMoment
		WHERE Grup.idLessonMomentGroup = NEW.idLessonMomentGroup
		AND   Grup.inAttendance = 0;
		
	END IF;
	
	# Aluno recebeu avaliaCAo na aula na data {{p0}} pelo professor {{p1}}
	IF OLD.coAssessment <> NEW.coAssessment
	THEN	
	
		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, 14
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
		FROM LessonMomentGroup Grup
			INNER JOIN LessonMomentActivity Acti
				   ON Acti.idNetwork			= Grup.idNetwork
				  AND Acti.idSchool				= Grup.idSchool
				  AND Acti.coGrade				= Grup.coGrade
				  AND Acti.idSchoolYear			= Grup.idSchoolYear
				  AND Acti.idClass				= Grup.idClas
				  AND Acti.idLessonMomentActivity  = Grup.idLessonMomentActivity
		     INNER JOIN LessonMoment Mome
				   ON Mome.idNetwork	 = Acti.idNetwork
				  AND Mome.idSchool		 = Acti.idSchool
				  AND Mome.coGrade		 = Acti.coGrade
				  AND Mome.idSchoolYear	 = Acti.idSchoolYear
				  AND Mome.idClass		 = Acti.idClass
				  AND Mome.idLessonMoment = Acti.idLessonMoment
		WHERE Grup.idLessonMomentGroup = NEW.idLessonMomentGroup;
		
	END IF;
			
END ;



CREATE TRIGGER `tg_ai_LessonStudentDocumentation` 
AFTER UPDATE ON LessonStudentDocumentation 
FOR EACH ROW BEGIN

	# Aluno recebeu registros na aula na data {{p0}} pelo professor {{p1}}
	INSERT INTO ActionLog
		(
		  dtAction
		, idActionLogType          
		, idNetwork
		, idUser
		, txVariables
		)
	SELECT NOW()
		, 15
		, Grup.idNetwork
		, Grup.idUserStudent
		, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
	FROM LessonStudentDocumentation StDo
		INNER JOIN LessonDocumentation Docm
			   ON Docm.idLessonDocumentation	= StDo.idLessonDocumentation
		INNER JOIN LessonMoment Mome
			   ON Mome.idLessonMoment	 = Docm.idLessonMoment
	WHERE StDo.idLessonStudentDocumentation = NEW.idLessonStudentDocumentation;
					
END ;


CREATE TRIGGER `tg_ai_Professor` 
AFTER INSERT ON Professor 
FOR EACH ROW BEGIN

	INSERT INTO ActionLog
		(
		  dtAction
		, idActionLogType          
		, idNetwork
		, idUser
		, txVariables
		)
	SELECT NOW()
		, 4 AS idActionLogtype # Aluno tem sua turma atualizada com a inclusao de professor {{p0}}
		, StCl.idNetwork
		, StCl.idUserStudent
		, JSON_OBJECT('@p0', NEW.idProfessor)
	FROM Professor AS Prof
		INNER JOIN Class AS Clas
		       ON Clas.idClass 	= Prof.idClass
			  AND Clas.idNetwork 	= Prof.idNetwork
			  AND Clas.idSchool 	= Prof.idSchool
			  AND Clas.coGrade 		= Prof.coGrade
			  AND Clas.idSchoolYear = Prof.idSchoolYear
		INNER JOIN StudentClass StCl
		        ON StCl.idClass 	= Clas.idClass
			  AND StCl.idNetwork 	= Clas.idNetwork
			  AND StCl.idSchool 	= Clas.idSchool
			  AND StCl.coGrade 		= Clas.coGrade
			  AND StCl.idSchoolYear = Clas.idSchoolYear
	WHERE Prof.idProfessor = NEW.idProfessor;
			
END ;


CREATE TRIGGER `tg_au_Professor` 
AFTER UPDATE ON Professor 
FOR EACH ROW BEGIN

	IF OLD.idClass = NEW.idClass
	THEN

		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, 4 AS idActionLogtype # Aluno tem sua turma atualizada com a inclusao de professor {{p0}}
			, StCl.idNetwork
			, StCl.idUserStudent
			, JSON_OBJECT('@p0', NEW.idProfessor)
		FROM Professor AS Prof
			INNER JOIN Class AS Clas
				   ON Clas.idClass 		= Prof.idClass
				  AND Clas.idNetwork 	= Prof.idNetwork
				  AND Clas.idSchool 	= Prof.idSchool
				  AND Clas.coGrade 		= Prof.coGrade
				  AND Clas.idSchoolYear 	= Prof.idSchoolYear
			INNER JOIN StudentClass StCl
				   ON StCl.idClass 		= Clas.idClass
				  AND StCl.idNetwork 	= Clas.idNetwork
				  AND StCl.idSchool 	= Clas.idSchool
				  AND StCl.coGrade 		= Clas.coGrade
				  AND StCl.idSchoolYear 	= Clas.idSchoolYear
		WHERE idProfessor = new.idProfessor;
			
	END IF;
	
END ;


CREATE TRIGGER `tg_ad_ProjectMoment` 
BEFORE DELETE ON ProjectMoment
FOR EACH ROW BEGIN

	# Aluno teve trilha desocupada pelo professor {{p0}}

	INSERT INTO ActionLog
	(
	  dtAction
	, idActionLogType          
	, idNetwork
	, idUser
	, txVariables
	)
	SELECT NOW()
		, 7
		, StudentClass.idNetwork
		, StudentClass.idUserStudent
		, JSON_OBJECT('@p0', OLD.idUserProfessor)
	FROM ProjectMoment 
		INNER JOIN Class 
			   ON Class.idClass      = ProjectMoment.idClass
			  AND Class.idNetwork    = ProjectMoment.idNetwork
			  AND Class.idSchool     = ProjectMoment.idSchool
			  AND Class.coGrade      = ProjectMoment.coGrade
			  AND Class.idSchoolYear = ProjectMoment.idSchoolYear
		INNER JOIN StudentClass  
			   ON StudentClass.idClass      = Class.idClass 
			  AND StudentClass.idNetwork    = Class.idNetwork 
			  AND StudentClass.idSchool     = Class.idSchool 
			  AND StudentClass.coGrade      = Class.coGrade 
			  AND StudentClass.idSchoolYear = Class.idSchoolYear
	WHERE ProjectMoment.idProjectMoment = OLD.idProjectMoment;
	
END ;


CREATE TRIGGER `tg_ai_ProjectMoment` 
AFTER INSERT ON ProjectMoment
FOR EACH ROW BEGIN

	INSERT INTO ActionLog
		(
		  dtAction
		, idActionLogType          
		, idNetwork
		, idUser
		, txVariables
		)
	SELECT NOW()
		, 21 AS idActionLogtype 	# Aluno tem momento de projetos {{p0}} gerados a turma
		, StCl.idNetwork
		, StCl.idUserStudent
		, JSON_OBJECT('@p0', NEW.idProjectMoment)
	FROM ProjectMoment AS PrMo
		INNER JOIN Class AS Clas
			   ON Clas.idClass 		= PrMo.idClass
			  AND Clas.idNetwork 	= PrMo.idNetwork
			  AND Clas.idSchool 	= PrMo.idSchool
			  AND Clas.coGrade 		= PrMo.coGrade
			  AND Clas.idSchoolYear 	= PrMo.idSchoolYear
		INNER JOIN StudentClass StCl
			   ON StCl.idClass 		= Clas.idClass
			  AND StCl.idNetwork 	= Clas.idNetwork
			  AND StCl.idSchool 	= Clas.idSchool
			  AND StCl.coGrade 		= Clas.coGrade
			  AND StCl.idSchoolYear 	= Clas.idSchoolYear
	WHERE LeMo.idProjectMoment = NEW.idProjectMoment;

	
END ;


CREATE TRIGGER `tg_au_ProjectMoment` 
AFTER UPDATE ON ProjectMoment
FOR EACH ROW BEGIN

	DECLARE _idActionLogType TINYINT;
    
     IF NEW.dtSchedule <> OLD.dtSchedule
     THEN 

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          SELECT NOW()
               , 5 
               , StudentClass.idNetwork
               , StudentClass.idUserStudent
               , JSON_OBJECT('@p0', NEW.idUserProfessor)
          FROM ProjectMoment 
               INNER JOIN Class 
                       ON Class.idClass      = ProjectMoment.idClass
                      AND Class.idNetwork    = ProjectMoment.idNetwork
                      AND Class.idSchool     = ProjectMoment.idSchool
                      AND Class.coGrade      = ProjectMoment.coGrade
                      AND Class.idSchoolYear = ProjectMoment.idSchoolYear
               INNER JOIN StudentClass  
                       ON StudentClass.idClass      = Class.idClass 
                      AND StudentClass.idNetwork    = Class.idNetwork 
                      AND StudentClass.idSchool     = Class.idSchool 
                      AND StudentClass.coGrade      = Class.coGrade 
                      AND StudentClass.idSchoolYear = Class.idSchoolYear
          WHERE idProjectMoment = NEW.idProjectMoment;

     END IF;    
	
	IF OLD.coMomentStatus <> NEW.coMomentStatus
	THEN	

		# Aluno tem sua aula na data {{p0}} encerrada pelo professor {{p1}}
		IF  OLD.coMomentStatus = 'INIC' # Aula iniciada
		AND NEW.coMomentStatus = 'AVPE' # Avaliacao Pendente
		THEN 
			SET _idActionLogType = 12;
		END IF;
		
		# Aluno tem sua aula na data {{p0}} com avaliacao confirmada pelo professor {{p1}}	 
		IF  OLD.coMomentStatus = 'AVPE' # Avaliacao Pendente
		AND NEW.coMomentStatus = 'FINA' # Aula Finalizada
		THEN 
			SET _idActionLogType = 13;
		END IF;

		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, _idActionLogType AS idActionLogtype
			, StCl.idNetwork
			, StCl.idUserStudent
			, JSON_OBJECT('@p0', NOW(), 'Professor', NEW.idUserProfessor)
		FROM ProjectMoment AS PrMo
			INNER JOIN Class AS Clas
				   ON Clas.idClass 		= PrMo.idClass
				  AND Clas.idNetwork 	= PrMo.idNetwork
				  AND Clas.idSchool 	= PrMo.idSchool
				  AND Clas.coGrade 		= PrMo.coGrade
				  AND Clas.idSchoolYear 	= PrMo.idSchoolYear
			INNER JOIN StudentClass StCl
				   ON StCl.idClass 		= Clas.idClass
				  AND StCl.idNetwork 	= Clas.idNetwork
				  AND StCl.idSchool 	= Clas.idSchool
				  AND StCl.coGrade 		= Clas.coGrade
				  AND StCl.idSchoolYear 	= Clas.idSchoolYear
		WHERE LeMo.idProjectMoment = NEW.idProjectMoment;
	
	END IF;

END ;


CREATE TRIGGER `tg_au_ProjectMomentGroup` 
AFTER UPDATE ON ProjectMomentGroup 
FOR EACH ROW BEGIN

	# Aluno foi excluido da aula na data {{p0}} pelo professor {{p1}}
	IF OLD.inAttendance = 1 AND New.inAttendance = 0
	THEN	
	
		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, 11
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
		FROM ProjectMomentGroup Grup
			INNER JOIN ProjectMomentStage Stag
				   ON Stag.idNetwork			= Grup.idNetwork
				  AND Stag.idSchool				= Grup.idSchool
				  AND Stag.coGrade				= Grup.coGrade
				  AND Stag.idSchoolYear			= Grup.idSchoolYear
				  AND Stag.idClass				= Grup.idClass
				  AND Stag.idProjectMomentStage	= Grup.idProjectMomentStage
		     INNER JOIN ProjectMoment Mome
				   ON Mome.idNetwork	 = Acti.idNetwork
				  AND Mome.idSchool		 = Acti.idSchool
				  AND Mome.coGrade		 = Acti.coGrade
				  AND Mome.idSchoolYear	 = Acti.idSchoolYear
				  AND Mome.idClass		 = Acti.idClass
				  AND Mome.idProjectMoment = Acti.idProjectMoment
		WHERE Grup.idProjectMomentGroup = NEW.idProjectMomentGroup
		AND   Grup.inAttendance = 0;
		
	END IF;
	
	# Aluno recebeu avaliacao na aula na data {{p0}} pelo professor {{p1}}
	IF OLD.coAssessment <> NEW.coAssessment
	THEN	
	
		INSERT INTO ActionLog
			(
			  dtAction
			, idActionLogType          
			, idNetwork
			, idUser
			, txVariables
			)
		SELECT NOW()
			, 14
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
		FROM ProjectMomentGroup Grup
			INNER JOIN ProjectMomentStage Stag
				   ON Stag.idNetwork			= Grup.idNetwork
				  AND Stag.idSchool				= Grup.idSchool
				  AND Stag.coGrade				= Grup.coGrade
				  AND Stag.idSchoolYear			= Grup.idSchoolYear
				  AND Stag.idClass				= Grup.idClas
				  AND Stag.idProjectMomentStage  	= Grup.idProjectMomentStage
		     INNER JOIN ProjectMoment Mome
				   ON Mome.idNetwork	 	= Stag.idNetwork
				  AND Mome.idSchool		 	= Stag.idSchool
				  AND Mome.coGrade		 	= Stag.coGrade
				  AND Mome.idSchoolYear	 	= Stag.idSchoolYear
				  AND Mome.idClass		 	= Stag.idClass
				  AND Mome.idProjectMoment 	= Stag.idProjectMoment
		WHERE Grup.idProjectMomentGroup = NEW.idProjectMomentGroup;
		
	END IF;
			
END ;



CREATE TRIGGER `tg_ai_ProjectStudentDocumentation` 
AFTER UPDATE ON ProjectStudentDocumentation 
FOR EACH ROW BEGIN

	# Aluno recebeu registros na aula na data {{p0}} pelo professor {{p1}}
	INSERT INTO ActionLog
		(
		  dtAction
		, idActionLogType          
		, idNetwork
		, idUser
		, txVariables
		)
	SELECT NOW()
		, 15
		, Grup.idNetwork
		, Grup.idUserStudent
		, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
	FROM ProjectStudentDocumentation StDo
		INNER JOIN ProjectDocumentation Docm
			   ON Docm.idProjectDocumentation	= StDo.idProjectDocumentation
		INNER JOIN ProjectMoment Mome
			   ON Mome.idProjectMoment	 = Docm.idProjectMoment
	WHERE StDo.idProjectStudentDocumentation = NEW.idProjectStudentDocumentation;
					
END ;


CREATE TRIGGER `tg_ai_Student` 
AFTER INSERT ON Student
FOR EACH ROW BEGIN

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 2 				# Aluno e vinculado a escola {{p0}} 
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', NEW.idSchool)
          );

END ;


CREATE TRIGGER `tg_ai_StudentClass` 
AFTER INSERT ON StudentClass 
FOR EACH ROW BEGIN

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 3           # Aluno vinculado a turma {{p0}}
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', NEW.idClass)
          );

END ;


CREATE TRIGGER `tgau_StudentClass` 
AFTER UPDATE ON StudentClass
FOR EACH ROW 
BEGIN

     IF NEW.inStatus = 0
     THEN 

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 16 # Aluno foi retirado da turma {{p0}} na data {{p1}}
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', OLD.idClass, '@p1', NOW())
          );

     END IF;

END ;


CREATE TRIGGER `tg_ai_UserProfile` 
AFTER INSERT ON `UserProfile` 
FOR EACH ROW BEGIN

	DECLARE _idNetworkReference INT;

	SELECT idNetworkReference INTO _idNetworkReference
	FROM Network
	WHERE idNetwork = new.idNetwork;
	
	IF _idNetworkReference IS NOT NULL
	THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_UserProfile: O identificador da rede informado no perfil nao e uma raiz de rede.';
	END IF;	

     IF NEW.coProfile = 'ALNO'
     THEN
     
          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 1                   # Usuario cadastrado com perfil de aluno
          , NEW.idNetwork
          , NEW.idUser
          , NULL
          );

     END IF;

END ;


CREATE TRIGGER `tg_bu_UserProfile` 
BEFORE UPDATE ON `UserProfile` 
FOR EACH ROW BEGIN

	DECLARE _idNetworkReference INT;

	SELECT idNetworkReference INTO _idNetworkReference
	FROM Network
	WHERE idNetwork = new.idNetwork;
	
	IF _idNetworkReference IS NOT NULL
	THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tg_bu_UserProfile: O identificador da rede informado no perfil nao e uma raiz de rede.';
	END IF;	

END ;

