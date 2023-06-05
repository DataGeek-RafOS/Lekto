/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/22/2023 7:17:44 PM                         */
/*==============================================================*/


alter table Category drop constraint FK_Category_Grade;

alter table LessonActivity drop constraint FK_LessonActivity_Category;

alter table LessonActivity drop constraint FK_LessonActivity_LessonStep;

alter table LessonActivity drop constraint FK_LessonActivity_EvidenceGrade;

alter table LessonActivityOrientation drop constraint FK_LessonActivityOrientation_LessonActivity;

alter table LessonMomentActivity drop constraint FK_LessonMomentActivity_LessonActivity;

alter table ProjectCategory drop constraint FK_ProjectCategory_Category;

alter table Category
modify column idCategory int not null first,
   drop primary key;

drop table if exists tmp_Category;

rename table Category to tmp_Category;

alter table LessonActivity
modify column idLessonActivity int not null first,
   drop primary key;

drop table if exists tmp_LessonActivity;

rename table LessonActivity to tmp_LessonActivity;

/*==============================================================*/
/* Table: Category                                              */
/*==============================================================*/
create table Category
(
   idCategory           smallint not null auto_increment,
   txName               varchar(100) not null,
   txImagePath          varchar(80) comment 'Caminho da imagem.',
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCategory)
)
default character set utf8mb4
collate utf8mb4_general_ci;

insert into Category (idCategory, txName, txImagePath, dtInserted, dtLastUpdate)
select idCategory, txName, txImagePath, dtInserted, dtLastUpdate
from tmp_Category;

drop table if exists tmp_Category;

/*==============================================================*/
/* Table: CategoryGrade                                         */
/*==============================================================*/
create table CategoryGrade
(
   idCategory           smallint not null,
   coGrade              char(4) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idCategory, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: LessonActivity                                        */
/*==============================================================*/
create table LessonActivity
(
   idLessonActivity     int not null auto_increment,
   coGrade              char(4) not null,
   idLessonStep         int not null,
   txTitle              varchar(150) not null,
   nuOrder              tinyint not null,
   idEvidence           int,
   idCategory           smallint null,
   txChallenge          varchar(500) not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonActivity, coGrade)
)
default character set utf8mb4
collate utf8mb4_general_ci;

select *
from CategoryGrade;

insert into CategoryGrade (idCategory, coGrade, dtInserted)
select distinct idCategory, coGrade, now() from LessonActivity where idCategory is not null;



insert into LessonActivity (idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate)
select idLessonActivity, coGrade, idLessonStep, txTitle, nuOrder, idEvidence, idCategory, txChallenge, dtInserted, dtLastUpdate
from tmp_LessonActivity;

drop table if exists tmp_LessonActivity;

alter table CategoryGrade add constraint FK_CategoryGrade_Category foreign key (idCategory)
      references Category (idCategory) on delete restrict on update restrict;

alter table CategoryGrade add constraint FK_CategoryGrade_Grade foreign key (coGrade)
      references Grade (coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_LessonStep foreign key (idLessonStep, coGrade)
      references LessonStep (idLessonStep, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict;

alter table LessonActivity add constraint FK_LessonActivity_EvidenceGrade foreign key (idEvidence, coGrade)
      references EvidenceGrade (idEvidence, coGrade) on delete restrict on update restrict;

alter table LessonActivityOrientation add constraint FK_LessonActivityOrientation_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;

alter table LessonMomentActivity add constraint FK_LessonMomentActivity_LessonActivity foreign key (idLessonActivity, coGrade)
      references LessonActivity (idLessonActivity, coGrade) on delete restrict on update restrict;
	 
insert into CategoryGrade (idCategory, coGrade, dtInserted)
select distinct idCategory, coGrade, now() 
from ProjectCategory 
where idCategory is not null
and not exists ( select 1 
			  from CategoryGrade
			  where CategoryGrade.idCategory = ProjectCategory.idCategory
			  and   CategoryGrade.coGrade = ProjectCategory.coGrade );

alter table ProjectCategory add constraint FK_ProjectCategory_CategoryGrade foreign key (idCategory, coGrade)
      references CategoryGrade (idCategory, coGrade) on delete restrict on update restrict;

