/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     3/31/2023 2:42:54 PM                         */
/*==============================================================*/


alter table DataUsage
   modify column txUserAgent varchar(300);

ALTER TABLE MediaInformation 
ADD COLUMN inDeleted tinyint NULL DEFAULT 0 AFTER `dtLastUpdate`;
