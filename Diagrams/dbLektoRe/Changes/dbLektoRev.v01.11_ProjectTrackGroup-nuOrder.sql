/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/10/2023 2:55:45 PM                         */
/*==============================================================*/


alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectComponent;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectTrack;

alter table ProjectTrackGroup
   drop primary key;

drop table if exists tmp_ProjectTrackGroup;

rename table ProjectTrackGroup to tmp_ProjectTrackGroup;

/*==============================================================*/
/* Table: ProjectTrackGroup                                     */
/*==============================================================*/
create table ProjectTrackGroup
(
   idProjectTrack       int not null,
   idProject            int not null,
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   nuOrder              smallint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack, idProject),
   key AK_ProjectTrackGroup (idProjectTrack, idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectTrackGroup (idProjectTrack, idProject, coGrade, coComponent, nuOrder, dtInserted, dtLastUpdate)
select idProjectTrack, idProject, coGrade, coComponent, 1, dtInserted, dtLastUpdate
from tmp_ProjectTrackGroup;

#WARNING: Drop cancelled because mandatory columns must have a value
drop table if exists tmp_ProjectTrackGroup;
alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectComponent foreign key (coComponent, coGrade, idProject)
      references ProjectComponent (coComponent, coGrade, idProject) on delete restrict on update restrict;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (idProjectTrack, coGrade, coComponent)
      references ProjectTrack (idProjectTrack, coGrade, coComponent) on delete restrict on update restrict;

