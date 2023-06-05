/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     2/11/2022 9:02:56 PM                         */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Card') and o.name = 'FK_Card_Theme')
alter table Card
   drop constraint FK_Card_Theme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_Moment_Theme')
alter table Moment
   drop constraint FK_Moment_Theme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ProfileTheme') and o.name = 'FK_ProfileTheme_Theme')
alter table ProfileTheme
   drop constraint FK_ProfileTheme_Theme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('RoomTheme') and o.name = 'FK_RoomTheme_Theme')
alter table RoomTheme
   drop constraint FK_RoomTheme_Theme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ThemeSubtheme') and o.name = 'FK_ThemeSubtheme_Theme')
alter table ThemeSubtheme
   drop constraint FK_ThemeSubtheme_Theme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ThemeSubtheme') and o.name = 'FK_ThemeSubtheme_idSubTheme')
alter table ThemeSubtheme
   drop constraint FK_ThemeSubtheme_idSubTheme
GO

alter table Theme
   drop constraint PK_Theme
GO

alter table Theme 
   drop constraint DF_Theme_inStatus
go
alter table Theme 
   drop constraint DF_Theme_dtInserted
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Theme')
            and   type = 'U')
   drop table tmp_Theme
GO

execute sp_rename 'Theme', tmp_Theme
GO

if exists (select 1
            from  sysobjects
           where  id = object_id('ThemeSubtheme')
            and   type = 'U')
   drop table ThemeSubtheme
GO

/*==============================================================*/
/* Table: Theme                                                 */
/*==============================================================*/
create table Theme (
   idTheme              smallint             identity(1,1),
   idThemeReference     smallint             null,
   idThemeConfiguration smallint             null,
   inStatus             bit                  not null constraint DF_Theme_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Theme_dtInserted default getdate(),
   constraint PK_Theme primary key (idTheme)
)
GO

set identity_insert Theme on
GO

insert into Theme (idTheme, inStatus, dtInserted)
select idTheme, inStatus, dtInserted
from tmp_Theme
GO

set identity_insert Theme off
GO

GRANT UPDATE,INSERT,SELECT,DELETE ON Theme TO usrLekto
GO

/*==============================================================*/
/* Table: ThemeConfiguration                                    */
/*==============================================================*/
create table ThemeConfiguration (
   idThemeConfiguration smallint             identity(1,1),
   txTheme              varchar(80)          not null,
   txImagePath          varchar(300)         null,
   txPrimaryColor       varchar(8)           null,
   txBgPrimaryColor     varchar(8)           null,
   inSubtheme           bit                  not null constraint DF_ThemeConfiguration_inSubtheme default 0,
   inStatus             bit                  not null constraint DF_ThemeConfiguration_inStatus default 1,
   dtInserted           datetime             not null constraint DF_ThemeConfigutation_dtInserted default getdate(),
   constraint PK_ThemeConfiguration primary key (idThemeConfiguration)
)
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ThemeConfiguration')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txImagePath')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ThemeConfiguration', 'column', 'txImagePath'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Caminho da imagem.',
   'user', @CurrentUser, 'table', 'ThemeConfiguration', 'column', 'txImagePath'

-- */
GO


INSERT INTO dbo.ThemeConfiguration (
                                     txTheme
                                   , txImagePath
                                   , txPrimaryColor
                                   , txBgPrimaryColor
                                   , inSubtheme
                                   , inStatus
                                   , dtInserted
                               )
SELECT txTheme 
     , txImagePath 
     , txPrimaryColor 
     , txBgPrimaryColor 
     , inSubtheme 
     , inStatus 
     , dtInserted 
FROM tmp_Theme

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Theme')
            and   type = 'U')
   drop table tmp_Theme
GO

GRANT UPDATE,INSERT,SELECT,DELETE ON ThemeConfiguration TO usrLekto
GO

alter table Card
   add constraint FK_Card_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table Moment
   add constraint FK_Moment_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table ProfileTheme
   add constraint FK_ProfileTheme_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table RoomTheme
   add constraint FK_RoomTheme_Theme foreign key (idTheme)
      references Theme (idTheme)
         on delete cascade
GO

alter table Theme
   add constraint FK_ThemeReference_Theme foreign key (idThemeReference)
      references Theme (idTheme)
GO

alter table Theme
   add constraint FK_Theme_ThemeConfiguration foreign key (idThemeConfiguration)
      references ThemeConfiguration (idThemeConfiguration)
GO

