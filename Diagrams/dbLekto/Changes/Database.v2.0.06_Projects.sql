/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     8/17/2022 9:27:08 AM                         */
/*==============================================================*/


drop table if exists tmp_ApprenticeScore;

rename table ApprenticeScore to tmp_ApprenticeScore;

drop table if exists tmp_Card;

rename table Card to tmp_Card;

drop table if exists tmp_CardEvidence;

rename table CardEvidence to tmp_CardEvidence;

drop table if exists tmp_CardInfrastructure;

rename table CardInfrastructure to tmp_CardInfrastructure;

drop table if exists tmp_LektoUserType;

rename table LektoUserType to tmp_LektoUserType;

drop table if exists tmp_MomentCard;

rename table MomentCard to tmp_MomentCard;

drop table if exists tmp_MomentNotesApprentice;

rename table MomentNotesApprentice to tmp_MomentNotesApprentice;

drop table if exists tmp_Personalization;

rename table Personalization to tmp_Personalization;

drop table if exists tmp_ProfileSurvey;

rename table ProfileSurvey to tmp_ProfileSurvey;

drop table if exists tmp_ProfileSurveyAnswer;

rename table ProfileSurveyAnswer to tmp_ProfileSurveyAnswer;

drop table if exists tmp_ProfileSurveyQuestion;

rename table ProfileSurveyQuestion to tmp_ProfileSurveyQuestion;

drop table if exists tmp_ProfileSurveyResult;

rename table ProfileSurveyResult to tmp_ProfileSurveyResult;

drop table if exists tmp_Project;

rename table Project to tmp_Project;

drop table if exists tmp_ProjectCard;

rename table ProjectCard to tmp_ProjectCard;

drop table if exists tmp_Room;

rename table Room to tmp_Room;

drop table if exists tmp_RoomTheme;

rename table RoomTheme to tmp_RoomTheme;

drop table if exists tmp_Segment;

rename table Segment to tmp_Segment;

/*==============================================================*/
/* Table: ApprenticeScore                                       */
/*==============================================================*/
create table ApprenticeScore
(
   idEvidence           smallint not null,
   idApprenticeMoment   int not null,
   coRating             varchar(2) not null,
   dtInserted           datetime not null default NOW(),
   primary key (idEvidence, idApprenticeMoment)
);

insert into ApprenticeScore (idEvidence, idApprenticeMoment, coRating, dtInserted)
select idEvidence, idApprenticeMoment, coRating, dtInserted
from tmp_ApprenticeScore;

drop table if exists tmp_ApprenticeScore;

/*==============================================================*/
/* Table: Card                                                  */
/*==============================================================*/
create table Card
(
   idCard               int not null auto_increment,
   txTitle              varchar(150) not null,
   txCard               varchar(2000) not null comment 'Texto descritivo do caraoo.',
   inStatus             bool not null default 1,
   dtInserted           datetime not null default NOW(),
   idTheme              smallint not null,
   txOtherPossibilities varchar(2000),
   txApprenticeCard     varchar(300),
   txSupport            varchar(500),
   txSupportAuthor      varchar(120),
   inShowThemeHierarchy bool default 0,
   txBncc               longtext,
   txMaterials          longtext,
   primary key (idCard)
);

insert into Card (idCard, txTitle, txCard, inStatus, dtInserted, idTheme, txOtherPossibilities, txApprenticeCard, txSupport, txSupportAuthor, inShowThemeHierarchy, txBncc, txMaterials)
select idCard, txTitle, txCard, inStatus, dtInserted, idTheme, txOtherPossibilities, txApprenticeCard, txSupport, txSupportAuthor, 0, txBncc, txMaterials
from tmp_Card;

/*
ALTER TABLE tmp_CardEvidence DROP CONSTRAINT FK_CARDEVID_REFERENCE_CARD;
ALTER TABLE CardGrade DROP CONSTRAINT FK_CARDGRAD_REFERENCE_CARD;
ALTER TABLE tmp_CardInfrastructure DROP CONSTRAINT FK_CardInfrastructure_Card;
ALTER TABLE CardLearningTool DROP CONSTRAINT FK_CardLearningTool_Card;
ALTER TABLE CardReference DROP CONSTRAINT FK_CARDREFE_REFERENCE_CARD;
ALTER TABLE CardSchoolSupply DROP CONSTRAINT FK_CardSchoolSupply_Card;
ALTER TABLE tmp_MomentCard DROP CONSTRAINT FK_MOMENTCA_REFERENCE_CARD;
ALTER TABLE Step DROP CONSTRAINT FK_Step_Card;
ALTER TABLE ProjectCard DROP CONSTRAINT FK_Card_ProjectCard;
ALTER TABLE tmp_ProjectCard DROP CONSTRAINT FK_Card_ProjectCard;
*/
drop table if exists tmp_Card;


