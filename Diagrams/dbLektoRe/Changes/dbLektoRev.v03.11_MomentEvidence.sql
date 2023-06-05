/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     4/11/2023 6:19:32 PM                         */
/*==============================================================*/



drop table if exists tmp_LessonMomentActivity;

rename table LessonMomentActivity to tmp_LessonMomentActivity;

drop table if exists tmp_LessonMomentGroup;

rename table LessonMomentGroup to tmp_LessonMomentGroup;

drop table if exists tmp_ProjectMomentGroup;

rename table ProjectMomentGroup to tmp_ProjectMomentGroup;

drop table if exists tmp_ProjectMomentStage;

rename table ProjectMomentStage to tmp_ProjectMomentStage;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;


alter table MediaInformation
   modify column txName varchar(2000) not null;

alter table MediaInformation
   modify column txPath varchar(2000) not null;

/*==============================================================*/
/* Table: EvidenceType                                          */
/*==============================================================*/
create table EvidenceType
(
   coEvidenceType       char(3) not null,
   txEvidenceType       varchar(50) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (coEvidenceType)
);

insert into EvidenceType (coEvidenceType, txEvidenceType, dtInserted ) values ('FIX', 'Fixa', now());
insert into EvidenceType (coEvidenceType, txEvidenceType, dtInserted ) values ('VAR', 'Variável', now());

/*==============================================================*/
/* Table: LessonActivityEvidence                                */
/*==============================================================*/
create table LessonActivityEvidence
(
   idLessonActivity     int not null,
   idEvidence           int not null,
   coGrade              char(4) not null,
   coEvidenceType       char(3) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, idEvidence, coGrade)
);

insert into LessonActivityEvidence 
(
  idLessonActivity
, idEvidence
, coGrade
, coEvidenceType
, dtInserted
, dtLastUpdate
)
select distinct
	  acti.idLessonActivity
	, evid.idEvidence
	, step.coGrade
	, 'FIX'
	, evid.dtInserted
	, evid.dtLastUpdate
from LessonStep step
	inner join LessonStepEvidence evid
		   on evid.idLessonStep = step.idLessonStep and evid.coGrade = step.coGrade
	inner join LessonActivity acti
		   on acti.idLessonStep = step.idLessonStep and acti.coGrade = step.coGrade;

insert into LessonActivityEvidence 
(
  idLessonActivity
, idEvidence
, coGrade
, coEvidenceType
, dtInserted
, dtLastUpdate
)
select distinct
	  idLessonActivity
	, idEvidence
	, coGrade
	, 'VAR'
	, dtInserted
	, dtLastUpdate
from LessonActivity
where idEvidence is not null
and   not exists ( select * 
			    from LessonActivityEvidence 
			    where LessonActivityEvidence.idLessonActivity = LessonActivity.idLessonActivity
			    and   LessonActivityEvidence.idEvidence = LessonActivity.idEvidence
			    and   LessonActivityEvidence.coGrade = LessonActivity.coGrade );


/*==============================================================*/
/* Table: LessonMomentActivity                                  */
/*==============================================================*/
create table LessonMomentActivity
(
   idLessonMomentActivity int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonActivity     int not null,
   idLessonMoment       int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentActivity),
   key AK_LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, idLessonActivity)
);

insert into LessonMomentActivity (idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, dtInserted, dtLastUpdate)
select idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, dtInserted, dtLastUpdate
from tmp_LessonMomentActivity;

alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonMomentActivity;

alter table tmp_LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;



