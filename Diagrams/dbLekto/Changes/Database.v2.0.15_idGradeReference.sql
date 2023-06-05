/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     08-Sep-22 18:00:29                           */
/*==============================================================*/


alter table Grade
   add idGradeReference int comment 'Id da série que será exposto para integrações externas.';

