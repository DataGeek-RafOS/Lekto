/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     5/16/2023 3:30:08 PM                         */
/*==============================================================*/


drop table if exists tmp_Class;

rename table Class to tmp_Class;

drop table if exists tmp_School;

rename table School to tmp_School;

/*==============================================================*/
/* Table: Class                                                 */
/*==============================================================*/
create table Class
(
   idClass              int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   txName               varchar(50) not null,
   inStatus             tinyint(1) not null default 1,
   txCodeOrigin         varchar(36),
   coClassShift         char(3),
   inSenseDataSync      tinyint(1) default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idClass),
   unique key AK_Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
);

insert into Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear, txName, inStatus, txCodeOrigin, coClassShift, dtInserted, dtLastUpdate)
select idClass, idNetwork, idSchool, coGrade, idSchoolYear, txName, inStatus, txCodeOrigin, coClassShift, dtInserted, dtLastUpdate
from tmp_Class;

alter table LessonMoment drop constraint FK_LessonMoment_Class;

alter table StudentClass drop constraint FK_StudentClass_Class;

alter table Professor drop constraint FK_Professor_Class;

alter table ProjectMoment drop constraint FK_ProjectMoment_Class;

drop table if exists tmp_Class;


/*==============================================================*/
/* Index: ukNCL_Class_CodeOrigin                                */
/*==============================================================*/
create unique index ukNCL_Class_CodeOrigin on Class
(
   idNetwork,
   txCodeOrigin
);

/*==============================================================*/
/* Table: School                                                */
/*==============================================================*/
create table School
(
   idNetwork            int not null,
   idSchool             int not null auto_increment,
   txName               varchar(200) not null,
   txCnpj               char(14),
   inStatus             tinyint(1) not null default 1,
   idSubNetwork         int,
   IdMediaInfoLogo      int,
   txCodeOrigin         varchar(36),
   inSenseDataSync      tinyint(1) default 0,
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool),
   unique key ukNCL_School_idSchool (idSchool)
);

insert into School (idNetwork, idSchool, txName, txCnpj, inStatus, idSubNetwork, IdMediaInfoLogo, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate)
select idNetwork, idSchool, txName, txCnpj, inStatus, idSubNetwork, IdMediaInfoLogo, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate
from tmp_School;

alter table SchoolAddress drop constraint FK_SchoolAddress_School;
alter table SchoolGrade drop constraint FK_SchoolGrade_School;
alter table UserProfileSchool drop constraint FK_UserProfileSchool_School;

drop table if exists tmp_School;

/*==============================================================*/
/* Index: ukNCL_School_txCodeOrigin                             */
/*==============================================================*/
create unique index ukNCL_School_txCodeOrigin on School
(
   txCodeOrigin,
   idNetwork
);

alter table Class add constraint FK_Class_ClassShift foreign key (coClassShift)
      references ClassShift (coClassShift) on delete restrict on update restrict;

alter table Class add constraint FK_Class_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict;

alter table Class add constraint FK_Class_SchoolYear foreign key (idSchoolYear)
      references SchoolYear (idSchoolYear) on delete restrict on update restrict;

alter table LessonMoment add constraint FK_LessonMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table ProjectMoment add constraint FK_ProjectMoment_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table School add constraint FK_School_MediaInformation foreign key (IdMediaInfoLogo)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table School add constraint FK_School_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table School add constraint FK_School_SubNetwork foreign key (idSubNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table SchoolAddress add constraint FK_SchoolAddress_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

alter table SchoolGrade add constraint FK_SchoolGrade_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

alter table StudentClass add constraint FK_StudentClass_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict;

alter table UserProfileSchool add constraint FK_UserProfileSchool_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