/*==============================================================*/
/* Table: LessonMomentGroup                                     */
/*==============================================================*/
create table LessonMomentGroup
(
   idLessonMomentGroup  bigint not null auto_increment,
   idUserStudent        int not null,
   idStudent            int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonActivity     int not null,
   idLessonMoment       int not null,
   idEvidence           int not null,
   coAssessment         varchar(2) default 'NO',
   dtAssessment         datetime,
   InAttendance         tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonMomentGroup 
( idUserStudent, idStudent, idNetwork
, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity
, idLessonMoment, idEvidence, coAssessment, dtAssessment
, InAttendance, dtInserted, dtLastUpdate )
select distinct
	  grop.idUserStudent
	, grop.idStudent
	, grop.idNetwork
	, grop.idSchool
	, grop.coGrade
	, grop.idSchoolYear
	, grop.idClass
	, moac.idLessonActivity
	, moac.idLessonMoment
	, evid.idEvidence
	, grop.coAssessment
	, grop.dtAssessment
	, grop.InAttendance
	, grop.dtInserted
	, grop.dtLastUpdate
from tmp_LessonMomentGroup grop
	inner join tmp_LessonMomentActivity moac
		   on moac.idNetwork 			= grop.idNetwork 
		  and moac.idSchool  			= grop.idSchool  
		  and moac.coGrade   			= grop.coGrade   
		  and moac.idSchoolYear			= grop.idSchoolYear	
		  and moac.idClass				= grop.idClass		
		  and moac.idLessonMomentActivity 	= grop.idLessonMomentActivity
	inner join LessonActivityEvidence evid
		   on evid.idLessonActivity = moac.idLessonActivity
		  and evid.coGrade = moac.coGrade;
		  

		  


# drop table if exists tmp_LessonMomentGroup;
# drop table if exists tmp_LessonMomentActivity;

/*==============================================================*/
/* Table: ProjectStageEvidence                                  */
/*==============================================================*/
create table ProjectStageEvidence
(
   idProjectStage       int not null,
   idEvidence           int not null,
   coGrade              char(4) not null,
   coEvidenceType       char(3) not null,
   inDeleted            tinyint not null default 0,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage, idEvidence, coGrade)
);

insert into ProjectStageEvidence
(
 idProjectStage       
, idEvidence           
, coGrade              
, coEvidenceType       
, inDeleted            
, dtInserted           
, dtLastUpdate         
)
select distinct
	  idProjectStage
	, idEvidenceFixed
	, coGrade
	, 'FIX'
	, 0
	, dtInserted
	, dtLastUpdate
from tmp_ProjectStage;

insert into ProjectStageEvidence
(
 idProjectStage       
, idEvidence           
, coGrade              
, coEvidenceType       
, inDeleted            
, dtInserted           
, dtLastUpdate         
)
select distinct
	  idProjectStage
	, idEvidenceVariable
	, coGrade
	, 'VAR'
	, 0 
	, dtInserted
	, dtLastUpdate
from tmp_ProjectStage
where not exists ( select *
			    from ProjectStageEvidence
			    where ProjectStageEvidence.idProjectStage = tmp_ProjectStage.idProjectStage
			    and   ProjectStageEvidence.idEvidence = tmp_ProjectStage.idEvidenceVariable
			    and   ProjectStageEvidence.coGrade = tmp_ProjectStage.coGrade );



/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProjectStage       int not null auto_increment,
   idProject            int not null,
   coGrade              char(4),
   txTitle              varchar(2000) not null,
   txDescription        text,
   nuOrder              tinyint not null,
   nuDuration           smallint comment 'Duracao em minutos',
   IdMediaRoadmap       int,
   txGuidanceBNCC       text,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectStage),
   key AK_ProjectStage (idProjectStage, coGrade)
);

insert into ProjectStage (idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, txGuidanceBNCC, dtInserted, dtLastUpdate)
select idProjectStage, idProject, coGrade, txTitle, txDescription, nuOrder, nuDuration, IdMediaRoadmap, txGuidanceBNCC, dtInserted, dtLastUpdate
from tmp_ProjectStage;


/*==============================================================*/
/* Table: ProjectMomentStage                                    */
/*==============================================================*/
create table ProjectMomentStage
(
   idProjectMomentStage int not null auto_increment,
   idProjectMoment      int not null,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectStage       int not null,
   nuStageGroup         tinyint not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentStage),
   key AK_ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment, idProjectStage)
);

insert into ProjectMomentStage (idProjectMomentStage, idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, nuStageGroup, dtInserted, dtLastUpdate)
select idProjectMomentStage, idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, nuStageGroup, dtInserted, dtLastUpdate
from tmp_ProjectMomentStage;


/*==============================================================*/
/* Table: ProjectMomentGroup                                    */
/*==============================================================*/
create table ProjectMomentGroup
(
   idProjectMomentGroup bigint not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idProjectStage       int not null,
   idProjectMoment      int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   coAssessment         varchar(2) default 'NO',
   idEvidence           int not null,
   dtAssessment         datetime,
   InAttendance         tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentGroup)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectMomentGroup ( idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, idProjectMoment, idUserStudent, idStudent, coAssessment, idEvidence, dtAssessment, InAttendance, dtInserted, dtLastUpdate)
select distinct 
	  grop.idNetwork
	, grop.idSchool
	, grop.coGrade
	, grop.idSchoolYear
	, grop.idClass
	, most.idProjectStage
	, most.idProjectMoment
	, grop.idUserStudent
	, grop.idStudent
	, grop.coAssessment
	, evid.idEvidence
	, grop.dtAssessment
	, grop.InAttendance
	, grop.dtInserted
	, grop.dtLastUpdate
