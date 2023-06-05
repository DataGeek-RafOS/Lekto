/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     5/10/2023 9:44:15 PM                         */
/*==============================================================*/


drop table if exists tmp_LessonMomentActivity;

rename table LessonMomentActivity to tmp_LessonMomentActivity;

drop table if exists tmp_LessonMomentGroup;

rename table LessonMomentGroup to tmp_LessonMomentGroup;

drop table if exists tmp_ProjectMomentGroup;

rename table ProjectMomentGroup to tmp_ProjectMomentGroup;

drop table if exists tmp_ProjectMomentStage;

rename table ProjectMomentStage to tmp_ProjectMomentStage;



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
   key AK_LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMomentActivity)
);

insert into LessonMomentActivity (idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, dtInserted, dtLastUpdate)
select idLessonMomentActivity, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMoment, dtInserted, dtLastUpdate
from tmp_LessonMomentActivity;


/*==============================================================*/
/* Table: LessonMomentGroup                                     */
/*==============================================================*/
create table LessonMomentGroup
(
   idLessonMomentGroup  bigint not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idLessonActivity     int not null,
   idLessonMomentActivity int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   InAttendance         tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup),
   key AK_LessonMomentGroup (idLessonMomentGroup, idLessonActivity, coGrade)
);


#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into LessonMomentGroup (idLessonMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMomentActivity, idUserStudent, idStudent, InAttendance, dtInserted, dtLastUpdate)
select distinct
	  mogr.idLessonMomentGroup
	, mogr.idNetwork
	, mogr.idSchool
	, mogr.coGrade
	, mogr.idSchoolYear
	, mogr.idClass
	, mogr.idLessonActivity
	, acti.idLessonMomentActivity
	, mogr.idUserStudent
	, mogr.idStudent
	, mogr.InAttendance
	, mogr.dtInserted
	, mogr.dtLastUpdate
from tmp_LessonMomentGroup mogr
	inner join tmp_LessonMomentActivity acti
	        on acti.idNetwork = mogr.idNetwork
		  and acti.idSchool  = mogr.idSchool
		  and acti.coGrade   = mogr.coGrade
		  and acti.idSchoolYear = mogr.idSchoolYear
		  and acti.idClass   = mogr.idClass
		  and acti.idLessonActivity = mogr.idLessonActivity
		  and acti.idLessonMoment = mogr.idLessonMoment
		  ;

/*==============================================================*/
/* Table: LessonGroupAssessment                                 */
/*==============================================================*/
create table LessonGroupAssessment
(
   idLessonGroupAssessment bigint not null auto_increment,
   idLessonMomentGroup  bigint not null,
   idLessonActivity     int not null,
   idEvidence           int,
   coGrade              char(4) not null,
   coAssessment         varchar(2) not null,
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonGroupAssessment)
);

insert into LessonGroupAssessment (idLessonMomentGroup, idLessonActivity, idEvidence, coGrade, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select mogr.idLessonMomentGroup
	, mogr.idLessonActivity
	, mogr.idEvidence
	, mogr.coGrade
	, COALESCE(mogr.coAssessment, 'NO')
	, mogr.dtAssessment
	, mogr.dtInserted
	, mogr.dtLastUpdate
from tmp_LessonMomentGroup mogr;




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
   key AK_ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, idProjectMomentStage)
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
   idProjectMomentStage int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   InAttendance         tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectMomentGroup),
   key AK_ProjectMomentGroup (idProjectMomentGroup, coGrade, idProjectStage)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectMomentGroup (idProjectMomentGroup, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, idProjectMomentStage, idUserStudent, idStudent, InAttendance, dtInserted, dtLastUpdate)
select distinct
	  mogr.idProjectMomentGroup
	, mogr.idNetwork
	, mogr.idSchool
	, mogr.coGrade
	, mogr.idSchoolYear
	, mogr.idClass
	, mogr.idProjectStage
	, stag.idProjectMomentStage
	, mogr.idUserStudent
	, mogr.idStudent
	, mogr.InAttendance
	, mogr.dtInserted
	, mogr.dtLastUpdate
