/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     5/19/2020 9:39:41 PM                         */
/*==============================================================*/


/* SNAPSHOT 

SELECT * FROM sys.sysfiles;

CREATE DATABASE ...
ON  
( 
NAME = dbRedeSSO_Data01, 
FILENAME = 'Path.ss' )  
AS SNAPSHOT OF dbName;  
GO 

*/

use master
go

create login usrLekto with password = 'u$rL3k7o#c4rd'

-- use dbLekto
go 

create user usrLekto for login usrLekto
GO
/*==============================================================*/
/* Table: AccessControl                                         */
/*==============================================================*/
create table AccessControl (
   idUser               int                  not null,
   txLogin              varchar(250)         not null,
   txPassword           varchar(128)         null,
   inStatus             bit                  not null constraint DF_AccessControl_inStatus default 1,
   dtInserted           datetime             not null constraint DF_AccessControl_dtInserted default getdate(),
   constraint PK_AccessControl primary key (idUser)
)
GO

GRANT SELECT,INSERT,UPDATE,DELETE ON AccessControl TO usrLekto
GO

/*==============================================================*/
/* Table: Agenda                                                */
/*==============================================================*/
create table Agenda (
   idAgenda             int                  identity(1,1),
   dtAgenda             datetime             not null,
   dtTimeStart          datetime             not null constraint DF_Agenda_dtTimeStart default getdate(),
   dtTimeEnd            datetime             null,
   dtInserted           datetime             not null constraint DF_Agenda_dtInserted default getdate(),
   inDeleted            bit                  not null constraint DF_Agenda_inDeleted default 0,
   constraint PK_Agenda primary key (idAgenda)
)
GO


GRANT UPDATE,INSERT,DELETE,SELECT ON Agenda TO usrLekto
GO

/*==============================================================*/
/* Table: Apprentice                                            */
/*==============================================================*/
create table Apprentice (
   idApprentice         int                  identity(1,1),
   idUser               int                  not null,
   idClass              int                  not null,
   constraint PK_Apprentice primary key (idApprentice),
   constraint ukNCL_Apprentice_idUser_idClass unique (idUser, idClass)
)
GO

GRANT UPDATE,DELETE,SELECT,INSERT ON Apprentice TO usrLekto
GO

/*==============================================================*/
/* Table: ApprenticeMoment                                      */
/*==============================================================*/
create table ApprenticeMoment (
   idApprenticeMoment   int                  identity(1,1),
   idApprentice         int                  not null,
   idMoment             int                  not null,
   inAttendance         bit                  null constraint DF_ApprenticeMoment_inAttendance default 0,
   constraint PK_ApprenticeMoment primary key (idApprenticeMoment)
)
GO


GRANT DELETE,UPDATE,SELECT,INSERT ON ApprenticeMoment TO usrLekto
GO

/*==============================================================*/
/* Table: ApprenticeProfile                                     */
/*==============================================================*/
create table ApprenticeProfile (
   idApprentice         int                  not null,
   coProfileType        char(4)              not null,
   dtInserted           datetime             not null constraint DF_ApprenticeProfile_dtInserted default getdate(),
   constraint PK_ApprenticeProfile primary key (idApprentice, coProfileType)
)
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON ApprenticeProfile TO usrLekto
GO

/*==============================================================*/
/* Table: ApprenticeScoreSkill                                  */
/*==============================================================*/
create table ApprenticeScoreSkill (
   idApprentice         int                  not null,
   idSkill              smallint             not null,
   nuScore              smallint             null constraint DF_ApprenticeScoreSkill_nuScore default 0,
   dtInserted           datetime             not null constraint DF_ApprenticeScoreSkill_dtInserted default getdate(),
   constraint PK_ApprenticeScoreSkill primary key (idApprentice, idSkill)
)
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON ApprenticeScoreSkill TO usrLekto
GO

