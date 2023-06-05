/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/10/2023 3:22:14 PM                         */
/*==============================================================*/


alter table LessonMoment drop constraint FK_LessonMoment_LessonTrackGroup;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonComponent;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;

alter table LessonTrackGroup
modify column idLessonTrackGroup int not null first,
   drop primary key;

drop table if exists tmp_LessonTrackGroup;

rename table LessonTrackGroup to tmp_LessonTrackGroup;

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
   nuOrder              smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrackGroup),
   key AK_LessonTrackGroup (idLessonTrack, idLesson, coGrade, coComponent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonTrackGroup (idLessonTrackGroup, idLessonTrack, idLesson, coGrade, coComponent, nuOrder, dtInserted, dtLastUpdate)
select idLessonTrackGroup, idLessonTrack, idLesson, coGrade, coComponent, 1, dtInserted, dtLastUpdate
from tmp_LessonTrackGroup;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonTrackGroup;
alter table LessonMoment add constraint FK_LessonMoment_LessonTrackGroup foreign key (idLessonTrackGroup)
      references LessonTrackGroup (idLessonTrackGroup) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonComponent foreign key (idLesson, coGrade, coComponent)
      references LessonComponent (idLesson, coGrade, coComponent) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade, coComponent)
      references LessonTrack (idLessonTrack, coGrade, coComponent) on delete restrict on update restrict;

