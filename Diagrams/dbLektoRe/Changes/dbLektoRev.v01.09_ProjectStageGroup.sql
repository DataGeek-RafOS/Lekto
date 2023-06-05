/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/9/2023 6:00:47 PM                          */
/*==============================================================*/


alter table ProjectStage drop constraint FK_ProjectStage_ProjectTrackStage;

alter table ProjectStage
   drop column idProjectTrackStage;

/*==============================================================*/
/* Table: ProjectStageGroup                                     */
/*==============================================================*/
create table ProjectStageGroup
(
   idProjectTrackStage  int not null,
   coGrade              char(4) not null,
   idEvidenceFixed      int not null,
   idProjectStage       int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage, coGrade, idEvidenceFixed, idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict;

