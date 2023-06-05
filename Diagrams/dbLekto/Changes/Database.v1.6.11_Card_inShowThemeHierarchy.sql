/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     2/15/2022 4:50:10 PM                         */
/*==============================================================*/


alter table Card
   add inShowThemeHierarchy bit                  null constraint DF_Card_inShowThemeHierarchy default 0
GO