/*==============================================================*/
/* Index: ixNCL_txTitle                                         */
/*==============================================================*/
create index ixNCL_txTitle on Card
(
   txTitle
);

/*==============================================================*/
/* Table: CardEvidence                                          */
/*==============================================================*/
create table CardEvidence
(
   idCard               int not null,
   idEvidence           smallint not null,
   dtInserted           datetime not null,
   inStatus             bool not null,
   primary key (idCard, idEvidence)
);

insert into CardEvidence (idCard, idEvidence, dtInserted, inStatus)
select idCard, idEvidence, dtInserted, inStatus
from tmp_CardEvidence;

ALTER TABLE EvaluationQuestion DROP CONSTRAINT FK_EVALUATI_REFERENCE_CARDEVID;

drop table if exists tmp_CardEvidence;

/*==============================================================*/
/* Table: CardInfrastructure                                    */
/*==============================================================*/
create table CardInfrastructure
(
   idCard               int not null,
   idInfrastructure     smallint not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null default NOW(),
   primary key (idCard, idInfrastructure)
);

insert into CardInfrastructure (idCard, idInfrastructure, inStatus, dtInserted)
select idCard, idInfrastructure, inStatus, dtInserted
from tmp_CardInfrastructure;

drop table if exists tmp_CardInfrastructure;

/*==============================================================*/
/* Table: Component                                             */
/*==============================================================*/
create table Component
(
   idComponent          int not null auto_increment,
   txComponent          varchar(100),
   txDescription        varchar(2000) not null,
   inStatus             tinyint not null default 1,
   dtInserted           datetime not null,
   primary key (idComponent)
);

/*==============================================================*/
/* Table: LektoUserType                                         */
/*==============================================================*/
create table LektoUserType
(
   idLektoUserType      int not null auto_increment,
   idUser               int not null,
   coUserType           char(4) not null,
   idSchool             int,
   idSchoolNetwork      int,
   dtInserted           datetime not null,
   inDeleted            bool not null default 0,
   coDistrictCode       char(2),
   primary key (idLektoUserType),
   key ukNCL_LektoUserType (idUser, coUserType, idSchool, idSchoolNetwork)
);

insert into LektoUserType (idLektoUserType, idUser, coUserType, idSchool, idSchoolNetwork, dtInserted, inDeleted, coDistrictCode)
select idLektoUserType, idUser, coUserType, idSchool, idSchoolNetwork, dtInserted, 0, coDistrictCode
from tmp_LektoUserType;

drop table if exists tmp_LektoUserType;

/*==============================================================*/
/* Table: MomentCard                                            */
/*==============================================================*/
create table MomentCard
(
   idMomentCard         int not null auto_increment,
   idMoment             int not null,
   idCard               int not null,
   primary key (idMomentCard)
);

insert into MomentCard (idMomentCard, idMoment, idCard)
select idMomentCard, idMoment, idCard
from tmp_MomentCard;

ALTER TABLE ApprenticeMoment DROP CONSTRAINT FK_APPRENTI_REFERENCE_MOMENTCA;

drop table if exists tmp_MomentCard;

/*==============================================================*/
/* Index: UK_MomentCard                                         */
/*==============================================================*/
create unique index UK_MomentCard on MomentCard
(
   idMoment,
   idCard
);

/*==============================================================*/
/* Table: MomentNotesApprentice                                 */
/*==============================================================*/
create table MomentNotesApprentice
(
   idMomentNotes        int not null,
   idApprenticeMoment   int not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null default NOW(),
   primary key (idMomentNotes, idApprenticeMoment)
);

alter table MomentNotesApprentice comment 'Referencia de informacoes adicionais com os aprendizes.';

insert into MomentNotesApprentice (idMomentNotes, idApprenticeMoment, inStatus, dtInserted)
select idMomentNotes, idApprenticeMoment, inStatus, dtInserted
from tmp_MomentNotesApprentice;

