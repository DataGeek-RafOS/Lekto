/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     11-Dec-22 19:53:10                           */
/*==============================================================*/

alter table Tutor drop constraint FK_LektoUser_Tutor;

alter table Tutor drop constraint FK_Tutor_SchoolClass;

alter table Tutor
   drop primary key;

drop table if exists tmp_Tutor;

rename table Tutor to tmp_Tutor;

/*==============================================================*/
/* Table: Tutor                                                 */
/*==============================================================*/
create table Tutor
(
   idTutor              int not null auto_increment,
   idUser               int not null,
   idSchoolClass        int not null,
   primary key (idTutor)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Tutor (idUser, idSchoolClass)
select idUser, idSchoolClass
from tmp_Tutor;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Tutor;
/*==============================================================*/
/* Index: ixNCL_Tutor_idSchoolClass_idUser                      */
/*==============================================================*/
create index ixNCL_Tutor_idSchoolClass_idUser on Tutor
(
   idSchoolClass,
   idUser
);

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

