/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/25/2023 11:47:04 AM                        */
/*==============================================================*/


alter table ActionLogType drop constraint FK_ActivityLogType_ActivityLogGroup;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;

alter table LessonMoment drop constraint FK_LessonMoment_Class;

alter table LessonMoment drop constraint FK_LessonMoment_ClassTrack;

alter table LessonMoment drop constraint FK_LessonMoment_MomentStatus;

alter table LessonMoment drop constraint FK_LessonMoment_Professor;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectSchedule;

alter table ProjectSchedule drop constraint FK_ProjectSchedule_Class;

alter table ProjectSchedule drop constraint FK_ProjectSchedule_Professor;

alter table ProjectSchedule drop constraint FK_ProjectSchedule_ProjectTrack;

alter table LessonMoment
modify column idLessonMoment int not null first,
   drop primary key;

drop table if exists tmp_LessonMoment;

rename table LessonMoment to tmp_LessonMoment;

alter table ProjectSchedule
   drop primary key;

drop table if exists tmp_ProjectSchedule;

rename table ProjectSchedule to tmp_ProjectSchedule;

/*==============================================================*/
/* Index: ukNCL_LektoUser_txCodeOrigin                          */
/*==============================================================*/
create unique index ukNCL_LektoUser_txCodeOrigin on LektoUser
(
   txCodeOrigin,
   idNetwork
);

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
   idClassTrack         int,
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
collate utf8mb4_general_ci;

insert into LessonMoment (idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtStartSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_LessonMoment;

drop table if exists tmp_LessonMoment;

/*==============================================================*/
/* Table: ProjectSchedule                                       */
/*==============================================================*/
create table ProjectSchedule
(
   idProjectSchedule    int not null auto_increment,
   idProjectTrack       int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectSchedule),
   key AK_ProjectSchedule (idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectSchedule (idProjectSchedule, idProjectTrack, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, dtSchedule, dtProcessed, dtInserted, dtLastUpdate)
select idProjectSchedule, idProjectTrack, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, dtStartSchedule, dtProcessed, dtInserted, dtLastUpdate
from tmp_ProjectSchedule;

drop table if exists tmp_ProjectSchedule;

/*==============================================================*/
/* Index: ukNCL_School_txCodeOrigin                             */
/*==============================================================*/
create unique index ukNCL_School_txCodeOrigin on School
(
   txCodeOrigin,
   idNetwork
);

alter table ActionLogType add constraint FK_ActionLogType_ActionLogGroup foreign key (idActionLogGroup)
      references ActionLogGroup (idActionLogGroup);

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_ClassTrack foreign key (idClassTrack, coGrade)
      references ClassTrack (idClassTrack, coGrade) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectSchedule foreign key (idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectSchedule (idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table ProjectSchedule add constraint FK_ProjectSchedule_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table ProjectSchedule add constraint FK_ProjectSchedule_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table ProjectSchedule add constraint FK_ProjectSchedule_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict;

