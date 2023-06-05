/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     3/7/2023 4:45:35 PM                          */
/*==============================================================*/

alter table UserProfileRegional drop constraint FK_UserProfileRegional_Network;

drop index ukNCL_UserProfileRegional on UserProfileRegional;

/*==============================================================*/
/* Index: ukNCL_UserProfileRegional                             */
/*==============================================================*/
create unique index ukNCL_UserProfileRegional on UserProfileRegional
(
   idUserProfile,
   idRegionalNetwork
);


alter table UserProfileRegional add constraint FK_UserProfileRegional_Network foreign key (idRegionalNetwork)
      references Network (idNetwork) on delete restrict on update restrict;