from tmp_ProjectMomentGroup grop
	inner join tmp_ProjectMomentStage most
		   on most.idNetwork = grop.idNetwork
		  and most.idSchool = grop.idSchool
		  and most.coGrade = grop.coGrade
		  and most.idSchoolYear = grop.idSchoolYear
		  and most.idClass = grop.idClass
		  and most.idProjectMomentStage = grop.idProjectMomentStage
	inner join ProjectStageEvidence evid
		   on evid.idProjectStage = most.idProjectStage
		  and evid.coGrade = most.coGrade;
		  

drop table if exists tmp_ProjectMomentGroup;

alter table ProjectMomentStageOrientation drop constraint FK_ProjectMomentStageOrientation_ProjectMomentStage;
drop table if exists tmp_ProjectMomentStage;

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;
alter table ProjectStageGroup drop constraint FK_ProjectStageGroup_ProjectStage;
alter table ProjectStageOrientation drop constraint FK_ProjectStageGroup_ProjectStage;
alter table ProjectStageSchoolSupply drop constraint FK_ProjectStageSchoolSupply_ProjectStage;
alter table ProjectStageOrientation drop constraint FK_ProjectStageOrientation_ProjectStage;
drop table if exists tmp_ProjectStage;



alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete restrict on update restrict;

alter table LessonActivityEvidence add constraint FK_LessonActivityEvidence_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonActivityEvidence add constraint FK_LessonActivityEvidence_EvidenceType foreign key (coEvidenceType)
      references EvidenceType (coEvidenceType) on delete restrict on update restrict;

alter table LessonActivityEvidence add constraint FK_LessonActivityEvidence_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

drop table tmp_LessonMomentActivity;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;
	 
