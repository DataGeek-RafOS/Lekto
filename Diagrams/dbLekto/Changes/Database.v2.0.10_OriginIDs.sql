/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     02-Sep-22 13:49:30                           */
/*==============================================================*/


drop table if exists tmp_Address;

rename table Address to tmp_Address;

/*==============================================================*/
/* Table: Address                                               */
/*==============================================================*/
create table Address
(
   idAddress            int not null auto_increment,
   txAddressLine1       varchar(150) not null,
   txAddressLine2       varchar(100),
   txZipcode            varchar(9) not null,
   txNeighborhood       varchar(50) not null,
   coDistrictCode       char(2),
   txCity               varchar(80),
   dtInserted           datetime not null,
   primary key (idAddress)
);

insert into Address (idAddress, txAddressLine1, txAddressLine2, txZipcode, txNeighborhood, dtInserted, txCity)
select idAddress, txAddressLine1, txAddressLine2, txZipcode, txNeighborhood, dtInserted, City.txName
from tmp_Address
	inner join
	City
		on tmp_Address.idCity = City.idCity;
		
alter table School drop constraint FK_SCHOOL_REFERENCE_ADDRESS;		

alter table LektoUser drop constraint FK_LEKTOUSE_REFERENCE_ADDRESS;		

drop table if exists tmp_Address;

alter table LektoUser
   add txCodeOrigin varchar(30);

alter table School
   add txCodeOrigin varchar(30);

alter table SchoolClass
   add coClassShift char(3);

alter table SchoolClass
   add txCodeOrigin varchar(30);
   
ALTER TABLE `dbLekto`.`Address` 
MODIFY COLUMN `coDistrictCode` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `txNeighborhood`;

alter table Address add constraint FK_Address_District foreign key (coDistrictCode)
      references District (coDistrictCode);

alter table LektoUser add constraint FK_Reference_94 foreign key (idAddress)
      references Address (idAddress) on delete set null;

alter table School add constraint FK_Reference_93 foreign key (idAddress)
      references Address (idAddress);

alter table SchoolClass add constraint FK_SchoolClass_ClassShift foreign key (coClassShift)
      references ClassShift (coClassShift);

alter table SchoolClass add constraint FK_SchoolClass_Schedule foreign key (idSchedule)
      references Schedule (idSchedule);

