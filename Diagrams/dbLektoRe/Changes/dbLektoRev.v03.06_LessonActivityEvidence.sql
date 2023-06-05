/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     3/28/2023 6:33:14 PM                         */
/*==============================================================*/




drop table if exists tmp_LessonActivity;

rename table LessonActivity to tmp_LessonActivity;

drop table if exists tmp_LessonMomentActivity;

rename table LessonMomentActivity to tmp_LessonMomentActivity;

drop table if exists tmp_LessonMomentGroup;

rename table LessonMomentGroup to tmp_LessonMomentGroup;


/*==============================================================*/
/* Pre-Requisites                                               */
/*==============================================================*/

INSERT INTO Competence (`idCompetence`, `txName`, `dtInserted`, `dtLastUpdate`) VALUES (-1, 'Sem vínculo', '2023-03-28 18:54:00', NULL);
INSERT INTO Ability (`idAbility`, `idCompetence`, `txName`, `txImagePath`, `txPrimaryColor`, `txBgPrimaryColor`, `txBgSecondaryColor`, `dtInserted`, `dtLastUpdate`) VALUES (-1, -1, 'Sem vínculo', '0x', '0x', '0x', '000000', '2023-03-28 18:54:50', NULL);
INSERT INTO Evidence (`idEvidence`, `txName`, `idAbility`, `dtInserted`, `dtLastUpdate`) VALUES (-1, 'Desconhecido', -1, '2023-03-28 18:58:49', NULL);
INSERT INTO EvidenceGrade (idEvidence, coGrade, dtInserted) SELECT DISTINCT -1 AS idEvidence, coGrade, NOW() FROM Grade;


SELECT * FROM Competence WHERE idCompetence = -1


/*==============================================================*/
/* Table: EvidenceType                                          */
/*==============================================================*/
create table EvidenceType
(
   coEvidenceType       char(3) not null,
   txEvidenceType       varchar(50) not null,
   dtInserted           datetime not null default now(),
   dtLastUpdate         datetime,
   primary key (coEvidenceType)
);

INSERT INTO EvidenceType (coEvidenceType, txEvidenceType, dtInserted) values ('FIX', 'Fixa', now());
INSERT INTO EvidenceType (coEvidenceType, txEvidenceType, dtInserted) values ('VAR', 'Variável', now());



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


INSERT INTO LessonActivityEvidence
(
     idLessonActivity     
   , idEvidence           
   , coGrade              
   , coEvidenceType       
   , dtInserted           
)
select distinct a.idLessonActivity, COALESCE(c.idEvidence, -1) AS idEvidence, c.coGrade, 'FIX' as coEvidenceType, now()
from tmp_LessonActivity a
	inner join LessonStep b
		   on a.idLessonStep = b.idLessonStep
	inner join LessonStepEvidence c
		   on c.idLessonStep = b.idLessonStep and c.coGrade = b.coGrade;


INSERT INTO LessonActivityEvidence
(
     idLessonActivity     
   , idEvidence           
   , coGrade              
   , coEvidenceType       
   , dtInserted           
)	
select idLessonActivity, COALESCE(idEvidence, -1) AS idEvidence, coGrade, 'VAR', now()
from tmp_LessonActivity
where not exists ( select *
			    from LessonActivityEvidence lae
			    where lae.idLessonActivity = tmp_LessonActivity.idLessonActivity
			    and   lae.idEvidence = tmp_LessonActivity.idEvidence
			    and   lae.coGrade = tmp_LessonActivity.coGrade );

/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idLessonStep         int not null,
   txTitle              varchar(2000) not null,
   nuOrder              tinyint not null,
   idCategory           smallint,
   txChallenge          text not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
);

insert into LessonActivity (idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idCategory, txChallenge, dtInserted, dtLastUpdate)
select idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idCategory, txChallenge, dtInserted, dtLastUpdate
from tmp_LessonActivity;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

alter table tmp_LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

drop table if exists tmp_LessonActivity;

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
   idLessonMoment       int not null,
   idLessonActivity     int not null,
   idEvidence           int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentActivity),
   key AK_LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, idEvidence)
);

