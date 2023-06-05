/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     5/25/2020 8:03:00 PM                         */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ApprenticeProfile') and o.name = 'FK_ApprenticeProfile_ProfileType')
alter table ApprenticeProfile
   drop constraint FK_ApprenticeProfile_ProfileType
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ProfilePersonalization') and o.name = 'FK_ProfilePersonalization_ProfileType')
alter table ProfilePersonalization
   drop constraint FK_ProfilePersonalization_ProfileType
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ProfileTheme') and o.name = 'FK_ProfileTheme_ProfileType')
alter table ProfileTheme
   drop constraint FK_ProfileTheme_ProfileType
GO

alter table ProfileType
   drop constraint PK_ProfileType
GO

alter table ProfileType 
   drop constraint DF_ProfileType_inStatuss
go
alter table ProfileType 
   drop constraint DF_ProfileType_dtInserted
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_ProfileType')
            and   type = 'U')
   drop table tmp_ProfileType
GO

execute sp_rename 'ProfileType', tmp_ProfileType
GO

/*==============================================================*/
/* Table: ProfileType                                           */
/*==============================================================*/
create table ProfileType (
   coProfileType        char(4)              not null,
   txProfileType        varchar(60)          not null,
   inStatus             bit                  not null constraint DF_ProfileType_inStatuss default 1,
   txProfileColor       char(7)              null,
   dtInserted           datetime             not null constraint DF_ProfileType_dtInserted default getdate(),
   constraint PK_ProfileType primary key (coProfileType)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('ProfileType') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'ProfileType' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de tipos de perfis de aprendizes.', 
   'user', @CurrentUser, 'table', 'ProfileType' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ProfileType')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txProfileColor')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ProfileType', 'column', 'txProfileColor'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Cor do perfil.',
   'user', @CurrentUser, 'table', 'ProfileType', 'column', 'txProfileColor'

-- */
GO

insert into ProfileType (coProfileType, txProfileType, inStatus, dtInserted)
select coProfileType, txProfileType, inStatus, dtInserted
from tmp_ProfileType
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON ProfileType TO usrLekto
GO

alter table ApprenticeProfile
   add constraint FK_ApprenticeProfile_ProfileType foreign key (coProfileType)
      references ProfileType (coProfileType)
GO

alter table ProfilePersonalization
   add constraint FK_ProfilePersonalization_ProfileType foreign key (coProfile)
      references ProfileType (coProfileType)
GO

alter table ProfileTheme
   add constraint FK_ProfileTheme_ProfileType foreign key (coProfile)
      references ProfileType (coProfileType)
GO

