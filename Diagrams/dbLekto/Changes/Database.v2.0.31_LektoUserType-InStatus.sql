/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     09-Nov-22 16:45:31                           */
/*==============================================================*/


alter table CardEvidence
   drop column nuOrder;

alter table LektoUserType
   add inStatus tinyint(1) default 1;