drop table if exists tmp_MomentNotesApprentice;

/*==============================================================*/
/* Table: Personalization                                       */
/*==============================================================*/
create table Personalization
(
   idPersonalisation    int not null auto_increment,
   idCard               int not null,
   idStep               int not null,
   coProfileType        char(4) not null,
   inStatus             bool not null default 1,
   dtInserted           datetime not null default NOW(),
   txPersonalisation    varchar(300) not null,
   primary key (idPersonalisation)
);

insert into Personalization (idPersonalisation, idCard, idStep, coProfileType, inStatus, dtInserted, txPersonalisation)
select idPersonalisation, idCard, idStep, coProfileType, inStatus, dtInserted, txPersonalisation
from tmp_Personalization;

drop table if exists tmp_Personalization;

/*==============================================================*/
/* Index: UK_Personalization                                    */
/*==============================================================*/
create unique index UK_Personalization on Personalization
(
   idCard,
   idStep,
   coProfileType
);

/*==============================================================*/
/* Table: ProfileSurvey                                         */
/*==============================================================*/
create table ProfileSurvey
(
   idProfileSurvey      int not null auto_increment,
   idProfileSurveyUser  int,
   idUser               int,
   dtInserted           datetime not null default now(),
   txChangeToken        varchar(36) not null,
   primary key (idProfileSurvey)
);

insert into ProfileSurvey (idProfileSurvey, idProfileSurveyUser, idUser, dtInserted, txChangeToken)
select idProfileSurvey, idProfileSurveyUser, idUser, dtInserted, txChangeToken
from tmp_ProfileSurvey;
#
#drop table if exists tmp_ProfileSurvey;

/*==============================================================*/
/* Table: ProfileSurveyAnswer                                   */
/*==============================================================*/
create table ProfileSurveyAnswer
(
   idProfileSurvey      int not null,
   idProfileSurveyQuestion int not null,
   idLikertScale        tinyint not null,
   primary key (idProfileSurvey, idProfileSurveyQuestion)
);

insert into ProfileSurveyAnswer (idProfileSurvey, idProfileSurveyQuestion, idLikertScale)
select idProfileSurvey, idProfileSurveyQuestion, idLikertScale
from tmp_ProfileSurveyAnswer;
#
#drop table if exists tmp_ProfileSurveyAnswer;

/*==============================================================*/
/* Table: ProfileSurveyQuestion                                 */
/*==============================================================*/
create table ProfileSurveyQuestion
(
   idProfileSurveyQuestion int not null auto_increment,
   idProfileSurveyCategory smallint not null,
   coProfileSurveyType  char(4) not null,
   txProfileSurveyQuestion varchar(500) not null,
   dtInserted           datetime not null default NOW(),
   primary key (idProfileSurveyQuestion)
);

insert into ProfileSurveyQuestion (idProfileSurveyQuestion, idProfileSurveyCategory, coProfileSurveyType, txProfileSurveyQuestion, dtInserted)
select idProfileSurveyQuestion, idProfileSurveyCategory, coProfileSurveyType, txProfileSurveyQuestion, dtInserted
from tmp_ProfileSurveyQuestion;
#
#drop table if exists tmp_ProfileSurveyQuestion;

/*==============================================================*/
/* Table: ProfileSurveyResult                                   */
/*==============================================================*/
create table ProfileSurveyResult
(
   idProfileSurvey      int not null,
   idProfileSurveyCategory smallint not null,
   coProfileSurveyType  char(4) not null,
   idProfileSurveyCategoryChosen smallint,
   coProfileSurveyTypeChosen char(4),
   primary key (idProfileSurvey, idProfileSurveyCategory, coProfileSurveyType)
);

