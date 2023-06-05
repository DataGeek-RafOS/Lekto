/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     9/20/2022 4:35:07 PM                         */
/*==============================================================*/


drop table if exists tmp_Theme;

rename table Theme to tmp_Theme;

/*==============================================================*/
/* Table: SegmentSchoolClass                                    */
/*==============================================================*/
create table SegmentSchoolClass
(
   idSegmentSchoolClass int not null auto_increment,
   idSchoolClass        int not null,
   idSegment            int not null,
   idTutorSurrogate     int,
   primary key (idSegmentSchoolClass)
);

/*==============================================================*/
/* Index: ixNCL_idSchoolClass_idSegment                         */
/*==============================================================*/
create index ixNCL_idSchoolClass_idSegment on SegmentSchoolClass
(
   idSchoolClass,
   idSegment
);

/*==============================================================*/
/* Table: Theme                                                 */
/*==============================================================*/
create table Theme
(
   idTheme              smallint not null auto_increment,
   idThemeReference     smallint,
   idThemeConfiguration smallint,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default 'getdate()',
   primary key (idTheme),
   key IX_Theme_idThemeConfiguration (idThemeConfiguration),
   key IX_Theme_idThemeReference (idThemeReference)
);

insert into Theme (idTheme, idThemeReference, idThemeConfiguration, inStatus, dtInserted)
select idTheme, idThemeReference, idThemeConfiguration, inStatus, dtInserted
from tmp_Theme;

drop table if exists tmp_Theme;

alter table Card add constraint FK_Card_Theme foreign key (idTheme)
      references Theme (idTheme);

alter table Moment add constraint FK_Reference_59 foreign key (idTheme)
      references Theme (idTheme);

alter table ProfileTheme add constraint FK_ProfileTheme_Theme foreign key (idTheme)
      references Theme (idTheme) on delete restrict on update restrict;

alter table RoomTheme add constraint FK_Reference_90 foreign key (idTheme)
      references Theme (idTheme) on delete cascade;

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_LektoUser foreign key (idTutorSurrogate)
      references LektoUser (idUser);

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass);

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_Segment foreign key (idSegment)
      references Segment (idSegment);

alter table Theme add constraint FK_ThemeReference_Theme foreign key (idThemeReference)
      references Theme (idTheme);

alter table Theme add constraint FK_Theme_ThemeConfiguration foreign key (idThemeConfiguration)
      references ThemeConfiguration (idThemeConfiguration);

