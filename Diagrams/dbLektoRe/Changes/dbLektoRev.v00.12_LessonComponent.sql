/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/20/2023 8:16:42 PM                         */
/*==============================================================*/


alter table ClassTrack drop constraint FK_ClassTrack_Component;

alter table ClassTrack drop constraint FK_ClassTrack_Grade;

alter table ClassTrackLesson drop constraint FK_ClassTrackLesson_ClassTrack;

alter table LessonMoment drop constraint FK_LessonMoment_ClassTrack;

alter table ClassTrack
modify column idClassTrack int not null first,
   drop primary key;

drop table if exists tmp_ClassTrack;

rename table ClassTrack to tmp_ClassTrack;

/*==============================================================*/
/* Table: ClassTrack                                            */
/*==============================================================*/
create table ClassTrack
(
   idClassTrack         int not null auto_increment,
   coGrade              char(4) not null,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idClassTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ClassTrack (idClassTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, dtInserted)
select idClassTrack, coGrade, txTitle, txDescription, coComponent, txGuidanceBNCC, ?
from tmp_ClassTrack;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ClassTrack;
/*==============================================================*/
/* Table: LessonComponent                                       */
/*==============================================================*/
create table LessonComponent
(
   idLesson             int not null,
   coComponent          char(3) not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLesson, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table Network
   alter column dtInserted set default (now());

alter table ClassTrack add constraint FK_ClassTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table ClassTrack add constraint FK_ClassTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table ClassTrackLesson add constraint FK_ClassTrackLesson_ClassTrack foreign key (idClassTrack, coGrade)
      references ClassTrack (idClassTrack, coGrade) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict;

alter table LessonComponent add constraint FK_LessonComponent_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_ClassTrack foreign key (idClassTrack, coGrade)
      references ClassTrack (idClassTrack, coGrade) on delete restrict on update restrict;

