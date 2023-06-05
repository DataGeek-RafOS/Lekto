/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     3/14/2023 3:37:13 PM                         */
/*==============================================================*/


drop table if exists tmp_ActionLog;

rename table ActionLog to tmp_ActionLog;

drop table if exists tmp_ActionLogType;

rename table ActionLogType to tmp_ActionLogType;

drop table if exists tmp_LessonActivity;

rename table LessonActivity to tmp_LessonActivity;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

/*==============================================================*/
/* Table: ActionLog                                             */
/*==============================================================*/
create table ActionLog
(
   idActionLog          bigint not null auto_increment,
   dtAction             datetime not null,
   idActionLogType      tinyint not null,
   idNetwork            int not null,
   idUser               int not null,
   txVariables          json,
   primary key (idActionLog, dtAction)
);

insert into ActionLog (idActionLog, dtAction, idActionLogType, idNetwork, idUser, txVariables)
select idActionLog, dtAction, idActionLogType, idNetwork, idUser, txVariables
from tmp_ActionLog;

drop table if exists tmp_ActionLog;

/*==============================================================*/
/* Index: ixNCL_ActivityLog_idUser                              */
/*==============================================================*/
create index ixNCL_ActivityLog_idUser on ActionLog
(
   idUser
);

/*==============================================================*/
/* Table: ActionLogType                                         */
/*==============================================================*/
create table ActionLogType
(
   idActionLogType      tinyint not null,
   txAction             varchar(200) not null,
   idActionLogGroup     tinyint not null,
   dtInserted           datetime not null,
   primary key (idActionLogType)
);

insert into ActionLogType (idActionLogType, txAction, idActionLogGroup, dtInserted)
select idActionLogType, txAction, idActionLogGroup, dtInserted
from tmp_ActionLogType;

drop table if exists tmp_ActionLogType;

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
   idCategory           smallint,
   txChallenge          text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
);

insert into LessonActivity (idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate)
select idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate
from tmp_LessonActivity;

drop table if exists tmp_LessonActivity;
/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4),
   txTitle              varchar(2000) not null,
   txDescription        text,
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   idEvidenceFixed      int not null,
   idEvidenceVariable   int,
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
);

insert into ProjectStage (idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectStage;

ALTER TABLE ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

drop table if exists tmp_ProjectStage;

alter table ActionLog add constraint FK_ActivityLog_ActivityLogType foreign key (idActionLogType)
      references ActionLogType (idActionLogType);

alter table ActionLog add constraint FK_ActionLog_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table ActionLogType add constraint FK_ActionLogType_ActionLogGroup foreign key (idActionLogGroup)
      references ActionLogGroup (idActionLogGroup);

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;


alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

drop table tmp_LessonActivity;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectStage;

alter table ProjectStageSchoolSupply drop constraint FK_ProjectStageSchoolSupply_ProjectStage;

drop table tmp_ProjectStage;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;



alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

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

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSchoolSupply add constraint FK_ProjectStageSchoolSupply_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

