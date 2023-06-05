/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     8/18/2022 2:02:35 PM                         */
/*==============================================================*/


drop table if exists tmp_Stage;

rename table Stage to tmp_Stage;

alter table SegmentGrade
   add inStatus bool not null default 1;

alter table SegmentGrade
   add dtInserted datetime not null default NOW();

/*==============================================================*/
/* Table: Stage                                                 */
/*==============================================================*/
create table Stage
(
   idStage              int not null,
   txName               varchar(200) not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (idStage)
);

insert into Stage (idStage, txName, inStatus, dtInserted)
select idStage, txName, inStatus, dtInserted
from tmp_Stage;

alter table BigFiveQuestion drop constraint FK_STAGE_BIGFIVEQUESTION;

alter table GradeStage drop constraint FK_GradeStage_Stage;

drop table if exists tmp_Stage;

alter table GradeStage add constraint FK_GradeStage_Stage foreign key (idStage)
      references Stage (idStage);

