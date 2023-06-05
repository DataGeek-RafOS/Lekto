/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     26-Oct-22 15:43:39                           */
/*==============================================================*/


drop table if exists tmp_Card;

rename table Card to tmp_Card;

/*==============================================================*/
/* Table: Card                                                  */
/*==============================================================*/
create table Card
(
   idCard               int not null auto_increment,
   txTitle              varchar(150) not null,
   txCard               varchar(2000) not null comment 'Texto descritivo do cartão.',
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default 'getdate()',
   idTheme              smallint not null,
   txOtherPossibilities longtext,
   txApprenticeCard     varchar(300),
   txSupport            varchar(500),
   txSupportAuthor      varchar(120),
   inShowThemeHierarchy tinyint(1) default 0,
   txBncc               longtext,
   txMaterials          longtext,
   txLinkPDF            varchar(255) character set utf8mb4,
   primary key (idCard),
   key ixNCL_txTitle (txTitle),
   key FK_Card_Theme (idTheme)
);

#WARNING: The following insert order will not restore columns: txOtherPossibilities
insert into Card (idCard, txTitle, txCard, inStatus, dtInserted, idTheme, txApprenticeCard, txSupport, txSupportAuthor, inShowThemeHierarchy, txBncc, txMaterials, txLinkPDF)
select idCard, txTitle, txCard, inStatus, dtInserted, idTheme, txApprenticeCard, txSupport, txSupportAuthor, inShowThemeHierarchy, txBncc, txMaterials, txLinkPDF
from tmp_Card;

#WARNING: Drop cancelled because columns cannot be restored: txOtherPossibilities
#drop table if exists tmp_Card;
alter table Moment
   add jobId varchar(36);

alter table Card add constraint FK_Card_Theme foreign key (idTheme)
      references Theme (idTheme);

alter table CardEvidence add constraint FK_CardEvidence_Card foreign key (idCard)
      references Card (idCard) on delete cascade;

alter table CardGrade add constraint FK_Reference_74 foreign key (idCard)
      references Card (idCard) on delete cascade;

alter table CardInfrastructure add constraint FK_CardInfrastructure_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

alter table CardLearningTool add constraint FK_CardLearningTool_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

alter table CardReference add constraint FK_Reference_108 foreign key (idCard)
      references Card (idCard) on delete cascade;

alter table CardSchoolSupply add constraint FK_CardSchoolSupply_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

alter table CardSupportMaterial add constraint FK_CardSupportMaterial_Card foreign key (idCard)
      references Card (idCard);

alter table MomentCard add constraint FK_Reference_58 foreign key (idCard)
      references Card (idCard);

alter table ProjectStage add constraint FK_Card_ProjectStage foreign key (idCard)
      references Card (idCard);

alter table Step add constraint FK_Step_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

