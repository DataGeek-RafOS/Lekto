/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/19/2023 10:08:01 PM                        */
/*==============================================================*/


alter table ActionLog drop constraint FK_ActionLog_LektoUser;

alter table Activity drop constraint FK_Activity_Category;

alter table Activity drop constraint FK_Activity_Evidence;

alter table Activity drop constraint FK_Activity_LessonStep;

alter table Class drop constraint FK_Class_ClassShift;

alter table Class drop constraint FK_Class_SchoolGrade;

alter table Class drop constraint FK_Class_SchoolYear;

alter table DataUsage drop constraint FK_DataUsage_LektoUser;

alter table GuidanceBox drop constraint FK_GuidanceBox_Activity;

alter table LektoUser drop constraint FK_LektoUser_MaritalStatus;

alter table LektoUser drop constraint FK_LektoUser_Network;

alter table Lesson drop constraint FK_Lesson_LessonTrail;

alter table LessonStep drop constraint FK_LessonStep_Evidence;

alter table LessonTrail drop constraint FK_LessonTrail_Component;

alter table LessonTrail drop constraint FK_LessonTrail_Grade;

alter table Moment drop constraint FK_Moment_Class;

alter table Moment drop constraint FK_Moment_MomentStatus;

alter table Moment drop constraint FK_Moment_Professor;

alter table MomentActivity drop constraint FK_MomentActivity_Assessment;

alter table MomentActivity drop constraint FK_MomentActivity_Activity;

alter table MomentActivity drop constraint FK_MomentActivity_Moment;

alter table MomentActivity drop constraint FK_MomentActivity_StudentClass;

alter table Notification drop constraint FK_Notification_LektoUser;

alter table Professor drop constraint FK_Professor_Class;

alter table Professor drop constraint FK_Professor_LektoUser;

alter table Relationship drop constraint FK_Relationship_LektoUser;

alter table Relationship drop constraint FK_Relationship_LektoUserBound;

alter table School drop constraint FK_School_MediaInformation;

alter table Student drop constraint FK_Student_LektoUser;

alter table Student drop constraint FK_Student_SchoolGrade;

alter table StudentClass drop constraint FK_StudentClass_Class;

alter table StudentClass drop constraint FK_StudentClass_Student;

alter table SupportReference drop constraint FK_SupportReference_GuidanceBox;

alter table SupportReference drop constraint FK_SupportReference_MediaInformation;

alter table SupportReference drop constraint FK_SupportReference_SupportReferenceType;

alter table UserAddress drop constraint FK_UserAddress_LektoUser;

alter table UserProfile drop constraint FK_UserProfile_LektoUser;

alter table UserSession drop constraint FK_UserSession_LektoUser;

drop index ixNCL_ActivityLog_idUser on ActionLog;

alter table ActionLog
   modify column `idActionLog` int NOT NULL FIRST,
   drop column idNetwork
;

alter table Activity
   modify column `idActivity` int NOT NULL FIRST, drop primary key
;

alter table Class
   modify column `idClass` int NOT NULL FIRST, drop primary key
;

drop table if exists tmp_Class
;

rename table Class to tmp_Class
;

drop table if exists tmp_Activity
;

rename table Activity to tmp_Activity
;

alter table DataUsage
   drop column idNetwork
;

alter table GuidanceBox
   modify column `idGuidanceBox` int NOT NULL FIRST, drop primary key
;

drop table if exists tmp_GuidanceBox
;

rename table GuidanceBox to tmp_GuidanceBox
;

alter table LektoUser
   modify column `idUser` int NOT NULL FIRST, drop primary key
;

drop table if exists tmp_LektoUser
;

rename table LektoUser to tmp_LektoUser
;

alter table Lesson
   drop column idLessonTrail
;

alter table tmp_Activity drop constraint FK_Activity_Step;

alter table LessonStep
   modify column `idStep` int NOT NULL FIRST, drop primary key
;

alter table LessonStep
   drop column txGuidance
;

alter table LessonStep drop constraint FK_Step_Evidence;