/*==============================================================*/
/* Table: ApprenticeScoreTheme                                  */
/*==============================================================*/
create table ApprenticeScoreTheme (
   idApprentice         int                  not null,
   idTheme              smallint             not null,
   nuScore              smallint             null constraint DF_ApprenticeScoreTheme_nuScore default 0,
   dtInserted           datetime             not null constraint DF_ApprenticeScoreTheme_dtInserted default getdate(),
   constraint PK_ApprenticeScoreTheme primary key (idApprentice, idTheme)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('ApprenticeScoreTheme') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'ApprenticeScoreTheme' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Score do aprendiz por temas.', 
   'user', @CurrentUser, 'table', 'ApprenticeScoreTheme' 
 
-- */
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON ApprenticeScoreTheme TO usrLekto
GO

/*==============================================================*/
/* Table: Assessment                                            */
/*==============================================================*/
create table Assessment (
   idAssessment         int                  identity(1,1),
   idApprenticeMoment   int                  not null,
   idEvaluationQuestion int                  not null,
   coRating             char(4)              null,
   constraint PK_Assessment primary key (idAssessment)
)
GO

GRANT DELETE,UPDATE,INSERT,SELECT ON Assessment TO usrLekto
GO

/*==============================================================*/
/* Table: Card                                                  */
/*==============================================================*/
create table Card (
   idCard               int                  identity(1,1),
   txTitle              varchar(150)         not null,
   txCard               varchar(2000)        not null,
   idTheme              smallint             not null,
   inStatus             bit                  not null constraint DF_Card_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Card_dtInserted default getdate(),
   constraint PK_Card primary key (idCard)
)
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Card')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txCard')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Card', 'column', 'txCard'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Texto descritivo do cart�o.',
   'user', @CurrentUser, 'table', 'Card', 'column', 'txCard'

-- */
GO

GRANT UPDATE,INSERT,SELECT,DELETE ON Card TO usrLekto
GO

