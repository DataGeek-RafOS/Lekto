/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/7/2023 10:46:38 AM                         */
/*==============================================================*/


alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;

alter table ProjectStage drop constraint FK_ProjectStage_ProjectTrackStage;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_Evidence;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_ProjectTrack;

alter table ProjectTrackStage
modify column idProjectTrackStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrackStage;

rename table ProjectTrackStage to tmp_ProjectTrackStage;

alter table ProjectTrack
   add unique AK_ProjectTrackcoGrade (idProjectTrack, coGrade);

/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null,
   idProjectTrack       int not null,
   coGrade              char(4) not null,
   idEvidenceFixed      int not null,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   txGuidanceCode       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage, coGrade, idEvidenceFixed),
   key AK_ProjectTrackStagecoGrade (idProjectTrackStage, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectTrackStage (idProjectTrackStage, idProjectTrack, coGrade, idEvidenceFixed, txDescription, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate)
select idProjectTrackStage, idProjectTrack, 'F2A8', idEvidenceFixed, txDescription, nuOrder, txGuidanceCode, dtInserted, dtLastUpdate
from tmp_ProjectTrackStage;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectTrackStage;
alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage, coGrade)
      references ProjectTrackStage (idProjectTrackStage, coGrade) on delete restrict on update restrict;



alter table ProjectStage add constraint FK_ProjectStage__ProjectTrackStage foreign key (idProjectTrackStage, coGrade, idEvidenceFixed)
      references ProjectTrackStage (idProjectTrackStage, coGrade, idEvidenceFixed) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_Evidence foreign key (idEvidenceFixed)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict;

