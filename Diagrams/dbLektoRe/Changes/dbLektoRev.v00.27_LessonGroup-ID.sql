/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     1/30/2023 3:54:29 PM                         */
/*==============================================================*/


alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_Assessment;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;

alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;

alter table LessonMomentGroup
   drop primary key;

rename table LessonMomentGroup to idLessonMomentGroup;

alter table idLessonMomentGroup
   add primary key (LessonMomentGroup);

alter table idLessonMomentGroup add constraint FK_idLessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table idLessonMomentGroup add constraint FK_idLessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete restrict on update restrict;

alter table idLessonMomentGroup add constraint FK_idLessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

