/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/28/2023 11:18:55 AM                        */
/*==============================================================*/


alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_Assessment;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_Assessment;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_ProjectMomentStage;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;

alter table LessonMomentGroup
modify column idLessonMomentGroup int not null first,
   drop primary key;

drop table if exists tmp_LessonMomentGroup;

rename table LessonMomentGroup to tmp_LessonMomentGroup;

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
   idLessonMomentGroup  bigint not null auto_increment,
   idUserStudent        int not null,
   idStudent            int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonMomentActivity int not null,
   coAssessment         varchar(2) default 'NO',
   dtAssessment         datetime,
   InAttendance         tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonMomentGroup (idLessonMomentGroup, idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select idLessonMomentGroup, idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, coAssessment, dtAssessment, dtInserted, dtLastUpdate
from tmp_LessonMomentGroup;

drop table if exists tmp_LessonMomentGroup;

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
   coAssessment         varchar(2) default 'NO',
   dtAssessment         datetime,
   InAttendance         tinyint(1) not null default 1,
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

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

