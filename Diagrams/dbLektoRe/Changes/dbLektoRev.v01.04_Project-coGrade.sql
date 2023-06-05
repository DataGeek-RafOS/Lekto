/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/7/2023 10:11:06 AM                         */
/*==============================================================*/


alter table ProjectCategory drop constraint FK_ProjectCategory_Project;

alter table ProjectCategory drop constraint FK_ProjectCategory_Category;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStage drop constraint FK_ProjectStage_ProjectTrackStage;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table Project
modify column idProject int not null first,
   drop primary key;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

alter table ProjectCategory
   drop primary key;

drop table if exists tmp_ProjectCategory;

rename table ProjectCategory to tmp_ProjectCategory;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_Project (idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Project (idProject, coGrade, txTitle, txDescription, dtInserted, dtLastUpdate)
select idProject, 'F2A8', txTitle, txDescription, dtInserted, dtLastUpdate
from tmp_Project;



#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_Project;

/*==============================================================*/
/* Table: ProjectCategory                                       */
/*==============================================================*/
create table ProjectCategory
(
   idProject            int not null,
   Pro_coGrade          char(4) not null,
   idCategory           smallint not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, Pro_coGrade, idCategory, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectCategory (idProject, Pro_coGrade, idCategory, coGrade, dtInserted, dtLastUpdate)
select idProject, 'F2A8', idCategory, coGrade, dtInserted, dtLastUpdate
from tmp_ProjectCategory;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectCategory;

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4) not null,
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

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStage (idProjectStage, idProject, coGrade, idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectStage, idProject, 'F2A8', idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectStage;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectStage;
alter table Project add constraint FK_Project_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Category foreign key (idCategory, coGrade)
      references Category (idCategory, coGrade) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;


update ProjectStage set idEvidenceVariable = 9

	select idEvidenceVariable, coGrade from ProjectStage;
	select * from Evidence;

	alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable, coGrade)
		 references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_ProjectTrackStage foreign key (idProjectTrackStage, idEvidenceFixed)
      references ProjectTrackStage (idProjectTrackStage, idEvidenceFixed) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

