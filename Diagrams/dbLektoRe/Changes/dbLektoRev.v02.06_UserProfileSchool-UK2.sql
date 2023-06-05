/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/21/2023 12:14:30 PM                        */
/*==============================================================*/


alter table UserProfileSchool drop constraint FK_UserProfileSchool_School;
;

alter table UserProfileSchool drop constraint FK_UserProfileSchool_UserProfile;
;

alter table UserProfileSchool
modify column idUserProfileSchool int not null first,
   drop primary key
;

drop table if exists tmp_UserProfileSchool
;

rename table UserProfileSchool to tmp_UserProfileSchool
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
   dtInserted           datetime not null default 'now()',
   dtLastUpdate         datetime,
   primary key (idUserProfileSchool)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into UserProfileSchool (idUserProfileSchool, idUserProfile, idNetwork, idSchool, dtInserted, dtLastUpdate)
select idUserProfileSchool, idUserProfile, idNetwork, idSchool, dtInserted, dtLastUpdate
from tmp_UserProfileSchool
;

drop table if exists tmp_UserProfileSchool
;

/*==============================================================*/
/* Index: ukNCL_UserProfileSchool                               */
/*==============================================================*/
create unique index ukNCL_UserProfileSchool on UserProfileSchool
(
   idNetwork,
   idSchool,
   idUserProfile
)
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_School foreign key (idNetwork, idSchool)
      references School (idNetwork, idSchool) on delete restrict on update restrict
;

alter table UserProfileSchool add constraint FK_UserProfileSchool_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
;




CREATE TRIGGER `tgad_UserProfileSchool` 
AFTER DELETE ON UserProfileSchool
FOR EACH ROW 
BEGIN

     INSERT INTO ActionLog
     (
       dtAction
     , idActionLogType          
     , idNetwork
     , idUser
     , txVariables
     )
	SELECT NOW()
		, 18 # Usuarioo foi retirado da escola {{p0}} da rede {{@p1}} do perfil {{p2}}
		, UserProfile.idNetwork
		, UserProfile.idUser
		, JSON_OBJECT('@p0', OLD.idSchool, '@p1', OLD.idNetwork, '@p2', UserProfile.coProfile)
	FROM UserProfileSchool
		INNER JOIN UserProfile
			   ON UserProfile.idUserProfile = UserProfileSchool.idUserProfile
	WHERE OLD.idUserProfileSchool;

END ;

