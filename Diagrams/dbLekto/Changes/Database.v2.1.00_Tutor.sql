/*==============================================================*/
/* DBMS name:      MySQL                                        */
/* Created on:     08-Dec-22 17:21:54                           */
/*==============================================================*/


drop table if exists tmp_SchoolClass;

rename table SchoolClass to tmp_SchoolClass;

drop table if exists tmp_SegmentSchoolClass;

rename table SegmentSchoolClass to tmp_SegmentSchoolClass;


/*==============================================================*/
/* Table: Tutor                                                 */
/*==============================================================*/
create table Tutor
(
   idUser               int not null,
   idSchoolClass        int not null,
   primary key (idUser, idSchoolClass)
);

insert into Tutor (idUser, idSchoolClass)
select idTutor, idSchoolClass
from tmp_SchoolClass
where idTutor is not null;


/*==============================================================*/
/* Table: SchoolClass                                           */
/*==============================================================*/
create table SchoolClass
(
   idSchoolClass        int not null auto_increment,
   idSchoolGrade        int not null,
   txName               varchar(50) not null,
   inStatus             tinyint(1) not null default 1,
   dtInserted           datetime not null default now(),
   idSchedule           int default NULL,
   dtStartPeriod        datetime,
   dtEndPeriod          datetime,
   coClassShift         char(3),
   txCodeOrigin         varchar(36),
   primary key (idSchoolClass),
   key IX_SchoolClass_idSchedule (idSchedule),
   key IX_SchoolClass_idSchoolGrade (idSchoolGrade)
)
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
;


alter table SchoolClass comment 'Turma';

insert into SchoolClass (idSchoolClass, idSchoolGrade, txName, inStatus, dtInserted, idSchedule, dtStartPeriod, dtEndPeriod, coClassShift, txCodeOrigin)
select idSchoolClass, idSchoolGrade, txName, inStatus, dtInserted, idSchedule, dtStartPeriod, dtEndPeriod, coClassShift, txCodeOrigin
from tmp_SchoolClass;

alter table Apprentice drop CONSTRAINT FK_Apprentice_Class;

alter table Moment drop CONSTRAINT FK_MOMENT_REFERENCE_SCHOOLCL;

alter table tmp_SegmentSchoolClass drop CONSTRAINT FK_SegmentSchoolClass_SchoolClass;

drop table if exists tmp_SchoolClass;

/*==============================================================*/
/* Table: SegmentSchoolClass                                    */
/*==============================================================*/
create table SegmentSchoolClass
(
   idSegmentSchoolClass int not null auto_increment,
   idSchoolClass        int not null,
   idSegment            int not null,
   idTutorSegment       int not null,
   nuOrder              smallint not null default 1,
   inProcessed          tinyint(1) not null default 0,
   primary key (idSegmentSchoolClass)
)
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci
;

insert into SegmentSchoolClass (idSegmentSchoolClass, idSchoolClass, idSegment, idTutorSegment, nuOrder, inProcessed)
select idSegmentSchoolClass, idSchoolClass, idSegment, idTutorSurrogate, nuOrder, inProcessed
from tmp_SegmentSchoolClass;

drop table if exists tmp_SegmentSchoolClass;

/*==============================================================*/
/* Index: ixNCL_idSchoolClass_idSegment                         */
/*==============================================================*/
create index ixNCL_idSchoolClass_idSegment on SegmentSchoolClass
(
   idSchoolClass,
   idSegment
);

/*==============================================================*/
/* Index: ukNCL_idSchoolClass_idSegment_nuOrder                 */
/*==============================================================*/
create unique index ukNCL_idSchoolClass_idSegment_nuOrder on SegmentSchoolClass
(
   idSchoolClass,
   idSegment,
   nuOrder
);


/*==============================================================*/
/* Index: ixNCL_Tutor_idSchoolClass_idUser                      */
/*==============================================================*/
create index ixNCL_Tutor_idSchoolClass_idUser on Tutor
(
   idSchoolClass,
   idUser
);

alter table Apprentice add constraint FK_Apprentice_Class foreign key (idClass)
      references SchoolClass (idSchoolClass) on delete restrict on update restrict;

alter table Moment add constraint FK_Moment_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass);

alter table SchoolClass add constraint FK_SchoolClass_ClassShift foreign key (coClassShift)
      references ClassShift (coClassShift);

alter table SchoolClass add constraint FK_SchoolClass_Schedule foreign key (idSchedule)
      references Schedule (idSchedule);

alter table SchoolClass add constraint FK_SchoolClass_SchoolGrade foreign key (idSchoolGrade)
      references SchoolGrade (idSchoolGrade) on delete restrict on update restrict;

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_LektoUser foreign key (idTutorSegment)
      references LektoUser (idUser);

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass);

alter table SegmentSchoolClass add constraint FK_SegmentSchoolClass_Segment foreign key (idSegment)
      references Segment (idSegment);

alter table Tutor add constraint FK_LektoUser_Tutor foreign key (idUser)
      references LektoUser (idUser);

alter table Tutor add constraint FK_Tutor_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass);

