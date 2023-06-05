/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     8/8/2022 3:42:25 PM                          */
/*==============================================================*/

drop table if exists tmp_ThemeConfiguration;

rename table ThemeConfiguration to tmp_ThemeConfiguration;

/*==============================================================*/
/* Index: ukNCL_txCPF                                           */
/*==============================================================*/
create unique index ukNCL_txCPF on LektoUser
(
   txCpf
);

/*==============================================================*/
/* Table: Project                                               */
/*==============================================================*/

create table Project
(
   idProject            int not null auto_increment,
   idSegment            int not null,
   txName               varchar(200) not null,
   primary key (idProject)
) ENGINE=INNODB;

/*==============================================================*/
/* Table: ProjectCard                                           */
/*==============================================================*/
create table ProjectCard
(
   idProject            int not null,
   idCard               int not null,
   primary key (idProject, idCard)
) ENGINE=INNODB;

alter table SchoolClass
   add dtStartPeriod datetime;

alter table SchoolClass
   add dtEndPeriod datetime;

/*==============================================================*/
/* Table: Segment                                               */
/*==============================================================*/
#drop table Segment;
create table Segment
(
   idSegment            int not null auto_increment,
   txName               varchar(150) not null,
   inStatus             bit not null default 1,
   dtInserted           datetime not null,
   primary key (idSegment)
) ENGINE=INNODB;

/*==============================================================*/
/* Table: ThemeConfiguration                                    */
/*==============================================================*/
create table ThemeConfiguration
(
   idThemeConfiguration smallint not null auto_increment,
   txTheme              varchar(80) not null,
   txImagePath          varchar(300) comment 'Caminho da imagem.',
   txPrimaryColor       varchar(8),
   txBgPrimaryColor     varchar(8),
   inSubtheme           bool not null default 0,
   nuSequence           smallint not null default 0,
   inStatus             bool not null default 1,
   dtInserted           datetime not null default now(),
   primary key (idThemeConfiguration)
);

insert into ThemeConfiguration (idThemeConfiguration, txTheme, txImagePath, txPrimaryColor, txBgPrimaryColor, inSubtheme, inStatus, dtInserted)
select idThemeConfiguration, txTheme, txImagePath, txPrimaryColor, txBgPrimaryColor, inSubtheme, inStatus, dtInserted
from tmp_ThemeConfiguration;

alter table Theme drop constraint FK_Theme_ThemeConfiguration;

drop table tmp_ThemeConfiguration;

alter table Project add constraint FK_Segment_Project foreign key (idSegment)
      references Segment (idSegment);

alter table ProjectCard add constraint FK_Card_ProjectCard foreign key (idCard)
      references Card (idCard);
	 
	 

alter table ProjectCard add constraint FK_Project_ProjectCard foreign key (idProject)
      references Project (idProject);

alter table Theme add constraint FK_Theme_ThemeConfiguration foreign key (idThemeConfiguration)
      references ThemeConfiguration (idThemeConfiguration);