/*==============================================================*/
/* Table: CardEvidence                                          */
/*==============================================================*/
create table CardEvidence (
   idCard               int                  not null,
   idDimension          smallint             not null,
   inStatus             bit                  not null constraint DF_CardEvidence_inStatus default 1,
   dtInserted           datetime             not null constraint DF_CardEvidence_dtInserted default getdate(),
   constraint PK_CardEvidence primary key (idCard, idDimension)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('CardEvidence') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'CardEvidence' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de dimens�es do card.', 
   'user', @CurrentUser, 'table', 'CardEvidence' 
 
-- */
GO

GRANT UPDATE,DELETE,SELECT,INSERT ON CardEvidence TO usrLekto
GO

/*==============================================================*/
/* Table: CardInfrastructure                                    */
/*==============================================================*/
create table CardInfrastructure (
   idCard               int                  not null,
   idInfrastructure     smallint             not null,
   inStatus             bit                  not null constraint DF_CardInfrastructure_inStatus default 1,
   dtInserted           datetime             not null constraint DF_CardInfrastructure_dtInserted default getdate(),
   constraint PK_CardInfrastructure primary key (idCard, idInfrastructure)
)
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON CardInfrastructure TO usrLekto
GO

/*==============================================================*/
/* Table: CardLearningTool                                      */
/*==============================================================*/
create table CardLearningTool (
   idCard               int                  not null,
   idLearningTool       smallint             not null,
   inStatus             bit                  not null constraint DF_CardLearningTool_inStatus default 1,
   dtInserted           datetime             not null constraint DF_CardLearningTool_dtInserted default getdate(),
   constraint PK_CardLearningTool primary key (idCard, idLearningTool)
)
GO

GRANT UPDATE,DELETE,INSERT,SELECT ON CardLearningTool TO usrLekto
GO

/*==============================================================*/
/* Table: CardSchoolSupply                                      */
/*==============================================================*/
create table CardSchoolSupply (
   idCard               int                  identity(1,1),
   idSchoolSupply       smallint             not null,
   inStatus             bit                  not null constraint DF_CardSchoolSupply_inStatus default 1,
   dtInserted           datetime             not null constraint DF_CardSchoolSupply_dtInserted default getdate(),
   constraint PK_CardSchoolSupply primary key (idCard, idSchoolSupply)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('CardSchoolSupply') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'CardSchoolSupply' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Materiais necess�rios para o card.', 
   'user', @CurrentUser, 'table', 'CardSchoolSupply' 
 
-- */
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON CardSchoolSupply TO usrLekto
GO

/*==============================================================*/
/* Table: Dimension                                             */
/*==============================================================*/
create table Dimension (
   idDimension          smallint             identity(1,1),
   idSkill              smallint             not null,
   txDimension          varchar(150)         not null,
   txConcept            varchar(300)         not null,
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
   'Tabela de dimens�es', 
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
   'Texto/Nomenclatura da dimens�o.',
   'user', @CurrentUser, 'table', 'Dimension', 'column', 'txDimension'

-- */
GO

GRANT SELECT,UPDATE,INSERT,DELETE ON Dimension TO usrLekto
GO

/*==============================================================*/
/* Table: EvaluationQuestion                                    */
/*==============================================================*/
create table EvaluationQuestion (
   idEvaluationQuestion int                  identity(1,1),
   idDimension          smallint             not null,
   txQuestion           varchar(500)         not null,
   nuOrder              smallint             not null constraint DF_EvaluationQuestion_nuOrder default 1,
   txTutorNotes         varchar(max)         null,
   constraint PK_EvaluationQuestion primary key (idEvaluationQuestion)
)
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('EvaluationQuestion')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txQuestion')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'EvaluationQuestion', 'column', 'txQuestion'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Texto da quest�o.',
   'user', @CurrentUser, 'table', 'EvaluationQuestion', 'column', 'txQuestion'

-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('EvaluationQuestion')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'nuOrder')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'EvaluationQuestion', 'column', 'nuOrder'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Ordena��o da quest�o no card.',
   'user', @CurrentUser, 'table', 'EvaluationQuestion', 'column', 'nuOrder'

-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('EvaluationQuestion')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txTutorNotes')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'EvaluationQuestion', 'column', 'txTutorNotes'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Observa��es do tutor.',
   'user', @CurrentUser, 'table', 'EvaluationQuestion', 'column', 'txTutorNotes'

-- */
GO

GRANT UPDATE,INSERT,SELECT,DELETE ON EvaluationQuestion TO usrLekto
GO

/*==============================================================*/
/* Table: Evidence                                              */
/*==============================================================*/
create table Evidence (
   idDimension          smallint             not null,
   idGrade              int                  not null,
   txDescription        varchar(350)         not null,
   inStatus             bit                  not null constraint DF_Evidence_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Evidence_dtInserted default getdate(),
   constraint PK_Evidence primary key (idDimension)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Evidence') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Evidence' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de relacionamento entre as dimens�es e as s�ries para cria��o da matrix de dimens�es.', 
   'user', @CurrentUser, 'table', 'Evidence' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Evidence')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txDescription')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Evidence', 'column', 'txDescription'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Descri��o da dimens�o para a s�rie.',
   'user', @CurrentUser, 'table', 'Evidence', 'column', 'txDescription'

-- */
GO

GRANT UPDATE,DELETE,SELECT,INSERT ON Evidence TO usrLekto
GO

/*==============================================================*/
/* Table: Grade                                                 */
/*==============================================================*/
create table Grade (
   idGrade              int                  identity(1,1),
   txGrade              varchar(30)          not null,
   constraint PK_Grade primary key (idGrade)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Grade') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Grade' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de s�ries dispon�veis para o sistema.', 
   'user', @CurrentUser, 'table', 'Grade' 
 
-- */
GO

GRANT SELECT,UPDATE,INSERT,DELETE ON Grade TO usrLekto
GO

/*==============================================================*/
/* Table: Guidance                                              */
/*==============================================================*/
create table Guidance (
   idGuidance           int                  identity(1,1),
   idCard               int                  not null,
   idStep               int                  not null,
   txGuidance           varchar(500)         not null,
   constraint PK_Guidance primary key (idGuidance)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Guidance') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Guidance' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabelas dos passos do card.', 
   'user', @CurrentUser, 'table', 'Guidance' 
 
-- */
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON Guidance TO usrLekto
GO

/*==============================================================*/
/* Table: Infrastructure                                        */
/*==============================================================*/
create table Infrastructure (
   idInfrastructure     smallint             identity(1,1),
   txInfrastructure     varchar(150)         not null,
   txImagePath          varchar(300)         null,
   inStatus             bit                  not null constraint DF_Infrastructure_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Infrastructure_dtInserted default getdate(),
   constraint PK_Infrastructure primary key (idInfrastructure)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Infrastructure') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Infrastructure' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de tipos de infra-estrutura.', 
   'user', @CurrentUser, 'table', 'Infrastructure' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Infrastructure')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txImagePath')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Infrastructure', 'column', 'txImagePath'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Caminho da imagem.',
   'user', @CurrentUser, 'table', 'Infrastructure', 'column', 'txImagePath'

-- */
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON Infrastructure TO usrLekto
GO

/*==============================================================*/
/* Table: LearningTool                                          */
/*==============================================================*/
create table LearningTool (
   idLearningTool       smallint             identity(1,1),
   txLearningTool       varchar(100)         not null,
   txImagePath          varchar(300)         null,
   constraint PK_LearningTool primary key (idLearningTool)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('LearningTool') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'LearningTool' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Ferramenta de aprendizagem.', 
   'user', @CurrentUser, 'table', 'LearningTool' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('LearningTool')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txImagePath')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'LearningTool', 'column', 'txImagePath'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Caminho da imagem.',
   'user', @CurrentUser, 'table', 'LearningTool', 'column', 'txImagePath'

-- */
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON LearningTool TO usrLekto
GO

/*==============================================================*/
/* Table: LektoUser                                             */
/*==============================================================*/
create table LektoUser (
   idUser               int                  identity(1,1),
   coUserType           char(4)              not null,
   txName               varchar(120)         not null,
   inStatus             bit                  not null constraint DF_LektoUser_inStatus default 1,
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

GRANT UPDATE,INSERT,SELECT,DELETE ON LektoUser TO usrLekto
GO

/*==============================================================*/
/* Table: LogAcessControl                                       */
/*==============================================================*/
create table LogAcessControl (
   idUser               int                  not null,
   dtAccess             datetime             not null,
   constraint PK_LogAcessControl primary key (idUser, dtAccess)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('LogAcessControl') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'LogAcessControl' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de log de acesso.', 
   'user', @CurrentUser, 'table', 'LogAcessControl' 
 
-- */
GO

GRANT UPDATE,SELECT,INSERT,DELETE ON LogAcessControl TO usrLekto
GO

/*==============================================================*/
/* Table: Moment                                                */
/*==============================================================*/
create table Moment (
   idMoment             int                  identity(1,1),
   idAgenda             int                  not null,
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

GRANT DELETE,UPDATE,INSERT,SELECT ON Moment TO usrLekto
GO

/*==============================================================*/
/* Table: MomentNotes                                           */
/*==============================================================*/
create table MomentNotes (
   idMomentNotes        int                  identity(1,1),
   idMoment             int                  not null,
   idEvaluationQuestion int                  null,
   txMomentNotes        varchar(max)         not null,
   txPathImage          varchar(300)         null,
   txPathAudio          varchar(300)         not null,
   dtInserted           datetime             not null constraint DF_MomentNotes_dtInserted default getdate(),
   constraint PK_MomentNotes primary key (idMomentNotes)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('MomentNotes') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'MomentNotes' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Informa��es complementares referentes ao grupo. Neste caso, poder�o ser vinculados alguns coment�rios por aluno ou para todo o grupo.
   ', 
   'user', @CurrentUser, 'table', 'MomentNotes' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('MomentNotes')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txMomentNotes')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'MomentNotes', 'column', 'txMomentNotes'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Informa��es complementares.
   ',
   'user', @CurrentUser, 'table', 'MomentNotes', 'column', 'txMomentNotes'

-- */
GO

GRANT UPDATE,DELETE,SELECT,INSERT ON MomentNotes TO usrLekto
GO

/*==============================================================*/
/* Table: MomentNotesApprentice                                 */
/*==============================================================*/
create table MomentNotesApprentice (
   idMomentNotes        int                  not null,
   idApprentice         int                  not null,
   inStatus             bit                  not null constraint DF_MomentNotesApprentice_inStatus default 1,
   dtInserted           datetime             not null constraint DF_MomentNotesApprentice_dtInserted default getdate(),
   constraint PK_MomentNotesApprentice primary key (idMomentNotes, idApprentice)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('MomentNotesApprentice') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'MomentNotesApprentice' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Refer�ncia de informa��es adicionais com os aprendizes.', 
   'user', @CurrentUser, 'table', 'MomentNotesApprentice' 
 
-- */
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON MomentNotesApprentice TO usrLekto
GO

/*==============================================================*/
/* Table: MomentStatus                                          */
/*==============================================================*/
create table MomentStatus (
   coMomentStatus       char(4)              not null,
   txMomentStatus       varchar(60)          not null,
   inStatus             bit                  not null constraint DF_MomentStatus_inStatus default 1,
   dtInserted           datetime             not null constraint DF_MomentStatus_dtInserted default getdate(),
   constraint PK_MomentStatus primary key (coMomentStatus)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('MomentStatus') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'MomentStatus' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de situa��o do momento.', 
   'user', @CurrentUser, 'table', 'MomentStatus' 
 
-- */
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON MomentStatus TO usrLekto
GO

/*==============================================================*/
/* Table: Notification                                          */
/*==============================================================*/
create table Notification (
   idNotification       int                  identity(1,1),
   idUser               int                  not null,
   coNotificationType   char(4)              not null,
   coNotificationSource char(4)              not null,
   dtReceived           datetime             not null,
   dtRead               datetime             null,
   constraint PK_Notification primary key (idNotification)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('Notification') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'Notification' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Tabela de notifica��es.', 
   'user', @CurrentUser, 'table', 'Notification' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Notification')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'coNotificationSource')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Notification', 'column', 'coNotificationSource'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'C�digo da origem da notifica��o.',
   'user', @CurrentUser, 'table', 'Notification', 'column', 'coNotificationSource'

-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Notification')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'dtReceived')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Notification', 'column', 'dtReceived'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Data de recebimento.',
   'user', @CurrentUser, 'table', 'Notification', 'column', 'dtReceived'

-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('Notification')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'dtRead')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'Notification', 'column', 'dtRead'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Data da leitura.',
   'user', @CurrentUser, 'table', 'Notification', 'column', 'dtRead'

-- */
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON Notification TO usrLekto
GO

/*==============================================================*/
/* Table: NotificationSource                                    */
/*==============================================================*/
create table NotificationSource (
   coNotificationSource char(4)              not null,
   txNotificationSource varchar(50)          not null,
   inStatus             bit                  not null constraint DF_NotificationSource_inStatus default 1,
   dtInserted           datetime             not null constraint DF_NotificationSource_dtInserted default getdate(),
   constraint PK_NotificationSource primary key (coNotificationSource)
)
GO

/* -- properties
if exists (select 1 from  sys.extended_properties
           where major_id = object_id('NotificationSource') and minor_id = 0)
begin 
   declare @CurrentUser sysname 
select @CurrentUser = user_name() 
execute sp_dropextendedproperty 'MS_Description',  
   'user', @CurrentUser, 'table', 'NotificationSource' 
 
end 


select @CurrentUser = user_name() 
execute sp_addextendedproperty 'MS_Description',  
   'Origem da notifica��o.', 
   'user', @CurrentUser, 'table', 'NotificationSource' 
 
-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('NotificationSource')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'coNotificationSource')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'NotificationSource', 'column', 'coNotificationSource'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'C�digo da origem da notifica��o.',
   'user', @CurrentUser, 'table', 'NotificationSource', 'column', 'coNotificationSource'

-- */
GO

/* -- properties
if exists(select 1 from sys.extended_properties p where
      p.major_id = object_id('NotificationSource')
  and p.minor_id = (select c.column_id from sys.columns c where c.object_id = p.major_id and c.name = 'txNotificationSource')
)
begin
   declare @CurrentUser sysname
select @CurrentUser = user_name()
execute sp_dropextendedproperty 'MS_Description', 
   'user', @CurrentUser, 'table', 'NotificationSource', 'column', 'txNotificationSource'

end


select @CurrentUser = user_name()
execute sp_addextendedproperty 'MS_Description', 
   'Descri��o da origem da notifica��o.',
   'user', @CurrentUser, 'table', 'NotificationSource', 'column', 'txNotificationSource'

-- */
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON NotificationSource TO usrLekto
GO

/*==============================================================*/
/* Table: NotificationType                                      */
/*==============================================================*/
create table NotificationType (
   coNotificationType   char(4)              not null,
   txNotificationType   varchar(50)          not null,
   inStatus             bit                  not null constraint DF_NotificationType_inStatus default 1,
   dtInserted           datetime             not null constraint DF_NotificationType_dtInserted default getdate(),
   constraint PK_NotificationType primary key (coNotificationType)
)
GO


GRANT DELETE,UPDATE,INSERT,SELECT ON NotificationType TO usrLekto
GO

/*==============================================================*/
/* Table: Personalization                                       */
/*==============================================================*/
create table Personalization (
   idPersonalisation    int                  identity(1,1),
   idCard               int                  not null,
   idStep               int                  not null,
   inStatus             bit                  not null constraint DF_Personalization_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Personalization_dtInserted default getdate(),
   constraint PK_Personalization primary key (idPersonalisation)
)
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON Personalization TO usrLekto
GO

/*==============================================================*/
/* Table: ProfilePersonalization                                */
/*==============================================================*/
create table ProfilePersonalization (
   idPersonalisation    int                  not null,
   coProfile            char(4)              not null,
   inStatus             bit                  not null constraint DF_ProfilePersonalization_inStatus default 1,
   dtInserted           datetime             not null constraint DF_ProfilePersonalization_dtInserted default getdate(),
   constraint PK_ProfilePersonalization primary key (idPersonalisation, coProfile)
)
GO

GRANT UPDATE,DELETE,INSERT,SELECT ON ProfilePersonalization TO usrLekto
GO

/*==============================================================*/
/* Table: ProfileTheme                                          */
/*==============================================================*/
create table ProfileTheme (
   idTheme              smallint             not null,
   coProfile            char(4)              not null,
   inStatus             bit                  not null constraint DF_ProfileTheme_inStatus default 1,
   dtInserted           datetime             not null constraint DF_ProfileTheme_dtInserted default getdate(),
   constraint PK_ProfileTheme primary key (idTheme, coProfile)
)
GO


GRANT UPDATE,INSERT,SELECT,DELETE ON ProfileTheme TO usrLekto
GO

/*==============================================================*/
/* Table: ProfileType                                           */
/*==============================================================*/
create table ProfileType (
   coProfileType        char(4)              not null,
   txProfileType        varchar(60)          not null,
   inStatus             bit                  not null constraint DF_ProfileType_inStatuss default 1,
   dtInserted           datetime             not null constraint DF_ProfileType_dtInserted default getdate(),
   constraint PK_ProfileType primary key (coProfileType)
)
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON ProfileType TO usrLekto
GO

/*==============================================================*/
/* Table: Rating                                                */
/*==============================================================*/
create table Rating (
   coRating             char(4)              not null,
   txRating             varchar(30)          not null,
   inStatus             bit                  not null constraint DF_Rating_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Rating_dtInserted default getdate(),
   constraint PK_Rating primary key (coRating)
)
GO

GRANT UPDATE,DELETE,INSERT,SELECT ON Rating TO usrLekto
GO

/*==============================================================*/
/* Table: RelationType                                          */
/*==============================================================*/
create table RelationType (
   coRelationType       char(4)              not null,
   txRelationType       varchar(40)          null,
   constraint PK_RelationType primary key (coRelationType)
)
GO

GRANT UPDATE,SELECT,DELETE,INSERT ON RelationType TO usrLekto
GO

/*==============================================================*/
/* Table: Relationship                                          */
/*==============================================================*/
create table Relationship (
   idUser               int                  not null,
   idUserBound          int                  not null,
   coRelationType       char(4)              not null,
   dtInserted           datetime             not null constraint DF_Relationship_dtInserted default getdate(),
   inDeleted            bit                  not null constraint DF_Relationship_inDeleted default 0,
   constraint PK_Relationship primary key (idUser, idUserBound)
)
GO


GRANT DELETE,UPDATE,INSERT,SELECT ON Relationship TO usrLekto
GO

/*==============================================================*/
/* Table: School                                                */
/*==============================================================*/
create table School (
   idSchool             int                  identity(1,1),
   txName               varchar(200)         not null,
   inStatus             bit                  not null constraint DF_School_inStatus default 1,
   dtInserted           datetime             not null constraint DF_School_dtInserted default getdate(),
   constraint PK_School primary key (idSchool)
)
GO

GRANT UPDATE,INSERT,DELETE,SELECT ON School TO usrLekto
GO

/*==============================================================*/
/* Table: SchoolClass                                           */
/*==============================================================*/
create table SchoolClass (
   idSchoolClass        int                  identity(1,1),
   idSchoolGrade        int                  not null,
   txName               varchar(50)          not null,
   inStatus             bit                  not null constraint DF_SchoolClass_inStatus default 1,
   dtInserted           datetime             not null constraint DF_SchoolClass_dtInserted default getdate(),
   constraint PK_SchoolClass primary key (idSchoolClass)
)
GO

GRANT SELECT,UPDATE,INSERT,DELETE ON SchoolClass TO usrLekto
GO

/*==============================================================*/
/* Table: SchoolGrade                                           */
/*==============================================================*/
create table SchoolGrade (
   idSchoolGrade        int                  identity(1,1),
   idSchool             int                  not null,
   idGrade              int                  not null,
   txName               varchar(50)          not null,
   inStatus             bit                  not null constraint DF_SchoolGrade_inStatus default 1,
   dtInserted           datetime             not null constraint DF_SchoolGrade_dtInserted default getdate(),
   constraint PK_SchoolGrade primary key (idSchoolGrade)
)
GO

GRANT UPDATE,INSERT,SELECT,DELETE ON SchoolGrade TO usrLekto
GO

/*==============================================================*/
/* Table: SchoolSupply                                          */
/*==============================================================*/
create table SchoolSupply (
   idSchoolSupply       smallint             identity(1,1),
   txSchoolSupply       varchar(100)         not null,
   dtInserted           datetime             not null constraint DF_SchoolSupply_dtInserted default getdate(),
   constraint PK_SchoolSupply primary key (idSchoolSupply)
)
GO

GRANT UPDATE,DELETE,INSERT,SELECT ON SchoolSupply TO usrLekto
GO

/*==============================================================*/
/* Table: Skill                                                 */
/*==============================================================*/
create table Skill (
   idSkill              smallint             identity(1,1),
   txSkill              varchar(50)          not null,
   txImagePath          varchar(300)         null,
   inStatus             bit                  not null constraint DF_Skill_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Skill_dtInserted default getdate(),
   constraint PK_Skill primary key (idSkill)
)
GO
GRANT SELECT,INSERT,DELETE,UPDATE ON Skill TO usrLekto
GO

/*==============================================================*/
/* Table: Step                                                  */
/*==============================================================*/
create table Step (
   idCard               int                  not null,
   idStep               int                  identity(1,1),
   txTitle              varchar(100)         not null,
   nuTimeStep           smallint             not null constraint DF_Step_nuTimeStep default 0,
   nuOrderStep          smallint             not null constraint DF_Step_nuOrderStep default 1,
   txNotes              varchar(300)         null,
   inStatus             bit                  not null constraint DF_Step_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Step_dtInserted default getdate(),
   constraint PK_Step primary key (idCard, idStep)
)
GO


GRANT DELETE,UPDATE,INSERT,SELECT ON Step TO usrLekto
GO

/*==============================================================*/
/* Table: SupportMaterial                                       */
/*==============================================================*/
create table SupportMaterial (
   idSupportMaterial    smallint             identity(1,1),
   idCard               int                  not null,
   idStep               int                  not null,
   txSupportMaterial    varchar(50)          not null,
   txImagePath          varchar(300)         null,
   inStatus             bit                  not null constraint DF_SupportMaterial_inStatus default 1,
   dtInserted           datetime             not null constraint DF_SupportMaterial_dtInserted default getdate(),
   constraint PK_SupportMaterial primary key (idSupportMaterial)
)
GO


GRANT UPDATE,SELECT,DELETE,INSERT ON SupportMaterial TO usrLekto
GO

/*==============================================================*/
/* Table: Theme                                                 */
/*==============================================================*/
create table Theme (
   idTheme              smallint             identity(1,1),
   txTheme              varchar(80)          not null,
   txImagePath          varchar(300)         null,
   inStatus             bit                  not null constraint DF_Theme_inStatus default 1,
   dtInserted           datetime             not null constraint DF_Theme_dtInserted default getdate(),
   constraint PK_Theme primary key (idTheme)
)
GO


GRANT UPDATE,INSERT,SELECT,DELETE ON Theme TO usrLekto
GO

/*==============================================================*/
/* Table: Tutor                                                 */
/*==============================================================*/
create table Tutor (
   idTutor              int                  not null,
   idUser               int                  not null,
   idClass              int                  not null,
   constraint PK_Tutor primary key (idTutor, idClass),
   constraint ukNCL_Tutor_idUser_idClass unique (idUser, idClass)
)
GO


GRANT UPDATE,INSERT,DELETE,SELECT ON Tutor TO usrLekto
GO

/*==============================================================*/
/* Table: UserType                                              */
/*==============================================================*/
create table UserType (
   coUserType           char(4)              not null,
   txUserType           varchar(30)          not null,
   inStatus             bit                  not null constraint DF_UserType_inStatus default 1,
   dtInserted           datetime             not null constraint DF_UserType_dtInserted default getdate(),
   constraint PK_UserType primary key (coUserType)
)
GO

GRANT DELETE,UPDATE,INSERT,SELECT ON UserType TO usrLekto
GO

alter table AccessControl
   add constraint FK_AccessControl_LektoUser foreign key (idUser)
      references LektoUser (idUser)
GO

alter table Apprentice
   add constraint FK_Apprentice_Class foreign key (idClass)
      references SchoolClass (idSchoolClass)
GO

alter table Apprentice
   add constraint FK_Apprentice_User foreign key (idUser)
      references LektoUser (idUser)
GO

alter table ApprenticeMoment
   add constraint FK_Group_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice)
GO

alter table ApprenticeMoment
   add constraint FK_Group_Moment foreign key (idMoment)
      references Moment (idMoment)
GO

alter table ApprenticeProfile
   add constraint FK_ApprenticeProfile_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice)
GO

alter table ApprenticeProfile
   add constraint FK_ApprenticeProfile_ProfileType foreign key (coProfileType)
      references ProfileType (coProfileType)
GO

alter table ApprenticeScoreSkill
   add constraint FK_ApprenticeScoreSkill_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice)
GO

alter table ApprenticeScoreSkill
   add constraint FK_ApprenticeScoreSkill_Skill foreign key (idSkill)
      references Skill (idSkill)
GO

alter table ApprenticeScoreTheme
   add constraint FK_ApprenticeScoreTheme_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice)
GO

alter table ApprenticeScoreTheme
   add constraint FK_ApprenticeScoreTheme_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table Assessment
   add constraint FK_Assessment_ApprenticeMoment foreign key (idApprenticeMoment)
      references ApprenticeMoment (idApprenticeMoment)
GO

alter table Assessment
   add constraint FK_Assessment_EvaluationQuestion foreign key (idEvaluationQuestion)
      references EvaluationQuestion (idEvaluationQuestion)
GO

alter table Assessment
   add constraint FK_Assessment_Rating foreign key (coRating)
      references Rating (coRating)
GO

alter table Card
   add constraint FK_Card_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table CardEvidence
   add constraint FK_CardDimension_Card foreign key (idCard)
      references Card (idCard)
GO

alter table CardEvidence
   add constraint FK_CardDimension_DimensionGrade foreign key (idDimension)
      references Evidence (idDimension)
GO

alter table CardInfrastructure
   add constraint DF_CardInfrastructure_Infrastructure foreign key (idInfrastructure)
      references Infrastructure (idInfrastructure)
GO

alter table CardInfrastructure
   add constraint FK_CardInfrastructure_Card foreign key (idCard)
      references Card (idCard)
GO

alter table CardLearningTool
   add constraint FK_CardLearningTool_Card foreign key (idCard)
      references Card (idCard)
GO

alter table CardLearningTool
   add constraint FK_CardLearningTool_LearningTool foreign key (idLearningTool)
      references LearningTool (idLearningTool)
GO

alter table CardSchoolSupply
   add constraint FK_CardSchoolSupply_Card foreign key (idCard)
      references Card (idCard)
GO

alter table CardSchoolSupply
   add constraint FK_CardSchoolSupply_SchoolSupply foreign key (idSchoolSupply)
      references SchoolSupply (idSchoolSupply)
GO

alter table Dimension
   add constraint FK_Dimension_Skill foreign key (idSkill)
      references Skill (idSkill)
GO

alter table EvaluationQuestion
   add constraint FK_EvalutionQuestion_Evidence foreign key (idDimension)
      references Evidence (idDimension)
GO

alter table Evidence
   add constraint FK_DimensionGrade_Dimension foreign key (idDimension)
      references Dimension (idDimension)
GO

alter table Evidence
   add constraint FK_DimensionGrade_Grade foreign key (idGrade)
      references Grade (idGrade)
GO

alter table Guidance
   add constraint FK_Guidance_Step foreign key (idCard, idStep)
      references Step (idCard, idStep)
GO

alter table LektoUser
   add constraint FK_User_UserType foreign key (coUserType)
      references UserType (coUserType)
GO

alter table LogAcessControl
   add constraint FK_LogAccessControl_AccessControl foreign key (idUser)
      references AccessControl (idUser)
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

alter table MomentNotes
   add constraint FK_MomentNotes_EvaluationQuestion foreign key (idEvaluationQuestion)
      references EvaluationQuestion (idEvaluationQuestion)
GO

alter table MomentNotes
   add constraint FK_MomentNotes_Moment foreign key (idMoment)
      references Moment (idMoment)
GO

alter table MomentNotesApprentice
   add constraint FK_GroupNotesApprentice_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice)
GO

alter table MomentNotesApprentice
   add constraint FK_MomentNotesApprentice_MomentNotes foreign key (idMomentNotes)
      references MomentNotes (idMomentNotes)
GO

alter table Notification
   add constraint FK_Notification_NotificationSource foreign key (coNotificationSource)
      references NotificationSource (coNotificationSource)
GO

alter table Notification
   add constraint FK_Notification_NotificationType foreign key (coNotificationType)
      references NotificationType (coNotificationType)
GO

alter table Notification
   add constraint FK_Notification_User foreign key (idUser)
      references LektoUser (idUser)
GO

alter table Personalization
   add constraint FK_Personalization_Step foreign key (idCard, idStep)
      references Step (idCard, idStep)
GO

alter table ProfilePersonalization
   add constraint FK_ProfilePersonalization_Personalization foreign key (idPersonalisation)
      references Personalization (idPersonalisation)
GO

alter table ProfilePersonalization
   add constraint FK_ProfilePersonalization_ProfileType foreign key (coProfile)
      references ProfileType (coProfileType)
GO

alter table ProfileTheme
   add constraint FK_ProfileTheme_ProfileType foreign key (coProfile)
      references ProfileType (coProfileType)
GO

alter table ProfileTheme
   add constraint FK_ProfileTheme_Theme foreign key (idTheme)
      references Theme (idTheme)
GO

alter table Relationship
   add constraint FK_Relationship_LektoUser foreign key (idUser)
      references LektoUser (idUser)
GO

alter table Relationship
   add constraint FK_Relationship_LektoUserBound foreign key (idUserBound)
      references LektoUser (idUser)
GO

alter table Relationship
   add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType)
GO

alter table SchoolClass
   add constraint FK_SchoolClass_SchoolGrade foreign key (idSchoolGrade)
      references SchoolGrade (idSchoolGrade)
GO

alter table SchoolGrade
   add constraint FK_SchoolGrade_Grade foreign key (idGrade)
      references Grade (idGrade)
GO

alter table SchoolGrade
   add constraint FK_SchoolGrade_School foreign key (idSchool)
      references School (idSchool)
GO

alter table Step
   add constraint FK_Step_Card foreign key (idCard)
      references Card (idCard)
GO

alter table SupportMaterial
   add constraint FK_SupportMaterial_Step foreign key (idCard, idStep)
      references Step (idCard, idStep)
GO

alter table Tutor
   add constraint FK_Teacher_Class foreign key (idClass)
      references SchoolClass (idSchoolClass)
GO

alter table Tutor
   add constraint FK_Tutor_User foreign key (idUser)
      references LektoUser (idUser)
GO


