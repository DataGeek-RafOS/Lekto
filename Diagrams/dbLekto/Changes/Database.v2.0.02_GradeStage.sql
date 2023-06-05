/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     6/22/2022 3:05:22 PM                         */
/*==============================================================*/


drop index IX_TXGRADE on Grade;

/*==============================================================*/
/* Index: ix_Grade_txGrade                                      */
/*==============================================================*/
create index ix_Grade_txGrade on Grade
(
   txGrade
);

/*==============================================================*/
/* Table: GradeStage                                            */
/*==============================================================*/
create table GradeStage
(
   idGradeStage         int not null auto_increment,
   idGrade              int not null,
   idStage              int not null,
   inStatus             boolean not null default 1,
   dtInserted           datetime not null,
   primary key (idGradeStage)
);

/*==============================================================*/
/* Index: uk_GradeStage_idGrade_idStage                         */
/*==============================================================*/
create unique index uk_GradeStage_idGrade_idStage on GradeStage
(
   idGrade,
   idStage
);

/*==============================================================*/
/* Table: Stage                                                 */
/*==============================================================*/
create table Stage
(
   idStage              int not null auto_increment,
   txName               varchar(200) not null,
   inStatus             boolean not null default 1,
   dtInserted           datetime not null,
   primary key (idStage)
);

alter table GradeStage add constraint FK_GradeStage_Grade foreign key (idGrade)
      references Grade (idGrade);

alter table GradeStage add constraint FK_GradeStage_Stage foreign key (idStage)
      references Stage (idStage);



INSERT INTO `dbLekto`.`DatabaseVersion`(`IdVersion`, `DateDeploy`, `txVersion`, `txComments`) VALUES (2, '2022-06-23 20:13:53', 'v2.0.02', '1. Criação das tabelas Grade e GradeStage');
