/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/19/2023 11:03:10 PM                        */
/*==============================================================*/


alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonDocumentation;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;

alter table LessonMoment drop constraint FK_LessonMoment_Class;

alter table LessonMoment drop constraint FK_LessonMoment_ClassTrack;

alter table LessonMoment drop constraint FK_LessonMoment_MomentStatus;

alter table LessonMoment drop constraint FK_LessonMoment_Professor;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;

alter table LessonActivityDocumentation
   drop primary key;

drop table if exists tmp_LessonActivityDocumentation;

rename table LessonActivityDocumentation to tmp_LessonActivityDocumentation;

alter table LessonMoment MODIFY COLUMN `idLessonMoment` int NOT NULL AFTER `idClass`,
   drop primary key;

drop table if exists tmp_LessonMoment;

rename table LessonMoment to tmp_LessonMoment;

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
collate utf8mb4_general_ci;

alter table LessonActivityDocumentation comment 'Documentacao de atividade por estudante';

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonActivityDocumentation (idLessonDocumentation, idLessonMomentActivity, dtInserted, dtLastUpdate)
select idDocumentation, ?, dtInserted, dtLastUpdate
from tmp_LessonActivityDocumentation;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonActivityDocumentation;
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
   dtStartSchedule      time not null comment 'Hora de inicio.',
   dtEndSchedule        time not null,
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

insert into LessonMoment (idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_LessonMoment;

drop table if exists tmp_LessonMoment;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete restrict on update restrict;

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

