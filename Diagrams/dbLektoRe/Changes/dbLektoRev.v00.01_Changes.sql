/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/10/2023 9:43:35 AM                         */
/*==============================================================*/


drop table if exists tmp_Abiliity;

rename table Abiliity to tmp_Abiliity;

alter table Activity
   drop primary key;

drop table if exists tmp_Activity;

rename table Activity to tmp_Activity;

drop table if exists tmp_Category;

rename table Category to tmp_Category;

drop table if exists tmp_GuidanceBox;

rename table GuidanceBox to tmp_GuidanceBox;

alter table LektoUser
   drop column idAddress;
   
 
alter table `dbLektoRev`.`Step` drop foreign key `FK_Step_Lesson`;   
   
alter table `dbLektoRev`.`Lesson` drop foreign key `FK_Lesson_Component`;   
   
alter table Lesson
modify column idLesson int not null first,
   drop primary key;


drop table if exists tmp_Lesson;

rename table Lesson to tmp_Lesson;

alter table LessonTrail
modify column idLessonTrail int not null first,
   drop primary key;

drop table if exists tmp_LessonTrail;

rename table LessonTrail to tmp_LessonTrail;

drop table if exists tmp_Moment;

rename table Moment to tmp_Moment;

drop table if exists tmp_Network;

rename table Network to tmp_Network;

drop table if exists tmp_Notification;

rename table Notification to tmp_Notification;

drop table if exists tmp_NotificationSource;

rename table NotificationSource to tmp_NotificationSource;

drop table if exists tmp_RelationType;

rename table RelationType to tmp_RelationType;

drop table if exists tmp_Relationship;

rename table Relationship to tmp_Relationship;

drop table if exists tmp_School;

rename table School to tmp_School;

alter table Step
   drop primary key;

drop table if exists tmp_Step;

rename table Step to tmp_Step;

alter table Student
   drop primary key;

drop table if exists tmp_Student;

rename table Student to tmp_Student;

drop table if exists tmp_SupportMaterial;

rename table SupportMaterial to tmp_SupportMaterial;

drop table if exists tmp_LektoUserType;

rename table LektoUserType to tmp_LektoUserType;



/*==============================================================*/
/* Table: Ability                                               */
/*==============================================================*/
create table Ability
(
   idAbiliity           smallint not null auto_increment,
   idCompetence         smallint not null,
   txName               varchar(50) not null,
   txImagePath          varchar(80) comment 'Caminho da imagem.',
   txPrimaryColor       varchar(8),
   txBgPrimaryColor     varchar(8),
   txBgSecondaryColor   varchar(8),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idAbiliity)
)
default character set utf8mb4
collate utf8mb4_general_ci;


alter table tmp_Activity drop constraint FK_Activity_Abiliity;

alter table tmp_Step drop constraint FK_Step_Abiliity;

drop table if exists tmp_Abiliity;

/*==============================================================*/
/* Table: Activity                                              */
/*==============================================================*/
create table Activity
(
   idActivity           int not null auto_increment,
   coGrade              char(4) not null,
   idStep               int not null,
   txTitle              varchar(150) not null,
   nuOrder              tinyint not null,
   idCategory           smallint not null,
   idEvidence           int not null,
   txChallenge          varchar(500) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table tmp_GuidanceBox drop constraint FK_GuidanceBox_Activity;

drop table if exists tmp_Activity;

/*==============================================================*/
/* Table: Category                                              */
/*==============================================================*/
create table Category
(
   idCategory           smallint not null auto_increment,
   txName               varchar(100) not null,
   txImagePath          varchar(80) comment 'Caminho da imagem.',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCategory)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_Category;

/*==============================================================*/
/* Table: Competence                                            */
/*==============================================================*/
create table Competence
(
   idCompetence         smallint not null auto_increment,
   txName               varchar(80) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCompetence)
)
default character set utf8mb4
collate utf8mb4_general_ci;

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

/*==============================================================*/
/* Table: District                                              */
/*==============================================================*/
create table District
(
   coDistrict           char(2) not null,
   txName               varchar(120) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coDistrict)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Evidence                                              */
