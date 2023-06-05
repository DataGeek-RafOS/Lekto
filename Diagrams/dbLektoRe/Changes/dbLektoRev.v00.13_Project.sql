/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/23/2023 10:07:44 AM                        */
/*==============================================================*/


alter table Project drop constraint FK_Project_ProjectTrail;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectTrail drop constraint FK_ProjectTrail_Grade;

alter table Project
   drop primary key;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

alter table ProjectStage
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

alter table ProjectTrail
   drop primary key;

drop table if exists tmp_ProjectTrail;

rename table ProjectTrail to tmp_ProjectTrail;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   idProjectTrack       int not null,
   idEvidence           int not null,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Project (idProject, idProjectTrack, idEvidence, coGrade, txTitle, dtInserted, dtLastUpdate)
select idProject, idProjectTrail, ?, ?, txTitle, dtInserted, dtLastUpdate
from tmp_Project;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Project;
/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idProject            int not null,
   coComponent          char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectMoment                                         */
/*==============================================================*/
create table ProjectMoment
(
   idProjectMoment      int not null auto_increment,
   idProjectSchedule    int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectStage       int not null,
   coMomentStatus       char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMoment),
   key AK_ProjectMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectMomentStage                                    */
/*==============================================================*/
create table ProjectMomentStage
(
   idProjectMomentStage int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectMoment      int not null,
   idUserStudent        int,
   idStudent            int,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectSchedule                                       */
/*==============================================================*/
create table ProjectSchedule
(
   idProjectSchedule    int not null auto_increment,
   idProjectTrack       int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   dtStartSchedule      time not null comment 'Hora de inicio.',
   dtEndSchedule        time not null,
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectSchedule),
   key AK_ProjectSchedule (idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   idEvidence           int not null,
   coGrade              char(4) not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStage (idProjectStage, idProject, idEvidence, coGrade, nuOrder, txTitle, nuDuration, dtInserted, dtLastUpdate)
select idProjectStage, idProject, ?, ?, nuOrder, txTitle, nuDuration, dtInserted, dtLastUpdate
from tmp_ProjectStage;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectStage;
/*==============================================================*/
/* Table: ProjectStageCategory                                  */
/*==============================================================*/
create table ProjectStageCategory
(
   idProjectStage       int not null,
   idCategory           smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage, idCategory)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectTrack                                          */
/*==============================================================*/
create table ProjectTrack
(
   idProjectTrack       int not null auto_increment,
   txTitle              varchar(150) not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectTrack (idProjectTrack, txTitle, coGrade, coComponent, dtInserted, dtLastUpdate)
select idProjectTrail, txTitle, coGrade, ?, dtInserted, dtLastUpdate
from tmp_ProjectTrail;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectTrail;
alter table Project add constraint FK_Project_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table Project add constraint FK_Project_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectSchedule foreign key (idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectSchedule (idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment)
      references ProjectMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectSchedule add constraint FK_ProjectSchedule_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table ProjectSchedule add constraint FK_ProjectSchedule_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table ProjectSchedule add constraint FK_ProjectSchedule_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectStageCategory add constraint FK_ProjectStageCategory_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict;

alter table ProjectStageCategory add constraint FK_ProjectStageCategory_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

