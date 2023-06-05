/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/10/2023 4:43:47 PM                         */
/*==============================================================*/


alter table Lesson drop constraint FK_Lesson_Grade;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;

alter table LessonActivity drop constraint FK_LessonActivity_CategoryGrade;

alter table LessonActivity drop constraint FK_LessonActivity_EvidenceGrade;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_LessonActivityOrientation;

alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_MediaInformation;

alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_SupportReferenceType;

alter table LessonComponent drop constraint FK_LessonComponent_Lesson;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table LessonSchoolSupply drop constraint FK_LessonSchoolSupply_Lesson;

alter table LessonStep drop constraint FK_LessonStep_Lesson;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_LessonStep;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_LessonStep;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_MediaInformation;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_SupportReferenceType;

alter table LessonTrack drop constraint FK_LessonTrack_Component;

alter table LessonTrack drop constraint FK_LessonTrack_Grade;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;

alter table Project drop constraint FK_Project_Grade;

alter table ProjectCategory drop constraint FK_ProjectCategory_Project;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;

alter table ProjectMomentOrientation drop constraint FK_ProjectMomentOrientation_ProjectMoment;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectMomentStageOrientation drop constraint FK_ProjectMomentStageOrientation_ProjectMomentStage;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;

alter table ProjectStage drop constraint FK_ProjectStage_MediaInformation;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectTrackStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table ProjectStageSchoolSupply drop constraint FK_ProjectStageSchoolSupply_ProjectStage;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_MediaInformation;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_ProjectStageOrientation;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_SupportReferenceType;

alter table ProjectTrack drop constraint FK_ProjectTrack_Component;

alter table ProjectTrack drop constraint FK_ProjectTrack_Grade;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectTrack;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_EvidenceGrade;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_ProjectTrack;

alter table Lesson
modify column idLesson int not null first,
   drop primary key;

drop table if exists tmp_Lesson;

rename table Lesson to tmp_Lesson;

alter table LessonActivity
modify column idLessonActivity int not null first,
   drop primary key;

drop table if exists tmp_LessonActivity;

rename table LessonActivity to tmp_LessonActivity;

alter table LessonActivityOrientation
modify column idLessonActivityOrientation int not null first,
   drop primary key;

drop table if exists tmp_LessonActivityOrientation;

rename table LessonActivityOrientation to tmp_LessonActivityOrientation;

alter table LessonActivitySupportReference
modify column idLessonActivitySupportReference int not null first,
   drop primary key;

drop table if exists tmp_LessonActivitySupportReference;

rename table LessonActivitySupportReference to tmp_LessonActivitySupportReference;

alter table LessonStep
modify column idLessonStep int not null first,
   drop primary key;

drop table if exists tmp_LessonStep;

rename table LessonStep to tmp_LessonStep;

alter table LessonStepSupportReference
modify column idLessonStepSupportReference int not null first,
   drop primary key;

drop table if exists tmp_LessonStepSupportReference;

rename table LessonStepSupportReference to tmp_LessonStepSupportReference;

alter table LessonTrack
modify column idLessonTrack int not null first,
   drop primary key;

drop table if exists tmp_LessonTrack;

rename table LessonTrack to tmp_LessonTrack;

alter table Project
modify column idProject int not null first,
   drop primary key;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

alter table ProjectMomentOrientation
modify column idProjectMomentOrientation int not null first,
   drop primary key;

drop table if exists tmp_ProjectMomentOrientation;

rename table ProjectMomentOrientation to tmp_ProjectMomentOrientation;

alter table ProjectMomentStageOrientation
modify column idProjectMomentStageOrientation int not null first,
   drop primary key;

drop table if exists tmp_ProjectMomentStageOrientation;

rename table ProjectMomentStageOrientation to tmp_ProjectMomentStageOrientation;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

alter table ProjectStageOrientation
modify column idProjectStageOrientation int not null first,
   drop primary key;

drop table if exists tmp_ProjectStageOrientation;

rename table ProjectStageOrientation to tmp_ProjectStageOrientation;

alter table ProjectStageSupportReference
modify column idProjectStageSupportReference int not null first,
   drop primary key;

drop table if exists tmp_ProjectStageSupportReference;

rename table ProjectStageSupportReference to tmp_ProjectStageSupportReference;

alter table ProjectTrack
modify column idProjectTrack int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrack;

rename table ProjectTrack to tmp_ProjectTrack;

alter table ProjectTrackStage
modify column idProjectTrackStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrackStage;

