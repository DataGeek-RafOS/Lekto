/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     11-Nov-22 17:42:03                           */
/*==============================================================*/


/*==============================================================*/
/* Table: DiagnosticAnswer                                      */
/*==============================================================*/
create table DiagnosticAnswer
(
   idDiagnosticSurvey   int not null,
   idDiagnosticQuestion int not null,
   idLikertScale        tinyint unsigned not null,
   primary key (idDiagnosticSurvey, idDiagnosticQuestion)
);


/*==============================================================*/
/* Table: DiagnosticSurvey                                      */
/*==============================================================*/
create table DiagnosticSurvey
(
   idDiagnosticSurvey   int not null auto_increment,
   idUser               int not null,
   dtInserted           datetime default NOW(),
   primary key (idDiagnosticSurvey)
);

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion);

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_DiagnosticSurvey foreign key (idDiagnosticSurvey)
      references DiagnosticSurvey (idDiagnosticSurvey);

alter table DiagnosticAnswer add constraint FK_DiagnosticAnswer_LikertScale foreign key (idLikertScale)
      references LikertScale (idLikertScale);

alter table DiagnosticSurvey add constraint FK_DiagnosticSurvey_LektoUser foreign key (idUser)
      references LektoUser (idUser);

