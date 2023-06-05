/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     08-Nov-22 13:51:43                           */
/*==============================================================*/


alter table CardEvidence
   add nuOrder smallint not null default 1 comment 'Ordenacao da questao no card.';

