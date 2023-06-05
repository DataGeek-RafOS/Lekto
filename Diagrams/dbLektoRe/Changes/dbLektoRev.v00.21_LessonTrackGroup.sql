/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/27/2023 6:30:27 PM                         */
/*==============================================================*/


alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_Lesson;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;

alter table LessonTrackGroup
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
   primary key (idLessonTrackGroup)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonTrackGroup (idLessonTrackGroup, idLessonTrack, idLesson, coGrade)
select idClassTrackLesson, idClassTrack, idLesson, coGrade
from tmp_LessonTrackGroup;

drop table if exists tmp_LessonTrackGroup;

/*==============================================================*/
/* Index: ukNCL_LessonTrackGroup                                */
/*==============================================================*/
create unique index ukNCL_LessonTrackGroup on LessonTrackGroup
(
   idLessonTrack,
   idLesson
);

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict;

