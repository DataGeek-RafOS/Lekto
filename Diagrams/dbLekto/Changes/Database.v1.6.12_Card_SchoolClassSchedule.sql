/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     3/18/2022 11:39:20 AM                        */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SchoolClass') and o.name = 'FK_SchoolClass_Schedule')
alter table SchoolClass
   drop constraint FK_SchoolClass_Schedule
GO
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('SchoolClass') and o.name = 'FK_SCHOOLCL_REFERENCE_SCHEDULE')
alter table SchoolClass
   drop constraint FK_SCHOOLCL_REFERENCE_SCHEDULE
GO

/*==============================================================*/
/* Table: SchoolClassSchedule                                   */
/*==============================================================*/
create table dbo.SchoolClassSchedule (
   idSchoolClass        int                  not null,
   idSchedule           int                  not null,
   constraint PK_SchoolClassSchedule primary key (idSchoolClass, idSchedule)
)
GO

INSERT INTO dbo.SchoolClassSchedule (idSchoolClass, idSchedule)
SELECT idSchoolClass, idSchedule
FROM dbo.SchoolClass


GRANT SELECT,INSERT,DELETE,UPDATE ON dbo.SchoolClassSchedule TO usrLekto
GO

alter table dbo.SchoolClassSchedule
   add constraint FK_SchoolClassSchedule_Schedule foreign key (idSchedule)
      references Schedule (idSchedule)
GO

alter table dbo.SchoolClassSchedule
   add constraint FK_SchoolClassSchedule_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass)
GO

alter table SchoolClass
   drop column idSchedule
GO

