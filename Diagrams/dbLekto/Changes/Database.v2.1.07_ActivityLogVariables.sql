/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     12/29/2022 5:45:19 PM                        */
/*==============================================================*/


drop table if exists tmp_ActivityLog;

rename table ActivityLog to tmp_ActivityLog;

drop table if exists tmp_ActivityLogType;

rename table ActivityLogType to tmp_ActivityLogType;

drop table if exists ActivityLogVariables;

/*==============================================================*/
/* Table: ActivityLog                                           */
/*==============================================================*/
create table ActivityLog
(
   idActivityLog        bigint not null auto_increment,
   dtActivity           datetime not null,
   idUser               int not null,
   idActivityLogType    int not null,
   txVariables          json,
   primary key (idActivityLog, dtActivity)
);

#WARNING: The following insert order will not restore columns: txVariables
insert into ActivityLog (idActivityLog, dtActivity, idUser, idActivityLogType)
select idActivityLog, dtActivity, idUser, idActivityLogType
from tmp_ActivityLog;

#WARNING: Drop cancelled because columns cannot be restored: txVariables
#drop table if exists tmp_ActivityLog;
/*==============================================================*/
/* Index: ixNCL_ActivityLog_idUser                              */
/*==============================================================*/
create index ixNCL_ActivityLog_idUser on ActivityLog
(
   idUser
);

/*==============================================================*/
/* Table: ActivityLogType                                       */
/*==============================================================*/
create table ActivityLogType
(
   idActivityLogType    int not null,
   txAction             varchar(200) not null,
   idActivityLogGroup   tinyint not null,
   dtInserted           datetime not null,
   primary key (idActivityLogType)
);

insert into ActivityLogType (idActivityLogType, txAction, idActivityLogGroup, dtInserted)
select idActivityLogType, txAction, idActivityLogGroup, dtInserted
from tmp_ActivityLogType;

drop table if exists tmp_ActivityLogType;

alter table ActivityLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActivityLogType)
      references ActivityLogType (idActivityLogType);

alter table ActivityLog add constraint FK_ActivityLog_LektoUser foreign key (idUser)
      references LektoUser (idUser);

alter table ActivityLogType add constraint FK_ActivityLogType_ActivityLogGroup foreign key (idActivityLogGroup)
      references ActivityLogGroup (idActivityLogGroup);

