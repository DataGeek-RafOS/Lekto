/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/7/2023 8:10:29 PM                          */
/*==============================================================*/


alter table LessonSupportReference drop constraint FK_LessonSupportReference_Lesson;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_MediaInformation;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_SupportReferenceType;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStage drop constraint FK_ProjectStage__ProjectTrackStage;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table LessonSupportReference
modify column idLessonSupportReference int not null first,
   drop primary key;

drop table if exists tmp_LessonSupportReference;

rename table LessonSupportReference to tmp_LessonSupportReference;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

/*==============================================================*/
/* Table: LessonSchoolSupply                                    */
/*==============================================================*/
create table LessonSchoolSupply
(
   idLessonSchoolSupply int not null auto_increment,
   idLesson             int,
   txSupply             varchar(50) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonSchoolSupply)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into LessonSchoolSupply (idLessonSchoolSupply, idLesson, txSupply, txQuantity, dtInserted, dtLastUpdate)
select idLessonSupportReference, idLesson, '', txQuantity, dtInserted, dtLastUpdate
from tmp_LessonSupportReference;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_LessonSupportReference;
/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4) not null,
   idProjectTrackStage  int not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   idEvidenceFixed      int not null,
   idEvidenceVariable   int not null,
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   txGuidanceBNCC       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectStage (idProjectStage, idProject, coGrade, idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectStage, idProject, coGrade, idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectStage;

drop table if exists tmp_ProjectStage;

/*==============================================================*/
/* Table: ProjectStageSchoolSupply                              */
/*==============================================================*/
create table ProjectStageSchoolSupply
(
   idProjectStageSchoolSupply int not null auto_increment,
   idProjectStage       int,
   txSupply             varchar(50) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageSchoolSupply)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table LessonSchoolSupply add constraint FK_LessonSchoolSupply_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_MediaInformation foreign key (IdMediaRoadmap)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_ProjectTrackStage foreign key (idProjectTrackStage, coGrade, idEvidenceFixed)
      references ProjectTrackStage (idProjectTrackStage, coGrade, idEvidenceFixed) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSchoolSupply add constraint FK_ProjectStageSchoolSupply_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

