/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/26/2023 6:55:38 PM                         */
/*==============================================================*/


alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonDocumentation;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_MediaInformation;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;

alter table LessonEvidenceDocumentation drop constraint FK_LessonEvidenceDocumentation_LessonDocumentation;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonDocumentation;

alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_LessonDocumentation;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_ProjectMomentStage;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;

alter table LessonDocumentation
   drop primary key;

drop table if exists tmp_LessonDocumentation;

rename table LessonDocumentation to tmp_LessonDocumentation;

alter table ProjectMomentGroup
modify column idProjectMomentGroup int not null first,
   drop primary key;

drop table if exists tmp_ProjectMomentGroup;

rename table ProjectMomentGroup to tmp_ProjectMomentGroup;

/*==============================================================*/
/* Table: LessonDocumentation                                   */
/*==============================================================*/
create table LessonDocumentation
(
   idLessonDocumentation int not null auto_increment,
   txMomentNotes        longtext not null comment 'Informacoes complementares.',
   IdMediaInformation   int,
   idLessonMoment       int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table LessonDocumentation comment 'Informacoes complementares referentes ao grupo.';

insert into LessonDocumentation (idLessonDocumentation, txMomentNotes, IdMediaInformation, idLessonMoment, dtInserted, dtLastUpdate)
select idLessonDocumentation, txMomentNotes, IdMediaInformation, idMoment, dtInserted, dtLastUpdate
from tmp_LessonDocumentation;

drop table if exists tmp_LessonDocumentation;

alter table LessonStudentDocumentation
   modify column idLessonDocumentation int;

/*==============================================================*/
/* Table: ProjectDocumentation                                  */
/*==============================================================*/
create table ProjectDocumentation
(
   idProjectDocumentation int not null auto_increment,
   idProjectMoment      int not null,
   txMomentNotes        longtext not null comment 'Informacoes complementares.            ',
   IdMediaInformation   int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectEvidenceDocumentation                          */
/*==============================================================*/
create table ProjectEvidenceDocumentation
(
   idProjectEvidenceDocumentation int not null auto_increment,
   idProjectDocumentation int not null,
   idEvidence           int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectEvidenceDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectMomentGroup                                    */
/*==============================================================*/
create table ProjectMomentGroup
(
   idProjectMomentGroup int not null auto_increment,
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

insert into ProjectMomentGroup (idProjectMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage, idUserStudent, idStudent, dtInserted, dtLastUpdate)
select idProjectMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage, idUserStudent, idStudent, dtInserted, dtLastUpdate
from tmp_ProjectMomentGroup;

drop table if exists tmp_ProjectMomentGroup;

/*==============================================================*/
/* Table: ProjectStudentDocumentation                           */
/*==============================================================*/
create table ProjectStudentDocumentation
(
   idProjectStudentDocumentation int not null auto_increment,
   idProjectDocumentation int,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStudentDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjetStageDocumentation                              */
/*==============================================================*/
create table ProjetStageDocumentation
(
   idProjectDocumentation int not null,
   idProjectStage       int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage, idProjectDocumentation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonDocumentation add constraint FK_LessonDocumentation_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idLessonMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict;

alter table ProjetStageDocumentation add constraint FK_ProjetStageDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict;

alter table ProjetStageDocumentation add constraint FK_ProjetStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

