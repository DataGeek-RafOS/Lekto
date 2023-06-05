/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     07-Oct-22 14:27:11                           */
/*==============================================================*/


drop table if exists tmp_MomentNotesEvidence;

rename table MomentNotesEvidence to tmp_MomentNotesEvidence;

/*==============================================================*/
/* Table: MomentNotesEvidence                                   */
/*==============================================================*/
create table MomentNotesEvidence
(
   idMomentNotes        int not null,
   idEvidence           smallint not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null DEFAULT NOW(),
   primary key (idMomentNotes, idEvidence)
);

insert into MomentNotesEvidence (idMomentNotes, idEvidence, inStatus, dtInserted)
select idMomentNotes, idEvidence, inStatus, dtInserted
from tmp_MomentNotesEvidence;

drop table if exists tmp_MomentNotesEvidence;

alter table MomentNotesEvidence add constraint FK_MomentNotesEvidence_Evidence foreign key (idEvidence)
      references Evidence (idEvidence);

alter table MomentNotesEvidence add constraint FK_MomentNotesEvidence_MomentNotes foreign key (idMomentNotes)
      references MomentNotes (idMomentNotes) on delete cascade on update CASCADE;

SELECT * FROM MomentNotesEvidence