insert into ProfileSurveyResult (idProfileSurvey, idProfileSurveyCategory, coProfileSurveyType, idProfileSurveyCategoryChosen, coProfileSurveyTypeChosen)
select idProfileSurvey, idProfileSurveyCategory, coProfileSurveyType, idProfileSurveyCategoryChosen, coProfileSurveyTypeChosen
from tmp_ProfileSurveyResult;
#
#drop table if exists tmp_ProfileSurveyResult;

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/
create table Project
(
   idProject            int not null auto_increment,
   idSegment            int not null,
   txName               varchar(200) not null,
   txDescription        varchar(500),
   inStatus             tinyint not null default 1,
   dtInserted           datetime not null,
   primary key (idProject)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Project (idProject, idSegment, txName, dtInserted)
select idProject, idSegment, txName, now()
from tmp_Project;

drop table if exists tmp_Project;

/*==============================================================*/
/* Table: ProjectComponent                                      */
/*==============================================================*/
create table ProjectComponent
(
   idComponent          int not null,
   idProject            int not null,
   inStatus             tinyint not null default 1,
   dtInserted           datetime not null,
 primary key (idComponent, idProject)
);

/*==============================================================*/
/* Table: ProjectStage                                          */
/*==============================================================*/
create table ProjectStage
(
   idProject            int not null,
   idCard               int not null,
   nuSequence           tinyint not null default 1,
   inStatus             tinyint not null default 1,
   dtInserted           datetime not null,
   primary key (idProject, idCard)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into ProjectStage (idProject, idCard, dtInserted)
select idProject, idCard, now()
from tmp_ProjectCard;

drop table if exists tmp_ProjectCard;

/*==============================================================*/
/* Table: Room                                                  */
/*==============================================================*/
create table Room
(
   idRoom               int not null auto_increment,
   idSchool             int not null,
   txName               varchar(50) not null,
   txLocation           varchar(25) not null,
   dtInserted           datetime not null,
   isMandathoryTheme    bool not null,
   txIdentification     varchar(30) not null default '',
   inDeleted            bool not null default 0,
   primary key (idRoom)
);

insert into Room (idRoom, idSchool, txName, txLocation, dtInserted, isMandathoryTheme, txIdentification, inDeleted)
select idRoom, idSchool, txName, txLocation, dtInserted, isMandathoryTheme, txIdentification, 0
from tmp_Room;


alter table RoomInfrastructure drop constraint FK_ROOMINFR_REFERENCE_ROOM; 
drop table if exists tmp_Room;

/*==============================================================*/
/* Table: RoomTheme                                             */
/*==============================================================*/
create table RoomTheme
(
   idRoom               int not null,
   idTheme              smallint not null,
   inStatus             bool not null,
   dtInserted           datetime not null,
   primary key (idRoom, idTheme)
);

insert into RoomTheme (idRoom, idTheme, inStatus, dtInserted)
select idRoom, idTheme, inStatus, dtInserted
from tmp_RoomTheme;

drop table if exists tmp_RoomTheme;

/*==============================================================*/
/* Table: Segment                                               */
/*==============================================================*/

alter table tmp_Project drop constraint FK_Segment_Project;

alter table SegmentGrade drop constraint FK_Segment_SegmentGrade;

drop table Segment;



create table Segment
(
   idSegment            int not null auto_increment,
   txName               varchar(150) not null,
   txDescription        varchar(2000) not null,
   idComponent          int,
   inStatus             tinyint not null default 1,
   dtInserted           datetime not null,
   primary key (idSegment)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into Segment (idSegment, txName, txDescription, inStatus, dtInserted)
select idSegment, txName, '', inStatus, dtInserted
from tmp_Segment;

drop table if exists tmp_Segment;

/*==============================================================*/
/* Table: SegmentGrade                                          */
/*==============================================================*/
create table SegmentGrade
(
   idSegment            int not null,
   idGrade              int not null,
   primary key (idSegment, idGrade)
);

alter table ApprenticeMoment add constraint FK_Reference_61 foreign key (idMomentCard)
      references MomentCard (idMomentCard) on delete cascade;

alter table ApprenticeScore add constraint FK_ApprenticeScore_ApprenticeMoment foreign key (idApprenticeMoment)
      references ApprenticeMoment (idApprenticeMoment);

ALTER TABLE `dbLekto`.`ApprenticeScore` 
MODIFY COLUMN `coRating` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL AFTER `idApprenticeMoment`;

alter table ApprenticeScore add constraint FK_ApprenticeScore_Rating foreign key (coRating)
      references Rating (coRating);
 
alter table ApprenticeScore add constraint FK_Reference_66 foreign key (idEvidence)
      references Evidence (idEvidence);

alter table Card add constraint FK_Card_Theme foreign key (idTheme)
      references Theme (idTheme);

alter table CardEvidence add constraint FK_CardEvidence_Card foreign key (idCard)
      references Card (idCard) on delete cascade;

alter table CardEvidence add constraint FK_Reference_64 foreign key (idEvidence)
      references Evidence (idEvidence) on delete cascade;

alter table CardGrade add constraint FK_Reference_74 foreign key (idCard)
      references Card (idCard) on delete cascade;

alter table CardInfrastructure add constraint FK_CardInfrastructure_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

alter table CardInfrastructure add constraint FK_CardInfrastructure_Infrastructure foreign key (idInfrastructure)
      references Infrastructure (idInfrastructure) on delete cascade on update restrict;

alter table CardLearningTool add constraint FK_CardLearningTool_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

alter table CardReference add constraint FK_Reference_108 foreign key (idCard)
      references Card (idCard) on delete cascade;

alter table CardSchoolSupply add constraint FK_CardSchoolSupply_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

alter table EvaluationQuestion add constraint FK_Reference_71 foreign key (idCard, idEvidence)
      references CardEvidence (idCard, idEvidence) on delete cascade;

ALTER TABLE `dbLekto`.`LektoUserType` 
MODIFY COLUMN `coDistrictCode` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `inDeleted`;

alter table LektoUserType add constraint FK_LektoUserType_District foreign key (coDistrictCode)
      references District (coDistrictCode);
	 
alter table LektoUserType add constraint FK_Reference_101 foreign key (idSchool)
      references School (idSchool) on delete cascade;

alter table LektoUserType add constraint FK_LEKTOUSE_REFERENCE_LEKTOUSERTYPE foreign key (idUser)
      references LektoUser (idUser) on delete cascade;
	 
ALTER TABLE `dbLekto`.`LektoUserType` 
MODIFY COLUMN `coUserType` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL AFTER `idUser`;

alter table LektoUserType add constraint FK_Reference_107 foreign key (coUserType)
      references UserType (coUserType) on delete cascade;

alter table LektoUserType add constraint FK_Reference_123 foreign key (idSchoolNetwork)
      references SchoolNetwork (idSchoolNetwork);

alter table MomentCard add constraint FK_MomentCard_Moment foreign key (idMoment)
      references Moment (idMoment) on delete cascade;

alter table MomentCard add constraint FK_Reference_58 foreign key (idCard)
      references Card (idCard);

alter table MomentNotesApprentice add constraint FK_ApprenticeMoment_MomentNotesApprentice foreign key (idApprenticeMoment)
      references ApprenticeMoment (idApprenticeMoment);

alter table MomentNotesApprentice add constraint FK_MomentNotesApprentice_MomentNotes foreign key (idMomentNotes)
      references MomentNotes (idMomentNotes) on delete cascade on update restrict;

ALTER TABLE `dbLekto`.`Personalization` 
MODIFY COLUMN `coProfileType` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL AFTER `idStep`;

alter table Personalization add constraint FK_Personalization_ProfileType foreign key (coProfileType)
      references ProfileType (coProfileType) on delete cascade;

alter table Personalization add constraint FK_Personalization_Step foreign key (idCard, idStep)
      references Step (idCard, idStep) on delete cascade on update restrict;
	 
/*==============================================================*/
/* Table: ProfileSurveyUser                                     */
/*==============================================================*/
create table ProfileSurveyUser
(
   idProfileSurveyUser  int not null auto_increment,
   coRelationType       char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL not null  comment 'Tabela de tipo de vínculos entre os usuários.',
   txName               varchar(120) not null,
   txEmail              varchar(120) not null,
   nuSunAge             tinyint not null,
   txSchoolGrade        varchar(80) not null,
   primary key (idProfileSurveyUser)
);

alter table ProfileSurveyUser add constraint FK_Reference_84 foreign key (coRelationType)
      references RelationType (coRelationType);
	 

alter table ProfileSurvey add constraint FK_ProfileSurveyUser_ProfileSurvey foreign key (idProfileSurveyUser)
      references ProfileSurveyUser (idProfileSurveyUser);
	 
alter table ProfileSurvey add constraint FK_Reference_86 foreign key (idUser)
      references LektoUser (idUser);
	 
ALTER TABLE `dbLekto`.`ProfileSurveyAnswer` 
MODIFY COLUMN `idLikertScale` tinyint UNSIGNED NOT NULL AFTER `idProfileSurveyQuestion`;	 

alter table ProfileSurveyAnswer add constraint FK_LikertScale_ProfileSurveyAnswer foreign key (idLikertScale)
      references LikertScale (idLikertScale);



alter table ProfileSurveyAnswer add constraint FK_ProfileSurveyAnswer_ProfileSurveyQuestion foreign key (idProfileSurveyQuestion)
      references ProfileSurveyQuestion (idProfileSurveyQuestion);

alter table ProfileSurveyAnswer add constraint FK_PROFILE_SURVEY_PROFILE_SURVEY_ANSWER foreign key (idProfileSurvey)
      references ProfileSurvey (idProfileSurvey);

alter table ProfileSurveyQuestion add constraint FK_ProfileSurveyCategory_ProfileSurveyQuestion foreign key (idProfileSurveyCategory, coProfileSurveyType)
      references ProfileSurveyCategory (idProfileSurveyCategory, coProfileSurveyType);

alter table ProfileSurveyResult add constraint FK_ProfileSurveyCategoryChosen_ProfileSurveryResult foreign key (idProfileSurveyCategoryChosen, coProfileSurveyTypeChosen)
      references ProfileSurveyCategory (idProfileSurveyCategory, coProfileSurveyType);
	 
/*==============================================================*/
/* Table: ProfileSurveyCategory                                 */
/*==============================================================*/
create table ProfileSurveyCategory
(
   idProfileSurveyCategory smallint not null auto_increment,
   coProfileSurveyType  char(4) not null,
   txProfileSurveyCategory varchar(100) not null,
   txProfileSurveyCategoryComplement longtext,
   dtInsertd            datetime not null default NOW(),
   txImagePath          varchar(300),
   txColor              varchar(8),
   txProfileSurveyCategoryDescription longtext,
   primary key (idProfileSurveyCategory, coProfileSurveyType)
);

drop table if exists ProfileSurveyType;

/*==============================================================*/
/* Table: ProfileSurveyType                                     */
/*==============================================================*/
create table ProfileSurveyType
(
   coProfileSurveyType  char(4) not null,
   txProfileSurveyType  varchar(100) not null,
   dtInserted           datetime not null default NOW(),
   nuQuestionsPerSession tinyint not null,
   nuBypassScore        tinyint not null,
   nuOrder              tinyint not null default 1,
   primary key (coProfileSurveyType)
);


alter table ProfileSurveyCategory add constraint FK_PROFILE_SURVEY_TYPE_PROFILE_SURVEY_CATEGORY foreign key (coProfileSurveyType)
      references ProfileSurveyType (coProfileSurveyType);
	 

alter table ProfileSurveyResult add constraint FK_ProfileSurveyCategory_ProfileSurveyResult foreign key (idProfileSurveyCategory, coProfileSurveyType)
      references ProfileSurveyCategory (idProfileSurveyCategory, coProfileSurveyType);

alter table ProfileSurveyResult add constraint FK_PROFILE_SURVEY_PROFILE_SURVEY_RESULT foreign key (idProfileSurvey)
      references ProfileSurvey (idProfileSurvey);
	 

alter table Project add constraint FK_Segment_Project foreign key (idSegment)
      references Segment (idSegment);

alter table ProjectComponent add constraint FK_ProjectComponent_Component foreign key (idComponent)
      references Component (idComponent);

alter table ProjectComponent add constraint FK_ProjectComponent_Project foreign key (idProject)
      references Project (idProject);

alter table ProjectStage add constraint FK_Card_ProjectStage foreign key (idCard)
      references Card (idCard);

alter table ProjectStage add constraint FK_Project_ProjectStage foreign key (idProject)
      references Project (idProject);

alter table Room add constraint FK_Room_School foreign key (idSchool)
      references School (idSchool);

alter table RoomInfrastructure add constraint FK_Reference_87 foreign key (idRoom)
      references Room (idRoom) on delete cascade;

alter table RoomTheme add constraint FK_Reference_89 foreign key (idRoom)
      references Room (idRoom) on delete cascade;

alter table RoomTheme add constraint FK_Reference_90 foreign key (idTheme)
      references Theme (idTheme) on delete cascade;

alter table Segment add constraint FK_Segment_Component foreign key (idComponent)
      references Component (idComponent);

alter table SegmentGrade add constraint FK_SegmentGrade_Grade foreign key (idGrade)
      references Grade (idGrade);

alter table SegmentGrade add constraint FK_Segment_SegmentGrade foreign key (idSegment)
      references Segment (idSegment);

alter table Step add constraint FK_Step_Card foreign key (idCard)
      references Card (idCard) on delete cascade on update restrict;

