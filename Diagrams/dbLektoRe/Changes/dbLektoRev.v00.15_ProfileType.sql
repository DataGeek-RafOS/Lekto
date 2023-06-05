/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/25/2023 3:37:02 PM                         */
/*==============================================================*/


alter table UserProfile drop constraint FK_UserProfile_Profile;

alter table Profile
   drop primary key;

alter table School
   drop column txCodeIntegrator;

rename table Profile to ProfileType;

alter table ProfileType
   add primary key (coProfile);

alter table UserProfile add constraint FK_UserProfile_ProfileType foreign key (coProfile)
      references ProfileType (coProfile) on delete restrict on update restrict;

