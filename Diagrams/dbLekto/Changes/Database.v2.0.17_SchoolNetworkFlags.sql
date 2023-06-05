/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     9/14/2022 8:42:06 PM                         */
/*==============================================================*/


alter table SchoolNetwork
   add inAdminLektoEnabled tinyint(1) not null default 1;

alter table SchoolNetwork
   add inSingleSignOn tinyint(1) not null default 0;