drop table tmp_LessonMomentGroup;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonActivityEvidence foreign key (idLessonActivity, idEvidence, coGrade)
      references LessonActivityEvidence (idLessonActivity, idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, idLessonActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, idLessonActivity) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment, idProjectStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment, idProjectStage) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectStageEvidence foreign key (idProjectStage, idEvidence, coGrade)
      references ProjectStageEvidence (idProjectStage, idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage, coGrade)
      references ProjectStage (idProjectStage, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_MediaInformation foreign key (IdMediaRoadmap)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectStage add constraint FK_ProjectStage_Project foreign key (idProject, coGrade)
      references Project (idProject, coGrade) on delete restrict on update restrict;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageEvidence add constraint FK_ProjectStageEvidence_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectStageEvidence add constraint FK_ProjectStageEvidence_EvidenceType foreign key (coEvidenceType)
      references EvidenceType (coEvidenceType) on delete restrict on update restrict;

alter table ProjectStageEvidence add constraint FK_ProjectStageEvidence_ProjectStage foreign key (idProjectStage, coGrade)
      references ProjectStage (idProjectStage, coGrade) on delete restrict on update restrict;

alter table ProjectStageGroup add constraint FK_ProjectStageGroup_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageOrientation add constraint FK_ProjectStageOrientation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;

alter table ProjectStageSchoolSupply add constraint FK_ProjectStageSchoolSupply_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;


alter table LessonActivity drop constraint FK_LessonActivity_EvidenceGrade;

alter table LessonActivity
   drop column idEvidence;

CREATE TRIGGER `tg_au_LessonMomentGroup` 
AFTER UPDATE ON LessonMomentGroup 
FOR EACH ROW BEGIN

	# Aluno foi excluido da aula na data {{p0}} pelo professor {{p1}}
	IF OLD.inAttendance = 1 AND New.inAttendance = 0
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
			, 11
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('p0', NOW(), 'p1', Mome.idProfessor)
		FROM LessonMomentGroup Grup
			INNER JOIN LessonMomentActivity Acti
				   ON Acti.idNetwork			    = Grup.idNetwork
				  AND Acti.idSchool			    	= Grup.idSchool
				  AND Acti.coGrade				    = Grup.coGrade
				  AND Acti.idSchoolYear			    = Grup.idSchoolYear
				  AND Acti.idClass				    = Grup.idClass
				  AND Acti.idLessonMomentActivity  = Grup.idLessonMomentActivity
		     INNER JOIN LessonMoment Mome
				   ON Mome.idNetwork	 = Acti.idNetwork
				  AND Mome.idSchool		 = Acti.idSchool
				  AND Mome.coGrade		 = Acti.coGrade
				  AND Mome.idSchoolYear	 = Acti.idSchoolYear
				  AND Mome.idClass		 = Acti.idClass
				  AND Mome.idLessonMoment = Acti.idLessonMoment
		WHERE Grup.idLessonMomentGroup = NEW.idLessonMomentGroup
		AND   Grup.inAttendance = 0;
		
	END IF;
	
	# Aluno recebeu avaliaCAo na aula na data {{p0}} pelo professor {{p1}}
	IF OLD.coAssessment <> NEW.coAssessment
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
			, 14
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('p0', NOW(), 'p1', Mome.idProfessor)
		FROM LessonMomentGroup Grup
			INNER JOIN LessonMomentActivity Acti
				   ON Acti.idNetwork			= Grup.idNetwork
				  AND Acti.idSchool				= Grup.idSchool
				  AND Acti.coGrade				= Grup.coGrade
				  AND Acti.idSchoolYear			= Grup.idSchoolYear
				  AND Acti.idClass				= Grup.idClass
				  AND Acti.idLessonMomentActivity  = Grup.idLessonMomentActivity
		     INNER JOIN LessonMoment Mome
				   ON Mome.idNetwork	 = Acti.idNetwork
				  AND Mome.idSchool		 = Acti.idSchool
				  AND Mome.coGrade		 = Acti.coGrade
				  AND Mome.idSchoolYear	 = Acti.idSchoolYear
				  AND Mome.idClass		 = Acti.idClass
				  AND Mome.idLessonMoment = Acti.idLessonMoment
		WHERE Grup.idLessonMomentGroup = NEW.idLessonMomentGroup;
		
	END IF;
			
END ;


CREATE TRIGGER `tg_au_ProjectMomentGroup` 
AFTER UPDATE ON ProjectMomentGroup 
FOR EACH ROW BEGIN

	# Aluno foi excluido da aula na data {{p0}} pelo professor {{p1}}
	IF OLD.inAttendance = 1 AND New.inAttendance = 0
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
			, 11
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('p0', NOW(), 'p1', Mome.idProfessor)
		FROM ProjectMomentGroup Grup
			INNER JOIN ProjectMomentStage Stag
				   ON Stag.idNetwork			= Grup.idNetwork
				  AND Stag.idSchool				= Grup.idSchool
				  AND Stag.coGrade				= Grup.coGrade
				  AND Stag.idSchoolYear			= Grup.idSchoolYear
				  AND Stag.idClass				= Grup.idClass
				  AND Stag.idProjectMomentStage	= Grup.idProjectMomentStage
		     INNER JOIN ProjectMoment Mome
				   ON Mome.idNetwork	 = Stag.idNetwork
				  AND Mome.idSchool		 = Stag.idSchool
				  AND Mome.coGrade		 = Stag.coGrade
				  AND Mome.idSchoolYear	 = Stag.idSchoolYear
				  AND Mome.idClass		 = Stag.idClass
				  AND Mome.idProjectMoment = Stag.idProjectMoment
		WHERE Grup.idProjectMomentGroup = NEW.idProjectMomentGroup
		AND   Grup.inAttendance = 0;
		
	END IF;
	
	# Aluno recebeu avaliacao na aula na data {{p0}} pelo professor {{p1}}
	IF OLD.coAssessment <> NEW.coAssessment
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
			, 14
			, Grup.idNetwork
			, Grup.idUserStudent
			, JSON_OBJECT('p0', NOW(), 'p1', Mome.idProfessor)
		FROM ProjectMomentGroup Grup
			INNER JOIN ProjectMomentStage Stag
				   ON Stag.idNetwork			= Grup.idNetwork
				  AND Stag.idSchool				= Grup.idSchool
				  AND Stag.coGrade				= Grup.coGrade
				  AND Stag.idSchoolYear			= Grup.idSchoolYear
				  AND Stag.idClass				= Grup.idClass
				  AND Stag.idProjectMomentStage  	= Grup.idProjectMomentStage
		     INNER JOIN ProjectMoment Mome
				   ON Mome.idNetwork	 	= Stag.idNetwork
				  AND Mome.idSchool		 	= Stag.idSchool
				  AND Mome.coGrade		 	= Stag.coGrade
				  AND Mome.idSchoolYear	 	= Stag.idSchoolYear
				  AND Mome.idClass		 	= Stag.idClass
				  AND Mome.idProjectMoment 	= Stag.idProjectMoment
		WHERE Grup.idProjectMomentGroup = NEW.idProjectMomentGroup;
		
	END IF;
			
END ;

