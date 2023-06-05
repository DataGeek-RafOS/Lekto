/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     8/17/2022 7:29:40 PM                         */
/*==============================================================*/


drop table if exists tmp_Component;

rename table Component to tmp_Component;

alter table tmp_ProjectCard drop constraint FK_Project_ProjectCard;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

drop table if exists tmp_ProjectComponent;

rename table ProjectComponent to tmp_ProjectComponent;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

/*==============================================================*/
/* Table: Component                                             */
/*==============================================================*/
create table Component
(
   idComponent          int not null auto_increment,
   txComponent          varchar(100),
   txDescription        varchar(2000) not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (idComponent)
);

insert into Component (idComponent, txComponent, txDescription, dtInserted, inStatus)
select idComponent, txComponent, txDescription, dtInserted, inStatus
from tmp_Component;

alter table tmp_ProjectComponent drop constraint FK_ProjectComponent_Component;
alter table Segment drop constraint FK_Segment_Component;

drop table if exists tmp_Component;

alter table GradeStage
   modify column inStatus bool not null default 1;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   idSegment            int not null,
   txName               varchar(200) not null,
   txDescription        varchar(500),
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (idProject)
);

insert into Project (idProject, idSegment, txName, txDescription, dtInserted, inStatus)
select idProject, idSegment, txName, '', now(), 1
from tmp_Project;

alter table tmp_ProjectComponent drop constraint FK_ProjectComponent_Project;

alter table tmp_ProjectStage drop constraint FK_Project_ProjectStage;

drop table if exists tmp_Project;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idComponent          int not null,
   idProject            int not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (idComponent, idProject)
);

insert into ProjectComponent (idComponent, idProject, dtInserted, inStatus)
select idComponent, idProject, dtInserted, inStatus
from tmp_ProjectComponent;

drop table if exists tmp_ProjectComponent;

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProject            int not null,
   idCard               int not null,
   nuSequence           tinyint not null default 1,
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (idProject, idCard)
);

insert into ProjectStage (idProject, idCard, nuSequence, dtInserted, inStatus)
select idProject, idCard, nuSequence, dtInserted, inStatus
from tmp_ProjectStage;

drop table if exists dbo.tmp_ProjectStage;

alter table Stage
   modify column inStatus bool not null default 1;

alter table Project add constraint FK_Segment_Project foreign key (idSegment)
      references Segment (idSegment);

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (idComponent)
      references Component (idComponent);

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject);

alter table ProjectStage add constraint FK_Card_ProjectStage foreign key (idCard)
      references Card (idCard);

alter table ProjectStage add constraint FK_Project_ProjectStage foreign key (idProject)
      references Project (idProject);

alter table Segment add constraint FK_Segment_Component foreign key (idComponent)
      references Component (idComponent);
	 
	 select * from Segment

ALTER TABLE `dbLekto`.`ProjectStage` 
MODIFY COLUMN `nuSequence` smallint NOT NULL DEFAULT 1 AFTER `idCard`;


ALTER TABLE `dbLekto`.`Segment` 
MODIFY COLUMN `inStatus` bool NOT NULL DEFAULT 1 AFTER `idComponent`;
