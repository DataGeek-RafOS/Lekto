/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/9/2023 6:32:19 PM                          */
/*==============================================================*/


alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectTrackStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectStage ;


alter table ProjectStageGroup
   drop primary key;

alter table ProjectStageGroup
   drop column dtLastUpdate;

alter table ProjectStageGroup
   drop column dtInserted;

alter table ProjectStageGroup
   drop column idEvidenceFixed;

alter table ProjectStageGroup
   drop column coGrade;

alter table ProjectStageGroup
   add primary key (idProjectTrackStage, idProjectStage);

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict;


alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;