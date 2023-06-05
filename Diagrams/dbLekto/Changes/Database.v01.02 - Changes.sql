/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     5/25/2020 6:56:50 PM                         */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_Moment_Agenda')
alter table Moment
   drop constraint FK_Moment_Agenda
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_Moment_Tutor')
alter table Moment
   drop constraint FK_Moment_Tutor
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Tutor') and o.name = 'FK_Teacher_Class')
alter table Tutor
   drop constraint FK_Teacher_Class
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Tutor') and o.name = 'FK_Tutor_User')
alter table Tutor
   drop constraint FK_Tutor_User
GO

alter table Agenda
   drop constraint PK_Agenda
GO

alter table Agenda 
   drop constraint DF_Agenda_dtTimeStart
go
alter table Agenda 
   drop constraint DF_Agenda_dtInserted
go
alter table Agenda 
   drop constraint DF_Agenda_inDeleted
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Agenda')
            and   type = 'U')
   drop table tmp_Agenda
GO

execute sp_rename 'Agenda', tmp_Agenda
GO

alter table Tutor
   drop constraint ukNCL_Tutor_idUser_idClass
GO

alter table Tutor
   drop constraint PK_Tutor
GO

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Tutor')
            and   type = 'U')
   drop table tmp_Tutor
GO

execute sp_rename 'Tutor', tmp_Tutor
GO

/*==============================================================*/
/* Table: Agenda                                                */
/*==============================================================*/
create table Agenda (
   idAgenda             int                  identity(1,1),
   dtAgenda             date                 not null,
   dtTimeStart          time                 not null constraint DF_Agenda_dtTimeStart default getdate(),
   dtTimeEnd            time                 null,
   dtInserted           datetime             not null constraint DF_Agenda_dtInserted default getdate(),
   inDeleted            bit                  not null constraint DF_Agenda_inDeleted default 0,
   constraint PK_Agenda primary key (idAgenda)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Agenda') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Agenda' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de calend�rio.
   ', 
   'user', @CurrentUser, 'table', 'Agenda' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Agenda')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'dtTimeStart')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Agenda', 'column', 'dtTimeStart'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Hora de in�cio.',
   'user', @CurrentUser, 'table', 'Agenda', 'column', 'dtTimeStart'

-- */
GO

set identity_insert Agenda on
GO

--WARNING: The following insert order will not restore columns: dtAgenda
insert into Agenda (idAgenda, dtAgenda, dtTimeStart, dtTimeEnd, dtInserted, inDeleted)
select idAgenda, CONVERT(DATE, dtAgenda), CONVERT(TIME, dtTimeStart), CONVERT(TIME, dtTimeEnd), dtInserted, inDeleted
from tmp_Agenda
GO

set identity_insert Agenda off
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON Agenda TO usrLekto
GO

/*==============================================================*/
/* Table: Tutor                                                 */
/*==============================================================*/
create table Tutor (
   idTutor              int                  identity(1,1),
   idUser               int                  not null,
   idClass              int                  not null,
   constraint PK_Tutor primary key (idTutor),
   constraint ukNCL_Tutor_idUser_idClass unique (idUser, idClass)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Tutor') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Tutor' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de tutores.', 
   'user', @CurrentUser, 'table', 'Tutor' 
 
-- */
GO

set identity_insert Tutor on
GO

insert into Tutor (idTutor, idUser, idClass)
select idTutor, idUser, idClass
from tmp_Tutor
GO

set identity_insert Tutor off
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON Tutor TO usrLekto
GO

alter table Moment
   add constraint FK_Moment_Agenda foreign key (idAgenda)
      references Agenda (idAgenda)
GO

alter table Moment
   add constraint FK_Moment_Tutor foreign key (idTutor)
      references Tutor (idTutor)
GO

alter table Tutor
   add constraint FK_Teacher_Class foreign key (idClass)
      references SchoolClass (idSchoolClass)
GO

alter table Tutor
   add constraint FK_Tutor_User foreign key (idUser)
      references LektoUser (idUser)
GO

