/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/15/2023 10:44:40 AM                        */
/*==============================================================*/


/*==============================================================*/
/* Table: DiagnosticAnswer                                      */
/*==============================================================*/
create table DiagnosticAnswer
(
   idDiagnosticSurvey   int not null,
   idDiagnosticQuestion int not null,
   idLikertScale        tinyint not null,
   primary key (idDiagnosticSurvey, idDiagnosticQuestion)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: DiagnosticQuestion                                    */
/*==============================================================*/
create table DiagnosticQuestion
(
   idDiagnosticQuestion int not null auto_increment,
   txQuestion           varchar(1000) character set utf8mb4 not null,
   idAbility            smallint not null,
   inStatus             tinyint(1) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDiagnosticQuestion)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: DiagnosticQuestionGrade                               */
/*==============================================================*/
create table DiagnosticQuestionGrade
(
   idDiagnosticQuestionGrade int not null auto_increment,
   idDiagnosticQuestion int not null,
   coGrade              char(4) not null,
   primary key (idDiagnosticQuestionGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: DiagnosticSurvey                                      */
/*==============================================================*/
create table DiagnosticSurvey
(
   idDiagnosticSurvey   int not null auto_increment,
   idNetwork            int not null,
   idUser               int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idDiagnosticSurvey)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LikertScale                                           */
/*==============================================================*/
drop table LikertScale
create table LikertScale
(
   idLikertScale        tinyint not null,
   txLikertScale        varchar(30) not null,
   nuLikertScaleScore   smallint not null,
   primary key (idLikertScale)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion) on delete restrict on update restrict;

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticSurvey foreign key (idDiagnosticSurvey)
      references DiagnosticSurvey (idDiagnosticSurvey) on delete restrict on update restrict;



alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_LikertScale foreign key (idLikertScale)
      references LikertScale (idLikertScale) on delete restrict on update restrict;

alter table DiagnosticQuestion add constraint FK_DiagnosticQuestion_Ability foreign key (idAbility)
      references Ability (idAbility) on delete restrict on update restrict;

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion) on delete restrict on update restrict;

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table DiagnosticSurvey add constraint FK_DiagnosticSurvey_LektoUser foreign key (idNetwork, idUser)
      references LektoUser (idNetwork, idUser) on delete restrict on update restrict;

