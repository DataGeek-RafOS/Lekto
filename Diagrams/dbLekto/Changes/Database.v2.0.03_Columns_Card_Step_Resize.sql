/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     6/28/2022 4:26:16 PM                         */
/*==============================================================*/


alter table Card
   modify column txMaterials varchar(2000);

alter table Step
   modify column txListeningDocumentation varchar(1000);



INSERT INTO`dbLekto`.DatabaseVersion (txVersion, txComments)
VALUES ('v2.0.03', '1. Alteração dos campos Step.txListeningDocumentation para varchar(1000) e Card.txMaterials para varchar(2000)')


SELECT * FROM DatabaseVersion