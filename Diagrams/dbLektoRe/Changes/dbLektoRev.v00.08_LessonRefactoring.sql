/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/19/2023 10:44:50 PM                        */
/*==============================================================*/


alter table ActionLog drop constraint FK_ActivityLog_ActivityLogType;

alter table ActionLog drop constraint FK_ActionLog_LektoUser;

alter table DataUsage drop constraint FK_DataUsage_LektoUser;

alter table DocumentationLessonStep drop constraint FK_DocumentationLessonStep_LessonDocumentation;

alter table DocumentationLessonStep drop constraint FK_DocumentationLessonStep_LessonStep;

alter table DocumentationStudent drop constraint FK_DocumentationStudent_LessonDocumentation;

alter table DocumentationStudent drop constraint FK_DocumentationStudent_StudentClass;

alter table LektoUser drop constraint FK_LektoUser_MaritalStatus;

alter table LektoUser drop constraint FK_LektoUser_Network;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_MediaInformation;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_MomentLesson;

alter table LessonDocumentationActivity drop constraint FK_LessonDocumentationActivity_LessonDocumentation;

alter table LessonDocumentationEvidence drop constraint FK_LessonDocumentationEvidence_Evidence;

alter table LessonDocumentationEvidence drop constraint FK_LessonDocumentationEvidence_LessonDocumentation;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_MomentLesson;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_Evidence;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_LessonStep;

alter table MomentLesson drop constraint FK_MomentLesson_Class;

alter table MomentLesson drop constraint FK_MomentLesson_ClassTrack;

alter table MomentLesson drop constraint FK_MomentLesson_MomentStatus;

alter table MomentLesson drop constraint FK_MomentLesson_Professor;

alter table Notification drop constraint FK_Notification_LektoUser;

alter table Notification drop constraint FK_Notification_NotificationSource;

alter table Notification drop constraint FK_Notification_NotificationType;

alter table Professor drop constraint FK_Professor_LektoUser;

alter table Relationship drop constraint FK_Relationship_LektoUser;

alter table Relationship drop constraint FK_Relationship_LektoUserBound;

alter table Relationship drop constraint FK_Relationship_RelationType;

alter table Student drop constraint FK_Student_LektoUser;

alter table UserAddress drop constraint FK_UserAddress_LektoUser;

alter table UserProfile drop constraint FK_UserProfile_LektoUser;

alter table UserSession drop constraint FK_UserSession_LektoUser;

alter table UserSession drop constraint FK_UserSession_UserSessionOrigin;

alter table ActionLog
   drop primary key;

drop table if exists tmp_ActionLog;

rename table ActionLog to tmp_ActionLog;

alter table DataUsage
   modify column idDataUsage bigint not null first, drop primary key;

drop table if exists tmp_DataUsage;

rename table DataUsage to tmp_DataUsage;

alter table DocumentationLessonStep
   drop primary key;

alter table LektoUser
modify column idUser int not null first, 
   drop primary key;

drop table if exists tmp_LektoUser;

rename table LektoUser to tmp_LektoUser;

alter table LessonDocumentation
   drop primary key;

drop table if exists tmp_LessonDocumentation;

rename table LessonDocumentation to tmp_LessonDocumentation;

alter table LessonDocumentationActivity
   drop primary key;

alter table LessonDocumentationEvidence
   drop primary key;

alter table LessonStepEvidence
   drop primary key;

drop table if exists tmp_LessonStepEvidence;

rename table LessonStepEvidence to tmp_LessonStepEvidence;

drop table if exists tmp_DocumentationStudent;

rename table DocumentationStudent to tmp_DocumentationStudent;

alter table MomentLesson
MODIFY COLUMN `idMomentLesson` int NOT NULL AFTER `idClass`,
   drop primary key;

drop table if exists tmp_MomentLesson;

rename table MomentLesson to tmp_MomentLesson;

alter table Notification
MODIFY COLUMN `idNotification` int NOT NULL FIRST,
   drop primary key;

drop table if exists tmp_Notification;

rename table Notification to tmp_Notification;

alter table Relationship
   drop primary key;

drop table if exists tmp_Relationship;

rename table Relationship to tmp_Relationship;

alter table UserSession MODIFY COLUMN `idUserSession` int NOT NULL FIRST,
   drop primary key;

drop table if exists tmp_UserSession;

rename table UserSession to tmp_UserSession;

