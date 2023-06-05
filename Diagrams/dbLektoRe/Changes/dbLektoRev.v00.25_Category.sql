/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/30/2023 11:42:30 AM                        */
/*==============================================================*/


alter table LessonActivity drop constraint FK_LessonActivity_Category;

alter table ProjectCategory drop constraint FK_ProjectCategory_Project;

alter table ProjectCategory drop constraint FK_ProjectCategory_Category;

alter table School drop constraint FK_School_MediaInformation;

alter table School drop constraint FK_School_Network;

alter table SchoolAddress drop constraint FK_SchoolAddress_School;

alter table SchoolGrade drop constraint FK_SchoolGrade_School;

alter table UserProfileSchool drop constraint FK_UserProfileSchool_School;

alter table Category
modify column idCategory smallint not null first,
   drop primary key;

drop table if exists tmp_Category;

rename table Category to tmp_Category;

alter table ProjectCategory
   drop primary key;

drop table if exists tmp_ProjectCategory;

rename table ProjectCategory to tmp_ProjectCategory;

alter table School
modify column idSchool smallint not null first,
   drop primary key;

drop table if exists tmp_School;

rename table School to tmp_School;

/*==============================================================*/
/* Table: Category                                              */
/*==============================================================*/
create table Category
(
   idCategory           smallint not null auto_increment,
   coGrade              char(4) not null,
   txName               varchar(100) not null,
   txImagePath          varchar(80) comment 'Caminho da imagem.',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCategory, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Category (idCategory, coGrade, txName, txImagePath, dtInserted, dtLastUpdate)
select idCategory, 1, txName, txImagePath, dtInserted, dtLastUpdate
from tmp_Category;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Category;
/*==============================================================*/
/* Table: ProjectCategory                                       */
/*==============================================================*/
create table ProjectCategory
(
   idProject            int not null,
   idCategory           smallint not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProject, idCategory, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectCategory (idProject, idCategory, coGrade, dtInserted, dtLastUpdate)
select idProject, idCategory, 1, dtInserted, dtLastUpdate
from tmp_ProjectCategory;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectCategory;
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
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool),
   unique key ukNCL_School_idSchool (idSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into School (idNetwork, idSchool, txName, txCnpj, inStatus, IdMediaInfoLogo, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate)
select idNetwork, idSchool, txName, txCnpj, inStatus, IdMediaInfoLogo, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate
from tmp_School;

drop table if exists tmp_School;

/*==============================================================*/
/* Index: ukNCL_School_txCodeOrigin                             */
/*==============================================================*/
create unique index ukNCL_School_txCodeOrigin on School
(
   txCodeOrigin,
   idNetwork
);

alter table Category add constraint FK_Category_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;
	 
alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 

alter table LessonActivity add constraint FK_LessonActivity_Category foreign key (idCategory, coGrade)
      references Category (idCategory, coGrade) on delete restrict on update restrict;
	 

alter table ProjectCategory add constraint FK_ProjectCategory_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectCategory add constraint FK_ProjectCategory_Category foreign key (idCategory, coGrade)
      references Category (idCategory, coGrade) on delete restrict on update restrict;

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

alter table UserProfileSchool add constraint FK_UserProfileSchool_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

