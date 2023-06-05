/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/19/2023 5:34:21 PM                         */
/*==============================================================*/


alter table Evidence drop constraint FK_Evidence_Ability;

alter table Evidence drop constraint FK_Evidence_Grade;

alter table LessonActivity drop constraint FK_LessonActivity_Evidence;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;

alter table LessonEvidenceDocumentation drop constraint FK_LessonEvidenceDocumentation_Evidence;

alter table LessonStep drop constraint FK_LessonStep_Lesson;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_Evidence;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_LessonStep;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_LessonStep;

alter table ProjectEvidenceDocumentation drop constraint FK_ProjectEvidenceDocumentation_Evidence;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;

alter table ProjectStage drop constraint FK_ProjectStage_MediaInformation;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectTrackStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table ProjectStageSchoolSupply drop constraint FK_ProjectStageSchoolSupply_ProjectStage;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_Evidence;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_ProjectTrack;

alter table Evidence
modify column idEvidence int not null first,
   drop primary key;

drop table if exists tmp_Evidence;

rename table Evidence to tmp_Evidence;

alter table LessonStep
modify column idLessonStep int not null first,
   drop primary key;

drop table if exists tmp_LessonStep;

rename table LessonStep to tmp_LessonStep;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

alter table ProjectTrackStage
modify column idProjectTrackStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrackStage;

rename table ProjectTrackStage to tmp_ProjectTrackStage;

/*==============================================================*/
/* Table: Evidence                                              */
/*==============================================================*/
create table Evidence
(
   idEvidence           int not null auto_increment,
   txName               varchar(80) not null,
   idAbility            smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idEvidence),
   key AK_Evidence (idEvidence)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Evidence (idEvidence, txName, idAbility, dtInserted, dtLastUpdate)
select idEvidence, txName, idAbility, dtInserted, dtLastUpdate
from tmp_Evidence;

drop table if exists tmp_Evidence;

/*==============================================================*/
/* Table: EvidenceGrade                                         */
/*==============================================================*/
create table EvidenceGrade
(
   idEvidence           int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idEvidence, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LessonStep                                            */
/*==============================================================*/
create table LessonStep
(
   idLessonStep         int not null auto_increment,
   coGrade              char(4) not null,
   idLesson             int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidance           varchar(2000) not null,
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep),
   key AK_LessonStep (idLessonStep, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonStep (idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonStep, 'F2A8', idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonStep;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonStep;
/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   idEvidenceFixed      int not null,
   idEvidenceVariable   int not null,
   txGuidanceBNCC       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectStage (idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectStage;

drop table if exists tmp_ProjectStage;

/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null,
   idProjectTrack       int not null,
   coGrade              char(4) not null,
   idEvidence           int,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   txGuidanceCode       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage, coGrade),
   key AK_ProjectTrackStagecoGrade (idProjectTrackStage, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectTrackStage (idProjectTrackStage, idProjectTrack, coGrade, txDescription, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate)
select idProjectTrackStage, idProjectTrack, coGrade, txDescription, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate
from tmp_ProjectTrackStage;

drop table if exists tmp_ProjectTrackStage;

alter table Evidence add constraint FK_Evidence_Ability foreign key (idAbility)
      references Ability (idAbility) on delete restrict on update restrict;

alter table EvidenceGrade add constraint FK_EvidenceGrade_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table EvidenceGrade add constraint FK_EvidenceGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity ;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;



INSERT INTO EvidenceGrade
SELECT DISTINCT idEvidence, 'F1A1', NOW(), NULL FROM Evidence

UPDATE LessonActivity
SET coGrade = 'F1A1';

UPDATE LessonMomentActivity
SET coGrade = 'F1A1';

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 
UPDATE LessonActivityOrientation
SET coGrade = 'F1A1'; 	 

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 
alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;


UPDATE LessonStep
SET coGrade = 'F1A1'; 	

alter table LessonActivity add constraint FK_LessonActivity__LessonStep foreign key (idStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;
	 
alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;




alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage, coGrade)
      references ProjectTrackStage (idProjectTrackStage, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;
	 
INSERT INTO EvidenceGrade
SELECT DISTINCT idEvidence, 'F2A8', NOW(), NULL FROM Evidence


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

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict;

