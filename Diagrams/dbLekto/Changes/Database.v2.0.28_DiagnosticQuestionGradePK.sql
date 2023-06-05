/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     28-Oct-22 15:49:02                           */
/*==============================================================*/

alter table DiagnosticQuestionGrade drop constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion ;

alter table DiagnosticQuestionGrade
   drop primary key;

drop table if exists tmp_DiagnosticQuestionGrade;

rename table DiagnosticQuestionGrade to tmp_DiagnosticQuestionGrade;

/*==============================================================*/
/* Table: DiagnosticQuestionGrade                               */
/*==============================================================*/
create table DiagnosticQuestionGrade
(
   idDiagnosticQuestionGrade int not null auto_increment,
   idDiagnosticQuestion int not null,
   idGrade              int not null,
   primary key (idDiagnosticQuestionGrade)
);

#WARNING: The following insert order will fail because it cannot give value to mandatory columns
insert into DiagnosticQuestionGrade (idDiagnosticQuestion, idGrade)
select idDiagnosticQuestion, idGrade
from tmp_DiagnosticQuestionGrade;

#WARNING: Drop cancelled because mandatory columns must have a value
#drop table if exists tmp_DiagnosticQuestionGrade;

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_DiagnosticQuestion foreign key (idDiagnosticQuestion)
      references DiagnosticQuestion (idDiagnosticQuestion);

alter table DiagnosticQuestionGrade add constraint FK_DiagnosticQuestionGrade_Grade foreign key (idGrade)
      references Grade (idGrade);

