/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/26/2023 8:57:55 PM                         */
/*==============================================================*/


alter table ClassTrackLesson drop constraint FK_ClassTrackLesson_Lesson;

alter table Lesson drop constraint FK_Lesson_Grade;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;

alter table LessonComponent drop constraint FK_LessonComponent_Component;

alter table LessonComponent drop constraint FK_LessonComponent_Lesson;

alter table LessonOrientation drop constraint FK_LessonOrientation_LessonStep;

alter table LessonStep drop constraint FK_Step_Lesson;

alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;

alter table LessonStepEvidence drop constraint FK_LessonStepEvidence_LessonStep;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_LessonOrientation;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_MediaInformation;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_SupportReferenceType;

alter table LessonTrack drop constraint FK_LessonTrack_Component;

alter table ProjectComponent drop constraint FK_ProjectComponent_ProjectComponentType;



alter table Lesson
modify column idLesson int not null first,
   drop primary key;

drop table if exists tmp_Lesson;

rename table Lesson to tmp_Lesson;

alter table LessonComponent
   drop primary key;

drop table if exists tmp_LessonComponent;

rename table LessonComponent to tmp_LessonComponent;

drop table if exists LessonOrientation;

alter table LessonStep
   drop primary key;

drop table if exists tmp_LessonStep;

rename table LessonStep to tmp_LessonStep;

alter table LessonSupportReference
modify column idLessonSupportReference int not null first,
   drop primary key;

drop table if exists tmp_LessonSupportReference;

rename table LessonSupportReference to tmp_LessonSupportReference;

alter table LessonTrack
   drop column coComponent;

alter table ProjectComponentType
   drop primary key;

drop table if exists tmp_ProjectComponentType;

rename table ProjectComponentType to tmp_ProjectComponentType;

/*==============================================================*/
/* Table: ComponentType                                         */
/*==============================================================*/
create table ComponentType
(
   coComponentType      char(3) not null,
   txComponentType      varchar(30) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coComponentType)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will not restore columns: txProjectComponentType
insert into ComponentType (coComponentType, txComponentType, dtInserted, dtLastUpdate)
select coProjectComponentType, txProjectComponentType, dtInserted, dtLastUpdate
from tmp_ProjectComponentType;

#WARNING: Drop cancelled because columns cannot be restored: txProjectComponentType
#drop table if exists tmp_ProjectComponentType;
/*==============================================================*/
/* Table: Lesson                                                */
/*==============================================================*/
create table Lesson
(
   idLesson             int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(300),
   txGuidance           varchar(2000),
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Lesson (idLesson, coGrade, txTitle, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLesson, coGrade, txTitle, txGuidance, dtInserted, dtLastUpdate
from tmp_Lesson;

drop table if exists tmp_Lesson;

/*==============================================================*/
/* Table: LessonComponent                                       */
/*==============================================================*/
create table LessonComponent
(
   idLesson             int not null,
   coComponent          char(3) not null,
   coGrade              char(4) not null,
   coComponentType      char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonComponent (idLesson, coComponent, coGrade, coComponentType, dtInserted, dtLastUpdate)
select idLesson, coComponent, coGrade, 'PRI', dtInserted, dtLastUpdate
from tmp_LessonComponent;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonComponent;
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
   txGuidance           varchar(2000) not null,
   txGuidanceBNCC       varchar(2000) not null comment 'Orientacoes gerais da aula (html)
            ',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStep),
   key AK_LessonStep (coGrade, idLessonStep)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonStep (idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, txGuidance, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonStep, coGrade, idLesson, nuOrder, txTitle, nuDuration, '', '', dtInserted, dtLastUpdate
from tmp_LessonStep;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep_;

drop table if exists tmp_LessonStep;
/*==============================================================*/
/* Table: LessonStepSupportReference                            */
/*==============================================================*/
create table LessonStepSupportReference
(
   idLessonStepSupportReference int not null auto_increment,
   idLessonStep         int not null,
   txTitle              varchar(120) not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int not null,
   txReference          varchar(300) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStepSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonStepSupportReference (idLessonStepSupportReference, idLessonStep, txTitle, coSupportReference, IdMediaInformation, txReference, txReferenceNumber, dtInserted, dtLastUpdate)
select idLessonSupportReference, 1, txTitle, coSupportReference, IdMediaInformation, txReference, txReferenceNumber, dtInserted, dtLastUpdate
from tmp_LessonSupportReference;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonSupportReference;
/*==============================================================*/
/* Table: LessonSupportReference                                */
/*==============================================================*/
create table LessonSupportReference
(
   idLessonSupportReference int not null auto_increment,
   idLesson             int,
   coGrade              char(4),
   IdMediaInformation   int,
   coSupportReference   char(4),
   txTitle              varchar(120) not null,
   txReference          varchar(300) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table ClassTrackLesson add constraint FK_ClassTrackLesson_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table Lesson add constraint FK_Lesson_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity__LessonStep foreign key (coGrade, idStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_ComponentType foreign key (coComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonStep add constraint FK_LessonStep_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (coGrade, idLessonStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict;

alter table LessonStepEvidence add constraint FK_LessonStepEvidence_LessonStep foreign key (coGrade, idLessonStep)
      references LessonStep (coGrade, idLessonStep) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table LessonSupportReference add constraint FK_LessonSupportReference_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonSupportReference add constraint FK_LessonSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table LessonSupportReference add constraint FK_LessonSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict;

alter table ProjectComponent add constraint FK_ProjectComponent_ComponentType foreign key (coProjectComponentType)
      references ComponentType (coComponentType) on delete restrict on update restrict;