/*==============================================================*/
create table Evidence
(
   idEvidence           int not null auto_increment,
   coGrade              char(4) not null,
   txName               varchar(80) not null,
   idAbiliity           smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idEvidence, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: GuidanceBox                                           */
/*==============================================================*/
create table GuidanceBox
(
   idGuidanceBox        int not null auto_increment,
   idActivity           int not null,
   coGrade              char(4) not null,
   txTitle              varchar(100) not null,
   txGuidanceCode       varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idGuidanceBox)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table tmp_SupportMaterial drop constraint FK_SupportMaterial_GuidanceBox;

drop table if exists tmp_GuidanceBox;

alter table LektoUser
   change column idAuth0 idSingleSignOn varchar(64);

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   coGrade              char(4) not null,
   idLessonTrail        int not null,
   txTitle              varchar(300) not null,
   txGuidance           varchar(2000) not null comment 'Orientacoes gerais da aula (html)',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_Lesson;

/*==============================================================*/
/* Table: LessonTrail                                           */
/*==============================================================*/
create table LessonTrail
(
   idLessonTrail        int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   primary key (idLessonTrail, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;


drop table if exists tmp_LessonTrail;

/*==============================================================*/
/* Table: MaritalStatus                                         */
/*==============================================================*/
create table MaritalStatus
(
   coMaritalStatus      char(3) not null,
   txName               varchar(30) not null,
   primary key (coMaritalStatus)
)
default character set utf8mb4
collate utf8mb4_general_ci;

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
   isPublic             tinyint(1) not null default 1,
   txAbsoluteUrl        varchar(300) not null,
   dtInserted2          datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (IdMediaInformation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Moment                                                */
/*==============================================================*/
create table Moment
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idMoment             int not null auto_increment,
   coMomentStatus       char(4) not null,
   dtStartSchedule      time not null comment 'Hora de inicio.',
   dtEndSchedule        time not null,
   dtStartMoment        datetime,
   dtEndMoment          datetime,
   txClassStateHash     varchar(256),
   txJobId              varchar(36),
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment),
   key ukNCL_Moment_idMoment (idMoment)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_Moment;

alter table MomentStatus comment 'Tabela de situacao do momento.';


/*==============================================================*/
/* Table: Network                                               */
/*==============================================================*/
create table Network
(
   idNetwork            int not null,
   txName               varchar(120) not null,
   idNetworkReference   int,
   coDistrict           char(2),
   inAdminLektoEnabled  tinyint(1) not null default 1,
   inSingleSignOn       tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table tmp_School drop constraint FK_School_Network;

alter table SchoolYear drop constraint FK_SchoolYear_Network;

alter table LektoUser drop constraint FK_LektoUser_Network;

drop table if exists tmp_Network;

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

drop table if exists tmp_Notification;

/*==============================================================*/
/* Table: NotificationSource                                    */
/*==============================================================*/
create table NotificationSource
(
   coNotificationSource char(4) not null comment 'Codigo da origem da notificacao.',
   txNotificationSource varchar(50) not null comment 'Descricao da origem da notificacao.',
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (coNotificationSource)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table NotificationSource comment 'Origem da notificacao.';

drop table if exists tmp_NotificationSource;

alter table NotificationType comment 'Tabela de tipos de notificacoes.';

rename table UserType to Profile;

alter table Profile
   change column coUserType coProfile char(4) not null;

alter table Profile
   change column txUserType txProfile varchar(30) not null;

alter table Profile
   change column txAuth0Scope coScope varchar(20);


/*==============================================================*/
/* Table: RelationType                                          */
/*==============================================================*/
create table RelationType
(
   coRelationType       char(4) not null comment 'Tabela de tipo de vinculos entre os usuarios.',
   txRelationType       varchar(40),
   primary key (coRelationType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_RelationType;

/*==============================================================*/
/* Table: Relationship                                          */
/*==============================================================*/
create table Relationship
(
   idUser               int not null comment 'Usuario principal.',
   idUserBound          int not null comment 'Usuario vinculado.',
   coRelationType       char(4) not null,
   idNetwork            int not null,
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUser, idUserBound)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table Relationship comment 'Tabela de relacionamento entre os usuarios.';

drop table if exists tmp_Relationship;

/*==============================================================*/
/* Index: ixNCL_Relationship_coRelationType                     */
/*==============================================================*/
create index ixNCL_Relationship_coRelationType on Relationship
(
   coRelationType
);

/*==============================================================*/
/* Table: School                                                */
/*==============================================================*/
create table School
(
   idNetwork            int not null,
   idSchool             int not null auto_increment,
   txName               varchar(200) not null,
   txCnpj               char(14),
   inStatus             tinyint(1) not null default 1,
   IdMediaInfoLogo      int,
   txCodeOrigin         varchar(36),
   txCodeIntegrator     varchar(36),
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool),
   unique key ukNCL_School_idSchool (idSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table SchoolGrade drop constraint FK_SchoolGrade_School;

drop table if exists tmp_School;

/*==============================================================*/
/* Table: SchoolAddress                                         */
/*==============================================================*/
create table SchoolAddress
(
   idSchoolAddress      int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   txAddressLine1       varchar(150),
   txAddressLine2       varchar(100),
   txZipcode            varchar(9),
   txNeighborhood       varchar(50),
   txCity               varchar(80),
   coDistrict           char(2) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idSchoolAddress)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Step                                                  */
/*==============================================================*/
create table Step
(
   idStep               int not null auto_increment,
   coGrade              char(4) not null,
   idLesson             int not null,
   idEvidence           int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidance           varchar(300) comment 'Orientacoes',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStep, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;
 
drop table if exists tmp_Step;

/*==============================================================*/
/* Table: Student                                               */
/*==============================================================*/
create table Student
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idUser               int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool, coGrade, idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_Student;

/*==============================================================*/
/* Index: ukNCL_Apprentice                                      */
/*==============================================================*/
create unique index ukNCL_Apprentice on Student
(
   idNetwork,
   idSchool,
   coGrade,
   idUser
);

/*==============================================================*/
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUser               int not null,
   primary key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: StudentLesson                                         */
/*==============================================================*/
create table StudentLesson
(
   idStudentLesson      int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUser               int not null,
   idLesson             int not null,
   idMoment             int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudentLesson)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: SupportReference                                      */
/*==============================================================*/
create table SupportReference
(
   idSupportReference   int not null auto_increment,
   idGuidanceBox        int not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_SupportMaterial;

/*==============================================================*/
/* Table: SupportReferenceType                                  */
/*==============================================================*/
create table SupportReferenceType
(
   coSupportReference   char(4) not null,
   txName               varchar(80) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: UserAddress                                           */
/*==============================================================*/
create table UserAddress
(
   idUserAddress        int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   txAddressLine1       varchar(150),
   txAddressLine2       varchar(100),
   txZipcode            varchar(9),
   txNeighborhood       varchar(50),
   coDistrict           char(2),
   txCity               varchar(80),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idUserAddress)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: UserProfile                                           */
/*==============================================================*/
create table UserProfile
(
   idNetwork            int not null,
   idUser               int not null,
   coProfile            char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   inStatus             tinyint(1) default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idUser, coProfile)
)
default character set utf8mb4
collate utf8mb4_general_ci;

drop table if exists tmp_LektoUserType;

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

/*==============================================================*/
/* Table: UserSessionOrigin                                     */
/*==============================================================*/
create table UserSessionOrigin
(
   coUserSessionOrigin  char(3) not null,
   txUserSessionOrigin  varchar(100) not null,
   primary key (coUserSessionOrigin)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table Ability add constraint FK_Ability_Competence foreign key (idCompetence)
      references Competence (idCompetence) on delete restrict on update restrict;

alter table Activity add constraint FK_Activity_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict;

alter table Activity add constraint FK_Activity_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table Activity add constraint FK_Activity_Step foreign key (idStep, coGrade)
      references Step (idStep, coGrade) on delete restrict on update restrict;

alter table DataUsage add constraint FK_DataUsage_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Evidence add constraint FK_Evidence_Ability foreign key (idAbiliity)
      references Ability (idAbiliity) on delete restrict on update restrict;

alter table Evidence add constraint FK_Evidence_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table GuidanceBox add constraint FK_GuidanceBox_Activity foreign key (idActivity, coGrade)
      references Activity (idActivity, coGrade) on delete restrict on update restrict;

alter table LektoUser add constraint FK_LektoUser_MaritalStatus foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete restrict on update restrict;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table Lesson add constraint FK_Lesson_LessonTrail foreign key (idLessonTrail, coGrade)
      references LessonTrail (idLessonTrail, coGrade) on delete restrict on update restrict;

alter table LessonTrail add constraint FK_LessonTrail_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonTrail add constraint FK_LessonTrail_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table Moment add constraint FK_Moment_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table Moment add constraint FK_Moment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table Network add constraint FK_Network_Network foreign key (idNetworkReference)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Network add constraint FK_Network_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_NotificationSource foreign key (coNotificationSource)
      references NotificationSource (coNotificationSource) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_NotificationType foreign key (coNotificationType)
      references NotificationType (coNotificationType) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

#alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUserBound)
#      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType) on delete restrict on update restrict;

alter table School add constraint FK_School_MediaInformation foreign key (IdMediaInfoLogo)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table School add constraint FK_School_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table SchoolAddress add constraint FK_SchoolAddress_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict;

alter table SchoolAddress add constraint FK_SchoolAddress_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

alter table SchoolGrade add constraint FK_SchoolGrade_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

alter table SchoolYear add constraint FK_SchoolYear_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Step add constraint FK_Step_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table Step add constraint FK_Step_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table Student add constraint FK_Student_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Student add constraint FK_Student_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict;

alter table StudentClass add constraint FK_StudentClass_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table StudentClass add constraint FK_StudentClass_Student foreign key (idNetwork, idSchool, coGrade, idUser)
      references Student (idNetwork, idSchool, coGrade, idUser) on delete restrict on update restrict;

alter table StudentLesson add constraint FK_StudentLesson_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table StudentLesson add constraint FK_StudentLesson_Moment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment)
      references Moment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment) on delete restrict on update restrict;

alter table StudentLesson add constraint FK_StudentLesson_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUser)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUser) on delete restrict on update restrict;

alter table SupportReference add constraint FK_SupportReference_GuidanceBox foreign key (idGuidanceBox)
      references GuidanceBox (idGuidanceBox) on delete restrict on update restrict;

alter table SupportReference add constraint FK_SupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table SupportReference add constraint FK_SupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table UserAddress add constraint FK_UserAddress_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict;

alter table UserAddress add constraint FK_UserAddress_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table UserProfile add constraint FK_UserProfile_Profile foreign key (coProfile)
      references Profile (coProfile) on delete restrict on update restrict;

alter table UserSession add constraint FK_UserSession_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table UserSession add constraint FK_UserSession_UserSessionOrigin foreign key (coUserSessionOrigin)
      references UserSessionOrigin (coUserSessionOrigin) on delete restrict on update restrict;

