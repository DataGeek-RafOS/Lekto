/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/30/2023 9:12:18 AM                         */
/*==============================================================*/


alter table Project drop constraint FK_Project_Evidence;

alter table ProjectCategory drop constraint FK_ProjectCategory_Project;

alter table ProjectComponent drop constraint FK_ProjectComponent_Component;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;

alter table ProjectComponent drop constraint FK_ProjectComponent_ComponentType;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_Project;

alter table Project
modify column idProject int not null first,
   drop primary key;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

alter table ProjectComponent
   drop primary key;

drop table if exists tmp_ProjectComponent;

rename table ProjectComponent to tmp_ProjectComponent;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   idEvidence           int not null,
   txDescription        varchar(300),
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_AK_Project (idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Project (idProject, idEvidence, coGrade, txTitle, dtInserted, dtLastUpdate)
select idProject, idEvidence, coGrade, txTitle, dtInserted, dtLastUpdate
from tmp_Project;

drop table if exists tmp_Project;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idProject            int not null,
   coComponent          char(3) not null,
   coComponentType      char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, coComponent, coComponentType),
   key AK_ProjectComponent (coComponent, idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectComponent (idProject, coComponent, coComponentType, dtInserted, dtLastUpdate)
select idProject, coComponent, coProjectComponentType, dtInserted, dtLastUpdate
from tmp_ProjectComponent;

drop table if exists tmp_ProjectComponent;

alter table Project add constraint FK_Project_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_ComponentType foreign key (coComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

