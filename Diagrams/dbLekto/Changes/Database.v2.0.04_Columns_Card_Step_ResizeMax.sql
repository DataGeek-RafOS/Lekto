/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     6/28/2022 4:26:16 PM                         */
/*==============================================================*/

ALTER TABLE `dbLekto`.`Card` 
MODIFY COLUMN `txBncc` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL AFTER `txSupportAuthor`,
MODIFY COLUMN `txMaterials` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL AFTER `txBncc`;

ALTER TABLE `dbLekto`.`Step`
MODIFY COLUMN txListeningDocumentation LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL;

ALTER TABLE `dbLekto`.`Evidence`
MODIFY COLUMN txDescription LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL;

ALTER TABLE `dbLekto`.`LektoUserType`
   ADD coDistrictCode CHAR(2);
   
ALTER TABLE `dbLekto`.`LektoUserType` ADD CONSTRAINT FK_District_LektoUserType FOREIGN KEY (coDistrictCode)
      REFERENCES District (coDistrictCode);   
   
   
INSERT INTO`dbLekto`.DatabaseVersion (txVersion, txComments)
VALUES ('v2.0.04', '1. Alteração dos campos txListeningDocumentation na tabela Step para TEXT; 
				2. Alteração dos campos txBNCC e txMaterials na tabela Card para TEXT;
				3. Alteração dos campos txDescription na tabela Evidence para TEXT;
				4. Adição do campo coDistrictCode na tabela LektoUserType;'					
				);


SELECT * FROM DatabaseVersion