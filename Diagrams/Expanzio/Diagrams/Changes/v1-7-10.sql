/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     3/4/2022 5:38:45 PM                          */
/*==============================================================*/


alter table Task add constraint FK_Task_UnitDocm foreign key (UnitDocumentationId)
      references UnitDocumentation (UnitDocumentationId) on delete restrict on update restrict;

