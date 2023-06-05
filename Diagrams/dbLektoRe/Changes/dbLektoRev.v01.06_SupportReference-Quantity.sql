/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/7/2023 4:41:19 PM                          */
/*==============================================================*/


alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_LessonActivityOrientation;
;

alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_MediaInformation;
;

alter table LessonActivitySupportReference drop constraint FK_LessonActivitySupportReference_SupportReferenceType;
;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_LessonStep;
;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_MediaInformation;
;

alter table LessonStepSupportReference drop constraint FK_LessonStepSupportReference_SupportReferenceType;
;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_Lesson;
;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_MediaInformation;
;

alter table LessonSupportReference drop constraint FK_LessonSupportReference_SupportReferenceType;
;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_MediaInformation;
;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_ProjectStageOrientation;
;

alter table ProjectStageSupportReference drop constraint FK_ProjectStageSupportReference_SupportReferenceType;
;

alter table LessonActivitySupportReference
modify column idLessonActivitySupportReference int not null first,
   drop primary key
;

drop table if exists tmp_LessonActivitySupportReference
;

rename table LessonActivitySupportReference to tmp_LessonActivitySupportReference
;

alter table LessonStepSupportReference
modify column idLessonStepSupportReference int not null first,
   drop primary key
;

drop table if exists tmp_LessonStepSupportReference
;

rename table LessonStepSupportReference to tmp_LessonStepSupportReference
;

alter table LessonSupportReference
modify column idLessonSupportReference int not null first,
   drop primary key
;

drop table if exists tmp_LessonSupportReference
;

rename table LessonSupportReference to tmp_LessonSupportReference
;

alter table ProjectStageSupportReference
modify column idProjectStageSupportReference int not null first,
   drop primary key
;

drop table if exists tmp_ProjectStageSupportReference
;

rename table ProjectStageSupportReference to tmp_ProjectStageSupportReference
;

