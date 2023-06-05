/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/27/2023 12:03:22 PM                        */
/*==============================================================*/


alter table ClassTrackLesson drop constraint FK_ClassTrackLesson_LessonTrack;

alter table ClassTrackLesson drop constraint FK_ClassTrackLesson_Lesson;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectComponent;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectTrack;

alter table ClassTrackLesson
modify column idClassTrackLesson int not null first,
   drop primary key;

SELECT *
FROM information_schema.REFERENTIAL_CONSTRAINTS
where referenced_table_name = 'ProjectComponent'

alter table ProjectComponent
   drop primary key;

alter table ProjectTrackGroup
   drop primary key;

drop table if exists tmp_ProjectTrackGroup;

rename table ProjectTrackGroup to tmp_ProjectTrackGroup;

rename table ClassTrackLesson to LessonTrackGroup;

alter table LessonTrackGroup
   add primary key (idClassTrackLesson);

alter table ProjectComponent
   add primary key (idProject, coComponent, coProjectComponentType);

/*==============================================================*/
/* Table: ProjectTrackGroup                                     */
/*==============================================================*/
create table ProjectTrackGroup
(
   idProjectTrack       int not null,
   idProject            int not null,
   coComponent          char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coComponent, idProjectTrack, idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into ProjectTrackGroup (idProjectTrack, idProject, coComponent, dtInserted, dtLastUpdate)
select idProjectTrack, idProject, coComponent, dtInserted, dtLastUpdate
from tmp_ProjectTrackGroup;

drop table if exists tmp_ProjectTrackGroup;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idClassTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectComponent foreign key (coComponent, idProject)
      references ProjectComponent (coComponent, idProject) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (coComponent, idProjectTrack)
      references ProjectTrack (coComponent, idProjectTrack) on delete restrict on update restrict;

