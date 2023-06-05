/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     5/29/2020 2:43:30 PM                         */
/*==============================================================*/



/*==============================================================*/
/* Table: ClassSchedule                                         */
/*==============================================================*/
create table ClassSchedule (
   idClassSchedule      numeric              identity(1,1),
   idSchoolClass        int                  not null,
   txWeekday            char(7)              not null constraint DF_ClassSchedule_txWeekday default '0000000'
      constraint CKC_ClassSchedule_txWeekday check (txWeekday = upper(txWeekday)),
   dtTimeStart          time                 not null,
   dtTimeEnd            time                 not null,
   constraint PK_ClassSchedule primary key (idClassSchedule)
)
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('ClassSchedule')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txWeekday')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'ClassSchedule', 'column', 'txWeekday'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Formato bin�rio come�ando no domingo
   
   00000000
   DSTQQSS',
   'user', @CurrentUser, 'table', 'ClassSchedule', 'column', 'txWeekday'

-- */
GO

GRANT SELECT,INSERT,UPDATE,DELETE ON ClassSchedule TO usrLekto
GO

alter table ClassSchedule
   add constraint FK_ClassSchedule_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass)
GO

