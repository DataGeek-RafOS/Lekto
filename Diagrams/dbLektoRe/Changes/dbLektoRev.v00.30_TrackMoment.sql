/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/31/2023 3:19:01 PM                         */
/*==============================================================*/


alter table Lesson drop constraint FK_Lesson_Grade;
;

alter table LessonComponent drop constraint FK_LessonComponent_Lesson;
;

alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;
;

alter table LessonMoment drop constraint FK_LessonMoment_LessonTrack;
;

alter table LessonMoment drop constraint FK_LessonMoment_Class;
;

alter table LessonMoment drop constraint FK_LessonMoment_MomentStatus;
;

alter table LessonMoment drop constraint FK_LessonMoment_Professor;
;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;
;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_Assessment;
;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;
;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;
;

alter table LessonStep drop constraint FK_LessonStep_Lesson;
;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_Lesson;
;

alter table LessonTrack drop constraint FK_LessonTrack_Component;
;

alter table LessonTrack drop constraint FK_LessonTrack_Grade;
;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_Lesson;
;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;
;

alter table Project drop constraint FK_Project_Evidence;
;

alter table ProjectCategory drop constraint FK_ProjectCategory_Project;
;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;
;

alter table ProjectDocumentation drop constraint FK_ProjectDocumentation_ProjectMoment;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_Class;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_Professor;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrack;
;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectMoment;
;

alter table ProjectStage drop constraint FK_ProjectStage_Project;
;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_Project;
;

alter table Lesson
modify column idLesson int not null first,
   drop primary key
;

drop table if exists tmp_Lesson
;

rename table Lesson to tmp_Lesson
;

alter table LessonMoment
modify column idLessonMoment int not null first,
   drop primary key
;

drop table if exists tmp_LessonMoment
;

rename table LessonMoment to tmp_LessonMoment
;

alter table LessonMomentGroup
modify column idLessonMomentGroup int not null first,
   drop primary key
;

drop table if exists tmp_LessonMomentGroup
;

rename table LessonMomentGroup to tmp_LessonMomentGroup
;

alter table LessonTrack
modify column idLessonTrack int not null first,
   drop primary key
;

drop table if exists tmp_LessonTrack
;

rename table LessonTrack to tmp_LessonTrack
;

alter table Project
modify column idProject int not null first,
   drop primary key
;

drop table if exists tmp_Project
;

rename table Project to tmp_Project
;

alter table ProjectMoment
modify column idProjectMoment int not null first,
   drop primary key
;

drop table if exists tmp_ProjectMoment
;

rename table ProjectMoment to tmp_ProjectMoment
;

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   txTitle              varchar(300),
   txDescription        varchar(300),
   coGrade              char(4) not null,
   txGuidance           varchar(2000),
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coGrade),
   key AK_Lesson (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Lesson (idLesson, txTitle, coGrade, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLesson, txTitle, coGrade, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_Lesson
;

drop table if exists tmp_Lesson
;

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
   idLesson             int not null,
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
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonMoment (idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idLessonTrack, idLesson, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idLessonMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, coMomentStatus, idUserProfessor, idProfessor, idLessonTrack, ?, dtSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_LessonMoment
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonMoment
#;
/*==============================================================*/
/* Table: LessonMomentGroup                                     */
/*==============================================================*/
create table LessonMomentGroup
(
   idLessonMomentGroup  bigint not null auto_increment,
   idUserStudent        int not null,
   idStudent            int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonMomentActivity int not null,
   coAssessment         varchar(2),
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonMomentGroup (idLessonMomentGroup, idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select idLessonMomentGroup, idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, coAssessment, dtAssessment, dtInserted, dtLastUpdate
from tmp_LessonMomentGroup
;

drop table if exists tmp_LessonMomentGroup
;

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
   primary key (idLessonTrack, coGrade),
   key AK_LessonTrack (idLessonTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonTrack (idLessonTrack, coGrade, coComponent, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonTrack, coGrade, coComponent, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonTrack
;

drop table if exists tmp_LessonTrack
;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coGrade              char(4) not null,
   idEvidence           int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_AK_Project (idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Project (idProject, txTitle, txDescription, coGrade, idEvidence, dtInserted, dtLastUpdate)
select idProject, txTitle, txDescription, coGrade, idEvidence, dtInserted, dtLastUpdate
from tmp_Project
;

drop table if exists tmp_Project
;

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
   idProjectTrack       int not null,
   idProject            int not null,
   dtSchedule           datetime not null comment 'Hora de inicio.',
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMoment),
   key AK_ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrack, idProject, dtSchedule, dtProcessed, dtInserted, dtLastUpdate)
select idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrack, ?, dtSchedule, dtProcessed, dtInserted, dtLastUpdate
from tmp_ProjectMoment
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectMoment
#;
alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idLessonMoment)
      references LessonMoment (idLessonMoment) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_LessonTrackGroup foreign key (idLessonTrack, coGrade, idLesson)
      references LessonTrackGroup (idLessonTrack, coGrade, idLesson) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict
;

alter table LessonMoment add constraint FK_LessonMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict
;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonTrack add constraint FK_LessonTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table LessonTrack add constraint FK_LessonTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict
;

alter table Project add constraint FK_Project_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict
;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackGroup foreign key (idProjectTrack, idProject, coGrade)
      references ProjectTrackGroup (idProjectTrack, idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict
;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;


CREATE TRIGGER `tgai_UserProfile` 
AFTER INSERT ON `UserProfile` 
FOR EACH ROW BEGIN

     IF NEW.coProfile = 'ALNO'
     THEN
     
          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 1
          , NEW.idNetwork
          , NEW.idUser
          , NULL
          );

     END IF;

END ;

