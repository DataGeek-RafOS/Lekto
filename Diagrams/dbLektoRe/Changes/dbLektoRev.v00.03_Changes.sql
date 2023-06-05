/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/11/2023 6:43:55 PM                         */
/*==============================================================*/


alter table LektoUser drop constraint FK_LektoUser_Network;

alter table Moment drop constraint FK_Moment_Class;

alter table Moment drop constraint FK_Moment_MomentStatus;

alter table Network drop constraint FK_Network_Network;

alter table Network drop constraint FK_Network_District;

alter table Professor drop constraint FK_Professor_Class;

alter table Professor drop constraint FK_Professor_LektoUser;

alter table School drop constraint FK_School_Network;

alter table SchoolYear drop constraint FK_SchoolYear_Network;

alter table Student drop constraint FK_Student_LektoUser;

alter table Student drop constraint FK_Student_SchoolGrade;

alter table StudentClass drop constraint FK_StudentClass_Class;

alter table StudentClass drop constraint FK_StudentClass_Student;

alter table StudentLesson drop constraint FK_StudentLesson_Lesson;

alter table StudentLesson drop constraint FK_StudentLesson_Moment;

alter table StudentLesson drop constraint FK_StudentLesson_StudentClass;

alter table Moment
   drop primary key;

drop table if exists tmp_Moment;

rename table Moment to tmp_Moment;

alter table Network
   drop primary key;

drop table if exists tmp_Network;

rename table Network to tmp_Network;

alter table Professor
	modify column `idProfessor` int not null first,
   drop primary key;

drop table if exists tmp_Professor;

rename table Professor to tmp_Professor;

alter table Student
	modify column `idStudent` int not null first,
   drop primary key;

drop table if exists tmp_Student;

rename table Student to tmp_Student;

alter table StudentClass
   drop primary key;

drop table if exists tmp_StudentClass;

rename table StudentClass to tmp_StudentClass;

alter table StudentLesson
modify column `idStudentLesson` int not null first,
drop primary key;

drop table if exists tmp_StudentLesson;

rename table StudentLesson to tmp_StudentLesson;

/*==============================================================*/
/* Table: Moment                                                */
/*==============================================================*/
create table Moment
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idMoment             int not null auto_increment,
   coMomentStatus       char(4) not null,
   Pro_idNetwork        int not null,
   Pro_idSchool         int not null,
   Pro_coGrade          char(4) not null,
   Pro_idSchoolYear     smallint not null,
   Pro_idClass          int not null,
   idUserProfessor      int not null,
   idProfessor          int not null,
   dtStartSchedule      time not null comment 'Hora de inicio.',
   dtEndSchedule        time not null,
   dtStartMoment        datetime,
   dtEndMoment          datetime,
   txClassStateHash     varchar(256),
   txJobId              varchar(36),
   dtProcessed          datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment),
   key ukNCL_Moment_idMoment (idMoment)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Moment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment, coMomentStatus, Pro_idNetwork, Pro_idSchool, Pro_coGrade, Pro_idSchoolYear, Pro_idClass, idUserProfessor, idProfessor, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate)
select idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment, coMomentStatus, dtStartSchedule, dtEndSchedule, dtStartMoment, dtEndMoment, txClassStateHash, txJobId, dtProcessed, dtInserted, dtLastUpdate
from tmp_Moment;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Moment;
/*==============================================================*/
/* Table: Network                                               */
/*==============================================================*/
create table Network
(
   idNetwork            int not null,
   txName               varchar(120) not null,
   idNetworkReference   int,
   coDistrict           char(2) not null,
   inAdminLektoEnabled  tinyint(1) not null default 1,
   inSingleSignOn       tinyint(1) not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Network (idNetwork, txName, idNetworkReference, coDistrict, inAdminLektoEnabled, inSingleSignOn, dtInserted, dtLastUpdate)
select idNetwork, txName, idNetworkReference, coDistrict, inAdminLektoEnabled, inSingleSignOn, dtInserted, dtLastUpdate
from tmp_Network;

drop table if exists tmp_Network;

/*==============================================================*/
/* Table: Professor                                             */
/*==============================================================*/
create table Professor
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserProfessor      int not null,
   idProfessor          int not null auto_increment,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor),
   key ukNCL_Professor (idProfessor)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor, dtInserted, dtLastUpdate)
select idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUser, idProfessor, dtInserted, dtLastUpdate
from tmp_Professor;

drop table if exists tmp_Professor;

/*==============================================================*/
/* Table: Student                                               */
/*==============================================================*/
create table Student
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idUserStudent        int not null,
   idStudent            int not null auto_increment,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idNetwork, idSchool, coGrade, idUserStudent, idStudent),
   key AK_ukNCL_Student (idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Student (idNetwork, idSchool, coGrade, idUserStudent, dtInserted, dtLastUpdate)
select idNetwork, idSchool, coGrade, idUser, dtInserted, dtLastUpdate
from tmp_Student;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Student;
/*==============================================================*/
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   primary key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
select idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUser, ?
from tmp_StudentClass;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_StudentClass;
/*==============================================================*/
/* Table: StudentLesson                                         */
/*==============================================================*/
create table StudentLesson
(
   idStudentLesson      int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   idLesson             int not null,
   idMoment             int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudentLesson)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into StudentLesson (idStudentLesson, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, idLesson, idMoment, dtInserted, dtLastUpdate)
select idStudentLesson, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUser, ?, idLesson, idMoment, dtInserted, dtLastUpdate
from tmp_StudentLesson;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_StudentLesson;
alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Moment add constraint FK_Moment_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table Moment add constraint FK_Moment_MomentStatus foreign key (coMomentStatus)
      references MomentStatus (coMomentStatus) on delete restrict on update restrict;

alter table Moment add constraint FK_Moment_Professor foreign key (Pro_idNetwork, Pro_idSchool, Pro_coGrade, Pro_idSchoolYear, Pro_idClass, idUserProfessor, idProfessor)
      references Professor (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserProfessor, idProfessor) on delete restrict on update restrict;

alter table Network add constraint FK_Network_District foreign key (coDistrict)
      references District (coDistrict) on delete restrict on update restrict;

alter table Network add constraint FK_Network_Network foreign key (idNetworkReference)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUserProfessor)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table School add constraint FK_School_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table SchoolYear add constraint FK_SchoolYear_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict;

alter table Student add constraint FK_Student_LektoUser foreign key (idNetwork, idUserStudent)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

alter table Student add constraint FK_Student_SchoolGrade foreign key (idNetwork, idSchool, coGrade)
      references SchoolGrade (idNetwork, idSchool, coGrade) on delete restrict on update restrict;

alter table StudentClass add constraint FK_StudentClass_Class foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references Class (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table StudentClass add constraint FK_StudentClass_Student foreign key (idNetwork, idSchool, coGrade, idUserStudent, idStudent)
      references Student (idNetwork, idSchool, coGrade, idUserStudent, idStudent) on delete restrict on update restrict;

alter table StudentLesson add constraint FK_StudentLesson_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict;

alter table StudentLesson add constraint FK_StudentLesson_Moment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment)
      references Moment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idMoment) on delete restrict on update restrict;

alter table StudentLesson add constraint FK_StudentLesson_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

