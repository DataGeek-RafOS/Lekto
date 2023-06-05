/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     29-Aug-22 18:11:23                           */
/*==============================================================*/


drop table if exists tmp_Component;

rename table Component to tmp_Component;

drop table if exists tmp_ProjectComponent;

rename table ProjectComponent to tmp_ProjectComponent;

drop table if exists tmp_Segment;

rename table Segment to tmp_Segment;

/*==============================================================*/
/* Table: Component                                             */
/*==============================================================*/
create table Component
(
   coComponent          char(3) not null,
   txComponent          varchar(100),
   txDescription        varchar(2000) not null,
   primary key (coComponent)
);

#WARNING: The following insert order will not restore columns: idComponent
insert into Component (coComponent, txComponent, txDescription)
select idComponent, txComponent, txDescription
from tmp_Component;

alter table tmp_ProjectComponent drop constraint FK_ProjectComponent_Component;

alter table tmp_Segment drop constraint FK_Segment_Component;

drop table if exists tmp_Component;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   coComponent          char(3) not null,
   idProject            int not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (coComponent, idProject)
);

#WARNING: The following insert order will not restore columns: idComponent
insert into ProjectComponent (coComponent, idProject, inStatus, dtInserted)
select idComponent, idProject, inStatus, dtInserted
from tmp_ProjectComponent;

#WARNING: Drop cancelled because columns cannot be restored: idComponent
drop table if exists tmp_ProjectComponent;

/*==============================================================*/
/* Table: Segment                                               */
/*==============================================================*/
create table Segment
(
   idSegment            int not null auto_increment,
   txName               varchar(150) not null,
   txDescription        varchar(2000) not null,
   coComponent          char(3),
   inStatus             bool not null default 1,
   dtInserted           datetime not null,
   primary key (idSegment)
);

#WARNING: The following insert order will not restore columns: idComponent
insert into Segment (idSegment, txName, txDescription, inStatus, dtInserted)
select idSegment, txName, txDescription, inStatus, dtInserted
from tmp_Segment;

alter table Project drop constraint FK_Segment_Project;

alter table SegmentGrade drop constraint FK_Segment_SegmentGrade;

drop table if exists tmp_Segment;


alter table Project add constraint FK_Segment_Project foreign key (idSegment)
      references Segment (idSegment);

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (coComponent)
      references Component (coComponent);

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject);

alter table Segment add constraint FK_Segment_Component foreign key (coComponent)
      references Component (coComponent);

alter table SegmentGrade add constraint FK_Segment_SegmentGrade foreign key (idSegment)
      references Segment (idSegment);


CREATE TRIGGER tg_bi_ProjectStage
BEFORE INSERT
ON ProjectStage
FOR EACH ROW
BEGIN

	IF ( SELECT COUNT(*) -- Grade do card manipulado
		FROM ProjectStage	
			INNER JOIN
			CardGrade
				ON CardGrade.idCard = ProjectStage.idCard
		WHERE ProjectStage.idProject = new.idProject
	     AND   ProjectStage.idCard    = new.idCard 
		AND   EXISTS ( SELECT 1 -- está cadastrado na tabela SegmentGrade vinculado ao projeto
					FROM Project
						INNER JOIN
						Segment
							ON Segment.idSegment = Project.idSegment
						INNER JOIN
						SegmentGrade
							ON SegmentGrade.idSegment = Segment.idSegment
					WHERE Project.idProject = ProjectStage.idProject
					AND   SegmentGrade.idGrade = CardGrade.idGrade ))= 0
	THEN
		SIGNAL sqlstate '45001' set message_text = "Violacaoo de Foreign Key durante inclusao/atualizacao da tabela ProjectStage.";
	END IF;
END;


CREATE TRIGGER tg_bu_ProjectStage
BEFORE UPDATE
ON ProjectStage
FOR EACH ROW
BEGIN

	IF ( SELECT COUNT(*) -- Grade do card manipulado
		FROM ProjectStage	
			INNER JOIN
			CardGrade
				ON CardGrade.idCard = ProjectStage.idCard
		WHERE ProjectStage.idProject = new.idProject
	     AND   ProjectStage.idCard    = new.idCard 
		AND   EXISTS ( SELECT 1 -- está cadastrado na tabela SegmentGrade vinculado ao projeto
					FROM Project
						INNER JOIN
						Segment
							ON Segment.idSegment = Project.idSegment
						INNER JOIN
						SegmentGrade
							ON SegmentGrade.idSegment = Segment.idSegment
					WHERE Project.idProject = ProjectStage.idProject
					AND   SegmentGrade.idGrade = CardGrade.idGrade ))= 0
	THEN
		SIGNAL sqlstate '45001' set message_text = "Violação de Foreign Key durante inclusão/atualização da tabela ProjectStage.";
	END IF;
END;

