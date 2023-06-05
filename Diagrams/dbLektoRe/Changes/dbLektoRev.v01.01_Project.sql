/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/5/2023 5:07:40 PM                          */
/*==============================================================*/


alter table KeyAPI drop constraint FK_KeyAPI_Network;

alter table LektoUser drop constraint FK_LektoUser_Network;

alter table LessonComponent drop constraint FK_LessonComponent_Component;

alter table LessonComponent drop constraint FK_LessonComponent_ComponentType;

alter table LessonComponent drop constraint FK_LessonComponent_Lesson;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;

alter table LessonMoment drop constraint FK_LessonMoment_LessonTrackGroup;

alter table LessonMoment drop constraint FK_LessonMoment_Class;

alter table LessonMoment drop constraint FK_LessonMoment_MomentStatus;

alter table LessonMoment drop constraint FK_LessonMoment_Professor;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;

alter table LessonTrack drop constraint FK_LessonTrack_Component;

alter table LessonTrack drop constraint FK_LessonTrack_Grade;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_Lesson;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;

alter table Network drop constraint FK_Network_District;

alter table Network drop constraint FK_Network_Network;

alter table Project drop constraint FK_Project_Evidence;

alter table ProjectCategory drop constraint FK_ProjectCategory_Project;

alter table ProjectComponent drop constraint FK_ProjectComponent_Component;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;

alter table ProjectComponent drop constraint FK_ProjectComponent_ComponentType;

alter table ProjectDocumentation drop constraint FK_ProjectDocumentation_ProjectMoment;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;

alter table ProjectMoment drop constraint FK_ProjectMoment_Class;

alter table ProjectMoment drop constraint FK_ProjectMoment_Professor;

alter table ProjectMomentOrientation drop constraint FK_ProjectMomentOrientation_ProjectMoment;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_MomentStatus;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectMoment;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectStage drop constraint FK_ProjectStage_Evidence;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStage drop constraint FK_ProjectStage_ProjectTrackStage;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectTrack drop constraint FK_ProjectTrack_Component;

alter table ProjectTrack drop constraint FK_ProjectTrack_Grade;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_Project;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectTrack;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_ProjectTrack;

alter table School drop constraint FK_School_Network;

alter table School drop constraint FK_School_SubNetwork;

alter table SchoolYear drop constraint FK_SchoolYear_Network;

alter table UserProfileRegional drop constraint FK_UserProfileRegional_Network;

alter table LessonComponent
   drop primary key;

drop table if exists tmp_LessonComponent;

rename table LessonComponent to tmp_LessonComponent;

alter table LessonMoment
modify column idLessonMoment int not null first,
   drop primary key;

drop table if exists tmp_LessonMoment;

rename table LessonMoment to tmp_LessonMoment;

alter table LessonTrack
modify column idLessonTrack int not null first,
   drop primary key;

drop table if exists tmp_LessonTrack;

rename table LessonTrack to tmp_LessonTrack;

alter table LessonTrackGroup
   drop primary key;

drop table if exists tmp_LessonTrackGroup;

rename table LessonTrackGroup to tmp_LessonTrackGroup;

alter table Network
modify column idNetwork int not null first,
   drop primary key;

drop table if exists tmp_Network;

rename table Network to tmp_Network;

alter table Project
modify column idProject int not null first,
   drop primary key;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

alter table ProjectComponent
   drop primary key;

drop table if exists tmp_ProjectComponent;

rename table ProjectComponent to tmp_ProjectComponent;

alter table ProjectMoment
modify column idProjectMoment int not null first,
   drop primary key;

drop table if exists tmp_ProjectMoment;

rename table ProjectMoment to tmp_ProjectMoment;

alter table ProjectMomentStage
   drop column coMomentStatus;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

alter table ProjectTrack
modify column idProjectTrack int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrack;

rename table ProjectTrack to tmp_ProjectTrack;

alter table ProjectTrackGroup
   drop primary key;

drop table if exists tmp_ProjectTrackGroup;

rename table ProjectTrackGroup to tmp_ProjectTrackGroup;

alter table ProjectTrackStage
modify column idProjectTrackStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrackStage;

rename table ProjectTrackStage to tmp_ProjectTrackStage;

