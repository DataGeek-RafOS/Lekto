
###
alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonDocumentation;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete cascade on update restrict;

###
alter table LessonActivityDocumentation drop constraint FK_LessonActivityDocumentation_LessonMomentActivity;

alter table LessonActivityDocumentation add constraint FK_LessonActivityDocumentation_LessonMomentActivity foreign key (idLessonMomentActivity)
      references LessonMomentActivity (idLessonMomentActivity) on delete cascade on update restrict;

###
alter table LessonDocumentation drop constraint FK_LessonDocumentation_LessonMoment;

alter table LessonDocumentation add constraint FK_LessonDocumentation_LessonMoment foreign key (idLessonMoment)
      references LessonMoment (idLessonMoment) on delete cascade on update restrict;

###
alter table LessonDocumentationMedia drop constraint FK_LessonDocumentationMedia_LessonDocumentation;

alter table LessonDocumentationMedia add constraint FK_LessonDocumentationMedia_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete cascade on update restrict;

###
alter table LessonDocumentationMedia drop constraint FK_LessonDocumentationMedia_MediaInformation;

alter table LessonDocumentationMedia add constraint FK_LessonDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;
	 
###
alter table LessonEvidenceDocumentation drop constraint FK_LessonEvidenceDocumentation_Evidence;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict;
	 
###
alter table LessonEvidenceDocumentation drop constraint FK_LessonEvidenceDocumentation_LessonDocumentation;

alter table LessonEvidenceDocumentation add constraint FK_LessonEvidenceDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete cascade on update restrict;
	 
###
alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 
###
alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonMoment;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonMoment foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment)
      references LessonMoment (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment) on delete cascade on update restrict;
	 
###
alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_Assessment;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;
	 
###
alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonActivityEvidence;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonActivityEvidence foreign key (idLessonActivity, idEvidence, coGrade)
      references LessonActivityEvidence (idLessonActivity, idEvidence, coGrade) on delete restrict on update restrict;
	 
###
alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_LessonMomentActivity;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_LessonMomentActivity foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, idLessonActivity)
      references LessonMomentActivity (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idLessonMoment, idLessonActivity) on delete cascade on update restrict;
	 
###
alter table LessonMomentGroup drop constraint FK_LessonMomentGroup_StudentClass;

alter table LessonMomentGroup add constraint FK_LessonMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;
	 
###
alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonDocumentation;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonDocumentation foreign key (idDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete cascade on update restrict;
	 
###
alter table LessonStepDocumentation drop constraint FK_LessonStepDocumentation_LessonStep;

alter table LessonStepDocumentation add constraint FK_LessonStepDocumentation_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;
	 
###
alter table LessonStepDocumentationMedia drop constraint FK_LessonStepDocumentationMedia_LessonStepDocumentation;

alter table LessonStepDocumentationMedia add constraint FK_LessonStepDocumentationMedia_LessonStepDocumentation foreign key (idLessonStepDocumentation)
      references LessonStepDocumentation (idLessonStepDocumentation) on delete restrict on update restrict;
	 
###
alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_LessonDocumentation;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete cascade on update restrict;
	 
###
alter table LessonStudentDocumentation drop constraint FK_LessonStudentDocumentation_StudentClass;

alter table LessonStudentDocumentation add constraint FK_LessonStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete cascade on update restrict;
