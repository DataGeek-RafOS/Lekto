/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/29/2023 6:23:36 PM                         */
/*==============================================================*/


alter table LessonMoment drop constraint FK_LessonMoment_LessonTrack;
;

alter table LessonTrack drop constraint FK_LessonTrack_Grade;
;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_Lesson;
;

alter table LessonTrackGroup drop constraint FK_LessonTrackGroup_LessonTrack;
;

alter table ProjectMoment drop constraint FK_ProjectMoment_ProjectTrack;
;

alter table ProjectTrack drop constraint FK_ProjectTrack_Component;
;

alter table ProjectTrack drop constraint FK_ProjectTrack_Grade;
;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectComponent;
;

alter table ProjectTrackGroup drop constraint FK_ProjectTrackGroup_ProjectTrack;
;

alter table UserProfile drop constraint FK_UserProfile_LektoUser;
;

alter table UserProfile drop constraint FK_UserProfile_ProfileType;
;

alter table UserProfileRegional drop constraint FK_UserProfileRegional_UserProfile;
;

alter table UserProfileSchool drop constraint FK_UserProfileSchool_UserProfile;
;

alter table LessonTrack
modify column idLessonTrack int not null first,
   drop primary key
;

drop table if exists tmp_LessonTrack
;

rename table LessonTrack to tmp_LessonTrack
;

alter table LessonTrackGroup
modify column idLessonTrackGroup int not null first,
drop primary key
;

drop table if exists tmp_LessonTrackGroup
;

rename table LessonTrackGroup to tmp_LessonTrackGroup
;

alter table ProjectTrack
modify column idProjectTrack int not null first,
   drop primary key
;

drop table if exists tmp_ProjectTrack
;

rename table ProjectTrack to tmp_ProjectTrack
;

alter table ProjectTrackGroup
   drop primary key
;

drop table if exists tmp_ProjectTrackGroup
;

rename table ProjectTrackGroup to tmp_ProjectTrackGroup
;

alter table UserProfile
modify column idUserProfile int not null first,
   drop primary key
;

drop table if exists tmp_UserProfile
;

rename table UserProfile to tmp_UserProfile
;

alter table Lesson
   add unique AK_Lesson (idLesson, coGrade)
;

/*==============================================================*/
/* Table: LessonTrack                                           */
/*==============================================================*/
create table LessonTrack
(
   idLessonTrack        int not null auto_increment,
   coGrade              char(4) not null,
   coComponent          char(3),
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack, coGrade),
   key AK_LessonTrack (idLessonTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonTrack (idLessonTrack, coGrade, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idLessonTrack, coGrade, txTitle, txDescription, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_LessonTrack
;

drop table if exists tmp_LessonTrack
;

/*==============================================================*/
/* Table: LessonTrackGroup                                      */
/*==============================================================*/
create table LessonTrackGroup
(
   idLessonTrack        int not null,
   idLesson             int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonTrack, coGrade, idLesson)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonTrackGroup (idLessonTrack, idLesson, coGrade, dtInserted)
select idLessonTrack, idLesson, coGrade, now()
from tmp_LessonTrackGroup
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_LessonTrackGroup
#;
alter table Project
   add unique AK_AK_Project (idProject, coGrade)
;

/*==============================================================*/
/* Table: ProjectTrack                                          */
/*==============================================================*/
create table ProjectTrack
(
   idProjectTrack       int not null auto_increment,
   txTitle              varchar(150) not null,
   txDescription        varchar(300),
   coGrade              char(4) not null,
   coComponent          char(3) not null,
   txGuidanceBNCC       varchar(1000),
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack),
   key AK_ProjectTrack (idProjectTrack, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into ProjectTrack (idProjectTrack, txTitle, txDescription, coGrade, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectTrack, txTitle, txDescription, coGrade, coComponent, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectTrack
;

drop table if exists tmp_ProjectTrack
;

/*==============================================================*/
/* Table: ProjectTrackGroup                                     */
/*==============================================================*/
create table ProjectTrackGroup
(
   idProjectTrack       int not null,
   idProject            int not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectTrack, idProject, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectTrackGroup (idProjectTrack, idProject, coGrade, dtInserted, dtLastUpdate)
select idProjectTrack, idProject, 1, dtInserted, dtLastUpdate
from tmp_ProjectTrackGroup
;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectTrackGroup
#;
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

insert into UserProfile (idUserProfile, idNetwork, idUser, coProfile, inDeleted, inStatus, dtInserted, dtLastUpdate)
select idUserProfile, idNetwork, idUser, coProfile, inDeleted, inStatus, dtInserted, dtLastUpdate
from tmp_UserProfile
;

drop table if exists tmp_UserProfile
;

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

alter table LessonMoment add constraint FK_LessonMoment_LessonTrack foreign key (idLessonTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict
;

alter table LessonTrack add constraint FK_LessonTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table LessonTrack add constraint FK_LessonTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_Lesson foreign key (idLesson, coGrade)
      references Lesson (idLesson, coGrade) on delete restrict on update restrict
;

alter table LessonTrackGroup add constraint FK_LessonTrackGroup_LessonTrack foreign key (idLessonTrack, coGrade)
      references LessonTrack (idLessonTrack, coGrade) on delete restrict on update restrict
;

alter table ProjectMoment add constraint FK_ProjectMoment_ProjectTrack foreign key (idProjectTrack)
      references ProjectTrack (idProjectTrack) on delete restrict on update restrict
;

alter table ProjectTrack add constraint FK_ProjectTrack_Component foreign key (coComponent)
      references Component (coComponent) on delete restrict on update restrict
;

alter table ProjectTrack add constraint FK_ProjectTrack_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict
;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict
;

alter table ProjectTrackGroup add constraint FK_ProjectTrackGroup_ProjectTrack foreign key (idProjectTrack, coGrade)
      references ProjectTrack (idProjectTrack, coGrade) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict
;

alter table UserProfile add constraint FK_UserProfile_ProfileType foreign key (coProfile)
      references ProfileType (coProfile) on delete restrict on update restrict
;

alter table UserProfileRegional add constraint FK_UserProfileRegional_UserProfile foreign key (idUserProfile)
      references UserProfile (idUserProfile) on delete restrict on update restrict
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

