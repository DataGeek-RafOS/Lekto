/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     12/27/2022 10:53:43 AM                       */
/*==============================================================*/


drop table if exists tmp_LektoUser;

rename table LektoUser to tmp_LektoUser;

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
   dtInserted           datetime not null default 'getdate()',
   inDeleted            tinyint(1) not null default 0,
   txEmail              varchar(120),
   txNickname           varchar(80),
   txPhone              varchar(11),
   txCpf                char(11),
   dtBirthdate          datetime,
   idAddress            int,
   idCityPlaceOfBirth   int,
   coMaritalStatus      char(3),
   idSchoolNetwork      int,
   isLgpdTermsAccepted  tinyint(1),
   txCodeOrigin         varchar(36),
   primary key (idUser),
   key IX_LektoUser_coMaritalStatus (coMaritalStatus),
   key IX_LektoUser_idAddress (idAddress),
   key IX_LektoUser_idCityPlaceOfBirth (idCityPlaceOfBirth),
   key IX_TXNAME (txName)
);

alter table LektoUser comment 'Tabela de usuários.';

insert into LektoUser (idUser, txName, inStatus, idAuth0, txImagePath, dtInserted, inDeleted, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idAddress, idCityPlaceOfBirth, coMaritalStatus, isLgpdTermsAccepted, txCodeOrigin)
select idUser, txName, inStatus, idAuth0, txImagePath, dtInserted, inDeleted, txEmail, txNickname, txPhone, txCpf, dtBirthdate, idAddress, idCityPlaceOfBirth, coMaritalStatus, isLgpdTermsAccepted, txCodeOrigin
from tmp_LektoUser;

drop table if exists tmp_LektoUser;

/*==============================================================*/
/* Index: ixNCL_LektoUser_txEmail                               */
/*==============================================================*/
create index ixNCL_LektoUser_txEmail on LektoUser
(
   txEmail
);

alter table AccessControl add constraint FK_AccessControl_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table Apprentice add constraint FK_Apprentice_User foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table Audit add constraint FK_Reference_99 foreign key (idUser)
      references LektoUser (idUser) on delete set null;

alter table BigFiveSurvey add constraint FK_Reference_116 foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

alter table DataUsage add constraint FK_Reference_122 foreign key (idUser)
      references LektoUser (idUser);

alter table DiagnosticSurvey add constraint FK_DiagnosticSurvey_LektoUser foreign key (idUser)
      references LektoUser (idUser);

alter table LektoUser add constraint FK_LektoUser_Address foreign key (idAddress)
      references Address (idAddress) on delete set null;

alter table LektoUser add constraint FK_LektoUser_SchoolNetwork foreign key (idSchoolNetwork)
      references SchoolNetwork (idSchoolNetwork);

alter table LektoUser add constraint FK_Reference_95 foreign key (idCityPlaceOfBirth)
      references City (idCity) on delete set null;

alter table LektoUser add constraint FK_Reference_96 foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete set null;

alter table LektoUserType add constraint FK_LEKTOUSE_REFERENCE_LEKTOUSERTYPE foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

alter table Moment add constraint FK_Reference_103 foreign key (idTutor)
      references LektoUser (idUser);

alter table Notification add constraint FK_Notification_User foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table ProfileSurvey add constraint FK_ProfileSurvey_LektoUser foreign key (idUser)
      references LektoUser (idUser);

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idUserBound)
      references LektoUser (idUser) on delete restrict on update restrict;

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_LektoUser foreign key (idTutorSegment)
      references LektoUser (idUser);

alter table Tutor add constraint FK_LektoUser_Tutor foreign key (idUser)
      references LektoUser (idUser);

alter table UserSession add constraint FK_UserSession_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

alter table UserTimetable add constraint FK_Reference_91 foreign key (idUser)
      references LektoUser (idUser) on delete cascade;

