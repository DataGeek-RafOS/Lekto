CREATE TABLE `dbLekto`.`DatabaseVersion`  (
  `IdVersion` int NOT NULL AUTO_INCREMENT,
  `DateDeploy` datetime NOT NULL DEFAULT (NOW()),
  `txVersion` varchar(10) NOT NULL COMMENT 'Versão aplicada',
  `txComments` varchar(1000) NULL COMMENT 'Alterações aplicadas',
  PRIMARY KEY (`IdVersion`)
) ENGINE = InnoDB;

INSERT INTO`dbLekto`.DatabaseVersion (txVersion, txComments)
VALUES ('v2.0.01', '1. Inclusão dos campos txBNCC e txMaterials na tabela Card; 2. Ajuste de nomenclatura de índices;')
#VALUES ('v2.0.02', '1. Criação das tabelas Grade e GradeStage')

SELECT * FROM DatabaseVersion