/*==============================================================*/
/* Table: Audit                                                 */
/*==============================================================*/
create table Audit
(
   idAudit              bigint not null auto_increment,
   idUser               int,
   txTableName          varchar(50) not null,
   txKeyValues          longtext not null,
   txOldValues          longtext,
   txNewValues          longtext,
   txIpAddress          varchar(39),
   dtIserted            datetime not null,
   primary key (idAudit),
   key IX_Audit_idUser (idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LessonComponent                                       */
/*==============================================================*/
create table LessonComponent
(
   idLesson             int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   coComponentType      char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coGrade, coComponent),
   key AK_LessonComponent (idLesson, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonComponent (idLesson, coGrade, coComponent, coComponentType, dtInserted, dtLastUpdate)
select idLesson, 'F1A1', coComponent, coComponentType, dtInserted, dtLastUpdate
from tmp_LessonComponent;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_LessonComponent;
/*==============================================================*/
/* Table: LessonMoment                                          */
/*==============================================================*/
create table LessonMoment
(
   idLessonMoment       int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   coMomentStatus       char(4) not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   idLessonTrackGroup   int not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   dtStartMoment        datetime,
   dtEndMoment          datetime,
   txClassStateHash     varchar(256),
   txJobId              varchar(36),
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMoment),
   key AK_LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonMoment (idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idLessonTrackGroup, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, 1, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_LessonMoment;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_LessonMoment;
/*==============================================================*/
/* Table: LessonTrack                                           */
/*==============================================================*/
create table LessonTrack
(
   idLessonTrack        int not null auto_increment,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack),
   key AK_LessonTrack (idLessonTrack, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonTrack (idLessonTrack, coGrade, coComponent, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonTrack, coGrade, coComponent, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonTrack;

drop table if exists tmp_LessonTrack;

/*==============================================================*/
/* Table: LessonTrackGroup                                      */
/*==============================================================*/
create table LessonTrackGroup
(
   idLessonTrackGroup   int not null auto_increment,
   idLessonTrack        int not null,
   idLesson             int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrackGroup),
   key AK_LessonTrackGroup (idLessonTrack, idLesson, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonTrackGroup (idLessonTrack, idLesson, coGrade, coComponent, dtInserted, dtLastUpdate)
select  idLessonTrack, idLesson, coGrade, 1, dtInserted, dtLastUpdate
from tmp_LessonTrackGroup;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_LessonTrackGroup;
/*==============================================================*/
/* Table: Network                                               */
/*==============================================================*/
create table Network
(
   idNetwork            int not null,
   txName               varchar(120) not null,
   idNetworkReference   int,
   coDistrict           char(2),
   inIntegration        tinyint(1) not null default 1,
   inSingleSignOn       tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idNetwork)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Network (idNetwork, txName, idNetworkReference, coDistrict, inIntegration, inSingleSignOn, dtInserted, dtLastUpdate)
select idNetwork, txName, idNetworkReference, coDistrict, inAdminLektoEnabled, inSingleSignOn, dtInserted, dtLastUpdate
from tmp_Network;

drop table if exists tmp_Network;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_Project (idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Project (idProject, txTitle, txDescription, dtInserted, dtLastUpdate)
select idProject, txTitle, txDescription, dtInserted, dtLastUpdate
from tmp_Project;

drop table if exists tmp_Project;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idProject            int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   coComponentType      char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, coGrade, coComponent, coComponentType),
   key AK_ProjectComponent (coComponent, coGrade, idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectComponent (idProject, coGrade, coComponent, coComponentType, dtInserted, dtLastUpdate)
select idProject, 'F1A1', coComponent, coComponentType, dtInserted, dtLastUpdate
from tmp_ProjectComponent;



#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectComponent;
/*==============================================================*/
/* Table: ProjectMoment                                         */
/*==============================================================*/
create table ProjectMoment
(
   idProjectMoment      int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   idProjectTrackStage  int not null,
   coMomentStatus       char(4) not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMoment),
   key AK_ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrackStage, coMomentStatus, dtSchedule, dtProcessed, dtInserted, dtLastUpdate)
select idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrackStage, 'PEND', dtSchedule, dtProcessed, dtInserted, dtLastUpdate
from tmp_ProjectMoment;


#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectMoment;
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
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStage (idProjectStage, idProject, idProjectTrackStage, txTitle, txDescription, idEvidenceFixed, idEvidenceVariable, nuOrder, nuDuration, dtInserted, dtLastUpdate)
select idProjectStage, idProject, idProjectTrackStage, txTitle, txDescription, idEvidence, 1, nuOrder, nuDuration, dtInserted, dtLastUpdate
from tmp_ProjectStage;

select * from Evidence

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectStage;
/*==============================================================*/
/* Table: ProjectStageOrientation                               */
/*==============================================================*/
create table ProjectStageOrientation
(
   idProjectStageOrientation int not null auto_increment,
   idProjectStage       int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectStageSupportReference                          */
/*==============================================================*/
create table ProjectStageSupportReference
(
   idProjectStageSupportReference int not null auto_increment,
   idProjectStageOrientation int,
   IdMediaInformation   int,
   coSupportReference   char(4) not null,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectTrack                                          */
/*==============================================================*/
create table ProjectTrack
(
   idProjectTrack       int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300) not null,
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack),
   key AK_ProjectTrack (idProjectTrack, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectTrack (idProjectTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectTrack;

drop table if exists tmp_ProjectTrack;

/*==============================================================*/
/* Table: ProjectTrackGroup                                     */
/*==============================================================*/
create table ProjectTrackGroup
(
   idProjectTrack       int not null,
   idProject            int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack, idProject),
   key AK_ProjectTrackGroup (idProjectTrack, idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectTrackGroup (idProjectTrack, idProject, coGrade, coComponent, dtInserted, dtLastUpdate)
select idProjectTrack, idProject, coGrade, 'BIO', dtInserted, dtLastUpdate
from tmp_ProjectTrackGroup;


#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectTrackGroup;
/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null,
   idProjectTrack       int not null,
   idEvidenceFixed      int not null,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   txGuidanceCode       varchar(2000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage, idEvidenceFixed)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectTrackStage (idProjectTrackStage, idProjectTrack, idEvidenceFixed, txDescription, nuOrder, dtInserted, dtLastUpdate)
select idProjectTrackStage, idProjectTrack, 6, txDescription, nuOrder, dtInserted, dtLastUpdate
from tmp_ProjectTrackStage;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectTrackStage;
alter table KeyAPI add constraint FK_KeyAPI_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_ComponentType foreign key (coComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;
	 
alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idLessonMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_LessonTrackGroup foreign key (idLessonTrackGroup)
      references LessonTrackGroup (idLessonTrackGroup) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;

alter table LessonTrack add constraint FK_LessonTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonTrack add constraint FK_LessonTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;
	 
SELECT * FROM LessonTrackGroup;	 
SELECT * FROM LessonComponent;

update LessonTrackGroup
inner join LessonComponent on LessonTrackGroup.idLesson = LessonComponent.idLesson and LessonTrackGroup.coGrade = LessonComponent.coGrade
set LessonTrackGroup.coComponent = LessonComponent.coComponent;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonComponent foreign key (idLesson, coGrade, coComponent)
      references LessonComponent (idLesson, coGrade, coComponent) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade, coComponent)
      references LessonTrack (idLessonTrack, coGrade, coComponent) on delete restrict on update restrict;

alter table Network add constraint FK_Network_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict;

alter table Network add constraint FK_Network_Network foreign key (idNetworkReference)
      references Network (idNetwork) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_ComponentType foreign key (coComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

select * from ProjectStage;
select * from ProjectTrackStage;

desc ProjectTrackStage
insert into ProjectTrackStage (
  idProjectTrackStage
, idProjectTrack
, idEvidenceFixed
, nuOrder
, dtInserted
)
select distinct idProjectTrackStage, idEvidenceFixed
from ProjectStage

update ProjectStage set idEvidenceFixed = 6


alter table ProjectStage add constraint FK_ProjectStage_ProjectTrackStage foreign key (idProjectTrackStage, idEvidenceFixed)
      references ProjectTrackStage (idProjectTrackStage, idEvidenceFixed) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_ProjectStageOrientation foreign key (idProjectStageOrientation)
      references ProjectStageOrientation (idProjectStageOrientation) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

select coComponent, coGrade, idProject from ProjectTrackGroup;
select coComponent, coGrade, idProject from ProjectComponent;

update ProjectTrackGroup set coComponent = 'CIE' WHERE idProject IN (1,2,3,4);
update ProjectTrackGroup set coComponent = 'QUI' WHERE idProject IN (5,6,7,8);
update ProjectTrackGroup set coComponent = 'FIS' WHERE idProject > 8;

	alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectComponent foreign key (coComponent, coGrade, idProject)
		 references ProjectComponent (coComponent, coGrade, idProject) on delete restrict on update restrict;
		 
		 
select idProjectTrack, coGrade, coComponent from ProjectTrackGroup;
select idProjectTrack, coGrade, coComponent from ProjectTrack;		 

update ProjectTrack set coGrade = 'F1A1'
		 

	alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (idProjectTrack, coGrade, coComponent)
		 references ProjectTrack (idProjectTrack, coGrade, coComponent) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_Evidence foreign key (idEvidenceFixed)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict;

alter table School add constraint FK_School_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table School add constraint FK_School_SubNetwork foreign key (idSubNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table SchoolYear add constraint FK_SchoolYear_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table UserProfileRegional add constraint FK_UserProfileRegional_Network foreign key (idRegionalNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

