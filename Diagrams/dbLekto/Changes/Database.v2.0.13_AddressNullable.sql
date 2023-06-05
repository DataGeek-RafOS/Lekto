/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     07-Sep-22 17:10:20                           */
/*==============================================================*/


drop table if exists tmp_Address;

rename table Address to tmp_Address;

/*==============================================================*/
/* Table: Address                                               */
/*==============================================================*/
create table Address
(
   idAddress            int not null auto_increment,
   idCity               int,
   txAddressLine1       varchar(150),
   txAddressLine2       varchar(100),
   txZipcode            varchar(9),
   txNeighborhood       varchar(50),
   coDistrictCode       char(2) null,
   txCity               varchar(80),
   dtInserted           datetime not null,
   primary key (idAddress)
);



insert into Address (idAddress, idCity, txAddressLine1, txAddressLine2, txZipcode, txNeighborhood, coDistrictCode, txCity, dtInserted)
select idAddress, null, txAddressLine1, txAddressLine2, txZipcode, txNeighborhood, coDistrictCode, txCity, dtInserted
from tmp_Address;

alter table LektoUser drop constraint FK_Reference_94;

alter table School drop constraint FK_Reference_93;

drop table if exists tmp_Address;

ALTER TABLE `dbLekto`.`Address` 
MODIFY COLUMN `coDistrictCode` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `txNeighborhood`;

alter table Address add constraint FK_Address_District foreign key (coDistrictCode)
      references District (coDistrictCode);

alter table LektoUser add constraint FK_Reference_94 foreign key (idAddress)
      references Address (idAddress) on delete set null;

alter table School add constraint FK_Reference_93 foreign key (idAddress)
      references Address (idAddress);

