/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/7/2023 11:54:22 AM                         */
/*==============================================================*/


alter table DiagnosticAnswer drop constraint FK_DiagnosticAnswer_DiagnosticQuestion;

alter table DiagnosticQuestion drop constraint FK_DiagnosticQuestion_Ability;

alter table DiagnosticQuestionGrade drop constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion;

alter table Lesson drop constraint FK_Lesson_Grade;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_LessonActivityOrientation;

alter table LessonComponent drop constraint FK_LessonComponent_Component;

alter table LessonComponent drop constraint FK_LessonComponent_Lesson;

alter table LessonSchoolSupply drop constraint FK_LessonSchoolSupply_Lesson;

alter table LessonStep drop constraint FK_LessonStep_Lesson;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_LessonStep;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_LessonStep;

alter table LessonTrack drop constraint FK_LessonTrack_Component;

alter table LessonTrack drop constraint FK_LessonTrack_Grade;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;

alter table ProjectComponent drop constraint FK_ProjectComponent_Component;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrackStage;

alter table ProjectMomentOrientation drop constraint FK_ProjectMomentOrientation_ProjectMoment;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage;

alter table ProjectMomentStageOrientation drop constraint FK_ProjectMomentStageOrientation_ProjectMomentStage;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceFixed;

alter table ProjectStage drop constraint FK_ProjectStage_EvidenceVariable;

alter table ProjectStage drop constraint FK_ProjectStage_MediaInformation;

alter table ProjectStage drop constraint FK_ProjectStage_Project;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectStage;

alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectTrackStage;

alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;

alter table ProjectStageSchoolSupply drop constraint FK_ProjectStageSchoolSupply_ProjectStage;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_ProjectStageOrientation;

alter table ProjectTrack drop constraint FK_ProjectTrack_Component;

alter table ProjectTrack drop constraint FK_ProjectTrack_Grade;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectTrack;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_EvidenceGrade;

alter table ProjectTrackStage drop constraint FK_ProjectTrackStage_ProjectTrack;

alter table Component
   drop primary key;

drop table if exists tmp_Component;

rename table Component to tmp_Component;

alter table DiagnosticQuestion
modify column idDiagnosticQuestion int not null first,
   drop primary key;

drop table if exists tmp_DiagnosticQuestion;

rename table DiagnosticQuestion to tmp_DiagnosticQuestion;

alter table Lesson
modify column idLesson int not null first,
   drop primary key;

drop table if exists tmp_Lesson;

rename table Lesson to tmp_Lesson;

alter table LessonActivityOrientation
modify column idLessonActivityOrientation int not null first,
   drop primary key;

drop table if exists tmp_LessonActivityOrientation;

rename table LessonActivityOrientation to tmp_LessonActivityOrientation;

alter table LessonStep
modify column idLessonStep int not null first,
   drop primary key;

drop table if exists tmp_LessonStep;

rename table LessonStep to tmp_LessonStep;

alter table LessonTrack
modify column idLessonTrack int not null first,
   drop primary key;

drop table if exists tmp_LessonTrack;

rename table LessonTrack to tmp_LessonTrack;

alter table ProjectMomentOrientation
modify column idProjectMomentOrientation int not null first,
   drop primary key;

drop table if exists tmp_ProjectMomentOrientation;

rename table ProjectMomentOrientation to tmp_ProjectMomentOrientation;

alter table ProjectMomentStageOrientation
modify column idProjectMomentStageOrientation int not null first,
   drop primary key;

drop table if exists tmp_ProjectMomentStageOrientation;

rename table ProjectMomentStageOrientation to tmp_ProjectMomentStageOrientation;

alter table ProjectStage
modify column idProjectStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

alter table ProjectStageOrientation
modify column idProjectStageOrientation int not null first,
   drop primary key;

drop table if exists tmp_ProjectStageOrientation;

rename table ProjectStageOrientation to tmp_ProjectStageOrientation;

alter table ProjectTrack
modify column idProjectTrack int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrack;

rename table ProjectTrack to tmp_ProjectTrack;

alter table ProjectTrackStage
modify column idProjectTrackStage int not null first,
   drop primary key;

drop table if exists tmp_ProjectTrackStage;

rename table ProjectTrackStage to tmp_ProjectTrackStage;

