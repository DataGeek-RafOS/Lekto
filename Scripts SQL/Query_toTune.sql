set statistics time, io on

exec sp_executesql N'SELECT [t0].[idAgenda], [t0].[idMoment], [t0].[idTutor], [t0].[idTheme], [t0].[dtTimeStart], [t0].[dtTimeEnd], [t0].[coMomentStatus], [t0].[txMomentStatus], [t0].[idAuth0], [t0].[dtAgenda], [t0].[c], [t0].[txTheme], [t0].[txImagePath], [t0].[txPrimaryColor], [t0].[txBgPrimaryColor], [t0].[idSchoolClass], [t0].[txName], [t0].[txName0], [t0].[txGrade], [t0].[useBeacon], [t0].[idUser], [t0].[idTheme0], [t0].[idSchoolGrade], [t0].[idGrade], [t0].[idSchool], [t0].[coMomentStatus0], [t11].[idMomentCard], [t11].[idCard], [t11].[idMoment], [t11].[txCard], [t11].[txTitle], [t11].[txOtherPossibilities], [t11].[txApprenticeCard], [t11].[idGrade], [t11].[txGrade], [t11].[idCard0], [t11].[idGrade0], [t11].[idLearningTool], [t11].[txLearningTool], [t11].[txImagePath], [t11].[idCard1], [t11].[idLearningTool0], [t11].[idApprentice], [t11].[idApprenticeMoment], [t11].[idMomentCard0], [t11].[inAttendance], [t11].[idApprentice0], [t11].[idClass], [t11].[idUser], [t11].[txName], [t11].[txNickname], [t11].[txImagePath0], [t11].[c], [t11].[c0], [t11].[c1], [t11].[idBeacon], [t11].[idUser0], [t11].[idEvidence], [t11].[coRating], [t11].[idApprenticeMoment0], [t11].[nuScore], [t11].[txRating], [t11].[coRating0], [t11].[idEvidence0], [t11].[txDescription], [t11].[c2], [t11].[c00], [t11].[txConcept], [t11].[txDimension], [t11].[idSkill], [t11].[txSkill], [t11].[txImagePath1], [t11].[txPrimaryColor], [t11].[txBgPrimaryColor], [t11].[txBgSecondaryColor], [t11].[idCard2], [t11].[idEvidence00], [t11].[idDimension], [t11].[idStep], [t11].[txTitle0], [t11].[txNotes], [t11].[nuTimeStep], [t11].[nuOrderStep], [t11].[idCard3], [t11].[idPersonalisation], [t11].[txPersonalisation], [t11].[coProfileType], [t11].[txProfileType], [t11].[txProfileColor], [t11].[idSupportMaterial], [t11].[txImagePath2], [t11].[txSupportMaterial], [t11].[IdMediaInfo], [t11].[txThumbnail], [t11].[c3], [t11].[IdMediaInfo0], [t11].[isPublic], [t11].[nuSize], [t11].[txAbsoluteUrl], [t11].[txContentType], [t11].[txName0], [t11].[txPath], [t11].[idGuidance], [t11].[txGuidance], [t11].[idSchoolSupply], [t11].[txImagePath3], [t11].[txSchoolSupply], [t11].[idCard4], [t11].[idSchoolSupply0], [t11].[idInfrastructure], [t11].[txImagePath4], [t11].[txInfrastructure], [t11].[idCard5], [t11].[idInfrastructure0]
FROM (
    SELECT TOP(1) [a].[idAgenda], [m].[idMoment], [m].[idTutor], [m].[idTheme], [a].[dtTimeStart], [a].[dtTimeEnd], [m].[coMomentStatus], [m0].[txMomentStatus], [l].[idAuth0], [a].[dtAgenda], CAST([t].[idTheme] AS int) AS [c], [t].[txTheme], [t].[txImagePath], [t].[txPrimaryColor], [t].[txBgPrimaryColor], [s].[idSchoolClass], [s1].[txName], [s].[txName] AS [txName0], [g].[txGrade], [s].[useBeacon], [l].[idUser], [t].[idTheme] AS [idTheme0], [s0].[idSchoolGrade], [g].[idGrade], [s1].[idSchool], [m0].[coMomentStatus] AS [coMomentStatus0]
    FROM [Moment] AS [m]
    INNER JOIN [LektoUser] AS [l] ON [m].[idTutor] = [l].[idUser]
    INNER JOIN [Agenda] AS [a] ON [m].[idAgenda] = [a].[idAgenda]
    INNER JOIN [Theme] AS [t] ON [m].[idTheme] = [t].[idTheme]
    INNER JOIN [SchoolClass] AS [s] ON [m].[idSchoolClass] = [s].[idSchoolClass]
    INNER JOIN [SchoolGrade] AS [s0] ON [s].[idSchoolGrade] = [s0].[idSchoolGrade]
    INNER JOIN [Grade] AS [g] ON [s0].[idGrade] = [g].[idGrade]
    INNER JOIN [School] AS [s1] ON [s0].[idSchool] = [s1].[idSchool]
    INNER JOIN [MomentStatus] AS [m0] ON [m].[coMomentStatus] = [m0].[coMomentStatus]
    WHERE [m].[idMoment] = @__idMoment_0
    ORDER BY [a].[dtAgenda], [a].[dtTimeStart], [a].[dtTimeEnd]
) AS [t0]
LEFT JOIN (
    SELECT [m1].[idMomentCard], [c].[idCard], [m1].[idMoment], [c].[txCard], [c].[txTitle], [c].[txOtherPossibilities], [c].[txApprenticeCard], [t1].[idGrade], [t1].[txGrade], [t1].[idCard] AS [idCard0], [t1].[idGrade0], [t2].[idLearningTool], [t2].[txLearningTool], [t2].[txImagePath], [t2].[idCard] AS [idCard1], [t2].[idLearningTool0], [t4].[idApprentice], [t4].[idApprenticeMoment], [t4].[idMomentCard] AS [idMomentCard0], [t4].[inAttendance], [t4].[idApprentice0], [t4].[idClass], [t4].[idUser], [t4].[txName], [t4].[txNickname], [t4].[txImagePath] AS [txImagePath0], [t4].[c], [t4].[c0], [t4].[c1], [t4].[idBeacon], [t4].[idUser0], [t4].[idEvidence], [t4].[coRating], [t4].[idApprenticeMoment0], [t4].[nuScore], [t4].[txRating], [t4].[coRating0], [t5].[idEvidence] AS [idEvidence0], [t5].[txDescription], [t5].[c] AS [c2], [t5].[c0] AS [c00], [t5].[txConcept], [t5].[txDimension], [t5].[idSkill], [t5].[txSkill], [t5].[txImagePath] AS [txImagePath1], [t5].[txPrimaryColor], [t5].[txBgPrimaryColor], [t5].[txBgSecondaryColor], [t5].[idCard] AS [idCard2], [t5].[idEvidence0] AS [idEvidence00], [t5].[idDimension], [t8].[idStep], [t8].[txTitle] AS [txTitle0], [t8].[txNotes], [t8].[nuTimeStep], [t8].[nuOrderStep], [t8].[idCard] AS [idCard3], [t8].[idPersonalisation], [t8].[txPersonalisation], [t8].[coProfileType], [t8].[txProfileType], [t8].[txProfileColor], [t8].[idSupportMaterial], [t8].[txImagePath] AS [txImagePath2], [t8].[txSupportMaterial], [t8].[IdMediaInfo], [t8].[txThumbnail], [t8].[c] AS [c3], [t8].[IdMediaInfo0], [t8].[isPublic], [t8].[nuSize], [t8].[txAbsoluteUrl], [t8].[txContentType], [t8].[txName] AS [txName0], [t8].[txPath], [t8].[idGuidance], [t8].[txGuidance], [t9].[idSchoolSupply], [t9].[txImagePath] AS [txImagePath3], [t9].[txSchoolSupply], [t9].[idCard] AS [idCard4], [t9].[idSchoolSupply0], [t10].[idInfrastructure], [t10].[txImagePath] AS [txImagePath4], [t10].[txInfrastructure], [t10].[idCard] AS [idCard5], [t10].[idInfrastructure0]
    FROM [MomentCard] AS [m1]
    INNER JOIN [Card] AS [c] ON [m1].[idCard] = [c].[idCard]
    LEFT JOIN (
        SELECT [g0].[idGrade], [g0].[txGrade], [c0].[idCard], [c0].[idGrade] AS [idGrade0]
        FROM [CardGrade] AS [c0]
        INNER JOIN [Grade] AS [g0] ON [c0].[idGrade] = [g0].[idGrade]
    ) AS [t1] ON [c].[idCard] = [t1].[idCard]
    LEFT JOIN (
        SELECT [l0].[idLearningTool], [l0].[txLearningTool], [l0].[txImagePath], [c1].[idCard], [c1].[idLearningTool] AS [idLearningTool0]
        FROM [CardLearningTool] AS [c1]
        INNER JOIN [LearningTool] AS [l0] ON [c1].[idLearningTool] = [l0].[idLearningTool]
    ) AS [t2] ON [c].[idCard] = [t2].[idCard]
    OUTER APPLY (
        SELECT [a3].[idApprentice], [a3].[idApprenticeMoment], [m1].[idMomentCard], [a3].[inAttendance], [a4].[idApprentice] AS [idApprentice0], [a4].[idClass], [a4].[idUser], [l1].[txName], [l1].[txNickname], [l1].[txImagePath], (
            SELECT TOP(1) [a0].[coProfileType]
            FROM [ApprenticeProfile] AS [a0]
            WHERE [a4].[idApprentice] = [a0].[idApprentice]
            ORDER BY [a0].[dtInserted] DESC) AS [c], (
            SELECT TOP(1) [p].[txProfileType]
            FROM [ApprenticeProfile] AS [a1]
            INNER JOIN [ProfileType] AS [p] ON [a1].[coProfileType] = [p].[coProfileType]
            WHERE [a4].[idApprentice] = [a1].[idApprentice]
            ORDER BY [a1].[dtInserted] DESC) AS [c0], (
            SELECT TOP(1) [p0].[txProfileColor]
            FROM [ApprenticeProfile] AS [a2]
            INNER JOIN [ProfileType] AS [p0] ON [a2].[coProfileType] = [p0].[coProfileType]
            WHERE [a4].[idApprentice] = [a2].[idApprentice]
            ORDER BY [a2].[dtInserted] DESC) AS [c1], [a4].[idBeacon], [l1].[idUser] AS [idUser0], [t3].[idEvidence], [t3].[coRating], [t3].[idApprenticeMoment] AS [idApprenticeMoment0], [t3].[nuScore], [t3].[txRating], [t3].[coRating0]
        FROM [ApprenticeMoment] AS [a3]
        INNER JOIN [Apprentice] AS [a4] ON [a3].[idApprentice] = [a4].[idApprentice]
        INNER JOIN [LektoUser] AS [l1] ON [a4].[idUser] = [l1].[idUser]
        LEFT JOIN (
            SELECT [a5].[idEvidence], [a5].[coRating], [a5].[idApprenticeMoment], [r].[nuScore], [r].[txRating], [r].[coRating] AS [coRating0]
            FROM [ApprenticeScore] AS [a5]
            INNER JOIN [Rating] AS [r] ON [a5].[coRating] = [r].[coRating]
        ) AS [t3] ON [a3].[idApprenticeMoment] = [t3].[idApprenticeMoment]
        WHERE [m1].[idMomentCard] = [a3].[idMomentCard]
    ) AS [t4]
    LEFT JOIN (
        SELECT [e].[idEvidence], [e].[txDescription], CAST([d].[idSkill] AS int) AS [c], CAST([d].[idDimension] AS int) AS [c0], [d].[txConcept], [d].[txDimension], [s2].[idSkill], [s2].[txSkill], [s2].[txImagePath], [s2].[txPrimaryColor], [s2].[txBgPrimaryColor], [s2].[txBgSecondaryColor], [c2].[idCard], [c2].[idEvidence] AS [idEvidence0], [d].[idDimension]
        FROM [CardEvidence] AS [c2]
        INNER JOIN [Evidence] AS [e] ON [c2].[idEvidence] = [e].[idEvidence]
        INNER JOIN [Dimension] AS [d] ON [e].[idDimension] = [d].[idDimension]
        INNER JOIN [Skill] AS [s2] ON [d].[idSkill] = [s2].[idSkill]
    ) AS [t5] ON [c].[idCard] = [t5].[idCard]
    LEFT JOIN (
        SELECT [s3].[idStep], [s3].[txTitle], [s3].[txNotes], [s3].[nuTimeStep], [s3].[nuOrderStep], [s3].[idCard], [t6].[idPersonalisation], [t6].[txPersonalisation], [t6].[coProfileType], [t6].[txProfileType], [t6].[txProfileColor], [t7].[idSupportMaterial], [t7].[txImagePath], [t7].[txSupportMaterial], [t7].[IdMediaInfo], [t7].[txThumbnail], [t7].[c], [t7].[IdMediaInfo0], [t7].[isPublic], [t7].[nuSize], [t7].[txAbsoluteUrl], [t7].[txContentType], [t7].[txName], [t7].[txPath], [g1].[idGuidance], [g1].[txGuidance]
        FROM [Step] AS [s3]
        LEFT JOIN (
            SELECT [p1].[idPersonalisation], [p1].[txPersonalisation], [p2].[coProfileType], [p2].[txProfileType], [p2].[txProfileColor], [p1].[idCard], [p1].[idStep]
            FROM [Personalization] AS [p1]
            INNER JOIN [ProfileType] AS [p2] ON [p1].[coProfileType] = [p2].[coProfileType]
        ) AS [t6] ON ([s3].[idCard] = [t6].[idCard]) AND ([s3].[idStep] = [t6].[idStep])
        LEFT JOIN (
            SELECT [s4].[idSupportMaterial], [s4].[txImagePath], [s4].[txSupportMaterial], [s4].[IdMediaInfo], [s4].[txThumbnail], CASE
                WHEN [s4].[IdMediaInfo] IS NOT NULL THEN CAST(1 AS bit)
                ELSE CAST(0 AS bit)
            END AS [c], [m2].[IdMediaInfo] AS [IdMediaInfo0], [m2].[isPublic], [m2].[nuSize], [m2].[txAbsoluteUrl], [m2].[txContentType], [m2].[txName], [m2].[txPath], [s4].[idCard], [s4].[idStep]
            FROM [SupportMaterial] AS [s4]
            LEFT JOIN [MediaInfo] AS [m2] ON [s4].[IdMediaInfo] = [m2].[IdMediaInfo]
        ) AS [t7] ON ([s3].[idCard] = [t7].[idCard]) AND ([s3].[idStep] = [t7].[idStep])
        LEFT JOIN [Guidance] AS [g1] ON ([s3].[idCard] = [g1].[idCard]) AND ([s3].[idStep] = [g1].[idStep])
    ) AS [t8] ON [c].[idCard] = [t8].[idCard]
    LEFT JOIN (
        SELECT [s5].[idSchoolSupply], [s5].[txImagePath], [s5].[txSchoolSupply], [c3].[idCard], [c3].[idSchoolSupply] AS [idSchoolSupply0]
        FROM [CardSchoolSupply] AS [c3]
        INNER JOIN [SchoolSupply] AS [s5] ON [c3].[idSchoolSupply] = [s5].[idSchoolSupply]
    ) AS [t9] ON [c].[idCard] = [t9].[idCard]
    LEFT JOIN (
        SELECT [i].[idInfrastructure], [i].[txImagePath], [i].[txInfrastructure], [c4].[idCard], [c4].[idInfrastructure] AS [idInfrastructure0]
        FROM [CardInfrastructure] AS [c4]
        INNER JOIN [Infrastructure] AS [i] ON [c4].[idInfrastructure] = [i].[idInfrastructure]
    ) AS [t10] ON [c].[idCard] = [t10].[idCard]
) AS [t11] ON [t0].[idMoment] = [t11].[idMoment]
ORDER BY [t0].[dtAgenda], [t0].[dtTimeStart], [t0].[dtTimeEnd], [t0].[idMoment], [t0].[idUser], [t0].[idAgenda], [t0].[idTheme0], [t0].[idSchoolClass], [t0].[idSchoolGrade], [t0].[idGrade], [t0].[idSchool], [t0].[coMomentStatus0], [t11].[txTitle], [t11].[idMomentCard], [t11].[idCard], [t11].[idCard0], [t11].[idGrade0], [t11].[idGrade], [t11].[idCard1], [t11].[idLearningTool0], [t11].[idLearningTool], [t11].[txName], [t11].[idApprenticeMoment], [t11].[idApprentice0], [t11].[idUser0], [t11].[idEvidence], [t11].[idApprenticeMoment0], [t11].[coRating0], [t11].[txSkill], [t11].[idCard2], [t11].[idEvidence00], [t11].[idEvidence0], [t11].[idDimension], [t11].[idSkill], [t11].[nuOrderStep], [t11].[idCard3], [t11].[idStep], [t11].[idPersonalisation], [t11].[coProfileType], [t11].[txSupportMaterial], [t11].[idSupportMaterial], [t11].[idGuidance], [t11].[txSchoolSupply], [t11].[idCard4], [t11].[idSchoolSupply0], [t11].[idSchoolSupply], [t11].[txInfrastructure], [t11].[idCard5], [t11].[idInfrastructure0], [t11].[idInfrastructure]',N'@__idMoment_0 int',@__idMoment_0=40