rename table ProjectTrackStage to tmp_ProjectTrackStage;

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(2000),
   txDescription        text,
   txGuidance           text,
   txGuidanceBNCC       text not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson),
   key AK_Lesson (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle, txDescription

insert into Lesson (idLesson, coGrade, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate, txDescription)
select idLesson, coGrade, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate, txDescription
from tmp_Lesson;

#WARNING: Drop cancelled because columns cannot be restored: txTitle, txDescription
#drop table if exists tmp_Lesson;
/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idLessonStep         int not null,
   txTitle              varchar(2000) not null,
   nuOrder              tinyint not null,
   idEvidence           int,
   idCategory           smallint  null,
   txChallenge          text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into LessonActivity (idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate)
select idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate
from tmp_LessonActivity;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
drop table if exists tmp_LessonActivity;
/*==============================================================*/
/* Table: LessonActivityOrientation                             */
/*==============================================================*/
create table LessonActivityOrientation
(
   idLessonActivityOrientation int not null auto_increment,
   idLessonActivity     int not null,
   coGrade              char(4) not null,
   txTitle              varchar(2000) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivityOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into LessonActivityOrientation (idLessonActivityOrientation, idLessonActivity, coGrade, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idLessonActivityOrientation, idLessonActivity, coGrade, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_LessonActivityOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
drop table if exists tmp_LessonActivityOrientation;
/*==============================================================*/
/* Table: LessonActivitySupportReference                        */
/*==============================================================*/
create table LessonActivitySupportReference
(
   idLessonActivitySupportReference int not null auto_increment,
   idLessonActivityOrientation int not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txTitle              varchar(2000) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivitySupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into LessonActivitySupportReference (idLessonActivitySupportReference, idLessonActivityOrientation, coSupportReference, IdMediaInformation, txTitle, txReferenceNumber, txReference, txQuantity, dtInserted, dtLastUpdate)
select idLessonActivitySupportReference, idLessonActivityOrientation, coSupportReference, IdMediaInformation, txTitle, txReferenceNumber, txReference, txQuantity, dtInserted, dtLastUpdate
from tmp_LessonActivitySupportReference;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_LessonActivitySupportReference;
/*==============================================================*/
/* Table: LessonStep                                            */
/*==============================================================*/
create table LessonStep
(
   idLessonStep         int not null auto_increment,
   coGrade              char(4) not null,
   idLesson             int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(2000) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidance           text not null,
   txGuidanceBNCC       text not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep),
   key AK_LessonStep (idLessonStep, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into LessonStep (idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonStep;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_LessonStep;
/*==============================================================*/
/* Table: LessonStepSupportReference                            */
/*==============================================================*/
create table LessonStepSupportReference
(
   idLessonStepSupportReference int not null auto_increment,
   idLessonStep         int not null,
   txTitle              varchar(2000) not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txReference          varchar(300) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStepSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into LessonStepSupportReference (idLessonStepSupportReference, idLessonStep, txTitle, coSupportReference, IdMediaInformation, txReference, txReferenceNumber, txQuantity, dtInserted, dtLastUpdate)
select idLessonStepSupportReference, idLessonStep, txTitle, coSupportReference, IdMediaInformation, txReference, txReferenceNumber, txQuantity, dtInserted, dtLastUpdate
from tmp_LessonStepSupportReference;



#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_LessonStepSupportReference;
/*==============================================================*/
/* Table: LessonTrack                                           */
/*==============================================================*/
create table LessonTrack
(
   idLessonTrack        int not null auto_increment,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   txTitle              varchar(2000) not null,
   txDescription        text,
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack),
   key AK_LessonTrack (idLessonTrack, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle, txDescription

insert into LessonTrack (idLessonTrack, coGrade, coComponent, txTitle, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonTrack, coGrade, coComponent, txTitle, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonTrack;

#WARNING: Drop cancelled because columns cannot be restored: txTitle, txDescription
#drop table if exists tmp_LessonTrack;
/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(2000) not null,
   txDescription        text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_Project (idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle, txDescription
insert into Project (idProject, coGrade, txTitle, dtInserted, dtLastUpdate, txDescription)
select idProject, coGrade, txTitle, dtInserted, dtLastUpdate, txDescription
from tmp_Project;

#WARNING: Drop cancelled because columns cannot be restored: txTitle, txDescription
#drop table if exists tmp_Project;
/*==============================================================*/
/* Table: ProjectMomentOrientation                              */
/*==============================================================*/
create table ProjectMomentOrientation
(
   idProjectMomentOrientation int not null auto_increment,
   idProjectMoment      int not null,
   txTitle              varchar(2000) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into ProjectMomentOrientation (idProjectMomentOrientation, idProjectMoment, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idProjectMomentOrientation, idProjectMoment, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_ProjectMomentOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_ProjectMomentOrientation;
/*==============================================================*/
/* Table: ProjectMomentStageOrientation                         */
/*==============================================================*/
create table ProjectMomentStageOrientation
(
   idProjectMomentStageOrientation int not null auto_increment,
   idProjectMomentStage int not null,
   txTitle              varchar(2000) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into ProjectMomentStageOrientation (idProjectMomentStageOrientation, idProjectMomentStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idProjectMomentStageOrientation, idProjectMomentStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_ProjectMomentStageOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_ProjectMomentStageOrientation;
/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4) not null,
   txTitle              varchar(2000) not null,
   txDescription        text,
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   idEvidenceFixed      int not null,
   idEvidenceVariable   int not null,
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle, txDescription
insert into ProjectStage (idProjectStage, idProject, coGrade, txTitle, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, txGuidanceBNCC, dtInserted, dtLastUpdate, txDescription)
select idProjectStage, idProject, coGrade, txTitle, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, txGuidanceBNCC, dtInserted, dtLastUpdate, txDescription
from tmp_ProjectStage;

#WARNING: Drop cancelled because columns cannot be restored: txTitle, txDescription
#drop table if exists tmp_ProjectStage;
/*==============================================================*/
/* Table: ProjectStageOrientation                               */
/*==============================================================*/
create table ProjectStageOrientation
(
   idProjectStageOrientation int not null auto_increment,
   idProjectStage       int not null,
   txTitle              varchar(2000) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into ProjectStageOrientation (idProjectStageOrientation, idProjectStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idProjectStageOrientation, idProjectStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_ProjectStageOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_ProjectStageOrientation;
/*==============================================================*/
/* Table: ProjectStageSupportReference                          */
/*==============================================================*/
create table ProjectStageSupportReference
(
   idProjectStageSupportReference int not null auto_increment,
   idProjectStageOrientation int,
   IdMediaInformation   int,
   coSupportReference   char(4) not null,
   txTitle              varchar(2000) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle
insert into ProjectStageSupportReference (idProjectStageSupportReference, idProjectStageOrientation, IdMediaInformation, coSupportReference, txTitle, txReferenceNumber, txReference, txQuantity, dtInserted, dtLastUpdate)
select idProjectStageSupportReference, idProjectStageOrientation, IdMediaInformation, coSupportReference, txTitle, txReferenceNumber, txReference, txQuantity, dtInserted, dtLastUpdate
from tmp_ProjectStageSupportReference;

#WARNING: Drop cancelled because columns cannot be restored: txTitle
#drop table if exists tmp_ProjectStageSupportReference;
/*==============================================================*/
/* Table: ProjectTrack                                          */
/*==============================================================*/
create table ProjectTrack
(
   idProjectTrack       int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(2000) not null,
   txDescription        text not null,
   coComponent          char(3) not null,
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack),
   key AK_ProjectTrack (idProjectTrack, coGrade, coComponent),
   key AK_ProjectTrackcoGrade (idProjectTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txTitle, txDescription
insert into ProjectTrack (idProjectTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectTrack;

#WARNING: Drop cancelled because columns cannot be restored: txTitle, txDescription
#drop table if exists tmp_ProjectTrack;
/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null auto_increment,
   idProjectTrack       int not null,
   coGrade              char(4) not null,
   idEvidence           int,
   txDescription        text,
   nuOrder              tinyint not null,
   txGuidanceCode       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage, coGrade),
   key AK_ProjectTrackStagecoGrade (idProjectTrackStage, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txDescription
insert into ProjectTrackStage (idProjectTrackStage, idProjectTrack, coGrade, idEvidence, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate, txDescription)
select idProjectTrackStage, idProjectTrack, coGrade, idEvidence, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate, txDescription
from tmp_ProjectTrackStage;

#WARNING: Drop cancelled because columns cannot be restored: txDescription
#drop table if exists tmp_ProjectTrackStage;
alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 
select idLessonActivity, coGrade from LessonActivityOrientation;	 
select idLessonActivity, coGrade from LessonActivity;


alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_LessonActivityOrientation foreign key (idLessonActivityOrientation)
      references LessonActivityOrientation (idLessonActivityOrientation) on delete restrict on update restrict;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonSchoolSupply add constraint FK_LessonSchoolSupply_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table LessonTrack add constraint FK_LessonTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonTrack add constraint FK_LessonTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade, coComponent)
      references LessonTrack (idLessonTrack, coGrade, coComponent) on delete restrict on update restrict;

alter table Project add constraint FK_Project_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage, coGrade)
      references ProjectTrackStage (idProjectTrackStage, coGrade) on delete restrict on update restrict;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_MediaInformation foreign key (IdMediaRoadmap)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSchoolSupply add constraint FK_ProjectStageSchoolSupply_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_ProjectStageOrientation foreign key (idProjectStageOrientation)
      references ProjectStageOrientation (idProjectStageOrientation) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (idProjectTrack, coGrade, coComponent)
      references ProjectTrack (idProjectTrack, coGrade, coComponent) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict;

