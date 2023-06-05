/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     4/2/2023 1:40:32 PM                          */
/*==============================================================*/


alter table LessonActivityOrientation
   add inDeleted char(10) not null default '0';

alter table LessonActivitySupportReference
   add inDeleted char(10) not null default '0';

alter table ProjectStageOrientation
   add inDeleted char(10) not null default '0';

alter table ProjectStageSupportReference
   add inDeleted char(10) not null default '0';

