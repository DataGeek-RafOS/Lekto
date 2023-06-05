/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     2/28/2023 5:01:56 PM                         */
/*==============================================================*/


alter table LessonDocumentation drop constraint FK_LessonDocumentation_MediaInformation;

alter table ProjectDocumentation drop constraint FK_ProjectDocumentation_MediaInformation;

alter table LessonDocumentation
   drop column IdMediaInformation;

alter table ProjectDocumentation
   drop column IdMediaInformation;

/*==============================================================*/
/* Table: LessonDocumentationMedia                              */
/*==============================================================*/
create table LessonDocumentationMedia
(
   idLessonDocumentationMedia int not null auto_increment,
   idLessonDocumentation int not null,
   IdMediaInformation   int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idLessonDocumentationMedia)
)
default character set utf8mb4
collate utf8mb4_general_ci;

/*==============================================================*/
/* Table: ProjectDocumentationMedia                             */
/*==============================================================*/
create table ProjectDocumentationMedia
(
   idProjectDocumentationMedia int not null auto_increment,
   idProjectDocumentation int not null,
   IdMediaInformation   int not null,
   dtInserted           datetime not null,
   dtLastUpdate         datetime,
   primary key (idProjectDocumentationMedia)
)
default character set utf8mb4
collate utf8mb4_general_ci;

alter table LessonDocumentationMedia add constraint FK_LessonDocumentationMedia_LessonDocumentation foreign key (idLessonDocumentation)
      references LessonDocumentation (idLessonDocumentation) on delete restrict on update restrict;

alter table LessonDocumentationMedia add constraint FK_LessonDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectDocumentationMedia add constraint FK_ProjectDocumentationMedia_MediaInformation foreign key (IdMediaInformation)
      references MediaInformation (IdMediaInformation) on delete restrict on update restrict;

alter table ProjectDocumentationMedia add constraint FK_ProjectDocumentationMedia_ProjectDocumentation foreign key (idProjectDocumentation)
      references ProjectDocumentation (idProjectDocumentation) on delete restrict on update restrict;

