/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     28-Sep-22 14:53:27                           */
/*==============================================================*/


drop table if exists tmp_CardSupportMaterial;

rename table CardSupportMaterial to tmp_CardSupportMaterial;

drop table if exists tmp_StepSupportMaterial;

rename table StepSupportMaterial to tmp_StepSupportMaterial;

/*==============================================================*/
/* Table: CardSupportMaterial                                   */
/*==============================================================*/
create table CardSupportMaterial
(
   idSupportMaterial    smallint not null,
   idCard               int not null,
   primary key (idSupportMaterial)
);

insert into CardSupportMaterial (idSupportMaterial, idCard)
select idSupportMaterial, idCard
from tmp_CardSupportMaterial;

drop table if exists tmp_CardSupportMaterial;

/*==============================================================*/
/* Table: StepSupportMaterial                                   */
/*==============================================================*/
create table StepSupportMaterial
(
   idSupportMaterial    smallint not null,
   idCard               int not null,
   idStep               int not null
);

   alter table StepSupportMaterial add constraint PK_StepSupportMaterial primary key (idSupportMaterial, idCard, idStep)

insert into StepSupportMaterial (idSupportMaterial, idCard, idStep)
select idSupportMaterial, idCard, idStep
from tmp_StepSupportMaterial;

/*==============================================================*/
/* Table: SupportMaterial                                       */
/*==============================================================*/
create table SupportMaterial
(
   idSupportMaterial    smallint not null auto_increment,
   IdMediaInfo          char(36) character set utf8mb4,
   coMediaType          char(3) character set utf8mb4 COLLATE utf8mb4_general_ci not null,
   txSupportMaterial    varchar(250) character set utf8mb4,
   txImagePath          longtext comment 'Caminho da imagem.',
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   txThumbnail          varchar(300) character set utf8mb4 COLLATE utf8mb4_general_ci,
   primary key (idSupportMaterial),
   key IX_StepSupportMaterial_IdMediaInfo (IdMediaInfo),
   key IX_StepSupportMaterial_coMediaType (coMediaType),
   key IX_StepSupportMaterial_txSupportMaterial (txSupportMaterial)
);



insert into SupportMaterial (idSupportMaterial, IdMediaInfo, coMediaType, txSupportMaterial, txImagePath, inStatus, dtInserted, txThumbnail)
select idSupportMaterial, IdMediaInfo, coMediaType, txSupportMaterial, txImagePath, inStatus, dtInserted, txThumbnail
from tmp_StepSupportMaterial;

drop table if exists tmp_StepSupportMaterial;

alter table CardSupportMaterial add constraint FK_CardSupportMaterial_Card foreign key (idCard)
      references Card (idCard);

alter table CardSupportMaterial add constraint FK_CardSupportMaterial_CardSupportMaterial foreign key (idSupportMaterial)
      references SupportMaterial (idSupportMaterial);

alter table StepSupportMaterial add constraint FK_StepSupportMaterial_SupportMaterial foreign key (idSupportMaterial)
      references SupportMaterial (idSupportMaterial);

alter table StepSupportMaterial add constraint FK_StepSupportMaterial_Step foreign key (idStep, idCard)
      references Step (idStep, idCard);

alter table School drop constraint FK_SCHOOL_REFERENCE_MEDIAINF;

ALTER TABLE `dbLekto`.`MediaInfo` 
MODIFY COLUMN `IdMediaInfo` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL FIRST;

alter table SupportMaterial add constraint FK_StepSupportMaterial_MediaInfo foreign key (IdMediaInfo)
      references MediaInfo (IdMediaInfo) on delete set null;
	 
alter table School add constraint FK_School_MediaInfo foreign key (IdMediaInfoLogo)
      references MediaInfo (IdMediaInfo) on delete set null;
	 

alter table SupportMaterial add constraint FK_SupportMaterial_MediaType foreign key (coMediaType)
      references MediaType (coMediaType);

