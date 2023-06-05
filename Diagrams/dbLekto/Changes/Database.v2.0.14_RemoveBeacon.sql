/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     08-Sep-22 17:39:49                           */
/*==============================================================*/


drop table if exists tmp_Apprentice;

rename table Apprentice to tmp_Apprentice;

drop table if exists tmp_LektoUser;

rename table LektoUser to tmp_LektoUser;

/*==============================================================*/
/* Table: Apprentice                                            */
/*==============================================================*/
create table Apprentice
(
   idApprentice         int not null auto_increment,
   idUser               int not null,
   idClass              int,
   coClassShift         char(3),
   primary key (idApprentice),
   unique key ukNCL_Apprentice_idUser_idClas (idUser, idClass),
   key IX_Apprentice_coClassShift (coClassShift),
   key IX_Apprentice_idClass (idClass)
);

insert into Apprentice (idApprentice, idUser, idClass, coClassShift)
select idApprentice, idUser, idClass, coClassShift
from tmp_Apprentice;

drop table if exists tmp_Apprentice;

/*==============================================================*/
/* Table: LektoUser                                             */
/*==============================================================*/
create table LektoUser
(
   idUser               int not null auto_increment,
   txName               varchar(120) not null,
   inStatus             tinyint(1) not null default 1,
   idAuth0              varchar(64),
   txImagePath          varchar(300) comment 'Caminho da imagem.',
   dtInserted           datetime not null default now(),
   inDeleted            tinyint(1) not null default 0,
   txEmail              varchar(120),
   txNickname           varchar(80),
   txPhone              varchar(11),
   txCpf                char(11),
   dtBirthdate          datetime,
   idAddress            int,
   idCityPlaceOfBirth   int,
   coMaritalStatus      char(3),
   isLgpdTermsAccepted  tinyint(1),
   txCodeOrigin         varchar(36),
   primary key (idUser),
   key IX_LektoUser_coMaritalStatus (coMaritalStatus),
   key IX_LektoUser_idAddress (idAddress),
   key IX_LektoUser_idCityPlaceOfBirth (idCityPlaceOfBirth),
   key IX_TXNAME (txName)
);

alter table LektoUser comment 'Tabela de usuarios.';

insert into LektoUser (idUser, txName, inStatus, idAuth0, txImagePath, dtInserted, inDeleted, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idAddress, idCityPlaceOfBirth, coMaritalStatus, isLgpdTermsAccepted, txCodeOrigin)
select idUser, txName, inStatus, idAuth0, txImagePath, dtInserted, inDeleted, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idAddress, idCityPlaceOfBirth, coMaritalStatus, isLgpdTermsAccepted, txCodeOrigin
from tmp_LektoUser;

alter table AccessControl drop constraint FK_AccessControl_LektoUser;

alter table tmp_Apprentice drop constraint FK_Apprentice_User;

alter table Audit drop constraint FK_AUDIT_REFERENCE_LEKTOUSE;

alter table BigFiveSurvey drop constraint FK_BIGFIVES_REFERENCE_LEKTOUSE;

alter table DataUsage drop constraint FK_DATAUSAG_REFERENCE_LEKTOUSE;

alter table Moment drop constraint FK_MOMENT_REFERENCE_LEKTOUSE;

alter table Notification drop constraint FK_Notification_User;

alter table Relationship drop constraint FK_Relationship_LektoUser;

alter table UserSession drop constraint FK_USERSESS_REFERENCE_LEKTOUSE;

alter table UserTimetable drop constraint FK_USERTIME_REFERENCE_LEKTOUSE;

alter table LektoUserType drop constraint FK_LEKTOUSE_REFERENCE_LEKTOUSERTYPE;

alter table ProfileSurvey drop constraint FK_Reference_86;

alter table SchoolClass drop constraint FK_SCHOOLCL_REFERENCE_LEKTOUSE;

alter table Relationship drop constraint FK_Relationship_LektoUserBound;

drop table if exists tmp_LektoUser;

alter table AccessControl add constraint FK_AccessControl_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;
	 
alter table ApprenticeProfile	 drop constraint FK_ApprenticeProfile_Apprentice;

alter table ApprenticeMoment	 drop constraint FK_Group_Apprentice;
	 
drop table tmp_Apprentice;	 
#
alter table Apprentice add constraint FK_Apprentice_Class foreign key (idClass)
      references SchoolClass (idSchoolClass) on delete restrict on update restrict;
#

 ALTER TABLE `dbLekto`.`Apprentice` 
MODIFY COLUMN `coClassShift` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `idClass`;

alter table Apprentice add constraint FK_Apprentice_ClassShift foreign key (coClassShift)
      references ClassShift (coClassShift) on delete set null;

alter table Apprentice add constraint FK_Apprentice_User foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table ApprenticeMoment add constraint FK_Group_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice) on delete restrict on update restrict;

alter table ApprenticeProfile add constraint FK_ApprenticeProfile_Apprentice foreign key (idApprentice)
      references Apprentice (idApprentice) on delete restrict on update restrict;

alter table Audit add constraint FK_Reference_99 foreign key (idUser)
      references LektoUser (idUser) on delete set null;

alter table BigFiveSurvey add constraint FK_Reference_116 foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

alter table DataUsage add constraint FK_Reference_122 foreign key (idUser)
      references LektoUser (idUser);

alter table LektoUser add constraint FK_LektoUser_Address foreign key (idAddress)
      references Address (idAddress) on delete set null;

alter table LektoUser add constraint FK_Reference_95 foreign key (idCityPlaceOfBirth)
      references City (idCity) on delete set null;

alter table LektoUser add constraint FK_Reference_96 foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete set null;
	 
ALTER TABLE `dbLekto`.`LektoUser` 
MODIFY COLUMN `coMaritalStatus` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `idCityPlaceOfBirth`;	 

alter table LektoUserType add constraint FK_LEKTOUSE_REFERENCE_LEKTOUSERTYPE foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

alter table Moment add constraint FK_Reference_103 foreign key (idTutor)
      references LektoUser (idUser);

alter table Notification add constraint FK_Notification_User foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table ProfileSurvey add constraint FK_Reference_86 foreign key (idUser)
      references LektoUser (idUser);

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idUserBound)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table SchoolClass add constraint FK_Reference_102 foreign key (idTutor)
      references LektoUser (idUser) on delete set null;

alter table UserSession add constraint FK_Reference_120 foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

alter table UserTimetable add constraint FK_Reference_91 foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

