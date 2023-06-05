/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/16/2023 6:53:04 PM                         */
/*==============================================================*/


/*==============================================================*/
/* Table: UserProfileRegional                                   */
/*==============================================================*/
create table UserProfileRegional
(
   idUserProfileRegional int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   coProfile            char(4) not null,
   idRegionalNetwork    int not null,
   primary key (idUserProfileRegional)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Index: ukNCL_UserProfileRegional                             */
/*==============================================================*/
create unique index ukNCL_UserProfileRegional on UserProfileRegional
(
   idNetwork,
   idUser,
   coProfile,
   idRegionalNetwork
);

/*==============================================================*/
/* Table: UserProfileSchool                                     */
/*==============================================================*/
create table UserProfileSchool
(
   idUserProfileSchool  int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   coProfile            char(4) not null,
   idSchool             int not null,
   primary key (idUserProfileSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Index: ukNCL_UserProfileSchool                               */
/*==============================================================*/
create unique index ukNCL_UserProfileSchool on UserProfileSchool
(
   idNetwork,
   idUser,
   coProfile,
   idSchool
);

alter table UserProfileRegional add constraint FK_UserProfileRegional_Network foreign key (idRegionalNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table UserProfileRegional add constraint FK_UserProfileRegional_UserProfile foreign key (idNetwork, idUser, coProfile)
      references UserProfile (idNetwork, idUser, coProfile) on delete restrict on update restrict;

alter table UserProfileSchool add constraint FK_UserProfileSchool_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict;

alter table UserProfileSchool add constraint FK_UserProfileSchool_UserProfile foreign key (idNetwork, idUser, coProfile)
      references UserProfile (idNetwork, idUser, coProfile) on delete restrict on update restrict;