ALTER TABLE LessonMomentActivity 
ADD COLUMN `idOLD` int NULL AFTER `dtLastUpdate`;


insert into LessonMomentActivity ( idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, idLessonActivity, idEvidence, dtInserted, dtLastUpdate, idOLD)
select distinct 
	  tmp_LessonMomentActivity.idNetwork
	, tmp_LessonMomentActivity.idSchool
	, tmp_LessonMomentActivity.coGrade
	, tmp_LessonMomentActivity.idSchoolYear
	, tmp_LessonMomentActivity.idClass
	, tmp_LessonMomentActivity.idLessonMoment
	, tmp_LessonMomentActivity.idLessonActivity
	, LessonActivityEvidence.idEvidence
	, tmp_LessonMomentActivity.dtInserted
	, tmp_LessonMomentActivity.dtLastUpdate
	, tmp_LessonMomentActivity.idLessonMomentActivity
from tmp_LessonMomentActivity
	inner join LessonActivityEvidence
		   on LessonActivityEvidence.idLessonActivity = tmp_LessonMomentActivity.idLessonActivity
		  and LessonActivityEvidence.coGrade = tmp_LessonMomentActivity.coGrade
order by tmp_LessonMomentActivity.idLessonMomentActivity;		  


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
   idLessonMomentActivity int not null,
   idEvidence           int not null,
   coAssessment         varchar(2) default 'NO',
   dtAssessment         datetime,
   InAttendance         tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonMomentGroup)
);

insert into LessonMomentGroup (idUserStudent, idStudent, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, idEvidence, coAssessment, dtAssessment, InAttendance, dtInserted, dtLastUpdate)
select a.idUserStudent
	, a.idStudent
	, a.idNetwork
	, a.idSchool
	, a.coGrade
	, a.idSchoolYear
	, a.idClass
	, a.idLessonMomentActivity
	, b.idEvidence
	, a.coAssessment
	, a.dtAssessment
	, a.InAttendance
	, a.dtInserted
	, a.dtLastUpdate
from tmp_LessonMomentGroup a
	inner join LessonMomentActivity b
		   on a.idNetwork = b.idNetwork
		  and a.idSchool = b.idSchool
		  and a.coGrade = b.coGrade
		  and a.idSchoolYear = b.idSchoolYear
		  and a.idClass = b.idClass
		  and a.idLessonMomentActivity = b.idOLD;
		  
		  
select distinct idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, idEvidence
from LessonMomentGroup
where not exists ( select * 
			    from LessonMomentActivity b 
			    where b.idNetwork = LessonMomentGroup.idNetwork
			    and b.idSchool = LessonMomentGroup.idSchool
			    and b.coGrade = LessonMomentGroup.coGrade
			    and b.idSchoolYear = LessonMomentGroup.idSchoolYear
			    and b.idClass = LessonMomentGroup.idClass
			    and b.idLessonMomentActivity = LessonMomentGroup.idLessonMomentActivity
			    and b.idEvidence = LessonMomentGroup.idEvidence )		  


alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonMomentActivity;

alter table tmp_LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;

drop table if exists tmp_LessonMomentActivity;

drop table if exists tmp_LessonMomentGroup;



alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete restrict on update restrict;
	 
alter table LessonActivityEvidence add constraint FK_LessonActivityEvidence_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonActivityEvidence add constraint FK_LessonActivityEvidence_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 
		    
			    

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivityEvidence foreign key (idLessonActivity, idEvidence, coGrade)
      references LessonActivityEvidence (idLessonActivity, idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;
	 
	 


alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, idEvidence)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMomentActivity, idEvidence) on delete restrict on update restrict;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;


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
			, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
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
			, JSON_OBJECT('@p0', NOW(), '@p1', Mome.idProfessor)
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

alter table LessonActivityEvidence add constraint FK_LessonActivityEvidence_EvidenceType foreign key (coEvidenceType)
      references EvidenceType (coEvidenceType) on delete restrict on update restrict;

ALTER TABLE LessonMomentActivity 
DROP COLUMN `idOLD`;
