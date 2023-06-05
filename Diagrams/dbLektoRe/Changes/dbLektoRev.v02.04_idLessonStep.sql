/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/19/2023 7:23:11 PM                         */
/*==============================================================*/


alter table LessonActivity drop constraint FK_LessonActivity_Category;

alter table LessonActivity drop constraint FK_LessonActivity__LessonStep;

alter table LessonActivity drop constraint FK_LessonActivity_EvidenceGrade;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table LessonActivity
modify column idLessonActivity int not null first,
   drop primary key;

drop table if exists tmp_LessonActivity;

rename table LessonActivity to tmp_LessonActivity;

/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idLessonStep         int not null,
   txTitle              varchar(150) not null,
   nuOrder              tinyint not null,
   idCategory           smallint,
   idEvidence           int,
   txChallenge          varchar(500) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into LessonActivity (idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idCategory, idEvidence, txChallenge, dtInserted, dtLastUpdate)
select idLessonActivity, coGrade, idStep, txTitle, nuOrder, idCategory, idEvidence, txChallenge, dtInserted, dtLastUpdate
from tmp_LessonActivity;

drop table if exists tmp_LessonActivity;

alter table LessonActivity add constraint FK_LessonActivity_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