/*==============================================================*/
/* Table: LessonActivitySupportReference                        */
/*==============================================================*/
create table LessonActivitySupportReference
(
   idLessonActivitySupportReference int not null auto_increment,
   idLessonActivityOrientation int not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivitySupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonActivitySupportReference (idLessonActivitySupportReference, idLessonActivityOrientation, coSupportReference, IdMediaInformation, txTitle, txReferenceNumber, txReference, dtInserted, dtLastUpdate)
select idLessonActivitySupportReference, idLessonActivityOrientation, coSupportReference, IdMediaInformation, txTitle, txReferenceNumber, txReference, dtInserted, dtLastUpdate
from tmp_LessonActivitySupportReference
;

drop table if exists tmp_LessonActivitySupportReference
;

/*==============================================================*/
/* Table: LessonStepSupportReference                            */
/*==============================================================*/
create table LessonStepSupportReference
(
   idLessonStepSupportReference int not null auto_increment,
   idLessonStep         int not null,
   txTitle              varchar(120) not null,
   coSupportReference   char(4) not null,
   IdMediaInformation   int,
   txReference          varchar(300) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonStepSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonStepSupportReference (idLessonStepSupportReference, idLessonStep, txTitle, coSupportReference, IdMediaInformation, txReference, txReferenceNumber, dtInserted, dtLastUpdate)
select idLessonStepSupportReference, idLessonStep, txTitle, coSupportReference, IdMediaInformation, txReference, txReferenceNumber, dtInserted, dtLastUpdate
from tmp_LessonStepSupportReference
;

drop table if exists tmp_LessonStepSupportReference
;

/*==============================================================*/
/* Table: LessonSupportReference                                */
/*==============================================================*/
create table LessonSupportReference
(
   idLessonSupportReference int not null auto_increment,
   idLesson             int,
   IdMediaInformation   int,
   coSupportReference   char(4),
   txTitle              varchar(120) not null,
   txReference          varchar(300) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into LessonSupportReference (idLessonSupportReference, idLesson, IdMediaInformation, coSupportReference, txTitle, txReference, txReferenceNumber, dtInserted, dtLastUpdate)
select idLessonSupportReference, idLesson, IdMediaInformation, coSupportReference, txTitle, txReference, txReferenceNumber, dtInserted, dtLastUpdate
from tmp_LessonSupportReference
;

drop table if exists tmp_LessonSupportReference
;

/*==============================================================*/
/* Table: ProjectStageSupportReference                          */
/*==============================================================*/
create table ProjectStageSupportReference
(
   idProjectStageSupportReference int not null auto_increment,
   idProjectStageOrientation int,
   IdMediaInformation   int,
   coSupportReference   char(4) not null,
   txTitle              varchar(120) not null,
   txReferenceNumber    varchar(10) not null comment 'Campo de referencia numerica (requisito do Joao Vitor)',
   txReference          varchar(300) not null,
   txQuantity           smallint,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStageSupportReference)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into ProjectStageSupportReference (idProjectStageSupportReference, idProjectStageOrientation, IdMediaInformation, coSupportReference, txTitle, txReferenceNumber, txReference, dtInserted, dtLastUpdate)
select idProjectStageSupportReference, idProjectStageOrientation, IdMediaInformation, coSupportReference, txTitle, txReferenceNumber, txReference, dtInserted, dtLastUpdate
from tmp_ProjectStageSupportReference
;

drop table if exists tmp_ProjectStageSupportReference
;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_LessonActivityOrientation foreign key (idLessonActivityOrientation)
      references LessonActivityOrientation (idLessonActivityOrientation) on delete restrict on update restrict
;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonActivitySupportReference add constraint FK_LessonActivitySupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_LessonStep foreign key (idLessonStep)
      references LessonStep (idLessonStep) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonStepSupportReference add constraint FK_LessonStepSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_Lesson foreign key (idLesson)
      references Lesson (idLesson) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table LessonSupportReference add constraint FK_LessonSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict
;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_ProjectStageOrientation foreign key (idProjectStageOrientation)
      references ProjectStageOrientation (idProjectStageOrientation) on delete restrict on update restrict
;

alter table ProjectStageSupportReference add constraint FK_ProjectStageSupportReference_SupportReferenceType foreign key (coSupportReference)
      references SupportReferenceType (coSupportReference) on delete restrict on update restrict
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
          , JSON_OBJECT('@p0', IIF(NEW.inStatus = 1, 'ativado', 'desativado'))
          );

     END IF;

END ;



CREATE TRIGGER `tgau_LessonMoment` 
AFTER UPDATE ON LessonMoment
FOR EACH ROW 
BEGIN

     IF NEW.dtStartMoment <> OLD.dtStartMoment OR NEW.dtEndMoment <> OLD.dtEndMoment 
     THEN 

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          SELECT NOW()
               , 5 # Aluno tem sua turma atualizada com a definição de horários de aula pelo usuário {{p0}}
               , StudentClass.idNetwork
               , StudentClass.idUserStudent
               , JSON_OBJECT('@p0', NEW.idUserProfessor)
          FROM LessonMoment 
               INNER JOIN Class 
                       ON Class.idClass      = LessonMoment.idClass
                      AND Class.idNetwork    = LessonMoment.idNetwork
                      AND Class.idSchool     = LessonMoment.idSchool
                      AND Class.coGrade      = LessonMoment.coGrade
                      AND Class.idSchoolYear = LessonMoment.idSchoolYear
               INNER JOIN StudentClass  
                       ON StudentClass.idClass      = Class.idClass 
                      AND StudentClass.idNetwork    = Class.idNetwork 
                      AND StudentClass.idSchool     = Class.idSchool 
                      AND StudentClass.coGrade      = Class.coGrade 
                      AND StudentClass.idSchoolYear = Class.idSchoolYear
          WHERE idLessonMoment = NEW.idLessonMoment;

     END IF;

END ;


CREATE TRIGGER `tgau_StudentClass` 
AFTER UPDATE ON StudentClass
FOR EACH ROW 
BEGIN

     IF NEW.inStatus = 0
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
          , 16 # Aluno foi retirado da turma {{p0}} na data {{p1}}
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', OLD.idClass, '@p1', NOW())
          );

     END IF;

END ;


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

