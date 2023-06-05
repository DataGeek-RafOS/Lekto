/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/30/2023 4:00:18 PM                         */
/*==============================================================*/


alter table idLessonMomentGroup drop constraint FK_idLessonMomentGroup_Assessment;

alter table idLessonMomentGroup drop constraint FK_idLessonMomentGroup_LessonMomentActivity;

alter table idLessonMomentGroup drop constraint FK_idLessonMomentGroup_StudentClass;

desc idLessonMomentGroup 

alter table idLessonMomentGroup modify column LessonMomentGroup bigint not null first,
   drop primary key;

drop table if exists tmp_idLessonMomentGroup;

rename table idLessonMomentGroup to tmp_idLessonMomentGroup;

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
   coAssessment         varchar(2),
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonMomentGroup (idLessonMomentGroup, idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select LessonMomentGroup, idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coAssessment, dtAssessment, dtInserted, dtLastUpdate
from tmp_idLessonMomentGroup;

drop table if exists tmp_idLessonMomentGroup;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

