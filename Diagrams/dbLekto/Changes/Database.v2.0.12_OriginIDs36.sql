/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     05-Sep-22 20:54:02                           */
/*==============================================================*/


alter table LektoUser
   modify column txCodeOrigin varchar(36);

alter table School
   modify column txCodeOrigin varchar(36);

alter table SchoolClass
   modify column txCodeOrigin varchar(36);

