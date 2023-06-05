/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2/24/2022 6:16:03 PM                         */
/*==============================================================*/

-- Observação: Lembrar de migrar os dados das colunas StoragePath, StorageKey e Name 
-- da tabela UnitDocumentation para UnitDocumentationFile

create table bkp_20220203_UnitDocumentation
(
   UnitDocumentationId  int not null,
   DocumentationId      int not null,
   UnitId               int not null,
   CustomerId           int not null,
   ExpiresIn            date,
   ReadyOn              datetime,
   IssuedOn             date comment 'Emito em',
   IsDeleted            bool not null default 0,
   primary key (UnitDocumentationId)
);


INSERT INTO bkp_20220203_UnitDocumentation
		(
		  UnitDocumentationId  
		, DocumentationId      
		, UnitId               
		, CustomerId           
		, ExpiresIn            
		, ReadyOn              
		, IssuedOn             
		, IsDeleted            
		)
SELECT UnitDocumentationId  
	, DocumentationId      
	, UnitId               
	, CustomerId           
	, ExpiresIn            
	, ReadyOn              
	, IssuedOn             
	, IsDeleted            
FROM UnitDocumentation;



/*==============================================================*/
/* Table: DocumentationStatus                                   */
/*==============================================================*/
create table DocumentationStatus
(
   DocumentationStatusCode char(3) not null,
   Description          varchar(25) not null,
   primary key (DocumentationStatusCode)
);


INSERT INTO DocumentationStatus (
DocumentationStatusCode,
Description
)
SELECT 'DEF', 'Definitivo'
	UNION ALL
SELECT 'DIS', 'Dispensado'
	UNION ALL
SELECT 'NSA', 'Não se aplica';

alter table Task
   modify column Title varchar(100) not null;

alter table UnitDocumentation
   add DocumentationStatusCode char(3);

/*==============================================================*/
/* Table: UnitDocumentationFile                                 */
/*==============================================================*/
create table UnitDocumentationFile
(
   UnitDocumentationFileId int not null auto_increment,
   UnitDocumentationId  int not null,
   Name                 varchar(120),
   StorageKey           char(36),
   StoragePath          varchar(256),
   IsDeleted            bool not null default 0,
   CreatedAt            datetime not null,
   primary key (UnitDocumentationFileId)
);

ALTER TABLE DocumentationStatus ENGINE = InnoDB;
ALTER TABLE UnitDocumentation CHARACTER SET = utf8;

ALTER TABLE DocumentationStatus
MODIFY COLUMN DocumentationStatusCode char(3) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL FIRST;

ALTER TABLE UnitDocumentation 
MODIFY COLUMN `DocumentationStatusCode` char(3) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL AFTER `IsDeleted`;

INSERT INTO UnitDocumentationFile 
	( UnitDocumentationId, Name, StorageKey, StoragePath, isDeleted, CreatedAt )
SELECT UnitDocumentationId, Name, StorageKey, StoragePath, IsDeleted, CURRENT_TIMESTAMP
FROM UnitDocumentation
WHERE StoragePath IS NOT NULL;
	
alter table UnitDocumentation
   drop column StoragePath;

alter table UnitDocumentation
   drop column StorageKey;

alter table UnitDocumentation
   drop column Name;
   

alter table UnitDocumentation add constraint FK_UnitDocm_DocmStatus foreign key (DocumentationStatusCode)
      references DocumentationStatus (DocumentationStatusCode) on delete restrict on update restrict;

alter table UnitDocumentationFile add constraint FK_UnitDocmFile_UnitDocm foreign key (UnitDocumentationId)
      references UnitDocumentation (UnitDocumentationId) on delete restrict on update restrict;

