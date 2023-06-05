ALTER TABLE `ProjectMoment` 
MODIFY COLUMN `dtSchedule` datetime NOT NULL COMMENT 'Data do agendamento' AFTER `coMomentStatus`,
ADD COLUMN `dtStartMoment` datetime NULL COMMENT 'Data e hora do inicio' AFTER `dtSchedule`,
ADD COLUMN `dtEndMoment` datetime NULL COMMENT 'Data e hora da finalizacao' AFTER `dtStartMoment`;