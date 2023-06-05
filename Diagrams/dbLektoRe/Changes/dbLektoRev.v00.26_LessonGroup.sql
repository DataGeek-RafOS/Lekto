/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/30/2023 3:30:49 PM                         */
/*==============================================================*/


alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_Assessment;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_StudentClass;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_Assessment;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_ProjectMomentStage;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;

alter table LessonMomentActivity
   drop column dtAssessment;

alter table LessonMomentActivity
   drop column coAssessment;

alter table LessonMomentActivity
   drop column idStudent;

alter table LessonMomentActivity
   drop column idUserStudent;

alter table ProjectMomentGroup
modify column idProjectMomentGroup int not null first,
   drop primary key;

drop table if exists tmp_ProjectMomentGroup;

rename table ProjectMomentGroup to tmp_ProjectMomentGroup;

/*==============================================================*/
/* Table: LessonMomentGroup                                     */
/*==============================================================*/
create table LessonMomentGroup
(
   LessonMomentGroup    bigint not null auto_increment,
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
   primary key (LessonMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

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
collate utf8mb4_general_ci;

insert into ProjectMomentGroup (idProjectMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage, idUserStudent, idStudent, coAssessment, dtInserted, dtLastUpdate)
select idProjectMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage, idUserStudent, idStudent, coAssessment, dtInserted, dtLastUpdate
from tmp_ProjectMomentGroup;

drop table if exists tmp_ProjectMomentGroup;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

