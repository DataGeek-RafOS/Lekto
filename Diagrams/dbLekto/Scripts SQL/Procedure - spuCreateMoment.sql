DROP PROCEDURE IF EXISTS `spuCreateMoment`;

CREATE PROCEDURE `spuCreateMoment` 
     ( IN 
       in_idClass int,
       in_dtAgenda date, 
       in_SchoolClassStateHash varchar(256),
       in_jobId varchar(36),
       in_idTheme smallint, 
       OUT
       out_idMoment int
     )
BEGIN

     DECLARE v_dtTimeStart TIME;
     DECLARE v_dtTimeEnd   TIME;
     DECLARE v_idTutor     INT;
     DECLARE v_idAgenda    INT;

     -- Recupera os dados de agendamento para criacao do agendamento
     SELECT dtTimeStart,
            dtTimeEnd
          INTO v_dtTimeStart, v_dtTimeEnd
     FROM SchoolClass ScCl
          INNER JOIN `Schedule` Sche
               ON Sche.idSchedule = ScCl.idSchedule
     WHERE idSchoolClass = in_idClass
     LIMIT 1;

     -- Recupera os dados do tutor atual da turma
     SELECT idTutor
          INTO v_idTutor
     FROM SchoolClass
     WHERE idSchoolClass = in_idClass;

     IF (v_idTutor IS NULL)
     THEN
          SIGNAL SQLSTATE '45000'
          SET MESSAGE_TEXT = 'O tutor da turma informada não foi encontrado.';
     END IF;      

     -- Se a turma não possui cadastro de Schedule (cadastro simulado), utiliza o período do dia informado
     IF v_dtTimeStart IS NULL
     THEN
          SET v_dtTimeStart = '00:00:00';
     END IF;

     IF v_dtTimeEnd IS NULL
     THEN
          SET v_dtTimeEnd = '23:59:59';
     END IF;

     INSERT INTO Agenda
          (
          dtAgenda,
          dtTimeStart,
          dtTimeEnd,
          dtInserted,
          inDeleted
          )
          VALUES ( in_dtAgenda,
                   v_dtTimeStart,
                   v_dtTimeEnd,
                   NOW(),
                   0
               );

     SET v_idAgenda = LAST_INSERT_ID();

     INSERT INTO Moment
          (
          idAgenda,
          coMomentStatus,
          idTheme,
          idTutor,
          idSchoolClass,
          SchoolClassStateHash,
          dtStart,
          dtFinish,
          jobId
          )
          VALUES ( v_idAgenda,
                   'PEND',
                   in_idTheme,
                   v_idTutor,
                   in_idClass,
                   in_SchoolClassStateHash,
                   NULL,
                   NULL,
                   in_jobId
               );

     SET out_idMoment = LAST_INSERT_ID();


END 