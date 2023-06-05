/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     12/19/2022 5:02:21 PM                        */
/*==============================================================*/

alter table Project drop constraint FK_Segment_Project;

alter table ProjectStage drop constraint FK_Project_ProjectStage;

alter table ProjectComponent drop constraint FK_ProjectComponent_Project;


alter table Project 
modify column idProject int not null first,
drop primary key;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

alter table ProjectComponent drop constraint FK_ProjectComponent_Component;

alter table ProjectComponent
   drop primary key;

drop table if exists tmp_ProjectComponent;

rename table ProjectComponent to tmp_ProjectComponent;

alter table ProjectStage
   drop primary key;

drop table if exists tmp_ProjectStage;

rename table ProjectStage to tmp_ProjectStage;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   idLearningTool       smallint not null,
   idSegment            int not null,
   txName               varchar(200) not null,
   txDescription        varchar(500),
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   primary key (idProject, idLearningTool),
   key FK_Segment_Project (idSegment)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Project (idProject, idLearningTool, idSegment, txName, txDescription, inStatus, dtInserted)
select idProject, 11, idSegment, txName, txDescription, inStatus, dtInserted
from tmp_Project;



#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_Project;
/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idProject            int not null,
   idLearningTool       smallint not null,
   coComponent          char(3) not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   primary key (coComponent, idProject, idLearningTool),
   key FK_ProjectComponent_Project (idProject)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectComponent (idProject, idLearningTool, coComponent, inStatus, dtInserted)
select idProject, 11, coComponent, inStatus, dtInserted
from tmp_ProjectComponent;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectComponent;
/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProject            int not null,
   idLearningTool       smallint not null,
   idCard               int not null,
   nuSequence           smallint not null default 1,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   primary key (idProject, idLearningTool, idCard)
)
default character set utf8mb4
collate utf8mb4_general_ci;

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStage (idProject, idLearningTool, idCard, nuSequence, inStatus, dtInserted)
select idProject, 11, idCard, nuSequence, inStatus, dtInserted
from tmp_ProjectStage;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_ProjectStage;
/*==============================================================*/
/* Table: SegmentClassSchedule                                  */
/*==============================================================*/
create table SegmentClassSchedule
(
   idSegmentClassSchedule int not null auto_increment,
   idSegmentSchoolClass int not null,
   dtSegmentSchedule    datetime not null,
   nuOrder              smallint not null,
   dtInserted           datetime not null,
   primary key (idSegmentClassSchedule)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table Project add constraint FK_Project_LearningTool foreign key (idLearningTool)
      references LearningTool (idLearningTool);

alter table Project add constraint FK_Segment_Project foreign key (idSegment)
      references Segment (idSegment);



			
UPDATE ProjectStage
			 INNER JOIN CardLearningTool 
					   ON CardLearningTool.idCard = ProjectStage.idCard
SET ProjectStage.idLearningTool = CardLearningTool.idLearningTool
WHERE CardLearningTool.idLearningTool <> ProjectStage.idLearningTool;
			
UPDATE ProjectComponent
	  INNER JOIN Project 
			ON ProjectComponent.idProject = Project.idProject
SET ProjectComponent.idLearningTool = Project.idLearningTool
WHERE Project.idLearningTool <> ProjectComponent.idLearningTool; 

UPDATE Project
	  INNER JOIN ProjectStage 
			ON ProjectStage.idProject = Project.idProject
SET Project.idLearningTool = ProjectStage.idLearningTool
WHERE Project.idLearningTool <> ProjectStage.idLearningTool; 




alter table ProjectStage add constraint FK_ProjectStage_CardLearningTool foreign key (idCard, idLearningTool)
      references CardLearningTool (idCard, idLearningTool);
	 
alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent);			

alter table ProjectComponent add constraint FK_ProjectComponent_ProjectLearningTool foreign key (idProject, idLearningTool)
      references Project (idProject, idLearningTool);

alter table ProjectStage add constraint FK_Project_ProjectStage foreign key (idProject, idLearningTool)
      references Project (idProject, idLearningTool);
	 

alter table SegmentClassSchedule add constraint FK_SegmentClassSchedule_SegmentSchoolClass foreign key (idSegmentSchoolClass)
      references SegmentSchoolClass (idSegmentSchoolClass);


DELIMITER $$

create trigger tg_bi_ProjectStage before insert
   on ProjectStage for each row
BEGIN

	IF ( SELECT COUNT(*) -- Grade do card manipulado
		FROM CardGrade
		WHERE CardGrade.idCard = new.idCard 
		AND   EXISTS ( SELECT 1 -- está cadastrado na tabela SegmentGrade vinculado ao projeto
					FROM Project
						INNER JOIN
						Segment
							ON Segment.idSegment = Project.idSegment
						INNER JOIN
						SegmentGrade
							ON SegmentGrade.idSegment = Segment.idSegment
					WHERE Project.idProject = new.idProject
					AND   SegmentGrade.idGrade = CardGrade.idGrade ))= 0
	THEN
		SIGNAL sqlstate '45001' set message_text = 'Violação de Foreign Key durante inclusão/atualização da tabela ProjectStage.';
END$$

create trigger tg_bu_ProjectStage before update
   on ProjectStage for each row
BEGIN

	IF ( SELECT COUNT(*) -- Grade do card manipulado
		FROM CardGrade
		WHERE CardGrade.idCard = new.idCard 
		AND   EXISTS ( SELECT 1 -- está cadastrado na tabela SegmentGrade vinculado ao projeto
					FROM Project
						INNER JOIN
						Segment
							ON Segment.idSegment = Project.idSegment
						INNER JOIN
						SegmentGrade
							ON SegmentGrade.idSegment = Segment.idSegment
					WHERE Project.idProject = new.idProject
					AND   SegmentGrade.idGrade = CardGrade.idGrade ))= 0
	THEN
		SIGNAL sqlstate '45001' set message_text = "Violação de Foreign Key durante inclusão/atualização da tabela ProjectStage.";