/*==============================================================*/
/* Table: ActionLog                                             */
/*==============================================================*/
create table ActionLog
(
   idActionLog          bigint not null auto_increment,
   dtAction             datetime not null,
   idActionLogType      int not null,
   idNetwork            int not null,
   idUser               int not null,
   txVariables          json,
   primary key (idActionLog, dtAction)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ActionLog (idActionLog, dtAction, idActionLogType, idNetwork, idUser, txVariables)
select idActionLog, dtAction, idActionLogType, 1, idUser, txVariables
from tmp_ActionLog;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ActionLog;
/*==============================================================*/
/* Index: ixNCL_ActivityLog_idUser                              */
/*==============================================================*/
create index ixNCL_ActivityLog_idUser on ActionLog
(
   idUser
);

/*==============================================================*/
/* Table: DataUsage                                             */
/*==============================================================*/
create table DataUsage
(
   idDataUsage          bigint not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   dtInserted           datetime not null,
   txRequestUrl         longtext not null,
   nuExecutionTime      int not null,
   nuResponseTime       int not null,
   nuStatusCode         smallint not null,
   nuSize               double not null,
   txMethod             varchar(20) not null,
   txUserAgent          varchar(200),
   txIpAddress          varchar(39),
   primary key (idDataUsage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into DataUsage (idDataUsage, idNetwork, idUser, dtInserted, txRequestUrl, nuExecutionTime, nuResponseTime, nuStatusCode, nuSize, txMethod, txUserAgent, txIpAddress)
select idDataUsage, ?, idUser, dtInserted, txRequestUrl, nuExecutionTime, nuResponseTime, nuStatusCode, nuSize, txMethod, txUserAgent, txIpAddress
from tmp_DataUsage;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_DataUsage;
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
   unique key AK_LektoUser (idNetwork, idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LektoUser (idNetwork, idUser, txName, idSingleSignOn, txImagePath, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idCityPlaceOfBirth, coMaritalStatus, inStatus, isLgpdTermsAccepted, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate)
select idNetwork, idUser, txName, idSingleSignOn, txImagePath, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idCityPlaceOfBirth, coMaritalStatus, inStatus, isLgpdTermsAccepted, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate
from tmp_LektoUser;

drop table if exists tmp_LektoUser;

rename table LessonDocumentationActivity to LessonActivityDocumentation;

alter table LessonActivityDocumentation comment 'Documentacao de atividade por estudante';

alter table LessonActivityDocumentation
   add primary key (idDocumentation, idMomentActivity);

/*==============================================================*/
/* Table: LessonDocumentation                                   */
/*==============================================================*/
create table LessonDocumentation
(
   idLessonDocumentation int not null auto_increment,
   txMomentNotes        longtext not null comment 'Informacoes complementares.
            ',
   IdMediaInformation   int,
   idMoment             int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation),
   key AK_LessonDocumentation (idLessonDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table LessonDocumentation comment 'Informacoes complementares referentes ao grupo. 
Neste';

insert into LessonDocumentation (idLessonDocumentation, txMomentNotes, IdMediaInformation, idMoment, dtInserted, dtLastUpdate)
select idLessonDocumentation, txMomentNotes, IdMediaInformation, idMoment, dtInserted, dtLastUpdate
from tmp_LessonDocumentation;

drop table if exists tmp_LessonDocumentation;

rename table LessonDocumentationEvidence to LessonEvidenceDocumentation;

alter table LessonEvidenceDocumentation
   add primary key (idLessonDocumentation, idEvidence);

rename table DocumentationLessonStep to LessonStepDocumentation;

alter table LessonStepDocumentation
   add primary key (idDocumentation, idLessonStep, coGrade);

/*==============================================================*/
/* Table: LessonStepEvidence                                    */
/*==============================================================*/
create table LessonStepEvidence
(
   Les_coGrade          char(4) not null,
   idLessonStep         int not null,
   coGrade              char(4) not null,
   idEvidence           int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (Les_coGrade, idLessonStep, coGrade, idEvidence)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonStepEvidence (Les_coGrade, idLessonStep, coGrade, idEvidence, dtInserted, dtLastUpdate)
select ?, idLessonStep, coGrade, idEvidence, dtInserted, dtLastUpdate
from tmp_LessonStepEvidence;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonStepEvidence;
/*==============================================================*/
/* Table: LessonStudentDocumentation                            */
/*==============================================================*/
create table LessonStudentDocumentation
(
   idLessonStudentDocumentation int not null auto_increment,
   idLessonDocumentation int not null,
   idNetwork            int,
   idSchool             int,
   coGrade              char(4),
   idSchoolYear         smallint,
   idClass              int,
   idUserStudent        int,
   idStudent            int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStudentDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonStudentDocumentation (idLessonStudentDocumentation, idLessonDocumentation, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, dtInserted, dtLastUpdate)
select ?, idLessonDocumentation, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, dtInserted, dtLastUpdate
from tmp_DocumentationStudent;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_DocumentationStudent;
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
   idUserProfessor      int not null,
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
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into MomentLesson (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson, coMomentStatus, ?, idProfessor, idClassTrack, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_MomentLesson;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_MomentLesson;
/*==============================================================*/
/* Table: Notification                                          */
/*==============================================================*/
create table Notification
(
   idNotification       int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   coNotificationSource char(4) not null comment 'Codigo da origem da notificacao.',
   coNotificationType   char(4) not null,
   dtReceived           datetime not null comment 'Data de recebimento.',
   dtRead               datetime comment 'Data da leitura.',
   txMessage            varchar(255) not null,
   txSubject            varchar(50) not null,
   txImage              varchar(300),
   txPayload            json,
   primary key (idNotification)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Notification (idNotification, idNetwork, idUser, coNotificationSource, coNotificationType, dtReceived, dtRead, txMessage, txSubject, txImage, txPayload)
select idNotification, ?, idUser, coNotificationSource, coNotificationType, dtReceived, dtRead, txMessage, txSubject, txImage, txPayload
from tmp_Notification;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Notification;
/*==============================================================*/
/* Table: Relationship                                          */
/*==============================================================*/
create table Relationship
(
   Lek_idNetwork        int not null,
   idUser               int not null comment 'Usuario principal.',
   idNetwork            int not null,
   idUserBound          int not null comment 'Usuario vinculado.',
   coRelationType       char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (Lek_idNetwork, idNetwork, idUser, idUserBound)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table Relationship comment 'Tabela de relacionamento entre os usuarios.';

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Relationship (Lek_idNetwork, idUser, idNetwork, idUserBound, coRelationType, inDeleted, dtInserted, dtLastUpdate)
select ?, idUser, ?, idUserBound, coRelationType, inDeleted, dtInserted, dtLastUpdate
from tmp_Relationship;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Relationship;
/*==============================================================*/
/* Index: ixNCL_Relationship_coRelationType                     */
/*==============================================================*/
create index ixNCL_Relationship_coRelationType on Relationship
(
   coRelationType
);

/*==============================================================*/
/* Table: UserSession                                           */
/*==============================================================*/
create table UserSession
(
   idUserSession        int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   coUserSessionOrigin  char(3) not null,
   dtStartSession       datetime not null,
   dtEndSession         datetime,
   txIdSession          longtext,
   txUserAgent          varchar(250),
   isDisconnectedByIdleness tinyint(1) not null default 0,
   primary key (idUserSession)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into UserSession (idUserSession, idNetwork, idUser, coUserSessionOrigin, dtStartSession, dtEndSession, txIdSession, txUserAgent, isDisconnectedByIdleness)
select idUserSession, ?, idUser, coUserSessionOrigin, dtStartSession, dtEndSession, txIdSession, txUserAgent, isDisconnectedByIdleness
from tmp_UserSession;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_UserSession;
alter table ActionLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActionLogType)
      references ActionLogType (idActionLogType);

alter table ActionLog add constraint FK_ActionLog_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table DataUsage add constraint FK_DataUsage_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table LektoUser add constraint FK_LektoUser_MaritalStatus foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete restrict on update restrict;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;
	 
alter table LessonActivity add constraint FK_LessonActivity_LessonStep_ foreign key (coGrade, idStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonDocumentation add constraint FK_LessonDocumentation_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table LessonDocumentation add constraint FK_LessonDocumentation_MomentLesson foreign key (idMoment)
      references MomentLesson (idMomentLesson) on delete restrict on update restrict;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_MomentLesson foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment)
      references MomentLesson (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (coGrade, idLessonStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (coGrade, idLessonStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table MomentLesson add constraint FK_MomentLesson_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table MomentLesson add constraint FK_MomentLesson_ClassTrack foreign key (idClassTrack, coGrade)
      references ClassTrack (idClassTrack, coGrade) on delete restrict on update restrict;

alter table MomentLesson add constraint FK_MomentLesson_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table MomentLesson add constraint FK_MomentLesson_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_NotificationSource foreign key (coNotificationSource)
      references NotificationSource (coNotificationSource) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_NotificationType foreign key (coNotificationType)
      references NotificationType (coNotificationType) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUserProfessor)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idNetwork, idUserBound)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType) on delete restrict on update restrict;

alter table Student add constraint FK_Student_LektoUser foreign key (idNetwork, idUserStudent)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table UserAddress add constraint FK_UserAddress_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table UserSession add constraint FK_UserSession_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table UserSession add constraint FK_UserSession_UserSessionOrigin foreign key (coUserSessionOrigin)
      references UserSessionOrigin (coUserSessionOrigin) on delete restrict on update restrict;

