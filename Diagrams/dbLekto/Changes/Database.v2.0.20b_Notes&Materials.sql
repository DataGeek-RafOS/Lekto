/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     28-Sep-22 14:11:17                           */
/*==============================================================*/


drop table if exists tmp_SupportMaterial;

rename table SupportMaterial to tmp_SupportMaterial;



/*==============================================================*/
/* Table: CardSupportMaterial                                   */
/*==============================================================*/
create table CardSupportMaterial
(
   idSupportMaterial    smallint not null auto_increment,
   idCard               int not null,
   IdMediaInfo          char(36) not null,
   coMediaType          char(3) character set utf8mb4 not null,
   txSupportMaterial    varchar(250) character set utf8mb4,
   txImagePath          longtext comment 'Caminho da imagem.',
   inStatus             tinyint(1) not null default 1,
   txThumbnail          varchar(300) character set utf8mb4,
   dtInserted           datetime not null default now(),
   primary key (idSupportMaterial),
   key IX_CardSupportMaterial_coMediaType (coMediaType),
   key IX_CardSupportMaterial_txSupportMaterial (txSupportMaterial)
);



/*==============================================================*/
/* Table: StepSupportMaterial                                   */
/*==============================================================*/
create table StepSupportMaterial
(
   idSupportMaterial    smallint not null auto_increment,
   idCard               int not null,
   idStep               int not null,
   IdMediaInfo          char(36) character set utf8mb4,
   coMediaType          char(3) character set utf8mb4 not null,
   txSupportMaterial    varchar(250) character set utf8mb4,
   txImagePath          longtext comment 'Caminho da imagem.',
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   txThumbnail          varchar(300) character set utf8mb4,
   primary key (idSupportMaterial),
   key IX_StepSupportMaterial_IdMediaInfo (IdMediaInfo),
   key IX_StepSupportMaterial_coMediaType (coMediaType),
   key IX_StepSupportMaterial_idCard_idStep (idCard, idStep),
   key IX_StepSupportMaterial_txSupportMaterial (txSupportMaterial)
);

insert into StepSupportMaterial (idSupportMaterial, idCard, idStep, IdMediaInfo, coMediaType, txSupportMaterial, txImagePath, inStatus, dtInserted, txThumbnail)
select idSupportMaterial, idCard, idStep, IdMediaInfo, coMediaType, txSupportMaterial, txImagePath, inStatus, dtInserted, txThumbnail
from tmp_SupportMaterial;

drop table if exists tmp_SupportMaterial;


alter table CardSupportMaterial add constraint FK_CardSupportMaterial_Card foreign key (idCard)
      references Card (idCard);

alter table CardSupportMaterial add constraint FK_CardSupportMaterial_MediaInfo foreign key (IdMediaInfo)
      references MediaInfo (IdMediaInfo);


alter table StepSupportMaterial add constraint FK_StepSupportMaterial_MediaInfo foreign key (IdMediaInfo)
      references MediaInfo (IdMediaInfo) on delete set null;

alter table StepSupportMaterial add constraint FK_SupportMaterial_Step foreign key (idStep, idCard)
      references Step (idStep, idCard) on delete cascade on update restrict;

alter table StepSupportMaterial add constraint FK_Reference_110 foreign key (coMediaType)
      references MediaType (coMediaType);

