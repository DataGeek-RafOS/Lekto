/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/2/2023 9:26:23 PM                          */
/*==============================================================*/


alter table LessonActivity drop constraint FK_LessonActivity_Category;
;

alter table LessonActivity drop constraint FK_LessonActivity_Evidence;
;

alter table LessonEvidenceDocumentation drop constraint FK_LessonEvidenceDocumentation_Evidence;
;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;
;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_Evidence;
;

alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_StudentClass;
;

alter table Project drop constraint FK_Project_Evidence;
;

alter table ProjectCategory drop constraint FK_ProjectCategory_Project;
;

alter table ProjectCategory drop constraint FK_ProjectCategory_Category;
;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;
;

alter table ProjectDocumentation drop constraint FK_ProjectDocumentation_ProjectMoment;
;

alter table ProjectEvidenceDocumentation drop constraint FK_ProjectEvidenceDocumentation_Evidence;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrack;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_Class;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_Professor;
;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;
;

alter table ProjectMomentOrientation drop constraint FK_ProjectMomentOrientation_ProjectMoment;
;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectMoment;
;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;
;

alter table ProjectStage drop constraint FK_ProjectStage_Evidence;
;

alter table ProjectStage drop constraint FK_ProjectStage_Project;
;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;
;

alter table ProjectStudentDocumentation drop constraint FK_ProjectStudentDocumentation_StudentClass;
;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_Project;
;

alter table StudentClass drop constraint FK_StudentClass_Class;
;

alter table StudentClass drop constraint FK_StudentClass_Student;
;

alter table Category
modify column idCategory int not null first,
   drop primary key
;

alter table Evidence
modify column idEvidence int not null first,
   drop primary key
;

alter table LessonEvidenceDocumentation
   drop column coGrade
;

alter table Project
modify column idProject int not null first,
   drop primary key
;

drop table if exists tmp_Project
;

rename table Project to tmp_Project
;

alter table ProjectEvidenceDocumentation
   drop column coGrade
;

alter table ProjectMoment
modify column idProjectMoment int not null first,
   drop primary key
;

drop table if exists tmp_ProjectMoment
;

rename table ProjectMoment to tmp_ProjectMoment
;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key
;

drop table if exists tmp_ProjectStage
;

rename table ProjectStage to tmp_ProjectStage
;

desc ProjectTrackGroup

alter table ProjectTrackGroup
   drop primary key
;

desc StudentClass

alter table StudentClass
modify column idStudent int not null first,
   drop primary key
;

drop table if exists tmp_StudentClass
;

rename table StudentClass to tmp_StudentClass
;

select * from Category

alter table Category
   add primary key (idCategory)
;



alter table Category
   add unique AK_Category (idCategory, coGrade)
;

DELETE from Evidence where idEvidence = 2 and coGrade LIKE'F1%'  

alter table Evidence
   add primary key (idEvidence)
;

alter table Evidence
   add unique AK_Evidence (idEvidence, coGrade)
;

/*==============================================================*/
/* Table: KeyAPI                                                */
/*==============================================================*/
create table KeyAPI
(
   idKeyAPI             smallint not null auto_increment,
   idNetwork            int not null,
   uiKeyAPI             char(36) not null,
   inStatus             tinyint(1),
   dtInserted           datetime not null default NOW(),
   dtLastUpdate         datetime,
   primary key (idKeyAPI)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   idEvidence           int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject),
   key AK_Project (idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Project (idProject, txTitle, txDescription, idEvidence, coGrade, dtInserted, dtLastUpdate)
select idProject, txTitle, txDescription, idEvidence, coGrade, dtInserted, dtLastUpdate
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
   idProjectTrackStage  int not null,
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
insert into ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, idProjectTrackStage, dtSchedule, dtProcessed, dtInserted, dtLastUpdate)
select idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, ?, dtSchedule, dtProcessed, dtInserted, dtLastUpdate
from tmp_ProjectMoment
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectMoment
#;
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
   idEvidence           int not null,
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStage (idProjectStage, idProject, idProjectTrackStage, txTitle, txDescription, idEvidence, nuOrder, nuDuration, dtInserted, dtLastUpdate)
select idProjectStage, idProject, ?, txTitle, txDescription, idEvidence, nuOrder, nuDuration, dtInserted, dtLastUpdate
from tmp_ProjectStage
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectStage
#;

SELECT * FROM ProjectTrackGroup

alter table ProjectTrackGroup
   add primary key (idProjectTrack, idProject)
;

alter table ProjectTrackGroup
   add unique AK_ProjectTrackGroup (idProjectTrack, idProject, coGrade)
;

/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null,
   idProjectTrack       int not null,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   idStudent            int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudent),
   key AK_StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into StudentClass (idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, inStatus, dtInserted, dtLastUpdate)
select idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, inStatus, dtInserted, dtLastUpdate
from tmp_StudentClass
;

drop table if exists tmp_StudentClass
;

alter table KeyAPI add constraint FK_KeyAPI_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table Project add constraint FK_Project_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

select * from ProjectCategory;
select * from Category;

desc Category

delete from ProjectCategory where idCategory not in ( select 

alter table ProjectCategory add constraint FK_ProjectCategory_Category foreign key (idCategory, coGrade)
      references Category (idCategory, coGrade) on delete restrict on update restrict
;

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict
;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict
;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict
;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict
;

alter table StudentClass add constraint FK_StudentClass_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table StudentClass add constraint FK_StudentClass_Student foreign key (idNetwork, idSchool, coGrade, idUserStudent, idStudent)
      references Student (idNetwork, idSchool, coGrade, idUserStudent, idStudent) on delete restrict on update restrict
;


DROP TRIGGER IF EXISTS `tgai_StudentClass`;
 
CREATE TRIGGER `tgai_StudentClass` 
AFTER INSERT ON StudentClass 
FOR EACH ROW BEGIN

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
          , 3
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', NEW.idClass)
          );

END ;

