/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/28/2023 8:03:20 PM                         */
/*==============================================================*/


alter table Relationship drop constraint FK_Relationship_LektoUser;
;

alter table Relationship drop constraint FK_Relationship_LektoUserBound;
;

alter table Relationship drop constraint FK_Relationship_RelationType;
;

alter table UserProfile drop constraint FK_UserProfile_LektoUser;
;

alter table UserProfile drop constraint FK_UserProfile_ProfileType;
;

alter table UserProfileRegional drop constraint FK_UserProfileRegional_Network;
;

alter table UserProfileRegional drop constraint FK_UserProfileRegional_UserProfile;
;

alter table UserProfileSchool drop constraint FK_UserProfileSchool_School;
;

alter table UserProfileSchool drop constraint FK_UserProfileSchool_UserProfile;
;

alter table Relationship
   drop primary key
;

drop table if exists tmp_Relationship
;

rename table Relationship to tmp_Relationship
;

alter table UserProfile
   drop primary key
;

drop table if exists tmp_UserProfile
;

rename table UserProfile to tmp_UserProfile
;

# DESC UserProfileRegional

alter table UserProfileRegional
modify column idUserProfileRegional int not null first,
   drop primary key
;

drop table if exists tmp_UserProfileRegional
;

rename table UserProfileRegional to tmp_UserProfileRegional
;


desc UserProfileSchool
alter table UserProfileSchool
modify column idUserProfileSchool int not null first,
   drop primary key
;

drop table if exists tmp_UserProfileSchool
;

rename table UserProfileSchool to tmp_UserProfileSchool
;

/*==============================================================*/
/* Table: Relationship                                          */
/*==============================================================*/
create table Relationship
(
   idNetwork            int not null,
   idUser               int not null comment 'Usuario principal.',
   idUserBound          int not null comment 'Usuario vinculado.',
   coRelationType       char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idNetwork, idUser, idUserBound)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

alter table Relationship comment 'Tabela de relacionamento entre os usuarios.'
;

insert into Relationship (idNetwork, idUser, idUserBound, coRelationType, inDeleted, dtInserted, dtLastUpdate)
select idNetwork, idUser, idUserBound, coRelationType, inDeleted, dtInserted, dtLastUpdate
from tmp_Relationship
;

drop table if exists tmp_Relationship
;

/*==============================================================*/
/* Index: ixNCL_Relationship_coRelationType                     */
/*==============================================================*/
create index ixNCL_Relationship_coRelationType on Relationship
(
   coRelationType
)
;

/*==============================================================*/
/* Table: UserProfile                                           */
/*==============================================================*/
create table UserProfile
(
   idUserProfile        int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   coProfile            char(4) not null,
   inDeleted            tinyint(1) not null default 0,
   inStatus             tinyint(1) default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idUserProfile)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into UserProfile (idNetwork, idUser, coProfile, inDeleted, inStatus, dtInserted, dtLastUpdate)
select idNetwork, idUser, coProfile, inDeleted, inStatus, dtInserted, dtLastUpdate
from tmp_UserProfile
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_UserProfile
#;
/*==============================================================*/
/* Index: ukNCL_UserProfile                                     */
/*==============================================================*/
create unique index ukNCL_UserProfile on UserProfile
(
   idNetwork,
   idUser,
   coProfile
)
;

/*==============================================================*/
/* Table: UserProfileRegional                                   */
/*==============================================================*/
create table UserProfileRegional
(
   idUserProfileRegional int not null auto_increment,
   idUserProfile        int not null,
   idRegionalNetwork    int not null,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUserProfileRegional)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into UserProfileRegional (idUserProfileRegional, idUserProfile, idRegionalNetwork)
select idUserProfileRegional, ?, idRegionalNetwork
from tmp_UserProfileRegional
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_UserProfileRegional
#;
/*==============================================================*/
/* Index: ukNCL_UserProfileRegional                             */
/*==============================================================*/
create unique index ukNCL_UserProfileRegional on UserProfileRegional
(
   idRegionalNetwork
)
;

/*==============================================================*/
/* Table: UserProfileSchool                                     */
/*==============================================================*/
create table UserProfileSchool
(
   idUserProfileSchool  int not null auto_increment,
   idUserProfile        int not null,
   idNetwork            int not null,
   idSchool             int not null,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (idUserProfileSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into UserProfileSchool (idUserProfileSchool, idUserProfile, idNetwork, idSchool)
select idUserProfileSchool, ?, idNetwork, idSchool
from tmp_UserProfileSchool
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_UserProfileSchool
#;
/*==============================================================*/
/* Index: ukNCL_UserProfileSchool                               */
/*==============================================================*/
create unique index ukNCL_UserProfileSchool on UserProfileSchool
(
   idNetwork,
   idSchool
)
;

alter table Relationship add constraint FK_Relationship_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_LektoUserBound foreign key (idNetwork, idUserBound)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table Relationship add constraint FK_Relationship_RelationType foreign key (coRelationType)
      references RelationType (coRelationType) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_ProfileType foreign key (coProfile)
      references ProfileType (coProfile) on delete restrict on update restrict
;

alter table UserProfileRegional add constraint FK_UserProfileRegional_Network foreign key (idRegionalNetwork)
      references Network (idNetwork) on delete restrict on update restrict
;

alter table UserProfileRegional add constraint FK_UserProfileRegional_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;


CREATE TRIGGER `tgi_UserProfile` BEFORE INSERT ON `UserProfile` FOR EACH ROW BEGIN

	DECLARE _idNetworkReference INT;

	SELECT idNetworkReference INTO _idNetworkReference
	FROM Network
	WHERE idNetwork = new.idNetwork;
	
	IF _idNetworkReference IS NOT NULL
	THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_UserProfile: O identificador da rede informado no perfil nao e uma raiz de rede.';
	END IF;	

END ;


CREATE TRIGGER `tgu_UserProfile` BEFORE UPDATE ON `UserProfile` FOR EACH ROW BEGIN

	DECLARE _idNetworkReference INT;

	SELECT idNetworkReference INTO _idNetworkReference
	FROM Network
	WHERE idNetwork = new.idNetwork;
	
	IF _idNetworkReference IS NOT NULL
	THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro em tgi_UserProfile: O identificador da rede informado no perfil nao e uma raiz de rede.';
	END IF;	

END ;

