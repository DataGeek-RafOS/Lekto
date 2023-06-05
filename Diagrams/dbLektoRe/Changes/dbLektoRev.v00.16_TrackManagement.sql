/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/26/2023 2:02:14 PM                         */
/*==============================================================*/


alter table ClassTrack drop constraint FK_ClassTrack_Component;

alter table ClassTrack drop constraint FK_ClassTrack_Grade;

alter table ClassTrackLesson drop constraint FK_ClassTrackLesson_ClassTrack;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;

alter table LessonMoment drop constraint FK_LessonMoment_Class;

alter table LessonMoment drop constraint FK_LessonMoment_ClassTrack;

alter table LessonMoment drop constraint FK_LessonMoment_MomentStatus;

alter table LessonMoment drop constraint FK_LessonMoment_Professor;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;

alter table Project drop constraint FK_Project_ProjectTrack;

alter table ProjectComponent drop constraint FK_ProjectComponent_Component;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;

alter table ProjectMoment drop constraint FK_ProjectMoment_MomentStatus;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectSchedule;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectStage;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectMoment;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_StudentClass;

alter table ProjectSchedule drop constraint FK_ProjectSchedule_Class;

alter table ProjectSchedule drop constraint FK_ProjectSchedule_Professor;

alter table ProjectSchedule drop constraint FK_ProjectSchedule_ProjectTrack;

alter table ProjectStageCategory drop constraint FK_ProjectStageCategory_Category;

alter table ProjectStageCategory drop constraint FK_ProjectStageCategory_ProjectStage;

alter table ProjectTrack drop constraint FK_ProjectTrack_Component;

alter table ProjectTrack drop constraint FK_ProjectTrack_Grade;

alter table ClassTrack 
modify column idClassTrack int not null first,
   drop primary key;

drop table if exists tmp_LessonMoment;

rename table LessonMoment to tmp_LessonMoment;

drop table if exists tmp_ClassTrack;

rename table ClassTrack to tmp_ClassTrack;

alter table LessonMoment
   drop primary key;

alter table Project
   drop column idProjectTrack;

alter table ProjectComponent
   drop primary key;

drop table if exists tmp_ProjectStageCategory;

rename table ProjectStageCategory to tmp_ProjectStageCategory;

drop table if exists tmp_ProjectComponent;

rename table ProjectComponent to tmp_ProjectComponent;

alter table ProjectMoment
modify column idProjectMoment int not null first,
   drop primary key;

alter table ProjectMomentStage
modify column idProjectMomentStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectSchedule;

rename table ProjectSchedule to tmp_ProjectSchedule;

drop table if exists tmp_ProjectMomentStage;

rename table ProjectMomentStage to tmp_ProjectMomentStage;

drop table if exists tmp_ProjectMoment;

rename table ProjectMoment to tmp_ProjectMoment;

alter table ProjectSchedule
modify column idProjectSchedule int not null first,
   drop primary key;

alter table ProjectStageCategory
   drop primary key;

alter table ProjectTrack
modify column idProjectTrack int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrack;

rename table ProjectTrack to tmp_ProjectTrack;

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
   idLessonTrack        int not null,
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

insert into LessonMoment (idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idLessonTrack, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idClassTrack, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_LessonMoment;

drop table if exists tmp_LessonMoment;

/*==============================================================*/
/* Table: LessonTrack                                           */
/*==============================================================*/
create table LessonTrack
(
   idLessonTrack        int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonTrack (idLessonTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idClassTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ClassTrack;

drop table if exists tmp_ClassTrack;

/*==============================================================*/
/* Table: ProjectCategory                                       */
/*==============================================================*/
create table ProjectCategory
(
   idProject            int not null,
   idCategory           smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, idCategory)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectCategory (idProject, idCategory, dtInserted, dtLastUpdate)
select idProject, idCategory, now(), now()
from tmp_ProjectStageCategory
	inner join ProjectStage
		   on ProjectStage.idProjectStage = tmp_ProjectStageCategory.idProjectStage;

drop table if exists tmp_ProjectStageCategory;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idProject            int not null,
   coComponent          char(3) not null,
   coProjectComponentType char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_ProjectComponent (coComponent, idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectComponentType                                  */
/*==============================================================*/
create table ProjectComponentType
(
   coProjectComponentType char(3) not null,
   txProjectComponentType char(10) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coProjectComponentType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectComponentType values ('PRI', 'Primário', NOW(), NOW());
insert into ProjectComponentType values ('SEC', 'Secundário', NOW(), NOW());


insert into ProjectComponent (idProject, coComponent, coProjectComponentType, dtInserted, dtLastUpdate)
select idProject, coComponent, 'PRI', dtInserted, dtLastUpdate
from tmp_ProjectComponent;

drop table if exists tmp_ProjectComponent;


/*==============================================================*/
/* Table: ProjectMoment                                         */
/*==============================================================*/
create table ProjectMoment
(
   idProjectMoment      int not null auto_increment,
   idProjectTrack       int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMoment),
   key AK_ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectMoment (idProjectMoment, idProjectTrack, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, dtSchedule, dtProcessed, dtInserted, dtLastUpdate)
select idProjectSchedule, idProjectTrack, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, dtSchedule, dtProcessed, dtInserted, dtLastUpdate
from tmp_ProjectSchedule;

drop table if exists tmp_ProjectSchedule;

/*==============================================================*/
/* Table: ProjectMomentGroup                                    */
/*==============================================================*/
create table ProjectMomentGroup
(
   idProjectMomentGroup int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectMomentStage int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectMomentGroup (idProjectMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage, idUserStudent, idStudent, dtInserted, dtLastUpdate)
select idProjectMomentStage, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment, idUserStudent, idStudent, dtInserted, dtLastUpdate
from tmp_ProjectMomentStage;

drop table if exists tmp_ProjectMomentStage;

/*==============================================================*/
/* Table: ProjectMomentStage                                    */
/*==============================================================*/
create table ProjectMomentStage
(
   idProjectMomentStage int not null auto_increment,
   idProjectMoment      int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectStage       int not null,
   coMomentStatus       char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStage),
   key AK_ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectMomentStage (idProjectMomentStage, idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, coMomentStatus, dtInserted, dtLastUpdate)
select idProjectMoment, idProjectSchedule, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, coMomentStatus, dtInserted, dtLastUpdate
from tmp_ProjectMoment;

drop table if exists tmp_ProjectMoment;

/*==============================================================*/
/* Table: ProjectTrack                                          */
/*==============================================================*/
create table ProjectTrack
(
   idProjectTrack       int not null auto_increment,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack),
   key AK_ProjectTrack (coComponent, idProjectTrack)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectTrack (idProjectTrack, txTitle, coGrade, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectTrack, txTitle, coGrade, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectTrack;

drop table if exists tmp_ProjectTrack;

/*==============================================================*/
/* Table: ProjectTrackGroup                                     */
/*==============================================================*/
create table ProjectTrackGroup
(
   coComponent          char(3) not null,
   idProjectTrack       int not null,
   idProject            int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coComponent, idProjectTrack, idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table ClassTrackLesson add constraint FK_ClassTrackLesson_LessonTrack foreign key (idClassTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict;

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_LessonTrack foreign key (idLessonTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict;

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

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_ProjectComponentType foreign key (coProjectComponentType)
      references ProjectComponentType (coProjectComponentType) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectComponent foreign key (coComponent, idProject)
      references ProjectComponent (coComponent, idProject) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (coComponent, idProjectTrack)
      references ProjectTrack (coComponent, idProjectTrack) on delete restrict on update restrict;

