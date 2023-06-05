/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     5/22/2020 3:09:07 PM                         */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AccessControl') and o.name = 'FK_AccessControl_LektoUser')
alter table AccessControl
   drop constraint FK_AccessControl_LektoUser
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Apprentice') and o.name = 'FK_Apprentice_User')
alter table Apprentice
   drop constraint FK_Apprentice_User
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('LektoUser') and o.name = 'FK_User_UserType')
alter table LektoUser
   drop constraint FK_User_UserType
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Notification') and o.name = 'FK_Notification_User')
alter table Notification
   drop constraint FK_Notification_User
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Relationship') and o.name = 'FK_Relationship_LektoUser')
alter table Relationship
   drop constraint FK_Relationship_LektoUser
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Relationship') and o.name = 'FK_Relationship_LektoUserBound')
alter table Relationship
   drop constraint FK_Relationship_LektoUserBound
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Tutor') and o.name = 'FK_Tutor_User')
alter table Tutor
   drop constraint FK_Tutor_User
GO

alter table LektoUser
   drop constraint PK_LektoUser
GO

alter table LektoUser 
   drop constraint DF_LektoUser_inStatus
go
alter table LektoUser 
   drop constraint DF_LektoUser_dtInserted
go
alter table LektoUser 
   drop constraint DF_LektoUser_inDeleted
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_LektoUser')
            and   type = 'U')
   drop table tmp_LektoUser
GO

execute sp_rename 'LektoUser', tmp_LektoUser
GO

/*==============================================================*/
/* Table: LektoUser                                             */
/*==============================================================*/
create table LektoUser (
   idUser               int                  identity(1,1),
   coUserType           char(4)              not null,
   txName               varchar(120)         not null,
   inStatus             bit                  not null constraint DF_LektoUser_inStatus default 1,
   idAuth0              varchar(64)          not null,
   txImagePath          varchar(300)         null,
   dtInserted           datetime             not null constraint DF_LektoUser_dtInserted default getdate(),
   inDeleted            bit                  not null constraint DF_LektoUser_inDeleted default 0,
   constraint PK_LektoUser primary key (idUser)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('LektoUser') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'LektoUser' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de usu�rios.', 
   'user', @CurrentUser, 'table', 'LektoUser' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('LektoUser')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txImagePath')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'LektoUser', 'column', 'txImagePath'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Caminho da imagem.',
   'user', @CurrentUser, 'table', 'LektoUser', 'column', 'txImagePath'

-- */
GO

set identity_insert LektoUser on
GO

--WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LektoUser (idUser, coUserType, txName, inStatus, idAuth0, txImagePath, dtInserted, inDeleted)
select idUser, coUserType, txName, inStatus, '0', txImagePath, dtInserted, inDeleted
from tmp_LektoUser
GO

set identity_insert LektoUser off
GO

GRANT UPDATE,INSERT,SELECT,DELETE ON LektoUser TO usrLekto
GO

alter table AccessControl
   add constraint FK_AccessControl_LektoUser foreign key (idUser)
      references LektoUser (idUser)
GO

alter table Apprentice
   add constraint FK_Apprentice_User foreign key (idUser)
      references LektoUser (idUser)
GO

alter table LektoUser
   add constraint FK_User_UserType foreign key (coUserType)
      references UserType (coUserType)
GO

alter table Notification
   add constraint FK_Notification_User foreign key (idUser)
      references LektoUser (idUser)
GO

alter table Relationship
   add constraint FK_Relationship_LektoUser foreign key (idUser)
      references LektoUser (idUser)
GO

alter table Relationship
   add constraint FK_Relationship_LektoUserBound foreign key (idUserBound)
      references LektoUser (idUser)
GO

alter table Tutor
   add constraint FK_Tutor_User foreign key (idUser)
      references LektoUser (idUser)
GO

