/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     04-Nov-22 11:00:10                           */
/*==============================================================*/


drop table if exists tmp_LektoUserType;

rename table LektoUserType to tmp_LektoUserType;

/*==============================================================*/
/* Index: ixNCL_LektoUser_txEmail                               */
/*==============================================================*/
create index ixNCL_LektoUser_txEmail on LektoUser
(
   txEmail
);

/*==============================================================*/
/* Table: LektoUserType                                         */
/*==============================================================*/
create table LektoUserType
(
   idLektoUserType      int not null auto_increment,
   idUser               int not null,
   coUserType           char(4) not null,
   idSchool             int,
   idSchoolNetwork      int,
   dtInserted           datetime not null,
   inDeleted            tinyint(1) not null default 0,
   coDistrictCode       char(2),
   primary key (idLektoUserType),
   key ukNCL_LektoUserType (idUser, coUserType, idSchool, idSchoolNetwork),
   key FK_LektoUserType_District (coDistrictCode)
);

insert into LektoUserType (idLektoUserType, idUser, coUserType, idSchool, idSchoolNetwork, dtInserted, inDeleted, coDistrictCode)
select idLektoUserType, idUser, coUserType, idSchool, idSchoolNetwork, dtInserted, inDeleted, coDistrictCode
from tmp_LektoUserType;

drop table if exists tmp_LektoUserType;

/*==============================================================*/
/* Index: ixNCL_LektoUserType_idSchoolNetwork                   */
/*==============================================================*/
create index ixNCL_LektoUserType_idSchoolNetwork on LektoUserType
(
   idSchoolNetwork
);

/*==============================================================*/
/* Index: ixNCL_LektoUserType_idSchool                          */
/*==============================================================*/
create index ixNCL_LektoUserType_idSchool on LektoUserType
(
   idSchool
);

/*==============================================================*/
/* Index: ixNCL_LektoUserType_coUserType                        */
/*==============================================================*/
create index ixNCL_LektoUserType_coUserType on LektoUserType
(
   coUserType
);

alter table LektoUserType add constraint FK_LektoUserType_District foreign key (coDistrictCode)
      references District (coDistrictCode);

alter table LektoUserType add constraint FK_LektoUserType_School foreign key (idSchool)
      references School (idSchool) on delete cascade;

alter table LektoUserType add constraint FK_LektoUserType_UserType foreign key (coUserType)
      references UserType (coUserType) on delete cascade;

alter table LektoUserType add constraint FK_SchoolNetwork_LektoUserType foreign key (idSchoolNetwork)
      references SchoolNetwork (idSchoolNetwork);

alter table LektoUserType add constraint FK_LEKTOUSE_REFERENCE_LEKTOUSERTYPE foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