alter table LessonStep
   drop column idEvidence
;

alter table LessonTrail
   modify column `idLessonTrail` int NOT NULL FIRST, drop primary key
;

drop table if exists tmp_LessonTrail
;

rename table LessonTrail to tmp_LessonTrail
;

alter table MediaInformation
   modify column `idMediaInformation` int NOT NULL FIRST, drop primary key
;

drop table if exists tmp_MediaInformation
;

rename table MediaInformation to tmp_MediaInformation
;

alter table Moment
   drop primary key
;

alter table MomentActivity
  modify column `idMomentActivity` int NOT NULL FIRST,  drop primary key
;

drop table if exists tmp_MomentActivity
;

rename table MomentActivity to tmp_MomentActivity
;

drop table if exists tmp_Moment
;

rename table Moment to tmp_Moment
;

alter table Notification
   drop column idNetwork
;

alter table Professor
   drop primary key
;

drop table if exists tmp_Professor
;

rename table Professor to tmp_Professor
;

alter table Relationship
   drop column idNetwork
;

alter table Student
   drop primary key
;

drop table if exists tmp_Student
;

rename table Student to tmp_Student
;

alter table StudentClass
   drop primary key
;

drop table if exists tmp_StudentClass
;

rename table StudentClass to tmp_StudentClass
;

alter table SupportReference
   modify column `idSupportReference` int NOT NULL FIRST, drop primary key
;

drop table if exists tmp_SupportReference
;

rename table SupportReference to tmp_SupportReference
;

alter table UserAddress
   drop column idNetwork
;

alter table UserSession
   drop column idNetwork
;

/*==============================================================*/
/* Index: ixNCL_ActivityLog_idUser                              */
/*==============================================================*/
create index ixNCL_ActivityLog_idUser on ActionLog
(
   idUser
)
;

/*==============================================================*/
/* Table: Class                                                 */
/*==============================================================*/
create table Class
(
   idClass              int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   txName               varchar(50) not null,
   inStatus             tinyint(1) not null default 1,
   txCodeOrigin         varchar(36),
   coClassShift         char(3),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idClass),
   unique key AK_Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear, txName, inStatus, txCodeOrigin, coClassShift, dtInserted, dtLastUpdate)
select idClass, idNetwork, idSchool, coGrade, idSchoolYear, txName, inStatus, txCodeOrigin, coClassShift, dtInserted, dtLastUpdate
from tmp_Class
;

drop table if exists tmp_Class
;

