/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     3/21/2022 4:59:39 PM                         */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.SchoolClassSchedule') and o.name = 'FK_SchoolClassSchedule_Schedule')
alter table dbo.SchoolClassSchedule
   drop constraint FK_SchoolClassSchedule_Schedule
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.SchoolClassSchedule') and o.name = 'FK_SchoolClassSchedule_SchoolClass')
alter table dbo.SchoolClassSchedule
   drop constraint FK_SchoolClassSchedule_SchoolClass
GO

if exists (select 1
            from  sysobjects
           where  id = object_id('Schedule')
            and   type = 'U')
   drop table Schedule
GO

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SchoolClassSchedule')
            and   type = 'U')
   drop table dbo.SchoolClassSchedule
GO

