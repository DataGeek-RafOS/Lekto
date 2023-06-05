drop table if exists tmp_MomentNotes;

rename table MomentNotes to tmp_MomentNotes;



/*==============================================================*/
/* Table: MomentNotesEvidence                                   */
/*==============================================================*/
create table MomentNotesEvidence
(
   idMomentNotes        int not null,
   idEvidence           smallint not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   primary key (idMomentNotes, idEvidence)
);

insert into MomentNotesEvidence (idMomentNotes, idEvidence, inStatus, dtInserted)
select idMomentNotes, idEvidence, 1, dtInserted
from tmp_MomentNotes
where idEvidence is not null;


/*==============================================================*/
/* Table: MomentNotes                                           */
/*==============================================================*/
create table MomentNotes
(
   idMomentNotes        int not null auto_increment,
   idMoment             int not null,
   IdMediaInfo          char(36),
   txMomentNotes        longtext not null comment 'Informacoes complementares.',
   dtInserted           datetime not null default now(),
   primary key (idMomentNotes),
   key IX_DTINSERTED1 (dtInserted),
   key IX_IDMEDIAINFO (IdMediaInfo),
   key IX_MomentNotes_idMoment (idMoment)
);

insert into MomentNotes (idMomentNotes, idMoment, IdMediaInfo, txMomentNotes, dtInserted)
select idMomentNotes, idMoment, IdMediaInfo, txMomentNotes, dtInserted
from tmp_MomentNotes;

alter table MomentNotesApprentice drop constraint FK_MomentNotesApprentice_MomentNotes;

drop table if exists tmp_MomentNotes;


alter table MomentNotes add constraint FK_MomentNotes_Moment foreign key (idMoment)
      references Moment (idMoment);
	 

alter table SupportMaterial drop constraint FK_SUPPORTM_REFERENCE_MEDIAINF;

alter table MomentNotes drop constraint FK_MomentNotes_MediaInfo;

alter table School drop constraint FK_SCHOOL_REFERENCE_MEDIAINF;

alter table Step drop constraint FK_MediaInfo_Step;

ALTER TABLE `dbLekto`.`MomentNotes` 
MODIFY COLUMN `IdMediaInfo` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `idMoment`;

ALTER TABLE `dbLekto`.`MediaInfo` 
MODIFY COLUMN `IdMediaInfo` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL FIRST;


alter table MomentNotes add constraint FK_MomentNotes_MediaInfo foreign key (IdMediaInfo)
      references MediaInfo (IdMediaInfo) on delete set null;
	 
ALTER TABLE `dbLekto`.`School` 
MODIFY COLUMN `IdMediaInfoLogo` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `idSchoolNetwork`;	 

alter table School add constraint FK_School_MediaInfo foreign key (IdMediaInfoLogo)
      references MediaInfo (IdMediaInfo) on delete set null;
	 
ALTER TABLE `dbLekto`.`Step` 
MODIFY COLUMN `IdMediaInfoApprenticeCard` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `txNotesApprentice`;	 

alter table Step add constraint FK_MediaInfo_Step foreign key (IdMediaInfoApprenticeCard)
      references MediaInfo (IdMediaInfo) on delete set null;


alter table MomentNotes add constraint FK_MomentNotes_MediaInfo foreign key (IdMediaInfo)
      references MediaInfo (IdMediaInfo) on delete set null;

alter table MomentNotesApprentice add constraint FK_MomentNotesApprentice_MomentNotes foreign key (idMomentNotes)
      references MomentNotes (idMomentNotes) on delete cascade on update restrict;

alter table MomentNotesEvidence add constraint FK_MomentNotesEvidence_Evidence foreign key (idEvidence)
      references Evidence (idEvidence);

alter table MomentNotesEvidence add constraint FK_MomentNotesEvidence_MomentNotes foreign key (idMomentNotes)
      references MomentNotes (idMomentNotes);

