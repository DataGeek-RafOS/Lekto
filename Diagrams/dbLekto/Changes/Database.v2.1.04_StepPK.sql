
alter table Step
   add unique ukNCL_Step_idStep (idStep);

alter table Step
   drop primary key;

alter table Step
   add primary key (idCard, idStep);


alter table Guidance add constraint FK_Guidance_Step foreign key (idCard, idStep)
      references Step (idCard, idStep) on delete cascade on update restrict;

alter table Personalization add constraint FK_Personalization_Step foreign key (idCard, idStep)
      references Step (idCard, idStep) on delete cascade on update restrict;

alter table SupportMaterial add constraint FK_SupportMaterial_Step foreign key (idCard, idStep)
      references Step (idCard, idStep);

