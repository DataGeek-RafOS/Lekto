/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     2/4/2022 4:05:40 PM                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Card') and o.name = 'FK_CARD_REFERENCE_THEME')
alter table Card
   drop constraint FK_CARD_REFERENCE_THEME
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Moment') and o.name = 'FK_MOMENT_REFERENCE_THEME')
alter table Moment
   drop constraint FK_MOMENT_REFERENCE_THEME
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ProfileTheme') and o.name = 'FK_ProfileTheme_Theme')
alter table ProfileTheme
   drop constraint FK_ProfileTheme_Theme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('RoomTheme') and o.name = 'FK_ROOMTHEM_REFERENCE_THEME')
alter table RoomTheme
   drop constraint FK_ROOMTHEM_REFERENCE_THEME
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ThemeSubtheme') and o.name = 'FK_ThemeSubtheme_idSubTheme')
alter table ThemeSubtheme
   drop constraint FK_ThemeSubtheme_idSubTheme
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('ThemeSubtheme') and o.name = 'FK_ThemeSubtheme_Theme')
alter table ThemeSubtheme
   drop constraint FK_ThemeSubtheme_Theme

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('tmp_Theme') and o.name = 'FK_ThemeReference_Theme')
alter table Theme
   drop constraint FK_ThemeReference_Theme

alter table Theme
   DROP CONSTRAINT FK_ThemeReference_Theme

alter table Theme
   drop constraint PK_THEME
GO

alter table Theme 
   drop constraint DF__Theme__dtInserte__61516785
GO

alter table Theme 
   drop constraint DF__Theme__inStatus__605D434C
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Theme')
            and   type = 'U')
   drop table tmp_Theme
GO

execute sp_rename 'Theme', tmp_Theme
GO


/*==============================================================*/
/* Table: Theme                                                 */
/*==============================================================*/
create table Theme (
   idTheme              smallint             identity(1,1),
   txTheme              varchar(80)          not null,
   txImagePath          varchar(300)         null,
   txPrimaryColor       varchar(8)           null,
   txBgPrimaryColor     varchar(8)           null,
   inSubtheme           bit                  not null,
   inStatus             bit                  not null constraint DF_Theme_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Theme_dtInserted default getdate(),
   constraint PK_Theme primary key (idTheme)
)
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Theme')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txImagePath')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Theme', 'column', 'txImagePath'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Caminho da imagem.',
   'user', @CurrentUser, 'table', 'Theme', 'column', 'txImagePath'

-- */
GO

set identity_insert Theme on
GO

--WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Theme (idTheme, txTheme, txImagePath, txPrimaryColor, txBgPrimaryColor, inSubtheme, inStatus, dtInserted)
select idTheme, txTheme, txImagePath, txPrimaryColor, txBgPrimaryColor, 0, inStatus, dtInserted
from tmp_Theme
GO

set identity_insert Theme off
GO

--WARNING: Drop cancelled because mandatory columns must have a value
--if exists (select 1
--            from  sysobjects
--           where  id = object_id('tmp_Theme')
--            and   type = 'U')
--   drop table tmp_Theme
--GO
GRANT UPDATE,INSERT,SELECT,DELETE ON Theme TO usrLekto
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

alter table ThemeSubtheme
   add constraint FK_ThemeSubtheme_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table ThemeSubtheme
   add constraint FK_ThemeSubtheme_idSubTheme foreign key (idSubtheme)
      references Theme (idTheme)
GO


/*==============================================================*/
/* Table: ThemeSubtheme                                         */
/*==============================================================*/
create table ThemeSubtheme (
   idTheme              smallint             not null,
   idSubtheme           smallint             not null,
   inStatus             bit                  not null constraint DF_ThemeSubtheme_inStatus default 1,
   dtInserted           datetime             not null constraint DF_ThemeSubtheme_dtInserted default getdate(),
   constraint PK_ThemeSubtheme primary key (idTheme, idSubtheme)
)
GO

/*==============================================================*/
/* Index: ixNCL_ThemeSubtheme_idSubTheme                        */
/*==============================================================*/
create index ixNCL_ThemeSubtheme_idSubTheme on ThemeSubtheme (
idSubtheme ASC
)
GO

alter table ThemeSubtheme
   add constraint FK_ThemeSubtheme_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table ThemeSubtheme
   add constraint FK_ThemeSubtheme_idSubTheme foreign key (idSubtheme)
      references Theme (idTheme)
GO

