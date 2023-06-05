/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     4/7/2022 2:31:36 PM                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BigFiveFacetDimension') and o.name = 'FK_BIGFIVEF_REFERENCE_DIMENSIO')
alter table BigFiveFacetDimension
   drop constraint FK_BIGFIVEF_REFERENCE_DIMENSIO
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Dimension') and o.name = 'FK_DIMENSIO_REFERENCE_SKILL')
alter table Dimension
   drop constraint FK_DIMENSIO_REFERENCE_SKILL
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('Evidence') and o.name = 'FK_EVIDENCE_REFERENCE_DIMENSIO')
alter table Evidence
   drop constraint FK_EVIDENCE_REFERENCE_DIMENSIO
GO

alter table Dimension
   drop constraint PK_Dimension
GO

alter table Dimension 
   drop constraint DF__Dimension__dtIns__1A9EF37A
go
alter table Dimension 
   drop constraint DF__Dimension__inSta__19AACF41
go

if exists (select 1
            from  sysobjects
           where  id = object_id('tmp_Dimension')
            and   type = 'U')
   drop table tmp_Dimension
GO

execute sp_rename 'Dimension', tmp_Dimension
GO

if exists (select 1
            from  sysindexes
           where  id    = object_id('Skill')
            and   name  = 'IX_TXSKILL'
            and   indid > 0
            and   indid < 255)
   drop index Skill.IX_TXSKILL
GO

/*==============================================================*/
/* Table: Dimension                                             */
/*==============================================================*/
create table Dimension (
   idDimension          smallint             identity(1,1),
   idSkill              smallint             not null,
   txDimension          varchar(150)         not null,
   txConcept            varchar(300)         not null,
   txComplementaryInformation varchar(1000)        null,
   inStatus             bit                  not null constraint DF_Dimension_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Dimension_dtInserted default getdate(),
   constraint PK_Dimension primary key (idDimension)
)
GO



/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Dimension') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Dimension' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de dimensões', 
   'user', @CurrentUser, 'table', 'Dimension' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Dimension')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txDimension')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Dimension', 'column', 'txDimension'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Texto/Nomenclatura da dimensào.',
   'user', @CurrentUser, 'table', 'Dimension', 'column', 'txDimension'

-- */
GO

set identity_insert Dimension on
GO

--WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Dimension (idDimension, idSkill, txDimension, txConcept, txComplementaryInformation, inStatus, dtInserted)
select idDimension, idSkill, txDimension, txConcept, NULL, inStatus, dtInserted
from tmp_Dimension
GO

set identity_insert Dimension off
GO

--WARNING: Drop cancelled because mandatory columns must have a value
--if exists (select 1
--            from  sysobjects
--           where  id = object_id('tmp_Dimension')
--            and   type = 'U')
--   drop table tmp_Dimension
--GO
GRANT SELECT,UPDATE,INSERT,DELETE ON Dimension TO usrLekto
GO

/*==============================================================*/
/* Index: ixNCL_Skill_txSkill                                   */
/*==============================================================*/
create index ixNCL_Skill_txSkill on Skill (
txSkill ASC
)
GO

alter table BigFiveFacetDimension
   add constraint FK_BigFiveFacetDimension_Dimension foreign key (idDimension)
      references Dimension (idDimension)
         on delete cascade
GO

alter table Dimension
   add constraint FK_Dimension_Skill foreign key (idSkill)
      references Skill (idSkill)
         on delete cascade
GO

alter table Evidence
   add constraint FK_Evidence_Dimension foreign key (idDimension)
      references Dimension (idDimension)
         on delete cascade
GO

