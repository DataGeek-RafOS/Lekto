/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/27/2023 12:13:37 PM                        */
/*==============================================================*/


alter table ProjetStageDocumentation drop constraint FK_ProjetStageDocumentation_ProjectDocumentation;

alter table ProjetStageDocumentation drop constraint FK_ProjetStageDocumentation_ProjectStage;

alter table ProjetStageDocumentation
   drop primary key;

rename table ProjetStageDocumentation to ProjectStageDocumentation;

alter table ProjectStageDocumentation
   add primary key (idProjectStage, idProjectDocumentation);

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