from tmp_ProjectMomentGroup mogr
	inner join tmp_ProjectMomentStage stag
	        on stag.idNetwork = mogr.idNetwork
		  and stag.idSchool  = mogr.idSchool
		  and stag.coGrade   = mogr.coGrade
		  and stag.idSchoolYear = mogr.idSchoolYear
		  and stag.idClass   = mogr.idClass
		  and stag.idProjectMoment = mogr.idProjectMoment
		  and stag.idProjectStage = mogr.idProjectStage
		   ;

/*==============================================================*/
/* Table: ProjectGroupAssessment                                */
/*==============================================================*/
create table ProjectGroupAssessment
(
   idProjectGroupAssessment bigint not null auto_increment,
   idProjectMomentGroup bigint not null,
   idProjectStage       int not null,
   coGrade              char(4) not null,
   idEvidence           int not null,
   coAssessment         varchar(2) not null,
   dtAssessment         datetime,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectGroupAssessment)
);

insert into ProjectGroupAssessment (idProjectMomentGroup, idProjectStage, coGrade, idEvidence, coAssessment, dtAssessment, dtInserted, dtLastUpdate)
select distinct
	  mogr.idProjectMomentGroup
	, mogr.idProjectStage
	, mogr.coGrade
	, mogr.idEvidence
	, mogr.coAssessment
	, mogr.dtAssessment
	, mogr.dtInserted
	, mogr.dtLastUpdate
from tmp_ProjectMomentGroup mogr;

select *
from information_schema.REFERENTIAL_CONSTRAINTS
where CONSTRAINT_NAME = 'FK_LessonMomentActivity_LessonActivity'

drop table if exists tmp_LessonMomentGroup;

alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonMomentActivity;

drop table if exists tmp_LessonMomentActivity;

drop table if exists tmp_ProjectMomentGroup;

alter table ProjectMomentStageOrientation drop constraint FK_ProjectMomentStageOrientation_ProjectMomentStage;

drop table if exists tmp_ProjectMomentStage;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete cascade on update restrict;

alter table LessonGroupAssessment add constraint FK_LessonGroupAssessment_LessonMomentGroup foreign key (idLessonMomentGroup, idLessonActivity, coGrade)
      references LessonMomentGroup (idLessonMomentGroup, idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonGroupAssessment add constraint FK_LessonGroupAssessment_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table LessonGroupAssessment add constraint FK_LessonGroupAssessment_LessonActivityEvidence foreign key (idLessonActivity, idEvidence, coGrade)
      references LessonActivityEvidence (idLessonActivity, idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;


alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete cascade on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMomentActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonActivity, idLessonMomentActivity) on delete cascade on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectGroupAssessment add constraint FK_ProjectGroupAssessment_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table ProjectGroupAssessment add constraint FK_ProjectGroupAssessment_ProjectMomentGroup foreign key (idProjectMomentGroup, coGrade, idProjectStage)
      references ProjectMomentGroup (idProjectMomentGroup, coGrade, idProjectStage) on delete restrict on update restrict;

alter table ProjectGroupAssessment add constraint FK_ProjectGroupAssessment_ProjectStageEvidence foreign key (idProjectStage, idEvidence, coGrade)
      references ProjectStageEvidence (idProjectStage, idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, idProjectMomentStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectStage, idProjectMomentStage) on delete cascade on update restrict;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete cascade on update restrict;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage, coGrade)
      references ProjectStage (idProjectStage, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete cascade on update restrict;




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
			
END ;


CREATE TRIGGER `tg_au_LessonGroupAssessment` 
AFTER UPDATE ON LessonGroupAssessment 
FOR EACH ROW BEGIN

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
	
			
END ;


CREATE TRIGGER `tg_au_ProjectGroupAssessment` 
AFTER UPDATE ON ProjectGroupAssessment 
FOR EACH ROW BEGIN

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

