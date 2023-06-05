/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     14-Oct-22 14:39:09                           */
/*==============================================================*/


alter table SegmentSchoolClass
   add inProcessed tinyint(1) not null default 0;

