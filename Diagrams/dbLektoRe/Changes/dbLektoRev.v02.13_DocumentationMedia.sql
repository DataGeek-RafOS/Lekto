/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/28/2023 3:59:03 PM                         */
/*==============================================================*/


alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonDocumentation;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectDocumentation;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table LessonStepDocumentation
   drop primary key;

drop table if exists tmp_LessonStepDocumentation;

rename table LessonStepDocumentation to tmp_LessonStepDocumentation;

alter table ProjectStageDocumentation
   drop primary key;

drop table if exists tmp_ProjectStageDocumentation;

rename table ProjectStageDocumentation to tmp_ProjectStageDocumentation;

drop index ukNCL_idStudent_idClass on StudentClass;

/*==============================================================*/
/* Table: LessonStepDocumentation                               */
/*==============================================================*/
create table LessonStepDocumentation
(
   idLessonStepDocumentation int not null auto_increment,
   idDocumentation      int not null,
   idLessonStep         int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStepDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonStepDocumentation (idDocumentation, idLessonStep, coGrade, dtInserted, dtLastUpdate)
select idDocumentation, idLessonStep, coGrade, dtInserted, dtLastUpdate
from tmp_LessonStepDocumentation;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonStepDocumentation;
/*==============================================================*/
/* Table: LessonStepDocumentationMedia                          */
/*==============================================================*/
create table LessonStepDocumentationMedia
(
   idLessonStepDocumentationMedia int not null auto_increment,
   idLessonStepDocumentation int not null,
   IdMediaInformation   int not null,
   dtInserted           datetime not null default NOW(),
   dtLastUpdate         datetime,
   primary key (idLessonStepDocumentationMedia)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectStageDocumentation                             */
/*==============================================================*/
create table ProjectStageDocumentation
(
   idProjectStageDocumentation int not null auto_increment,
   idProjectDocumentation int not null,
   idProjectStage       int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStageDocumentation (idProjectDocumentation, idProjectStage, dtInserted, dtLastUpdate)
select idProjectDocumentation, idProjectStage, dtInserted, dtLastUpdate
from tmp_ProjectStageDocumentation;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectStageDocumentation;
/*==============================================================*/
/* Table: ProjectStageDocumentationMedia                        */
/*==============================================================*/
create table ProjectStageDocumentationMedia
(
   ProjectStageDocumentationMedia int not null auto_increment,
   idProjectStageDocumentation int not null,
   IdMediaInformation   int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (ProjectStageDocumentationMedia)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Index: ukNCL_Student                                         */
/*==============================================================*/
create unique index ukNCL_Student on Student
(
   idNetwork,
   idSchool,
   coGrade,
   idUserStudent
);

/*==============================================================*/
/* Index: ukNCL_idStudent_idClass                               */
/*==============================================================*/
create unique index ukNCL_idStudent_idClass on StudentClass
(
   idNetwork,
   idSchool,
   coGrade,
   idSchoolYear,
   idUserStudent,
   idClass
);

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepDocumentationMedia add constraint FK_LessonStepDocumentationMedia_LessonStepDocumentation foreign key (idLessonStepDocumentation)
      references LessonStepDocumentation (idLessonStepDocumentation) on delete restrict on update restrict;

alter table LessonStepDocumentationMedia add constraint FK_LessonStepDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageDocumentationMedia add constraint FK_ProjectStageDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStageDocumentationMedia add constraint FK_ProjectStageDocumentationMedia_ProjectStageDocumentation foreign key (idProjectStageDocumentation)
      references ProjectStageDocumentation (idProjectStageDocumentation) on delete restrict on update restrict;

