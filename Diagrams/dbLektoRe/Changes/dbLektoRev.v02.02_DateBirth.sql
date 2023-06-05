/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/17/2023 3:37:10 PM                         */
/*==============================================================*/


alter table ActionLog drop constraint FK_ActionLog_LektoUser;
;

alter table DataUsage drop constraint FK_DataUsage_LektoUser;
;

alter table DiagnosticSurvey drop constraint FK_DiagnosticSurvey_LektoUser;
;

alter table LektoUser drop constraint FK_LektoUser_MaritalStatus;
;

alter table LektoUser drop constraint FK_LektoUser_Network;
;

alter table Notification drop constraint FK_Notification_LektoUser;
;

alter table Professor drop constraint FK_Professor_LektoUser;
;

alter table Relationship drop constraint FK_Relationship_LektoUser;
;

alter table Relationship drop constraint FK_Relationship_LektoUserBound;
;

alter table Student drop constraint FK_Student_LektoUser;
;

alter table UserAddress drop constraint FK_UserAddress_LektoUser;
;

alter table UserProfile drop constraint FK_UserProfile_LektoUser;
;

alter table UserSession drop constraint FK_UserSession_LektoUser;
;

alter table LektoUser
modify column idLektoUser int not null first,
   drop primary key
;

drop table if exists tmp_LektoUser
;

rename table LektoUser to tmp_LektoUser
;

/*==============================================================*/
/* Table: LektoUser                                             */
/*==============================================================*/
create table LektoUser
(
   idNetwork            int not null,
   idUser               int not null auto_increment,
   txName               varchar(120) not null,
   idSingleSignOn       varchar(64),
   txImagePath          varchar(300) comment 'Caminho da imagem.',
   txEmail              varchar(120),
   txNickname           varchar(80),
   txPhone              varchar(11),
   txCpf                char(11),
   dtBirthdate          date,
   idCityPlaceOfBirth   int,
   coMaritalStatus      char(3),
   inStatus             tinyint(1) not null default 1,
   txCodeOrigin         varchar(36),
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default 'NOW()',
   dtLastUpdate         datetime,
   primary key (idUser),
   unique key AK_LektoUser (idNetwork, idUser)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will not restore columns: dtBirthdate
insert into LektoUser (idNetwork, idUser, txName, idSingleSignOn, txImagePath, txEmail, txNickname, txPhone, txCpf, idCityPlaceOfBirth, coMaritalStatus, inStatus, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate)
select idNetwork, idUser, txName, idSingleSignOn, txImagePath, txEmail, txNickname, txPhone, txCpf, idCityPlaceOfBirth, coMaritalStatus, inStatus, txCodeOrigin, inDeleted, dtInserted, dtLastUpdate
from tmp_LektoUser
;

#WARNING: Drop cancelled because columns cannot be restored: dtBirthdate
#drop table if exists tmp_LektoUser
#;
/*==============================================================*/
/* Index: ukNCL_LektoUser_txCodeOrigin                          */
/*==============================================================*/
create unique index ukNCL_LektoUser_txCodeOrigin on LektoUser
(
   txCodeOrigin,
   idNetwork
)
;

/*==============================================================*/
/* Index: ukNCL_Lekto_txEmail                                   */
/*==============================================================*/
create unique index ukNCL_Lekto_txEmail on LektoUser
(
   txEmail
)
;

alter table ActionLog add constraint FK_ActionLog_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table DataUsage add constraint FK_DataUsage_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table DiagnosticSurvey add constraint FK_DiagnosticSurvey_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table LektoUser add constraint FK_LektoUser_MaritalStatus foreign key (coMaritalStatus)
      references MaritalStatus (coMaritalStatus) on delete restrict on update restrict
;

alter table LektoUser add constraint FK_LektoUser_Network foreign key (idNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table Notification add constraint FK_Notification_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Professor add constraint FK_Professor_LektoUser foreign key (idNetwork, idUserProfessor)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idNetwork, idUserBound)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Student add constraint FK_Student_LektoUser foreign key (idNetwork, idUserStudent)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserAddress add constraint FK_UserAddress_LektoUser foreign key (idUser)
      references LektoUser (idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserSession add constraint FK_UserSession_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;



CREATE TRIGGER `tgau_LektoUser` 
AFTER UPDATE ON LektoUser
FOR EACH ROW 
BEGIN

     IF NEW.inStatus <> OLD.inStatus
     THEN

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 17 # A situação do usuário mudou para {{@p0}}
          , NEW.idNetwork
          , NEW.idUser
          , JSON_OBJECT('@p0', CASE WHEN NEW.inStatus = 1 THEN 'ativado' ELSE 'desativado' END)
          );

     END IF;

END ;

