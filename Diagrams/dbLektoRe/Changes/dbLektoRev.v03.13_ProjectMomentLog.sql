/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     4/23/2023 7:29:23 PM                         */
/*==============================================================*/


/*==============================================================*/
/* Table: ProjectMomentLog                                      */
/*==============================================================*/
create table ProjectMomentLog
(
   ProjectMomentLog     bigint not null auto_increment,
   idProjectMoment      int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   dtInserted           datetime not null,
   txLog                text,
   primary key (ProjectMomentLog)
);

alter table ProjectMomentLog add constraint FK_ProjectMomentLog_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

