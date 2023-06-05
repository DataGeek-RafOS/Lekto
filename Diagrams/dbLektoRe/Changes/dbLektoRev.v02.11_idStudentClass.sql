/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/28/2023 9:12:12 AM                         */
/*==============================================================*/


alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;
;

alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_StudentClass;
;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;
;

alter table ProjectStudentDocumentation drop constraint FK_ProjectStudentDocumentation_StudentClass;
;

alter table StudentClass drop constraint FK_StudentClass_Class;
;

alter table StudentClass drop constraint FK_StudentClass_Student;
;

alter table StudentClass
modify column idStudentClass int not null first,
   drop primary key
;

drop table if exists tmp_StudentClass
;

rename table StudentClass to tmp_StudentClass
;

/*==============================================================*/
/* Table: StudentClass                                          */
/*==============================================================*/
create table StudentClass
(
   idStudentClass       int not null auto_increment,
   idNetwork            int not null,
   idSchool             int not null,
   coGrade              char(4) not null,
   idSchoolYear         smallint not null,
   idClass              int not null,
   idUserStudent        int not null,
   idStudent            int not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idStudentClass),
   key AK_StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
)
default character set utf8mb4
collate utf8mb4_general_ci
;

insert into StudentClass (idStudentClass, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, inStatus, dtInserted, dtLastUpdate)
select StudentClass, idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent, inStatus, dtInserted, dtLastUpdate
from tmp_StudentClass
;

drop table if exists tmp_StudentClass
;

/*==============================================================*/
/* Index: ukNCL_idStudent_idClass                               */
/*==============================================================*/
create unique index ukNCL_idStudent_idClass on StudentClass
(
   idNetwork,
   idSchool,
   coGrade,
   idSchoolYear,
   idUserStudent,
   idStudent,
   idClass
)
;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict
;

alter table StudentClass add constraint FK_StudentClass_Class foreign key (idClass, idNetwork, idSchool, coGrade, idSchoolYear)
      references Class (idClass, idNetwork, idSchool, coGrade, idSchoolYear) on delete restrict on update restrict
;

alter table StudentClass add constraint FK_StudentClass_Student foreign key (idNetwork, idSchool, coGrade, idUserStudent, idStudent)
      references Student (idNetwork, idSchool, coGrade, idUserStudent, idStudent) on delete restrict on update restrict
;


DROP TRIGGER IF EXISTS `tgai_StudentClass`;
 
CREATE TRIGGER `tgai_StudentClass` 
AFTER INSERT ON StudentClass 
FOR EACH ROW BEGIN

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 3 # Aluno vinculado a turma {{p0}}
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', NEW.idClass)
          );

END ;


CREATE TRIGGER `tgau_StudentClass` 
AFTER UPDATE ON StudentClass
FOR EACH ROW 
BEGIN

     IF NEW.inStatus = 0
     THEN 

          INSERT INTO ActionLog
          (
            dtAction
          , idActionLogType          
          , idNetwork
          , idUser
          , txVariables
          )
          VALUES
          (
            NOW()
          , 16 # Aluno foi retirado da turma {{p0}} na data {{p1}}
          , NEW.idNetwork
          , NEW.idUserStudent
          , JSON_OBJECT('@p0', OLD.idClass, '@p1', NOW())
          );

     END IF;

END ;

