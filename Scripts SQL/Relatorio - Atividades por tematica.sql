SELECT ThemeConfiguration.txTheme
	, Card.txCard
	, Card.txTitle
FROM Theme
	INNER JOIN
	ThemeConfiguration
		ON ThemeConfiguration.idThemeConfiguration = Theme.idThemeConfiguration
	INNER JOIN
	Card
		ON Card.idTheme = Theme.idTheme
WHERE Card.inStatus = 1
AND   Theme.inStatus = 1
ORDER BY Theme.idTheme;


SELECT Theme.idTheme
	, ThemeConfiguration.txTheme
	, COUNT(1) atividades
FROM Theme
	LEFT JOIN
	ThemeConfiguration
		ON ThemeConfiguration.idThemeConfiguration = Theme.idThemeConfiguration
	INNER JOIN
	Card
		ON Card.idTheme = Theme.idTheme
WHERE Card.inStatus = 1
AND   Theme.inStatus = 1
GROUP BY Theme.idTheme
	  , ThemeConfiguration.txTheme
ORDER BY Theme.idTheme;