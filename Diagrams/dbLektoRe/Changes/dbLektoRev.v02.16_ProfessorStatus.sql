/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/1/2023 8:47:56 PM                          */
/*==============================================================*/


alter table LessonMoment drop constraint FK_LessonMoment_Professor;

alter table Professor drop constraint FK_Professor_Class;

alter table Professor drop constraint FK_Professor_LektoUser;

alter table ProjectMoment drop constraint FK_ProjectMoment_Professor;

alter table Professor
modify column idProfessor int not null first,
   drop primary key;

drop table if exists tmp_Professor;

rename table Professor to tmp_Professor;

/*==============================================================*/
/* Table: Professor                                             */
/*==============================================================*/
create table Professor
(
   idProfessor          int not null auto_increment,
   idNetwork            int not null,
   idUserProfessor      int not null,
   idClass              int,
   idSchool             int,
   coGrade              char(4),
   idSchoolYear         smallint,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProfessor),
   key AK_Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Professor (idProfessor, idNetwork, idUserProfessor, idClass, idSchool, coGrade, idSchoolYear, dtInserted, dtLastUpdate)
select idProfessor, idNetwork, idUserProfessor, idClass, idSchool, coGrade, idSchoolYear, dtInserted, dtLastUpdate
from tmp_Professor;

drop table if exists tmp_Professor;

alter table LessonMoment add constraint FK_LessonMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUserProfessor)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

