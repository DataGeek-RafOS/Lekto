/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/30/2023 6:36:26 PM                         */
/*==============================================================*/


alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonMomentActivity;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_Assessment;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;

alter table LessonMomentActivity
modify column idLessonMomentActivity int not null first,
   drop primary key;

drop table if exists tmp_LessonMomentActivity;

rename table LessonMomentActivity to tmp_LessonMomentActivity;

alter table LessonMomentGroup
modify column idLessonMomentGroup int not null first,
drop primary key;

drop table if exists tmp_LessonMomentGroup;

rename table LessonMomentGroup to tmp_LessonMomentGroup;

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
collate utf8mb4_general_ci;

insert into LessonMomentActivity (idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, dtInserted, dtLastUpdate)
select idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, dtInserted, dtLastUpdate
from tmp_LessonMomentActivity;

drop table if exists tmp_LessonMomentActivity;

/*==============================================================*/
/* Table: LessonMomentGroup                                     */
/*==============================================================*/
create table LessonMomentGroup
(
   idLessonMomentGroup  bigint not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonMomentActivity int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   coAssessment         varchar(2),
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonMomentGroup (idLessonMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, idUserStudent, idStudent, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select idLessonMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, 1, idUserStudent, idStudent, coAssessment, dtAssessment, dtInserted, dtLastUpdate
from tmp_LessonMomentGroup;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonMomentGroup;
alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

