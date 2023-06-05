/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/20/2023 6:17:29 PM                         */
/*==============================================================*/


alter table Network drop constraint FK_Network_District;

alter table Network
   modify column coDistrict char(2);

alter table Network add constraint FK_Network_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict;

