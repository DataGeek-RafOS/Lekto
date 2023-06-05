/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/2/2023 5:19:21 PM                          */
/*==============================================================*/


alter table Lesson drop constraint FK_Lesson_Grade;
;

alter table LessonActivity drop constraint FK_LessonActivity_Category;
;

alter table LessonActivity drop constraint FK_LessonActivity_Evidence;
;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;
;

alter table LessonComponent drop constraint FK_LessonComponent_Lesson;
;

alter table LessonStep drop constraint FK_LessonStep_Lesson;
;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;
;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_LessonStep;
;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_LessonStep;
;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_Lesson;
;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_Lesson;
;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackGroup;
;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_ProjectMomentStage;
;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_MomentStatus;
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

alter table Lesson
modify column idLesson int not null first,
   drop primary key
;

drop table if exists tmp_Lesson
;

rename table Lesson to tmp_Lesson
;

alter table LessonComponent
   drop column coGrade
;


ALTER TABLE LessonActivity DROP CONSTRAINT FK_LessonActivity__LessonStep

alter table LessonStep
modify column idLessonStep int not null first,
   drop primary key
;

drop table if exists tmp_LessonStep
;

rename table LessonStep to tmp_LessonStep
;



alter table LessonStepEvidence
modify column idLessonStepEvidence int not null first,
   drop primary key
;

alter table LessonStepEvidence
   drop column Les_coGrade
;

alter table LessonSupportReference
   drop column coGrade
;

alter table LessonTrack
modify column idLessonTrack int not null first,
   drop primary key
;

alter table ProjectMoment
   drop column idProject
;

alter table ProjectMomentStage
modify column idProjectMomentStage int not null first,
   drop primary key
;

drop table if exists tmp_ProjectMomentStage
;

rename table ProjectMomentStage to tmp_ProjectMomentStage
;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key
;

drop table if exists tmp_ProjectStage
;

rename table ProjectStage to tmp_ProjectStage
;

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(300),
   txDescription        varchar(300),
   txGuidance           varchar(2000),
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson),
   key AK_Lesson (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into Lesson (idLesson, coGrade, txTitle, txDescription, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLesson, coGrade, txTitle, txDescription, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_Lesson
;

drop table if EXISTS tmp_Lesson;


alter table LessonActivity
   modify column idCategory smallint
;

alter table LessonActivity
   modify column idEvidence int
;

/*==============================================================*/
/* Table: LessonStep                                            */
/*==============================================================*/
create table LessonStep
(
   idLessonStep         int not null auto_increment,
   idLesson             int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidance           varchar(2000) not null,
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep),
   key AK_LessonStep (idLessonStep)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonStep (idLessonStep, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonStep, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonStep
;

drop table if exists tmp_LessonStep
;

alter table LessonStepEvidence
   add primary key (idLessonStep, coGrade, idEvidence)
;

alter table LessonTrack
   add primary key (idLessonTrack)
;

/*==============================================================*/
/* Table: ProjectMomentOrientation                              */
/*==============================================================*/
create table ProjectMomentOrientation
(
   idProjectMomentOrientation int not null auto_increment,
   idProjectMoment      int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

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
   nuStageGroup         tinyint not null,
   coMomentStatus       char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStage),
   key AK_ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectMomentStage (idProjectMomentStage, idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, nuStageGroup, coMomentStatus, dtInserted, dtLastUpdate)
select idProjectMomentStage, idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage,1, coMomentStatus, dtInserted, dtLastUpdate
from tmp_ProjectMomentStage
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectMomentStage
#;
/*==============================================================*/
/* Table: ProjectMomentStageOrientation                         */
/*==============================================================*/
create table ProjectMomentStageOrientation
(
   idProjectMomentStageOrientation int not null auto_increment,
   idProjectMomentStage int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    varchar(2000) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   idEvidence           int not null,
   txDescription        varchar(300),
   coGrade              char(4) not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into ProjectStage (idProjectStage, idProject, idEvidence, coGrade, nuOrder, txTitle, nuDuration, dtInserted, dtLastUpdate)
select idProjectStage, idProject, idEvidence, coGrade, nuOrder, txTitle, nuDuration, dtInserted, dtLastUpdate
from tmp_ProjectStage
;

drop table if exists tmp_ProjectStage
;

alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update RESTRICT
;

SELECT DISTINCT LessonActivity.idCategory, LessonActivity.coGrade 
FROM LessonActivity
     LEFT JOIN Category
            ON Category.idCategory = LessonActivity.idCategory AND Category.coGrade = LessonActivity.coGrade
WHERE Category.idCategory is null



alter table LessonActivity add constraint FK_LessonActivity_Category foreign key (idCategory, coGrade)
      references Category (idCategory, coGrade) on delete restrict on update restrict
;

DELETE FROM LessonMomentActivity
DELETE FROM LessonActivity


     

alter table LessonActivity add constraint FK_LessonActivity_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict
;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update RESTRICT
;

SELECT * FROM information_schema.REFERENTIAL_CONSTRAINTS rc where constraint_name LIKE '%LessonStepDocumentation%'

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation__LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict
;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMomentStage) on delete restrict on update restrict
;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict
;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict
;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Evidence foreign key (idEvidence, coGrade)
      references Evidence (idEvidence, coGrade) on delete restrict on update restrict
;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject)
      references Project (idProject) on delete restrict on update restrict
;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update RESTRICT
;


DROP TRIGGER IF EXISTS `tgai_Student` 
CREATE TRIGGER `tgai_Student` 
AFTER INSERT ON Student
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
          , 2
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', NEW.idSchool, '@p1', 'ALNO')
          );

END ;

DROP TRIGGER IF EXISTS `tgai_StudentClass` 
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

