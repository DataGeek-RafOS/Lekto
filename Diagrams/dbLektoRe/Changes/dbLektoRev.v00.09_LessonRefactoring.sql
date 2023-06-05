/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/19/2023 10:57:44 PM                        */
/*==============================================================*/


alter table LessonDocumentation drop constraint FK_LessonDocumentation_MomentLesson;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_Assessment;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_MomentLesson;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_StudentClass;

alter table MomentLesson drop constraint FK_MomentLesson_Class;

alter table MomentLesson drop constraint FK_MomentLesson_ClassTrack;

alter table MomentLesson drop constraint FK_MomentLesson_MomentStatus;

alter table MomentLesson drop constraint FK_MomentLesson_Professor;

alter table LessonMomentActivity MODIFY COLUMN `idLessonMomentActivity` int NOT NULL FIRST,
   drop primary key;

drop table if exists tmp_LessonMomentActivity;

rename table LessonMomentActivity to tmp_LessonMomentActivity;

alter table MomentLesson MODIFY COLUMN `idMomentLesson` int NOT NULL AFTER `idClass`,
   drop primary key;

drop table if exists tmp_MomentLesson;

rename table MomentLesson to tmp_MomentLesson;

/*==============================================================*/
/* Table: LessonMoment                                          */
/*==============================================================*/
create table LessonMoment
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonMoment       int not null auto_increment,
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

insert into LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMomentLesson, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_MomentLesson;

drop table if exists tmp_MomentLesson;

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
   idUserStudent        int,
   idStudent            int,
   coAssessment         varchar(2),
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentActivity),
   key AK_LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonMomentActivity (idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, idUserStudent, idStudent, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idMoment, idUserStudent, idStudent, coAssessment, dtAssessment, dtInserted, dtLastUpdate
from tmp_LessonMomentActivity;

drop table if exists tmp_LessonMomentActivity;

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

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

