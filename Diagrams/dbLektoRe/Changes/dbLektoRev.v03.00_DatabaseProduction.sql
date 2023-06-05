/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/2/2023 3:14:13 PM                          */
/*==============================================================*/


/*==============================================================*/
/* Table: Ability                                               */
/*==============================================================*/
create table Ability
(
   idAbility            smallint not null auto_increment,
   idCompetence         smallint not null,
   txName               varchar(50) not null,
   txImagePath          varchar(80) comment 'Caminho da imagem.',
   txPrimaryColor       varchar(8),
   txBgPrimaryColor     varchar(8),
   txBgSecondaryColor   varchar(8),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idAbility)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: Assessment                                            */
/*==============================================================*/
create table Assessment
(
   coAssessment         varchar(2) not null,
   txAssessment         varchar(30) not null,
   nuScore              double not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   primary key (coAssessment)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: Audit                                                 */
/*==============================================================*/
create table Audit
(
   idAudit              bigint not null auto_increment,
   idUser               int,
   txTableName          varchar(50) not null,
   txKeyValues          longtext not null,
   txOldValues          longtext,
   txNewValues          longtext,
   txIpAddress          varchar(39),
   dtIserted            datetime not null,
   primary key (idAudit),
   key IX_Audit_idUser (idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: CategoryGrade                                         */
/*==============================================================*/
create table CategoryGrade
(
   idCategory           smallint not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCategory, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
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
collate utf8mb4_general_ci
;

alter table ClassShift comment 'Turno Escolar. e.g.: Matutino, Vespertino...'
;

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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ComponentType                                         */
/*==============================================================*/
create table ComponentType
(
   coComponentType      char(3) not null,
   txComponentType      varchar(30) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coComponentType)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: DiagnosticAnswer                                      */
/*==============================================================*/
create table DiagnosticAnswer
(
   idDiagnosticSurvey   int not null,
   idDiagnosticQuestion int not null,
   idLikertScale        tinyint not null,
   primary key (idDiagnosticSurvey, idDiagnosticQuestion)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: DiagnosticQuestion                                    */
/*==============================================================*/
create table DiagnosticQuestion
(
   idDiagnosticQuestion int not null auto_increment,
   txQuestion           varchar(1000) character set utf8mb4 not null,
   idAbility            smallint not null,
   inStatus             tinyint(1) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDiagnosticQuestion)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: DiagnosticQuestionGrade                               */
/*==============================================================*/
create table DiagnosticQuestionGrade
(
   idDiagnosticQuestionGrade int not null auto_increment,
   idDiagnosticQuestion int not null,
   coGrade              char(4) not null,
   primary key (idDiagnosticQuestionGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: DiagnosticSurvey                                      */
/*==============================================================*/
create table DiagnosticSurvey
(
   idDiagnosticSurvey   int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDiagnosticSurvey)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: Evidence                                              */
/*==============================================================*/
create table Evidence
(
   idEvidence           int not null auto_increment,
   txName               varchar(500) not null,
   idAbility            smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idEvidence),
   key AK_Evidence (idEvidence)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: EvidenceGrade                                         */
/*==============================================================*/
create table EvidenceGrade
(
   idEvidence           int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idEvidence, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: KeyAPI                                                */
/*==============================================================*/
create table KeyAPI
(
   idKeyAPI             smallint not null auto_increment,
   idNetwork            int not null,
   uiKeyAPI             char(36) not null,
   inStatus             tinyint(1),
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idKeyAPI)
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
   dtBirthdate          date,
   idCityPlaceOfBirth   int,
   coMaritalStatus      char(3),
   inStatus             tinyint(1) not null default 1,
   txCodeOrigin         varchar(36),
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUser),
   unique key AK_LektoUser (idNetwork, idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Index: ukNCL_LektoUser_txCodeOrigin                          */
/*==============================================================*/
create unique index ukNCL_LektoUser_txCodeOrigin on LektoUser
(
   txCodeOrigin,
   idNetwork
)
;

/*==============================================================*/
/* Index: ukNCL_Lekto_txEmail                                   */
/*==============================================================*/
create unique index ukNCL_Lekto_txEmail on LektoUser
(
   txEmail
)
;

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(300),
   txDescription        varchar(300),
   txGuidance           varchar(2000),
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson),
   key AK_Lesson (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idLessonStep         int not null,
   txTitle              varchar(150) not null,
   nuOrder              tinyint not null,
   idEvidence           int,
   idCategory           smallint not null,
   txChallenge          varchar(500) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonActivityDocumentation                           */
/*==============================================================*/
create table LessonActivityDocumentation
(
   idLessonDocumentation int not null,
   idLessonMomentActivity int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

alter table LessonActivityDocumentation comment 'Documentacao de atividade por estudante'
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
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivitySupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonComponent                                       */
/*==============================================================*/
create table LessonComponent
(
   idLesson             int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   coComponentType      char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coGrade, coComponent),
   key AK_LessonComponent (idLesson, coGrade, coComponent)
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
   txMomentNotes        longtext not null comment 'Informacoes complementares.
            ',
   IdMediaInformation   int,
   idLessonMoment       int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

alter table LessonDocumentation comment 'Informacoes complementares referentes ao grupo. 
Neste'
;

/*==============================================================*/
/* Table: LessonEvidenceDocumentation                           */
/*==============================================================*/
create table LessonEvidenceDocumentation
(
   idLessonDocumentation int not null,
   idEvidence           int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation, idEvidence)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
   idLessonMoment       int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentActivity),
   key AK_LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonMomentGroup                                     */
/*==============================================================*/
create table LessonMomentGroup
(
   idLessonMomentGroup  bigint not null auto_increment,
   idUserStudent        int not null,
   idStudent            int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonMomentActivity int not null,
   coAssessment         varchar(2),
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonSchoolSupply                                    */
/*==============================================================*/
create table LessonSchoolSupply
(
   idLessonSchoolSupply int not null auto_increment,
   idLesson             int,
   txSupply             varchar(50) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonSchoolSupply)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonStep                                            */
/*==============================================================*/
create table LessonStep
(
   idLessonStep         int not null auto_increment,
   coGrade              char(4) not null,
   idLesson             int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidance           varchar(2000) not null,
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep),
   key AK_LessonStep (idLessonStep, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonStepDocumentation                               */
/*==============================================================*/
create table LessonStepDocumentation
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
/* Table: LessonStepSupportReference                            */
/*==============================================================*/
create table LessonStepSupportReference
(
   idLessonStepSupportReference int not null auto_increment,
   idLessonStep         int not null,
   txTitle              varchar(120) not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txReference          varchar(300) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStepSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonStudentDocumentation                            */
/*==============================================================*/
create table LessonStudentDocumentation
(
   idLessonStudentDocumentation int not null auto_increment,
   idLessonDocumentation int,
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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonTrack                                           */
/*==============================================================*/
create table LessonTrack
(
   idLessonTrack        int not null auto_increment,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack),
   key AK_LessonTrack (idLessonTrack, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LessonTrackGroup                                      */
/*==============================================================*/
create table LessonTrackGroup
(
   idLessonTrackGroup   int not null auto_increment,
   idLessonTrack        int not null,
   idLesson             int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   nuOrder              smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrackGroup),
   key AK_LessonTrackGroup (idLessonTrack, idLesson, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: LikertScale                                           */
/*==============================================================*/
create table LikertScale
(
   idLikertScale        tinyint unsigned not null,
   txLikertScale        varchar(30) not null,
   nuLikertScaleScore   smallint not null,
   primary key (idLikertScale)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
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
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (IdMediaInformation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

alter table MomentStatus comment 'Tabela de situacao do momento.'
;

/*==============================================================*/
/* Table: Network                                               */
/*==============================================================*/
create table Network
(
   idNetwork            int not null,
   txName               varchar(120) not null,
   idNetworkReference   int,
   coDistrict           char(2),
   inIntegration        tinyint(1) not null default 1,
   inSingleSignOn       tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idNetwork)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

alter table NotificationSource comment 'Origem da notificacao.'
;

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
collate utf8mb4_general_ci
;

alter table NotificationType comment 'Tabela de tipos de notificacoes.'
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

/*==============================================================*/
/* Table: ProfileType                                           */
/*==============================================================*/
create table ProfileType
(
   coProfile            char(4) not null,
   txProfile            varchar(30) not null,
   inStatus             tinyint(1) not null default 1,
   coScope              varchar(20),
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (coProfile)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_Project (idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectCategory                                       */
/*==============================================================*/
create table ProjectCategory
(
   idProject            int not null,
   idCategory           smallint not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, idCategory, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idProject            int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   coComponentType      char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, coGrade, coComponent, coComponentType),
   key AK_ProjectComponent (coComponent, coGrade, idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectDocumentation                                  */
/*==============================================================*/
create table ProjectDocumentation
(
   idProjectDocumentation int not null auto_increment,
   idProjectMoment      int not null,
   txMomentNotes        longtext not null comment 'Informacoes complementares.
            ',
   IdMediaInformation   int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectEvidenceDocumentation                          */
/*==============================================================*/
create table ProjectEvidenceDocumentation
(
   idProjectEvidenceDocumentation int not null auto_increment,
   idProjectDocumentation int not null,
   idEvidence           int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectEvidenceDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
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

/*==============================================================*/
/* Table: ProjectMomentGroup                                    */
/*==============================================================*/
create table ProjectMomentGroup
(
   idProjectMomentGroup bigint not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectMomentStage int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   coAssessment         varchar(2),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectMomentOrientation                              */
/*==============================================================*/
create table ProjectMomentOrientation
(
   idProjectMomentOrientation int not null auto_increment,
   idProjectMoment      int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectMomentStage                                    */
/*==============================================================*/
create table ProjectMomentStage
(
   idProjectMomentStage int not null auto_increment,
   idProjectMoment      int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectStage       int not null,
   nuStageGroup         tinyint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStage),
   key AK_ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectMomentStageOrientation                         */
/*==============================================================*/
create table ProjectMomentStageOrientation
(
   idProjectMomentStageOrientation int not null auto_increment,
   idProjectMomentStage int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   idEvidenceFixed      int not null,
   idEvidenceVariable   int not null,
   txGuidanceBNCC       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStageDocumentation                             */
/*==============================================================*/
create table ProjectStageDocumentation
(
   idProjectDocumentation int not null,
   idProjectStage       int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage, idProjectDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStageGroup                                     */
/*==============================================================*/
create table ProjectStageGroup
(
   idProjectTrackStage  int not null,
   idProjectStage       int not null,
   primary key (idProjectTrackStage, idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStageOrientation                               */
/*==============================================================*/
create table ProjectStageOrientation
(
   idProjectStageOrientation int not null auto_increment,
   idProjectStage       int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStageSchoolSupply                              */
/*==============================================================*/
create table ProjectStageSchoolSupply
(
   idProjectStageSchoolSupply int not null auto_increment,
   idProjectStage       int,
   txSupply             varchar(50) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageSchoolSupply)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStageSupportReference                          */
/*==============================================================*/
create table ProjectStageSupportReference
(
   idProjectStageSupportReference int not null auto_increment,
   idProjectStageOrientation int,
   IdMediaInformation   int,
   coSupportReference   char(4) not null,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStudentDocumentation                           */
/*==============================================================*/
create table ProjectStudentDocumentation
(
   idProjectStudentDocumentation int not null auto_increment,
   idProjectDocumentation int,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStudentDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectTrack                                          */
/*==============================================================*/
create table ProjectTrack
(
   idProjectTrack       int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300) not null,
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack),
   key AK_ProjectTrack (idProjectTrack, coGrade, coComponent),
   key AK_ProjectTrackcoGrade (idProjectTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectTrackGroup                                     */
/*==============================================================*/
create table ProjectTrackGroup
(
   idProjectTrack       int not null,
   idProject            int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   nuOrder              smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack, idProject),
   key AK_ProjectTrackGroup (idProjectTrack, idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null,
   idProjectTrack       int not null,
   coGrade              char(4) not null,
   idEvidence           int,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   txGuidanceCode       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage, coGrade),
   key AK_ProjectTrackStagecoGrade (idProjectTrackStage, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: Relationship                                          */
/*==============================================================*/
create table Relationship
(
   idNetwork            int not null,
   idUser               int not null comment 'Usuario principal.',
   idUserBound          int not null comment 'Usuario vinculado.',
   coRelationType       char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idNetwork, idUser, idUserBound)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

alter table Relationship comment 'Tabela de relacionamento entre os usuarios.'
;

/*==============================================================*/
/* Index: ixNCL_Relationship_coRelationType                     */
/*==============================================================*/
create index ixNCL_Relationship_coRelationType on Relationship
(
   coRelationType
)
;

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
   idSubNetwork         int,
   IdMediaInfoLogo      int,
   txCodeOrigin         varchar(36),
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool),
   unique key ukNCL_School_idSchool (idSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Index: ukNCL_School_txCodeOrigin                             */
/*==============================================================*/
create unique index ukNCL_School_txCodeOrigin on School
(
   txCodeOrigin,
   idNetwork
)
;

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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
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
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: UserAddress                                           */
/*==============================================================*/
create table UserAddress
(
   idUserAddress        int not null auto_increment,
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
collate utf8mb4_general_ci
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

/*==============================================================*/
/* Table: UserProfileRegional                                   */
/*==============================================================*/
create table UserProfileRegional
(
   idUserProfileRegional int not null auto_increment,
   idUserProfile        int not null,
   idRegionalNetwork    int not null,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUserProfileRegional)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Index: ukNCL_UserProfileRegional                             */
/*==============================================================*/
create unique index ukNCL_UserProfileRegional on UserProfileRegional
(
   idRegionalNetwork
)
;

/*==============================================================*/
/* Table: UserProfileSchool                                     */
/*==============================================================*/
create table UserProfileSchool
(
   idUserProfileSchool  int not null auto_increment,
   idUserProfile        int not null,
   idNetwork            int not null,
   idSchool             int not null,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUserProfileSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Index: ukNCL_UserProfileSchool                               */
/*==============================================================*/
create unique index ukNCL_UserProfileSchool on UserProfileSchool
(
   idNetwork,
   idSchool,
   idUserProfile
)
;

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
collate utf8mb4_general_ci
;

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
collate utf8mb4_general_ci
;

alter table Ability add constraint FK_Ability_Competence foreign key (idCompetence)
      references Competence (idCompetence) on delete restrict on update restrict
;

alter table ActionLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActionLogType)
      references ActionLogType (idActionLogType)
;

alter table ActionLog add constraint FK_ActionLog_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table ActionLogType add constraint FK_ActionLogType_ActionLogGroup foreign key (idActionLogGroup)
      references ActionLogGroup (idActionLogGroup)
;

alter table CategoryGrade add constraint FK_CategoryGrade_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict
;

alter table CategoryGrade add constraint FK_CategoryGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
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

alter table DataUsage add constraint FK_DataUsage_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion) on delete restrict on update restrict
;

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticSurvey foreign key (idDiagnosticSurvey)
      references DiagnosticSurvey (idDiagnosticSurvey) on delete restrict on update restrict
;

alter table DiagnosticAnswer MODIFY column idLikertScale tinyint unsigned;

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_LikertScale foreign key (idLikertScale)
      references LikertScale (idLikertScale) on delete restrict on update restrict
;



alter table DiagnosticQuestion add constraint FK_DiagnosticQuestion_Ability foreign key (idAbility)
      references Ability (idAbility) on delete restrict on update restrict
;

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion) on delete restrict on update restrict
;

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table DiagnosticSurvey add constraint FK_DiagnosticSurvey_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Evidence add constraint FK_Evidence_Ability foreign key (idAbility)
      references Ability (idAbility) on delete restrict on update restrict
;

alter table EvidenceGrade add constraint FK_EvidenceGrade_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table EvidenceGrade add constraint FK_EvidenceGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table Grade add constraint FK_Grade_Stage foreign key (coStage)
      references Stage (coStage) on delete restrict on update restrict
;

alter table KeyAPI add constraint FK_KeyAPI_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table LektoUser add constraint FK_LektoUser_MaritalStatus foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete restrict on update restrict
;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
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

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete restrict on update restrict
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

alter table LessonComponent add constraint FK_LessonComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table LessonComponent add constraint FK_LessonComponent_ComponentType foreign key (coComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict
;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonDocumentation add constraint FK_LessonDocumentation_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idLessonMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict
;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
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

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonSchoolSupply add constraint FK_LessonSchoolSupply_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict
;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict
;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict
;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonTrack add constraint FK_LessonTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table LessonTrack add constraint FK_LessonTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonComponent foreign key (idLesson, coGrade, coComponent)
      references LessonComponent (idLesson, coGrade, coComponent) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade, coComponent)
      references LessonTrack (idLessonTrack, coGrade, coComponent) on delete restrict on update restrict
;

alter table Network add constraint FK_Network_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict
;

alter table Network add constraint FK_Network_Network foreign key (idNetworkReference)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table Notification add constraint FK_Notification_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Notification add constraint FK_Notification_NotificationSource foreign key (coNotificationSource)
      references NotificationSource (coNotificationSource) on delete restrict on update restrict
;

alter table Notification add constraint FK_Notification_NotificationType foreign key (coNotificationType)
      references NotificationType (coNotificationType) on delete restrict on update restrict
;

alter table Professor add constraint FK_Professor_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUserProfessor)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Project add constraint FK_Project_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table ProjectCategory add constraint FK_ProjectCategory_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict
;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectComponent add constraint FK_ProjectComponent_ComponentType foreign key (coComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict
;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict
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

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict
;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage) on delete restrict on update restrict
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

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_MediaInformation foreign key (IdMediaRoadmap)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict
;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict
;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectStageSchoolSupply add constraint FK_ProjectStageSchoolSupply_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_ProjectStageOrientation foreign key (idProjectStageOrientation)
      references ProjectStageOrientation (idProjectStageOrientation) on delete restrict on update restrict
;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict
;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectComponent foreign key (coComponent, coGrade, idProject)
      references ProjectComponent (coComponent, coGrade, idProject) on delete restrict on update restrict
;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (idProjectTrack, coGrade, coComponent)
      references ProjectTrack (idProjectTrack, coGrade, coComponent) on delete restrict on update restrict
;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idNetwork, idUserBound)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType) on delete restrict on update restrict
;

alter table School add constraint FK_School_MediaInformation foreign key (IdMediaInfoLogo)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table School add constraint FK_School_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table School add constraint FK_School_SubNetwork foreign key (idSubNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table SchoolAddress add constraint FK_SchoolAddress_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict
;

alter table SchoolAddress add constraint FK_SchoolAddress_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict
;

alter table SchoolGrade add constraint FK_SchoolGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table SchoolGrade add constraint FK_SchoolGrade_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict
;

alter table SchoolYear add constraint FK_SchoolYear_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
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

alter table UserAddress add constraint FK_UserAddress_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict
;

alter table UserAddress add constraint FK_UserAddress_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_ProfileType foreign key (coProfile)
      references ProfileType (coProfile) on delete restrict on update restrict
;

alter table UserProfileRegional add constraint FK_UserProfileRegional_Network foreign key (idRegionalNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table UserProfileRegional add constraint FK_UserProfileRegional_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;

alter table UserSession add constraint FK_UserSession_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserSession add constraint FK_UserSession_UserSessionOrigin foreign key (coUserSessionOrigin)
      references UserSessionOrigin (coUserSessionOrigin) on delete restrict on update restrict
;



CREATE TRIGGER `tgau_LektoUser` 
AFTER UPDATE ON LektoUser
FOR EACH ROW 
BEGIN

     IF NEW.inStatus <> OLD.inStatus
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
          , 17 # A situacao do usuario mudou para {{@p0}}
          , NEW.idNetwork
          , NEW.idUser
          , JSON_OBJECT('@p0', CASE WHEN NEW.inStatus = 1 THEN 'ativado' ELSE 'desativado' END)
          );

     END IF;

END ;



CREATE TRIGGER `tgau_LessonMoment` 
AFTER UPDATE ON LessonMoment
FOR EACH ROW 
BEGIN

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
               , 5 # Aluno tem sua turma atualizada com a definicao de horarios de aula pelo usuario {{p0}}
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

END ;


CREATE TRIGGER `tgi_SchoolYear` BEFORE INSERT ON `SchoolYear` FOR EACH ROW BEGIN
	
	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtStartPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de inicio informada ja existe em um periodo existente na tabela SchoolYear.';
	END IF;
	
	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtEndPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de termino informada pertence a um periodo existente na tabela SchoolYear.';
	END IF;	

END;
;


CREATE TRIGGER `tgu_SchoolYear` BEFORE UPDATE ON `SchoolYear` FOR EACH ROW BEGIN

	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtStartPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de inicio informada já existe em um período existente na tabela SchoolYear.';
	END IF;
	
	IF ( SELECT COUNT(1) 
		FROM SchoolYear ScYe 
		WHERE new.dtEndPeriod BETWEEN ScYe.dtStartPeriod AND ScYe.dtEndPeriod ) > 0
	THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_SchoolYear: A data de término informada pertence a um período existente na tabela SchoolYear.';
	END IF;	

END;
;



CREATE TRIGGER `tgai_Student` 
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
          , 2 # Usuario vinculado a escola {{p0}} no perfil {{p1}}
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', NEW.idSchool, '@p1', 'ALNO')
          );

END ;


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




CREATE TRIGGER `tgad_UserProfileSchool` 
AFTER DELETE ON UserProfileSchool
FOR EACH ROW 
BEGIN

     INSERT INTO ActionLog
     (
       dtAction
     , idActionLogType          
     , idNetwork
     , idUser
     , txVariables
     )
	SELECT NOW()
		, 18 # Usuarioo foi retirado da escola {{p0}} da rede {{@p1}} do perfil {{p2}}
		, UserProfile.idNetwork
		, UserProfile.idUser
		, JSON_OBJECT('@p0', OLD.idSchool, '@p1', OLD.idNetwork, '@p2', UserProfile.coProfile)
	FROM UserProfileSchool
		INNER JOIN UserProfile
			   ON UserProfile.idUserProfile = UserProfileSchool.idUserProfile
	WHERE OLD.idUserProfileSchool;

END ;

