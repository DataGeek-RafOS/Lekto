SELECT JSON_OBJECT(
			     'createdAt', NOW(),
			     'idMoment', Moment.idMoment
		        , 'dtAgenda', Agenda.dtAgenda
			   , 'dtTimeStart', Agenda.dtTimeStart
			   , 'dtTimeEnd', Agenda.dtTimeEnd
			   , 'dtMomentStart', Moment.dtStart
			   , 'dtmomentFinish', Moment.dtFinish
			   , 'coMomentStatus', MomentStatus.coMomentStatus
			   , 'txMomentStatus', MomentStatus.txMomentStatus
			   , 'theme', (SELECT JSON_ARRAYAGG(
								JSON_OBJECT(
										   'txTheme', ThemeConfiguration.txTheme
										 , 'txImagePath',	ThemeConfiguration.txImagePath
										 , 'txPrimaryColor', ThemeConfiguration.txPrimaryColor
										 , 'txBgPrimaryColor', ThemeConfiguration.txBgPrimaryColor
										 ))
						FROM Theme
							INNER JOIN
							ThemeConfiguration
								ON ThemeConfiguration.idThemeConfiguration = Theme.idThemeConfiguration
						WHERE Theme.idTheme = Moment.idTheme
					    )
			   , 'schoolClass', (SELECT JSON_ARRAYAGG(
								JSON_OBJECT(
										   'txName', SchoolClass.txName
										 , 'txGrade',	Grade.txGrade
										 , 'schoolTxName', School.txName
										 ))
							 FROM SchoolClass
							   	 INNER JOIN
							  	 SchoolGrade
							  		ON SchoolGrade.idSchoolGrade = SchoolClass.idSchoolGrade
							  	 INNER JOIN
							  	 Grade
							  		ON Grade.idGrade = SchoolGrade.idGrade
							  	 INNER JOIN
							  	 School
							  		ON School.idSchool = SchoolGrade.idSchool
							  WHERE SchoolClass.idSchoolClass = Moment.idSchoolClass
						       )		   
			   , 'cards', (SELECT JSON_ARRAYAGG(
								JSON_OBJECT(
										   'idMomentCard', MomentCard.idMomentCard
										 , 'idCard', Card.idCard
										 , 'txTitle', Card.txTitle
										 , 'txCard', Card.txCard
										 ))
							 FROM MomentCard
							   	 INNER JOIN
							  	 Card
							  		ON Card.idCard = MomentCard.idCard
							  WHERE MomentCard.idMoment = Moment.idMoment
						       )				   			   
			   ) AS momentDetailed
FROM Moment
	INNER JOIN
	Agenda
		ON Agenda.idAgenda = Moment.idAgenda
	INNER JOIN
	MomentStatus
		ON MomentStatus.coMomentStatus = Moment.coMomentStatus
WHERE idMoment = 2291

