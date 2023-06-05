/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/11/2023 6:52:20 PM                         */
/*==============================================================*/


alter table Moment drop constraint FK_Moment_Professor;

alter table Moment
   drop column Pro_idClass;

alter table Moment
   drop column Pro_idSchoolYear;

alter table Moment
   drop column Pro_coGrade;

alter table Moment
   drop column Pro_idSchool;

alter table Moment
   drop column Pro_idNetwork;
   


alter table Moment add constraint FK_Moment__Professor foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;
	 

