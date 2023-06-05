
alter table ProjectDocumentation drop constraint FK_ProjectDocumentation_ProjectMoment ;

alter table ProjectDocumentation add constraint FK_ProjectDocumentation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete cascade on update restrict;

alter table ProjectDocumentationMedia drop constraint FK_ProjectDocumentationMedia_MediaInformation ;

alter table ProjectDocumentationMedia add constraint FK_ProjectDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;


alter table ProjectDocumentationMedia drop constraint FK_ProjectDocumentationMedia_ProjectDocumentation;

alter table ProjectDocumentationMedia add constraint FK_ProjectDocumentationMedia_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete cascade on update restrict;


alter table ProjectEvidenceDocumentation drop constraint FK_ProjectEvidenceDocumentation_Evidence ;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_Evidence foreign key (idEvidence)
      references Evidence (idEvidence) on delete restrict on update restrict;

alter table ProjectEvidenceDocumentation drop constraint FK_ProjectEvidenceDocumentation_ProjectDocumentation ;

alter table ProjectEvidenceDocumentation add constraint FK_ProjectEvidenceDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete cascade on update restrict;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_Assessment ;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_Assessment foreign key (coAssessment)
      references Assessment (coAssessment) on delete restrict on update restrict;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_ProjectMomentStage ;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectMomentStage2 foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment, idProjectStage)
      references ProjectMomentStage (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idProjectMoment, idProjectStage) on delete cascade on update restrict;

alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_StudentClass;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;


alter table ProjectMomentGroup drop constraint FK_ProjectMomentGroup_ProjectStageEvidence;

alter table ProjectMomentGroup add constraint FK_ProjectMomentGroup_ProjectStageEvidence foreign key (idProjectStage, idEvidence, coGrade)
      references ProjectStageEvidence (idProjectStage, idEvidence, coGrade) on delete restrict on update restrict;

alter table ProjectMomentLog drop constraint FK_ProjectMomentLog_ProjectMoment ;

alter table ProjectMomentLog add constraint FK_ProjectMomentLog_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete cascade on update restrict;

alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectMoment ;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectMoment foreign key (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass)
      references ProjectMoment (idProjectMoment, idNetwork, idSchool, coGrade, idSchoolYear, idClass) on delete cascade on update restrict;


alter table ProjectMomentStage drop constraint FK_ProjectMomentStage_ProjectStage ;

alter table ProjectMomentStage add constraint FK_ProjectMomentStage_ProjectStage foreign key (idProjectStage, coGrade)
      references ProjectStage (idProjectStage, coGrade) on delete restrict on update restrict;

alter table ProjectMomentStageOrientation drop constraint FK_ProjectMomentStageOrientation_ProjectMomentStage ;

alter table ProjectMomentStageOrientation add constraint FK_ProjectMomentStageOrientation_ProjectMomentStage foreign key (idProjectMomentStage)
      references ProjectMomentStage (idProjectMomentStage) on delete cascade on update restrict;


alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectDocumentation;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete cascade on update restrict;
	 
	 

alter table ProjectStageDocumentation drop constraint FK_ProjectStageDocumentation_ProjectStage;

alter table ProjectStageDocumentation add constraint FK_ProjectStageDocumentation_ProjectStage foreign key (idProjectStage)
      references ProjectStage (idProjectStage) on delete restrict on update restrict;


alter table ProjectStageDocumentationMedia drop constraint FK_ProjectStageDocumentationMedia_MediaInformation;

alter table ProjectStageDocumentationMedia add constraint FK_ProjectStageDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;


alter table ProjectStageDocumentationMedia drop constraint FK_ProjectStageDocumentationMedia_ProjectStageDocumentation;

alter table ProjectStageDocumentationMedia add constraint FK_ProjectStageDocumentationMedia_ProjectStageDocumentation foreign key (idProjectStageDocumentation)
      references ProjectStageDocumentation (idProjectStageDocumentation) on delete cascade on update restrict;


alter table ProjectStudentDocumentation drop constraint FK_ProjectStudentDocumentation_StudentClass;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_StudentClass foreign key (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent)
      references StudentClass (idNetwork, idSchool, coGrade, idSchoolYear, idClass, idUserStudent, idStudent) on delete restrict on update restrict;

alter table ProjectStudentDocumentation drop constraint FK_ProjectStudentDocumentation_ProjectDocumentation ;

alter table ProjectStudentDocumentation add constraint FK_ProjectStudentDocumentation_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete cascade on update restrict;


alter table ProjectMomentOrientation drop constraint FK_ProjectMomentOrientation_ProjectMoment;

alter table ProjectMomentOrientation add constraint FK_ProjectMomentOrientation_ProjectMoment foreign key (idProjectMoment)
      references ProjectMoment (idProjectMoment) on delete restrict on update restrict;


