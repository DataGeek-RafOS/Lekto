/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     27-Oct-22 12:05:23                           */
/*==============================================================*/


/*==============================================================*/
/* Table: DiagnosticQuestion                                    */
/*==============================================================*/
create table DiagnosticQuestion
(
   idDiagnosticQuestion int not null auto_increment,
   txQuestion           varchar(1000) character set utf8mb4 not null,
   idDimension          smallint not null,
   dtInserted           datetime not null,
   inStatus             tinyint(1) not null,
   primary key (idDiagnosticQuestion)
);

/*==============================================================*/
/* Table: DiagnosticQuestionGrade                               */
/*==============================================================*/
create table DiagnosticQuestionGrade
(
   idDiagnosticQuestion int not null,
   idGrade              int not null,
   primary key (idDiagnosticQuestion, idGrade)
);

alter table DiagnosticQuestion add constraint FK_DiagnosticQuestion_Dimension foreign key (idDimension)
      references Dimension (idDimension);

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion);

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_Grade foreign key (idGrade)
      references Grade (idGrade);

