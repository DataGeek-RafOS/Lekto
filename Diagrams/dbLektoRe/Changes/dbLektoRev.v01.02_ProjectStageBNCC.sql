/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/6/2023 4:06:28 PM                          */
/*==============================================================*/


alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStage drop constraint FK_ProjectStage_ProjectTrackStage;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   idProjectTrackStage  int not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   idEvidenceFixed      int not null,
   idEvidenceVariable   int not null,
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidanceBNCC       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectStage (idProjectStage, idProject, idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, dtInserted, dtLastUpdate)
select idProjectStage, idProject, idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, dtInserted, dtLastUpdate
from tmp_ProjectStage;

drop table if exists tmp_ProjectStage;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_ProjectTrackStage foreign key (idProjectTrackStage, idEvidenceFixed)
      references ProjectTrackStage (idProjectTrackStage, idEvidenceFixed) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

