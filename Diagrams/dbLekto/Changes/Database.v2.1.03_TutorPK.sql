/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     12/19/2022 10:34:05 PM                       */
/*==============================================================*/


alter table Tutor
modify column `idTutor` int NOT NULL FIRST;

alter table Tutor
   drop primary key;

drop table if exists tmp_Tutor;

rename table Tutor to tmp_Tutor;

/*==============================================================*/
/* Table: Tutor                                                 */
/*==============================================================*/
create table Tutor
(
   idSchoolClass        int not null,
   idUser               int not null,
   primary key (idUser, idSchoolClass)
)
default character set utf8mb4
collate utf8mb4_general_ci;

ALTER TABLE Tutor 
DROP PRIMARY KEY,
ADD PRIMARY KEY (`idSchoolClass`, `idUser`) USING BTREE;

insert into Tutor (idSchoolClass, idUser)
select distinct idSchoolClass, idUser
from tmp_Tutor;



drop table if exists tmp_Tutor;

/*==============================================================*/
/* Index: ixNCL_Tutor_idUser_idSchoolClass                      */
/*==============================================================*/
create index ixNCL_Tutor_idUser_idSchoolClass on Tutor
(
   idUser,
   idSchoolClass
);

alter table Tutor add constraint FK_LektoUser_Tutor foreign key (idUser)
      references LektoUser (idUser);

alter table Tutor add constraint FK_Tutor_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass);

