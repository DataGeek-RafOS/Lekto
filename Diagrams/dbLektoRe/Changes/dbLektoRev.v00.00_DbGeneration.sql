/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/5/2023 2:29:38 PM                          */
/*==============================================================*/

-- CREATE DATABASE `dbLektoRev` CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_general_ci';

/*==============================================================*/
/* Table: Abiliity                                              */
/*==============================================================*/
create table Abiliity
(
   idAbiliity           smallint not null,
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

/*==============================================================*/
/* Index: ixNCL_ActivityLog_idUser                              */
/*==============================================================*/
create index ixNCL_ActivityLog_idUser on ActionLog
(
   idNetwork,
   idUser
);

/*==============================================================*/
/* Table: ActionLogGroup                                        */
/*==============================================================*/
create table ActionLogGroup
(
   idActionLogGroup     tinyint not null,
   txName               varchar(150),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idActionLogGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ActionLogType                                         */
/*==============================================================*/
create table ActionLogType
(
   idActionLogType      int not null,
   txAction             varchar(200) not null,
   idActionLogGroup     tinyint not null,
   dtInserted           datetime not null,
   primary key (idActionLogType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Activity                                              */
/*==============================================================*/
create table Activity
(
   idActivity           int not null auto_increment,
   idStep               int not null,
   txTitle              varchar(150) not null,
   nuOrder              tinyint not null,
   idCategory           smallint not null,
   idAbiliity           smallint not null,
   txChallenge          varchar(500) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idActivity)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Category                                              */
/*==============================================================*/
create table Category
(
   idCategory           smallint not null,
   txName               varchar(100) not null,
   txImagePath          varchar(80) comment 'Caminho da imagem.',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCategory)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Class                                                 */
/*==============================================================*/
create table Class
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null auto_increment,
   txName               varchar(50) not null,
   inStatus             tinyint(1) not null default 1,
   txCodeOrigin         varchar(36),
   coClassShift         char(3),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool, coGrade, idSchoolYear, idClass),
   unique key ukNCL_Class_idClass (idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ClassShift                                            */
/*==============================================================*/
create table ClassShift
(
   coClassShift         char(3) not null,
   txClassShift         varchar(30) not null,
   primary key (coClassShift)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table ClassShift comment 'Turno Escolar. e.g.: Matutino, Vespertino...';

/*==============================================================*/
/* Table: Component                                             */
/*==============================================================*/
create table Component
(
   coComponent          char(3) not null,
   txComponent          varchar(100),
   txDescription        varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Grade                                                 */
/*==============================================================*/
create table Grade
(
   coGrade              char(4) not null,
   coStage              char(4) not null,
   txGrade              varchar(100) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coGrade)
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
   txTitle              varchar(100) not null,
   txCode               varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idGuidanceBox)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LektoUser                                             */
/*==============================================================*/
create table LektoUser
(
   idNetwork            int not null,
   idUser               int not null auto_increment,
   txName               varchar(120) not null,
   idAuth0              varchar(64),
   txImagePath          varchar(300) comment 'Caminho da imagem.',
   txEmail              varchar(120),
   txNickname           varchar(80),
   txPhone              varchar(11),
   txCpf                char(11),
   dtBirthdate          datetime,
   idAddress            int,
   idCityPlaceOfBirth   int,
   coMaritalStatus      char(3),
   inStatus             tinyint(1) not null default 1,
   isLgpdTermsAccepted  tinyint(1),
   txCodeOrigin         varchar(36),
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idNetwork, idUser),
   unique key ukNCL_LektoUser_idUser (idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LektoUserType                                         */
/*==============================================================*/
create table LektoUserType
(
   idNetwork            int not null,
   idUser               int not null,
   coUserType           char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   inStatus             tinyint(1) default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idUser, coUserType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   txTitle              varchar(300) not null,
   coComponent          char(3) not null,
   txGuidance           varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LessonTrail                                           */
/*==============================================================*/
create table LessonTrail
(
   idLessonTrail        int not null auto_increment,
   primary key (idLessonTrail)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table LessonTrail comment 'Trilha de aulas';

/*==============================================================*/
/* Table: Moment                                                */
/*==============================================================*/
create table Moment
(
   dtTimeStart          time not null default 'getdate()' comment 'Hora de inicio.',
   dtTimeEnd            time,
   dtInserted           datetime not null,
   dtLastUpdate         datetime
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: MomentStatus                                          */
/*==============================================================*/
create table MomentStatus
(
   coMomentStatus       char(4) not null,
   txMomentStatus       varchar(60) not null,
   inDeleted            tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (coMomentStatus)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table MomentStatus comment 'Tabela de situacao do momento.';

/*==============================================================*/
/* Table: Network                                               */
/*==============================================================*/
create table Network
(
   idNetwork            int not null auto_increment,
   txName               varchar(120) not null,
   inAdminLektoEnabled  tinyint(1) not null default 1,
   inSingleSignOn       tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Notification                                          */
/*==============================================================*/
create table Notification
(
   idNotification       int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   coNotificationSource char(4) not null comment 'Codigo da origem da notificacao..',
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

/*==============================================================*/
/* Table: NotificationType                                      */
/*==============================================================*/
create table NotificationType
(
   coNotificationType   char(4) not null,
   txNotificationType   varchar(50) not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (coNotificationType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table NotificationType comment 'Tabela de tipos de notificacoes.';

/*==============================================================*/
/* Table: Professor                                             */
/*==============================================================*/
create table Professor
(
   idProfessor          int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUser               int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProfessor)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Index: ukNCL_Tutor                                           */
/*==============================================================*/
create unique index ukNCL_Tutor on Professor
(
   idNetwork,
   idSchool,
   coGrade,
   idClass,
   idUser
);

/*==============================================================*/
/* Table: RelationType                                          */
/*==============================================================*/
create table RelationType
(
   coRelationType       char(4) not null comment 'Tabela de tipo de vinculos entre os usuarios..',
   txRelationType       varchar(40),
   primary key (coRelationType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

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
   IdMediaInfoLogo      char(36),
   idAddress            int,
   txTradingName        varchar(200) comment 'Nome Fantasia',
   txStateRegistration  varchar(13),
   txMunicipalRegistration varchar(13),
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

/*==============================================================*/
/* Table: SchoolGrade                                           */
/*==============================================================*/
create table SchoolGrade
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   primary key (idNetwork, idSchool, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: SchoolYear                                            */
/*==============================================================*/
create table SchoolYear
(
   idSchoolYear         smallint not null auto_increment,
   idNetwork            int not null,
   dtStartPeriod        date not null,
   dtEndPeriod          date not null,
   primary key (idSchoolYear)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Stage                                                 */
/*==============================================================*/
create table Stage
(
   coStage              char(4) not null,
   txName               varchar(200) not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Step                                                  */
/*==============================================================*/
create table Step
(
   idStep               int not null auto_increment,
   idLesson             int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   idAbiliity           smallint not null,
   nuDuration           smallint not null comment 'Duracao em minutos',
   txGuidance           varchar(300) comment 'Orientacoes',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStep)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: Student                                               */
/*==============================================================*/
create table Student
(
   idStudent            int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint,
   idClass              int,
   idUser               int not null,
   dtFitInClass         date comment 'Entrada na turma',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Index: ukNCL_Apprentice                                      */
/*==============================================================*/
create unique index ukNCL_Apprentice on Student
(
   idNetwork,
   idSchool,
   coGrade,
   idClass,
   idUser
);

/*==============================================================*/
/* Table: SupportMaterial                                       */
/*==============================================================*/
create table SupportMaterial
(
   idSupportMaterial    int not null auto_increment,
   idGuidanceBox        int not null,
   txMaterial           varchar(80) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   primary key (idSupportMaterial)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: UserType                                              */
/*==============================================================*/
create table UserType
(
   coUserType           char(4) not null,
   txUserType           varchar(30) not null,
   inStatus             tinyint(1) not null default 1,
   txAuth0Scope         varchar(20),
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (coUserType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table ActionLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActionLogType)
      references ActionLogType (idActionLogType);

alter table ActionLog add constraint FK_ActionLog_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table ActionLogType add constraint FK_ActivityLogType_ActivityLogGroup foreign key (idActionLogGroup)
      references ActionLogGroup (idActionLogGroup);

alter table Activity add constraint FK_Activity_Abiliity foreign key (idAbiliity)
      references Abiliity (idAbiliity) on delete restrict on update restrict;

alter table Activity add constraint FK_Activity_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict;

alter table Activity add constraint FK_Activity_Step foreign key (idStep)
      references Step (idStep) on delete restrict on update restrict;

alter table Class add constraint FK_Class_ClassShift foreign key (coClassShift)
      references ClassShift (coClassShift) on delete restrict on update restrict;

alter table Class add constraint FK_Class_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict;

alter table Class add constraint FK_Class_SchoolYear foreign key (idSchoolYear)
      references SchoolYear (idSchoolYear) on delete restrict on update restrict;

alter table Grade add constraint FK_Grade_Stage foreign key (coStage)
      references Stage (coStage) on delete restrict on update restrict;

alter table GuidanceBox add constraint FK_GuidanceBox_Activity foreign key (idActivity)
      references Activity (idActivity) on delete restrict on update restrict;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table LektoUserType add constraint FK_LektoUserType_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table LektoUserType add constraint FK_LektoUserType_UserType foreign key (coUserType)
      references UserType (coUserType) on delete restrict on update restrict;

alter table Lesson add constraint FK_Lesson_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_NotificationSource foreign key (coNotificationSource)
      references NotificationSource (coNotificationSource) on delete restrict on update restrict;



alter table Professor add constraint FK_Professor_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUserBound)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType) on delete restrict on update restrict;

alter table School add constraint FK_School_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table SchoolGrade add constraint FK_SchoolGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table SchoolGrade add constraint FK_SchoolGrade_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

alter table SchoolYear add constraint FK_SchoolYear_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Step add constraint FK_Step_Abiliity foreign key (idAbiliity)
      references Abiliity (idAbiliity) on delete restrict on update restrict;


alter table Student add constraint FK_Student_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table Student add constraint FK_Student_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Student add constraint FK_Student_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict;

alter table SupportMaterial add constraint FK_SupportMaterial_GuidanceBox foreign key (idGuidanceBox)
      references GuidanceBox (idGuidanceBox) on delete restrict on update restrict;

alter table Notification add constraint FK_Notification_NotificationType foreign key (coNotificationType)
      references NotificationType (coNotificationType) on delete restrict on update restrict;


alter table Step add constraint FK_Step_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict;	 