/*==============================================================*/
/* Table: ClassTrack                                            */
/*==============================================================*/
create table ClassTrack
(
   idClassTrack         int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   primary key (idClassTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into ClassTrack (idClassTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC)
select idLessonTrail, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC
from tmp_LessonTrail
;

drop table if exists tmp_LessonTrail
;

/*==============================================================*/
/* Table: ClassTrackLesson                                      */
/*==============================================================*/
create table ClassTrackLesson
(
   idClassTrackLesson   int not null auto_increment,
   idClassTrack         int not null,
   idLesson             int not null,
   coGrade              char(4) not null,
   primary key (idClassTrackLesson)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Index: ukNCL_ClassTrackLesson                                */
/*==============================================================*/
create unique index ukNCL_ClassTrackLesson on ClassTrackLesson
(
   idClassTrack,
   idLesson
)
;

/*==============================================================*/
/* Table: DocumentationLessonStep                               */
/*==============================================================*/
create table DocumentationLessonStep
(
   idDocumentation      int not null,
   idLessonStep         int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDocumentation, idLessonStep, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: DocumentationStudent                                  */
/*==============================================================*/
create table DocumentationStudent
(
   idLessonDocumentation int not null,
   idNetwork            int,
   idSchool             int,
   coGrade              char(4),
   idSchoolYear         smallint,
   idClass              int,
   idUserStudent        int,
   idStudent            int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LektoUser                                             */
/*==============================================================*/
create table LektoUser
(
   idNetwork            int not null,
   idUser               int not null auto_increment,
   txName               varchar(120) not null,
   idSingleSignOn       varchar(64),
   txImagePath          varchar(300) comment 'Caminho da imagem.',
   txEmail              varchar(120),
   txNickname           varchar(80),
   txPhone              varchar(11),
   txCpf                char(11),
   dtBirthdate          datetime,
   idCityPlaceOfBirth   int,
   coMaritalStatus      char(3),
   inStatus             tinyint(1) not null default 1,
   isLgpdTermsAccepted  tinyint(1),
   txCodeOrigin         varchar(36),
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default NOW(),
   dtLastUpdate         datetime,
   primary key (idUser),
   unique key ukNCL_LektoUser_idUser (idNetwork, idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LektoUser (idNetwork, idUser, txName, idSingleSignOn, txImagePath, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idCityPlaceOfBirth, coMaritalStatus, inStatus, isLgpdTermsAccepted, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate)
select idNetwork, idUser, txName, idSingleSignOn, txImagePath, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idCityPlaceOfBirth, coMaritalStatus, inStatus, isLgpdTermsAccepted, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate
from tmp_LektoUser
;

drop table if exists tmp_LektoUser
;

/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idStep               int not null,
   txTitle              varchar(150) not null,
   nuOrder              tinyint not null,
   idCategory           smallint not null,
   idEvidence           int not null,
   txChallenge          varchar(500) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonActivity (idLessonActivity, coGrade, idStep, txTitle, nuOrder, idCategory, idEvidence, txChallenge, dtInserted, dtLastUpdate)
select idActivity, coGrade, idStep, txTitle, nuOrder, idCategory, idEvidence, txChallenge, dtInserted, dtLastUpdate
from tmp_Activity
;

drop table if exists tmp_Activity
;

/*==============================================================*/
/* Table: LessonActivityOrientation                             */
/*==============================================================*/
create table LessonActivityOrientation
(
   idLessonActivityOrientation int not null auto_increment,
   idLessonActivity     int not null,
   coGrade              char(4) not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivityOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonActivitySupportReference                        */
/*==============================================================*/
create table LessonActivitySupportReference
(
   idLessonActivitySupportReference int not null auto_increment,
   idLessonActivityOrientation int not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivitySupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonDocumentation                                   */
/*==============================================================*/
create table LessonDocumentation
(
   idLessonDocumentation int not null auto_increment,
   txMomentNotes        longtext not null comment 'Informacoes complementares.',
   IdMediaInformation   int,
   idMoment             int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation),
   key AK_LessonDocumentation (idLessonDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

alter table LessonDocumentation comment 'Informacoes complementares referentes ao grupo. 
Neste'
;

/*==============================================================*/
/* Table: LessonDocumentationActivity                           */
/*==============================================================*/
create table LessonDocumentationActivity
(
   idDocumentation      int not null,
   idMomentActivity     int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDocumentation, idMomentActivity)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

alter table LessonDocumentationActivity comment 'Documentacao de atividade por estudante'
;

/*==============================================================*/
/* Table: LessonDocumentationEvidence                           */
/*==============================================================*/
create table LessonDocumentationEvidence
(
   idLessonDocumentation int not null,
   idEvidence           int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation, idEvidence)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonMomentActivity                                  */
/*==============================================================*/
create table LessonMomentActivity
(
   idLessonMomentActivity int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonActivity     int not null,
   coAssessment         varchar(2),
   idUserStudent        int,
   idStudent            int,
   idMoment             int,
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentActivity),
   key AK_LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonMomentActivity (idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, coAssessment, idUserStudent, idStudent, idMoment, dtAssessment, dtInserted, dtLastUpdate)
select idMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idActivity, coAssessment, idUserStudent, idStudent, idMoment, dtAssessment, dtInserted, dtLastUpdate
from tmp_MomentActivity
;

drop table if exists tmp_MomentActivity
;

/*==============================================================*/
/* Table: LessonOrientation                                     */
/*==============================================================*/
create table LessonOrientation
(
   idLessonStepOrientation int not null auto_increment,
   idLessonStep         int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStepOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonOrientation (idLessonStepOrientation, idLessonStep, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idGuidanceBox, ?, txTitle, txGuidanceCode, dtInserted, dtLastUpdate
from tmp_GuidanceBox
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_GuidanceBox
#;

ALTER TABLE `dbLektoRev`.`LessonStep` 
CHANGE COLUMN `idStep` `idLessonStep` int NOT NULL FIRST;

alter table LessonStep
   add primary key (idLessonStep)
;

alter table LessonStep
   add unique AK_LessonStep (coGrade, idLessonStep)
;

/*==============================================================*/
/* Table: LessonStepEvidence                                    */
/*==============================================================*/
create table LessonStepEvidence
(
   idLessonStep         int not null,
   coGrade              char(4) not null,
   idEvidence           int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep, coGrade, idEvidence)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonSupportReference                                */
/*==============================================================*/
create table LessonSupportReference
(
   idLessonSupportReference int not null auto_increment,
   idLessonStepOrientation int not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonSupportReference (idLessonSupportReference, idLessonStepOrientation, coSupportReference, IdMediaInformation, txTitle, txReferenceNumber, txReference, dtInserted, dtLastUpdate)
select idSupportReference, idGuidanceBox, coSupportReference, IdMediaInformation, txTitle, txReferenceNumber, txReference, dtInserted, dtLastUpdate
from tmp_SupportReference
;

drop table if exists tmp_SupportReference
;

/*==============================================================*/
/* Table: MediaInformation                                      */
/*==============================================================*/
create table MediaInformation
(
   IdMediaInformation   int not null auto_increment,
   coMediaLocator       char(36) not null,
   txName               varchar(100) not null,
   nuSize               double not null,
   txContentType        varchar(30) not null,
   txPath               varchar(300) not null,
   inPublic             tinyint(1) not null default 1,
   txAbsoluteUrl        varchar(300) not null,
   dtInserted           datetime not null default NOW(),
   dtLastUpdate         datetime,
   primary key (IdMediaInformation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into MediaInformation (IdMediaInformation, coMediaLocator, txName, nuSize, txContentType, txPath, inPublic, txAbsoluteUrl, dtInserted, dtLastUpdate)
select IdMediaInformation, coMediaLocator, txName, nuSize, txContentType, txPath, isPublic, txAbsoluteUrl, dtInserted2, dtLastUpdate
from tmp_MediaInformation
;

drop table if exists tmp_MediaInformation
;

/*==============================================================*/
/* Table: MomentLesson                                          */
/*==============================================================*/
create table MomentLesson
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idMomentLesson       int not null auto_increment,
   coMomentStatus       char(4) not null,
   idProfessor          int not null,
   idClassTrack         int,
   dtStartSchedule      time not null comment 'Hora de inicio.',
   dtEndSchedule        time not null,
   dtStartMoment        datetime,
   dtEndMoment          datetime,
   txClassStateHash     varchar(256),
   txJobId              varchar(36),
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idMomentLesson),
   key AK_MomentLesson (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into MomentLesson (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson, coMomentStatus, idProfessor, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment, coMomentStatus, idProfessor, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_Moment
;

drop table if exists tmp_Moment
;

/*==============================================================*/
/* Table: Professor                                             */
/*==============================================================*/
create table Professor
(
   idProfessor          int not null auto_increment,
   idNetwork            int not null,
   idUserProfessor      int not null,
   idClass              int,
   idSchool             int,
   coGrade              char(4),
   idSchoolYear         smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProfessor),
   key AK_Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Professor (idProfessor, idNetwork, idUserProfessor, idClass, idSchool, coGrade, idSchoolYear, dtInserted, dtLastUpdate)
select idProfessor, idNetwork, idUserProfessor, idClass, idSchool, coGrade, idSchoolYear, dtInserted, dtLastUpdate
from tmp_Professor
;

drop table if exists tmp_Professor
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
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   idStudent            int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudent),
   key AK_StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into StudentClass (idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, dtInserted)
select idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, now()
from tmp_StudentClass
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_StudentClass
#;
alter table ActionLog add constraint FK_ActionLog_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table Class add constraint FK_Class_ClassShift foreign key (coClassShift)
      references ClassShift (coClassShift) on delete restrict on update restrict
;

alter table Class add constraint FK_Class_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict
;

alter table Class add constraint FK_Class_SchoolYear foreign key (idSchoolYear)
      references SchoolYear (idSchoolYear) on delete restrict on update restrict
;

alter table ClassTrack add constraint FK_ClassTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table ClassTrack add constraint FK_ClassTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table ClassTrackLesson add constraint FK_ClassTrackLesson_ClassTrack foreign key (idClassTrack, coGrade)
      references ClassTrack (idClassTrack, coGrade) on delete restrict on update restrict
;

alter table ClassTrackLesson add constraint FK_ClassTrackLesson_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table DataUsage add constraint FK_DataUsage_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table DocumentationLessonStep add constraint FK_DocumentationLessonStep_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table DocumentationLessonStep add constraint FK_DocumentationLessonStep_LessonStep foreign key (coGrade, idLessonStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict
;

alter table DocumentationStudent add constraint FK_DocumentationStudent_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table DocumentationStudent add constraint FK_DocumentationStudent_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LektoUser add constraint FK_LektoUser_MaritalStatus foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete restrict on update restrict
;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict
;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_LessonActivityOrientation foreign key (idLessonActivityOrientation)
      references LessonActivityOrientation (idLessonActivityOrientation) on delete restrict on update restrict
;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table LessonDocumentation add constraint FK_LessonDocumentation_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonDocumentation add constraint FK_LessonDocumentation_MomentLesson foreign key (idMoment)
      references MomentLesson (idMomentLesson) on delete restrict on update restrict
;

alter table LessonDocumentationActivity add constraint FK_LessonDocumentationActivity_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table LessonDocumentationEvidence add constraint FK_LessonDocumentationEvidence_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table LessonDocumentationEvidence add constraint FK_LessonDocumentationEvidence_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_MomentLesson foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment)
      references MomentLesson (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonOrientation add constraint FK_LessonOrientation_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_LessonOrientation foreign key (idLessonStepOrientation)
      references LessonOrientation (idLessonStepOrientation) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table MomentLesson add constraint FK_MomentLesson_Class foreign key (idClass)
      references Class (idClass) on delete restrict on update restrict
;

alter table MomentLesson add constraint FK_MomentLesson_ClassTrack foreign key (idClassTrack, coGrade)
      references ClassTrack (idClassTrack, coGrade) on delete restrict on update restrict
;

alter table MomentLesson add constraint FK_MomentLesson_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict
;

alter table MomentLesson add constraint FK_MomentLesson_Professor foreign key (idProfessor)
      references Professor (idProfessor) on delete restrict on update restrict
;

alter table Notification add constraint FK_Notification_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table Professor add constraint FK_Professor_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUserProfessor)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idUserBound)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table School add constraint FK_School_MediaInformation foreign key (IdMediaInfoLogo)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
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

alter table UserAddress add constraint FK_UserAddress_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table UserSession add constraint FK_UserSession_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;


CREATE TRIGGER `tgi_SchoolYear` 
BEFORE INSERT ON `SchoolYear` 
FOR EACH ROW BEGIN

	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtStartPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	BEGIN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de inicio informada ja existe em um periodo existente na tabela SchoolYear.';
	END IF;
	
	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtEndPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	BEGIN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de termino informada pertence a um periodo existente na tabela SchoolYear.';
	END IF;	

END;


CREATE TRIGGER `tgu_SchoolYear` BEFORE UPDATE ON `SchoolYear` FOR EACH ROW BEGIN

	DECLARE 
	
	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtStartPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	BEGIN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de inicio informada ja existe em um periodo existente na tabela SchoolYear.';
	END IF;
	
	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtEndPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	BEGIN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de termino informada pertence a um periodo existente na tabela SchoolYear.';
	END IF;	

END

;


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

