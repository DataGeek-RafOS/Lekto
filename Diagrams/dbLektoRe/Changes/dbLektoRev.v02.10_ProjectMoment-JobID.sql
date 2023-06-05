/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/27/2023 9:53:32 PM                         */
/*==============================================================*/


alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;
;

alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_StudentClass;
;

alter table ProjectDocumentation drop constraint FK_ProjectDocumentation_ProjectMoment;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_MomentStatus;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_Class;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_Professor;
;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;
;

alter table ProjectMomentOrientation drop constraint FK_ProjectMomentOrientation_ProjectMoment;
;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectMoment;
;

alter table ProjectStudentDocumentation drop constraint FK_ProjectStudentDocumentation_StudentClass;
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

alter table ProjectMoment
modify column idProjectMoment int not null first,
   drop primary key
;

drop table if exists tmp_ProjectMoment
;

rename table ProjectMoment to tmp_ProjectMoment
;

alter table StudentClass
modify column StudentClass int not null first,
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

/*==============================================================*/
/* Table: ProjectMoment                                         */
/*==============================================================*/
create table ProjectMoment
(
   idProjectMoment      int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   idProjectTrackStage  int not null,
   coMomentStatus       char(4) not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   txJobId              varchar(36),
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMoment),
   key AK_ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrackStage, coMomentStatus, dtSchedule, dtProcessed, dtInserted, dtLastUpdate)
select idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrackStage, coMomentStatus, dtSchedule, dtProcessed, dtInserted, dtLastUpdate
from tmp_ProjectMoment
;

drop table if exists tmp_ProjectMoment
;

/*==============================================================*/
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   StudentClass         int not null auto_increment,
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
   primary key (StudentClass),
   key AK_StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into StudentClass (StudentClass, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, inStatus, dtInserted, dtLastUpdate)
select StudentClass, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, inStatus, dtInserted, dtLastUpdate
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
   idStudent,
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

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage, coGrade)
      references ProjectTrackStage (idProjectTrackStage, coGrade) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict
;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict
;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
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


DROP TRIGGER IF EXISTS `tgai_StudentClass`;
 
CREATE TRIGGER `tgai_StudentClass` 
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
          , 3 # Aluno vinculado a turma {{p0}}
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


CREATE TRIGGER `tgai_UserProfile` 
AFTER INSERT ON `UserProfile` 
FOR EACH ROW BEGIN

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
          , 1 # Usuario cadastrado com perfil de aluno
          , NEW.idNetwork
          , NEW.idUser
          , NULL
          );

     END IF;

END ;


CREATE TRIGGER `tgi_UserProfile` BEFORE INSERT ON `UserProfile` FOR EACH ROW BEGIN

	DECLARE _idNetworkReference INT;

	SELECT idNetworkReference INTO _idNetworkReference
	FROM Network
	WHERE idNetwork = new.idNetwork;
	
	IF _idNetworkReference IS NOT NULL
	THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_UserProfile: O identificador da rede informado no perfil nao e uma raiz de rede.';
	END IF;	

END ;


CREATE TRIGGER `tgu_UserProfile` BEFORE UPDATE ON `UserProfile` FOR EACH ROW BEGIN

	DECLARE _idNetworkReference INT;

	SELECT idNetworkReference INTO _idNetworkReference
	FROM Network
	WHERE idNetwork = new.idNetwork;
	
	IF _idNetworkReference IS NOT NULL
	THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_UserProfile: O identificador da rede informado no perfil nao e uma raiz de rede.';
	END IF;	

END ;

