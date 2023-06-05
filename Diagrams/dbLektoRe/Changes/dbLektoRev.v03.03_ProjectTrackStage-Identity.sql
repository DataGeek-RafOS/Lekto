/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/10/2023 10:05:47 AM                        */
/*==============================================================*/


alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectTrackStage;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_EvidenceGrade;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_ProjectTrack;

alter table ProjectTrackStage
modify column idProjectTrackStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrackStage;

rename table ProjectTrackStage to tmp_ProjectTrackStage;

/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null auto_increment,
   idProjectTrack       int not null,
   coGrade              char(4) not null,
   idEvidence           int,
   txDescription        varchar(300),
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

insert into ProjectTrackStage (idProjectTrackStage, idProjectTrack, coGrade, idEvidence, txDescription, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate)
select idProjectTrackStage, idProjectTrack, coGrade, idEvidence, txDescription, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate
from tmp_ProjectTrackStage;

drop table if exists tmp_ProjectTrackStage;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage, coGrade)
      references ProjectTrackStage (idProjectTrackStage, coGrade) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict;

