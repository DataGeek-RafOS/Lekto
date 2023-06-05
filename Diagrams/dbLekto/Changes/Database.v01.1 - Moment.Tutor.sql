/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     5/25/2020 3:41:05 PM                         */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ApprenticeMoment') and o.name = 'FK_Group_Moment')
alter table ApprenticeMoment
   drop constraint FK_Group_Moment
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_Moment_Agenda')
alter table Moment
   drop constraint FK_Moment_Agenda
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_Moment_Card')
alter table Moment
   drop constraint FK_Moment_Card
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_Moment_MomentStatus')
alter table Moment
   drop constraint FK_Moment_MomentStatus
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('MomentNotes') and o.name = 'FK_MomentNotes_Moment')
alter table MomentNotes
   drop constraint FK_MomentNotes_Moment
GO

alter table Moment
   drop constraint PK_Moment
GO

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Moment')
            and   type = 'U')
   drop table tmp_Moment
GO

execute sp_rename 'Moment', tmp_Moment
GO

alter table Tutor
   drop constraint PK_Tutor
GO

/*==============================================================*/
/* Table: Moment                                                */
/*==============================================================*/
create table Moment (
   idMoment             int                  identity(1,1),
   idAgenda             int                  not null,
   idTutor              int                  not null,
   idCard               int                  not null,
   coMomentStatus       char(4)              not null,
   constraint PK_Moment primary key (idMoment)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Moment') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Moment' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de momentos.', 
   'user', @CurrentUser, 'table', 'Moment' 
 
-- */
GO

set identity_insert Moment on
GO

--WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Moment (idMoment, idAgenda, idTutor, idCard, coMomentStatus)
select idMoment, idAgenda, 1, idCard, coMomentStatus
from tmp_Moment
GO

set identity_insert Moment off
GO

GRANT DELETE,UPDATE,INSERT,SELECT ON Moment TO usrLekto
GO

alter table Tutor
   add constraint PK_Tutor primary key (idTutor)
GO

alter table ApprenticeMoment
   add constraint FK_Group_Moment foreign key (idMoment)
      references Moment (idMoment)
GO

alter table Moment
   add constraint FK_Moment_Agenda foreign key (idAgenda)
      references Agenda (idAgenda)
GO

alter table Moment
   add constraint FK_Moment_Card foreign key (idCard)
      references Card (idCard)
GO

alter table Moment
   add constraint FK_Moment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus)
GO

alter table Moment
   add constraint FK_Moment_Tutor foreign key (idTutor)
      references Tutor (idTutor)
GO

alter table MomentNotes
   add constraint FK_MomentNotes_Moment foreign key (idMoment)
      references Moment (idMoment)
GO

