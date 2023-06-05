/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     5/11/2023 9:48:22 PM                         */
/*==============================================================*/

ALTER TABLE `LessonGroupAssessment` 
DROP COLUMN `dtInserted`,
MODIFY COLUMN `idEvidence` int NOT NULL AFTER `idLessonActivity`;

ALTER TABLE `ProjectGroupAssessment` 
DROP COLUMN `dtInserted`;