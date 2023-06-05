ALTER VIEW vwThemeAbility
AS
SELECT DISTINCT
	  Theme.idTheme AS idTheme
     , ThemeConfiguration.txTheme AS txTheme
     , Dimension.idDimension AS idDimension
     , Dimension.txDimension AS txDimension
FROM Theme
     INNER JOIN 
     ThemeConfiguration
          ON ThemeConfiguration.idThemeConfiguration = Theme.idThemeConfiguration
     INNER JOIN 
     Card
          ON Card.idTheme = Theme.idTheme
     INNER JOIN CardEvidence
          ON CardEvidence.idCard = Card.idCard
     INNER JOIN 
     Evidence
          ON Evidence.idEvidence = CardEvidence.idEvidence
     INNER JOIN 
     Dimension
          ON Dimension.idDimension = Evidence.idDimension
WHERE Theme.inStatus = 1
      AND ThemeConfiguration.inStatus = 1
      AND Card.inStatus = 1
      AND CardEvidence.inStatus = 1
      AND Evidence.inStatus = 1
      AND Dimension.inStatus = 1;