/*==============================================================*/
/* Table: Component                                             */
/*==============================================================*/
create table Component
(
   coComponent          char(3) not null,
   txComponent          varchar(100),
   txDescription        text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txDescription
insert into Component (coComponent, txComponent, txDescription, dtInserted, dtLastUpdate)
select coComponent, txComponent, txDescription, dtInserted, dtLastUpdate
from tmp_Component;

#WARNING: Drop cancelled because columns cannot be restored: txDescription
#drop table if exists tmp_Component;
/*==============================================================*/
/* Table: DiagnosticQuestion                                    */
/*==============================================================*/
create table DiagnosticQuestion
(
   idDiagnosticQuestion int not null auto_increment,
   txQuestion           text character set utf8mb4 not null,
   idAbility            smallint not null,
   inStatus             tinyint(1) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDiagnosticQuestion)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txQuestion
insert into DiagnosticQuestion (idDiagnosticQuestion, txQuestion, idAbility, inStatus, dtInserted, dtLastUpdate)
select idDiagnosticQuestion, txQuestion, idAbility, inStatus, dtInserted, dtLastUpdate
from tmp_DiagnosticQuestion;

#WARNING: Drop cancelled because columns cannot be restored: txQuestion
#drop table if exists tmp_DiagnosticQuestion;
/*==============================================================*/
/* Index: ukNCL_KeyAPI_uiKeyAPI                                 */
/*==============================================================*/
create unique index ukNCL_KeyAPI_uiKeyAPI on KeyAPI
(
   uiKeyAPI
);

/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(300),
   txDescription        varchar(300),
   txGuidance           text,
   txGuidanceBNCC       text not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson),
   key AK_Lesson (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;


insert into Lesson (idLesson, coGrade, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate, txGuidance)
select idLesson, coGrade, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate,txGuidance
from tmp_Lesson;

#WARNING: Drop cancelled because columns cannot be restored: txGuidance, txGuidanceBNCC
#drop table if exists tmp_Lesson;
/*==============================================================*/
/* Table: LessonActivityOrientation                             */
/*==============================================================*/
create table LessonActivityOrientation
(
   idLessonActivityOrientation int not null auto_increment,
   idLessonActivity     int not null,
   coGrade              char(4) not null,
   txTitle              varchar(100) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivityOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txOrientationCode
insert into LessonActivityOrientation (idLessonActivityOrientation, idLessonActivity, coGrade, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idLessonActivityOrientation, idLessonActivity, coGrade, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_LessonActivityOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txOrientationCode
#drop table if exists tmp_LessonActivityOrientation;
/*==============================================================*/
/* Table: LessonStep                                            */
/*==============================================================*/
create table LessonStep
(
   idLessonStep         int not null auto_increment,
   coGrade              char(4) not null,
   idLesson             int not null,
   nuOrder              tinyint not null,
   txTitle              varchar(150) not null,
   nuDuration           smallint comment 'Duracao em minutos',
   txGuidance           text not null,
   txGuidanceBNCC       text not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep),
   key AK_LessonStep (idLessonStep, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txGuidance, txGuidanceBNCC
insert into LessonStep (idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonStep;

#WARNING: Drop cancelled because columns cannot be restored: txGuidance, txGuidanceBNCC
#drop table if exists tmp_LessonStep;
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
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack),
   key AK_LessonTrack (idLessonTrack, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txGuidanceBNCC
insert into LessonTrack (idLessonTrack, coGrade, coComponent, txTitle, txDescription, dtInserted, dtLastUpdate, txGuidanceBNCC)
select idLessonTrack, coGrade, coComponent, txTitle, txDescription, dtInserted, dtLastUpdate, txGuidanceBNCC
from tmp_LessonTrack;

#WARNING: Drop cancelled because columns cannot be restored: txGuidanceBNCC
#drop table if exists tmp_LessonTrack;
/*==============================================================*/
/* Table: ProjectMomentOrientation                              */
/*==============================================================*/
create table ProjectMomentOrientation
(
   idProjectMomentOrientation int not null auto_increment,
   idProjectMoment      int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txOrientationCode
insert into ProjectMomentOrientation (idProjectMomentOrientation, idProjectMoment, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idProjectMomentOrientation, idProjectMoment, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_ProjectMomentOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txOrientationCode
#drop table if exists tmp_ProjectMomentOrientation;
/*==============================================================*/
/* Table: ProjectMomentStageOrientation                         */
/*==============================================================*/
create table ProjectMomentStageOrientation
(
   idProjectMomentStageOrientation int not null auto_increment,
   idProjectMomentStage int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txOrientationCode
insert into ProjectMomentStageOrientation (idProjectMomentStageOrientation, idProjectMomentStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idProjectMomentStageOrientation, idProjectMomentStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_ProjectMomentStageOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txOrientationCode
#drop table if exists tmp_ProjectMomentStageOrientation;
/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   idEvidenceFixed      int not null,
   idEvidenceVariable   int not null,
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txGuidanceBNCC
insert into ProjectStage (idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, dtInserted, dtLastUpdate, txGuidanceBNCC)
select idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, idEvidenceFixed, idEvidenceVariable, dtInserted, dtLastUpdate, txGuidanceBNCC
from tmp_ProjectStage;

#WARNING: Drop cancelled because columns cannot be restored: txGuidanceBNCC
#drop table if exists tmp_ProjectStage;
/*==============================================================*/
/* Table: ProjectStageOrientation                               */
/*==============================================================*/
create table ProjectStageOrientation
(
   idProjectStageOrientation int not null auto_increment,
   idProjectStage       int not null,
   txTitle              varchar(100) not null,
   txOrientationCode    text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageOrientation)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txOrientationCode
insert into ProjectStageOrientation (idProjectStageOrientation, idProjectStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate)
select idProjectStageOrientation, idProjectStage, txTitle, txOrientationCode, dtInserted, dtLastUpdate
from tmp_ProjectStageOrientation;

#WARNING: Drop cancelled because columns cannot be restored: txOrientationCode
#drop table if exists tmp_ProjectStageOrientation;
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
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack),
   key AK_ProjectTrack (idProjectTrack, coGrade, coComponent),
   key AK_ProjectTrackcoGrade (idProjectTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txGuidanceBNCC
insert into ProjectTrack (idProjectTrack, coGrade, txTitle, txDescription, coComponent, dtInserted, dtLastUpdate, txGuidanceBNCC)
select idProjectTrack, coGrade, txTitle, txDescription, coComponent, dtInserted, dtLastUpdate, txGuidanceBNCC
from tmp_ProjectTrack;

#WARNING: Drop cancelled because columns cannot be restored: txGuidanceBNCC
#drop table if exists tmp_ProjectTrack;
/*==============================================================*/
/* Table: ProjectTrackStage                                     */
/*==============================================================*/
create table ProjectTrackStage
(
   idProjectTrackStage  int not null,
   idProjectTrack       int not null,
   coGrade              char(4) not null,
   idEvidence           int,
   txDescription        varchar(300),
   nuOrder              tinyint not null,
   txGuidanceCode       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrackStage),
   key AK_ProjectTrackStage (idProjectTrackStage, coGrade),
   key AK_ProjectTrackStagecoGrade (idProjectTrackStage, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txGuidanceCode
insert into ProjectTrackStage (idProjectTrackStage, idProjectTrack, coGrade, idEvidence, txDescription, nuOrder, dtInserted, dtLastUpdate, txGuidanceCode)
select idProjectTrackStage, idProjectTrack, coGrade, idEvidence, txDescription, nuOrder, dtInserted, dtLastUpdate, txGuidanceCode
from tmp_ProjectTrackStage;

#WARNING: Drop cancelled because columns cannot be restored: txGuidanceCode
#drop table if exists tmp_ProjectTrackStage;
alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion) on delete restrict on update restrict;

alter table DiagnosticQuestion add constraint FK_DiagnosticQuestion_Ability foreign key (idAbility)
      references Ability (idAbility) on delete restrict on update restrict;

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion) on delete restrict on update restrict;

alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_LessonActivityOrientation foreign key (idLessonActivityOrientation)
      references LessonActivityOrientation (idLessonActivityOrientation) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonSchoolSupply add constraint FK_LessonSchoolSupply_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict;

alter table LessonTrack add constraint FK_LessonTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonTrack add constraint FK_LessonTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade, coComponent)
      references LessonTrack (idLessonTrack, coGrade, coComponent) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrackStage foreign key (idProjectTrackStage, coGrade)
      references ProjectTrackStage (idProjectTrackStage, coGrade) on delete restrict on update restrict;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceFixed foreign key (idEvidenceFixed, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_EvidenceVariable foreign key (idEvidenceVariable, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_MediaInformation foreign key (IdMediaRoadmap)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectTrackStage foreign key (idProjectTrackStage)
      references ProjectTrackStage (idProjectTrackStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSchoolSupply add constraint FK_ProjectStageSchoolSupply_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_ProjectStageOrientation foreign key (idProjectStageOrientation)
      references ProjectStageOrientation (idProjectStageOrientation) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (idProjectTrack, coGrade, coComponent)
      references ProjectTrack (idProjectTrack, coGrade, coComponent) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectTrackStage add constraint FK_ProjectTrackStage_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict;

