
DROP PROCEDURE IF EXISTS `spuGetLessonDocumentation`;

CREATE DEFINER=`root`@`%` PROCEDURE `spuGetLessonDocumentation`( IN in_idLessonMoment INT )
GetLessonDocumentation: BEGIN

	# Declaracao de variaveis
     DECLARE va_SQLState           VARCHAR(1000);
     DECLARE va_SQLMessage         VARCHAR(1000);

	DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING 
	BEGIN
		ROLLBACK;
		GET DIAGNOSTICS CONDITION 1
		va_SQLState = RETURNED_SQLSTATE, va_SQLMessage = MESSAGE_TEXT;
          SELECT CONCAT('Um erro ocorreu durante a operação [State: ', COALESCE(va_SQLState, 'N/A') , '] com a mensagem [', COALESCE(va_SQLMessage, 'N/A'), ']') As sql_error; 
		RESIGNAL;
	END;

	SELECT JSON_ARRAYAGG(
					  JSON_OBJECT( 'idLessonDocumentation', LeDo.idLessonDocumentation
							   , 'txMomentNotes', LeDo.txMomentNotes 
							  #xxxxxx , 'idMediaInformation', LeDo.IdMediaInformation
							#   , 'evidences', ( 
							#			   SELECT JSON_ARRAYAGG( idEvidence )  
							#			   FROM LessonEvidenceDocumentation EviD
							#			   WHERE EviD.idLessonDocumentation = LeDo.idLessonDocumentation
							#			   )
							   , 'steps', ( 
										   SELECT JSON_OBJECT(
														   'id', Step.idLessonStep
														 , 'step', Step.txTitle
														 , 'order', Step.nuOrder
														 , 'evidences', ( 
																      SELECT JSON_ARRAYAGG(
																					 JSON_OBJECT(
																					              'id', Evid.idEvidence
																						       , 'name', Evid.txName
																							  , 'ability', ( SELECT JSON_OBJECT( 'id', Abil.idAbility
																														, 'name', Abil.txName
  																													    )
																									       FROM Ability Abil
																										  WHERE Abil.idAbility = Evid.idAbility
																									     )
																							  ) )
																	 FROM LessonStepEvidence StEv
																	      INNER JOIN EvidenceGrade EvGr
																	 		    ON EvGr.idEvidence = StEv.idEvidence
																	 		   AND EvGr.coGrade    = StEv.coGrade
																	      INNER JOIN Evidence Evid
																	 		   ON Evid.idEvidence = EvGr.idEvidence
																	 WHERE StEv.idLessonStep = Step.idLessonStep
																	 AND   StEv.coGrade	     = Step.coGrade
																	 )
														 )  
										   FROM LessonStepDocumentation DoSt
											   INNER JOIN LessonStep Step
												      ON Step.idLessonStep = DoSt.idLessonStep
												     AND Step.coGrade      = DoSt.coGrade
										   WHERE DoSt.idDocumentation = LeDo.idLessonDocumentation
										   )							   
							   , 'students', ( SELECT JSON_ARRAYAGG(
															JSON_OBJECT( 'id', lUsr.idUser 
																	 , 'name', lUsr.txName
																	 , 'image', lUsr.txImagePath
																	) )  
										   FROM LessonStudentDocumentation Stud
											   INNER JOIN LektoUser lUsr
											           ON lUsr.idNetwork = Stud.idNetwork
												     AND lUsr.idUser   = Stud.idUserStudent
										   WHERE Stud.idLessonDocumentation = LeDo.idLessonDocumentation
										   )
							   , 'activities', (
										   SELECT JSON_ARRAYAGG( MoAc.idLessonActivity )  
										   FROM LessonActivityDocumentation Acti
											   INNER JOIN LessonMomentActivity MoAc
												      ON MoAc.idLessonMomentActivity = Acti.idLessonMomentActivity
										   WHERE Acti.idLessonDocumentation = LeDo.idLessonDocumentation							   
										    )
							   )
					)
	FROM LessonDocumentation LeDo 
	WHERE idLessonMoment = in_idLessonMoment;
	
     COMMIT;

END	
	
	/*
	select json_object(
  'id',p.id 
 ,'desc',p.`desc`
 ,'child_objects',(select CAST(CONCAT('[',
                GROUP_CONCAT(
                  JSON_OBJECT(
                    'id',id,'parent_id',parent_id,'desc',`desc`)),
                ']')
         AS JSON) from child_table where parent_id = p.id)

 ) from parent_table p;
 */