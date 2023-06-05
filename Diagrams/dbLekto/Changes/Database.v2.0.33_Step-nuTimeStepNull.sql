/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     10-Nov-22 16:35:09                           */
/*==============================================================*/


alter table Step
   modify column nuTimeStep smallint;

alter table Step
   alter column nuTimeStep drop default;

