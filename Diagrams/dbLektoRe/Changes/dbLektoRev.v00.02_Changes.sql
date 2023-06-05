/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/10/2023 10:34:50 AM                        */
/*==============================================================*/


drop table if exists tmp_Relationship;

rename table Relationship to tmp_Relationship;


alter table `dbLektoRev`.`Ability` 
change column `idAbiliity` `idAbility` smallint NOT NULL AUTO_INCREMENT FIRST,
DROP PRIMARY KEY,
ADD PRIMARY KEY PK_Ability (`idAbility`) USING BTREE;   

alter table Moment
   alter column dtStartSchedule drop default;

/*==============================================================*/
/* Table: Relationship                                          */
/*==============================================================*/
create table Relationship
(
   idUser               int not null comment 'Usuario principal.',
   idUserBound          int not null comment 'Usuario vinculado.',
   coRelationType       char(4) not null,
   idNetwork            int not null,
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUser, idUserBound)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table Relationship comment 'Tabela de relacionamento entre os usuarios.';

drop table if exists tmp_Relationship;

/*==============================================================*/
/* Index: ixNCL_Relationship_coRelationType                     */
/*==============================================================*/
create index ixNCL_Relationship_coRelationType on Relationship
(
   coRelationType
);

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idNetwork, idUserBound)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType) on delete restrict on update restrict;

