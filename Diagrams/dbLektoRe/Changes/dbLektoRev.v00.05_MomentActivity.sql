/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/16/2023 5:30:51 PM                         */
/*==============================================================*/


alter table StudentLesson drop constraint FK_StudentLesson_Lesson;

alter table StudentLesson drop constraint FK_StudentLesson_Moment;

alter table StudentLesson drop constraint FK_StudentLesson_StudentClass;

alter table StudentLesson
   modify column `idStudentLesson` int not null first,
   drop primary key;

drop table if exists tmp_StudentLesson;

rename table StudentLesson to tmp_StudentLesson;

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
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: MomentActivity                                        */
/*==============================================================*/
create table MomentActivity
(
   idMomentActivity     int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   idMoment             int not null,
   idActivity           int not null,
   coAssessment         varchar(2),
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idMomentActivity)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into MomentActivity (idMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, idMoment, idActivity, dtInserted, dtLastUpdate)
select idStudentLesson, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, idMoment, ?, dtInserted, dtLastUpdate
from tmp_StudentLesson;

drop table if exists tmp_StudentLesson;

alter table MomentActivity add constraint FK_MomentActivity_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table MomentActivity add constraint FK_MomentActivity_Activity foreign key (idActivity, coGrade)
      references Activity (idActivity, coGrade) on delete restrict on update restrict;

alter table MomentActivity add constraint FK_MomentActivity_Moment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment)
      references Moment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment) on delete restrict on update restrict;

alter table MomentActivity add constraint FK_MomentActivity_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;
	 
ALTER TABLE `dbLektoRev`.`Evidence` 
CHANGE COLUMN `idAbiliity` `idAbility` smallint NOT NULL AFTER `txName`;	 

