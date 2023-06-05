/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/21/2023 12:09:51 PM                        */
/*==============================================================*/


alter table UserProfileSchool
   add unique AK_UserProfileSchool (idNetwork, idSchool);

drop constraint AK_UserProfileSchool on UserProfileSchool;

/*==============================================================*/
/* Index: ukNCL_UserProfileSchool                               */
/*==============================================================*/
create unique index ukNCL_UserProfileSchool on UserProfileSchool
(
   idNetwork,
   idSchool,
   idUserProfile
);

ALTER TABLE `dbLekto`.`UserProfileSchool` 
DROP INDEX `AK_UserProfileSchool`;