/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     12/27/2022 11:52:07 AM                       */
/*==============================================================*/


/*==============================================================*/
/* Table: ActivityLog                                           */
/*==============================================================*/
create table ActivityLog
(
   idActivityLog        bigint not null auto_increment,
   dtActivity           datetime not null,
   idUser               int not null,
   idActivityLogType    int not null,
   txVariables          varchar(200),
   primary key (idActivityLog, dtActivity)
)
default character set utf8mb4
collate utf8mb4_general_ci;


/*==============================================================*/
/* Index: ixNCL_ActivityLog_idUser                              */
/*==============================================================*/
create index ixNCL_ActivityLog_idUser on ActivityLog
(
   idUser
)
;

/*==============================================================*/
/* Table: ActivityLogGroup                                      */
/*==============================================================*/
create table ActivityLogGroup
(
   idActivityLogGroup   tinyint not null,
   txName               varchar(150),
   dtInserted           datetime not null,
   primary key (idActivityLogGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ActivityLogType                                       */
/*==============================================================*/
create table ActivityLogType
(
   idActivityLogType    int not null auto_increment,
   txAction             varchar(200) not null,
   idActivityLogGroup   tinyint not null,
   dtInserted           datetime not null,
   primary key (idActivityLogType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ActivityLogVariables                                  */
/*==============================================================*/
create table ActivityLogVariables
(
   idActivityLogVariables int not null auto_increment,
   idActivityLogType    int,
   inPosition           tinyint not null comment 'Posicao da variavel no texto.',
   txField              char(10) comment 'Campo do banco de dados aonde a informacao se encontra.',
   dtInserted           datetime not null,
   primary key (idActivityLogVariables)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Index: ixNCL_ActivityLogVariables_idActivityLogType          */
/*==============================================================*/
create index ixNCL_ActivityLogVariables_idActivityLogType on ActivityLogVariables
(
   idActivityLogType
);

alter table ActivityLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActivityLogType)
      references ActivityLogType (idActivityLogType);

alter table ActivityLog add constraint FK_ActivityLog_LektoUser foreign key (idUser)
      references LektoUser (idUser);

alter table ActivityLogType add constraint FK_ActivityLogType_ActivityLogGroup foreign key (idActivityLogGroup)
      references ActivityLogGroup (idActivityLogGroup);

alter table ActivityLogVariables add constraint FK_ActivityLogVariables_ActivityLogType foreign key (idActivityLogType)
      references ActivityLogType (idActivityLogType);

