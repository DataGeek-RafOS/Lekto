/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2014 (RafaelOLSR)       */
/* Created on:     3/21/2022 10:04:42 AM                        */
/*==============================================================*/


/*==============================================================*/
/* Table: SchoolClassTimeTable                                  */
/*==============================================================*/
if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.SchoolClassTimeTable') and o.name = 'FK_SchoolClassTimeTable_SchoolClass')
alter table dbo.SchoolClassTimeTable
   drop constraint FK_SchoolClassTimeTable_SchoolClass
GO

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('dbo.SchoolClassTimeTable') and o.name = 'FK_SchoolClassTimeTable_Timetable')
alter table dbo.SchoolClassTimeTable
   drop constraint FK_SchoolClassTimeTable_Timetable
GO

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SchoolClassTimeTable')
            and   type = 'U')
   drop table dbo.SchoolClassTimeTable
GO

/*==============================================================*/
/* Table: SchoolClassTimeTable                                  */
/*==============================================================*/
create table dbo.SchoolClassTimeTable (
   idSchoolClassTimeTable int                  identity(1,1),
   idSchoolClass        int                  not null,
   idTimetable          int                  not null,
   constraint PK_SchoolClassTimeTable primary key (idSchoolClassTimeTable)
)
GO

alter table dbo.SchoolClassTimeTable
   add constraint FK_SchoolClassTimeTable_SchoolClass foreign key (idSchoolClass)
      references SchoolClass (idSchoolClass)
GO

alter table dbo.SchoolClassTimeTable
   add constraint FK_SchoolClassTimeTable_Timetable foreign key (idTimetable)
      references Timetable (idTimetable)
GO

GRANT SELECT, UPDATE, INSERT, DELETE ON SchoolClassTimeTable TO usrLekto
GO


DECLARE @idSchoolClass INT
      , @idWeekDay     INT   
      , @dtTimeStart   TIME
      , @dtTimeEnd     TIME
      , @dtInserted    DATETIME
      , @idTimetable   INT

DECLARE _curWeekDay CURSOR LOCAL FAST_FORWARD FORWARD_ONLY FOR 
     SELECT unPvt.idSchoolClass
          , unPvt.idWeekDay
          , unPvt.dtTimeStart
          , unPvt.dtTimeEnd
          , unPvt.dtInserted
     FROM (
          SELECT idSchoolClass
               , IIF(SUBSTRING(txWeekday, 1, 1) = 1, 1, 0) AS [1]
               , IIF(SUBSTRING(txWeekday, 2, 1) = 1, 2, 0) AS [2]
               , IIF(SUBSTRING(txWeekday, 3, 1) = 1, 3, 0) AS [3]
               , IIF(SUBSTRING(txWeekday, 4, 1) = 1, 4, 0) AS [4]
               , IIF(SUBSTRING(txWeekday, 5, 1) = 1, 5, 0) AS [5]
               , IIF(SUBSTRING(txWeekday, 6, 1) = 1, 6, 0) AS [6]
               , IIF(SUBSTRING(txWeekday, 7, 1) = 1, 7, 0) AS [7]
               , dtTimeStart
               , dtTimeEnd
               , dtInserted
          FROM dbo.Schedule
               INNER JOIN
               dbo.SchoolClassSchedule
                    ON SchoolClassSchedule.idSchedule = Schedule.idSchedule
          ) Pvt
     UNPIVOT (
               idWeekDay FOR Schedule IN ([1], [2], [3], [4], [5], [6], [7])
             ) AS unPvt
     WHERE unPvt.idWeekDay <> 0

OPEN _curWeekDay;

FETCH NEXT FROM _curWeekDay
     INTO @idSchoolClass
        , @idWeekDay 
        , @dtTimeStart 
        , @dtTimeEnd 
        , @dtInserted 

BEGIN TRANSACTION

WHILE @@FETCH_STATUS = 0 
BEGIN 

     SET @idTimetable = 0

     SELECT @idTimetable = idTimetable
     FROM dbo.Timetable
     WHERE idWeekday = @idWeekDay
     AND   dtStart = @dtTimeStart
     AND   dtEnd   = @dtTimeEnd

     IF @idTimetable = 0 /* cadastro do registro na Timetable */
     BEGIN 

          INSERT INTO dbo.Timetable
               ( idWeekday
               , dtStart
               , dtEnd
               , dtInserted )
          VALUES
          ( @idWeekDay   
          , @dtTimeStart 
          , @dtTimeEnd 
          , @dtInserted
          );

          SET @idTimetable = IDENT_CURRENT('dbo.Timetable')

     END;

     IF ISNULL(@idTimetable, 0) = 0
     BEGIN
          RAISERROR('Falha na recuperação do @idTimeTable', 16, 1);
     END

     IF NOT EXISTS ( SELECT 1
                     FROM dbo.SchoolClassTimeTable
                     WHERE idSchoolClass = @idSchoolClass
                     AND   idTimetable = @idTimetable
                   )
     BEGIN

          INSERT INTO dbo.SchoolClassTimeTable
               ( idSchoolClass, idTimetable )
          VALUES
          ( @idSchoolClass, @idTimetable );

     END;               

     FETCH NEXT FROM _curWeekDay
          INTO @idSchoolClass
             , @idWeekDay 
             , @dtTimeStart 
             , @dtTimeEnd 
             , @dtInserted      

END

CLOSE _curWeekDay
DEALLOCATE _curWeekDay

-- ROLLBACK
-- COMMIT


/*
     SELECT unPvt.idSchoolClass
          , unPvt.idWeekDay
          , unPvt.dtTimeStart
          , unPvt.dtTimeEnd
          , unPvt.dtInserted
     FROM (
          SELECT idSchoolClass
               , IIF(SUBSTRING(txWeekday, 1, 1) = 1, 1, 0) AS [1]
               , IIF(SUBSTRING(txWeekday, 2, 1) = 1, 2, 0) AS [2]
               , IIF(SUBSTRING(txWeekday, 3, 1) = 1, 3, 0) AS [3]
               , IIF(SUBSTRING(txWeekday, 4, 1) = 1, 4, 0) AS [4]
               , IIF(SUBSTRING(txWeekday, 5, 1) = 1, 5, 0) AS [5]
               , IIF(SUBSTRING(txWeekday, 6, 1) = 1, 6, 0) AS [6]
               , IIF(SUBSTRING(txWeekday, 7, 1) = 1, 7, 0) AS [7]
               , dtTimeStart
               , dtTimeEnd
               , dtInserted
          FROM dbo.Schedule
               INNER JOIN
               dbo.SchoolClassSchedule
                    ON SchoolClassSchedule.idSchedule = Schedule.idSchedule
          ) Pvt
     UNPIVOT (
               idWeekDay FOR Schedule IN ([1], [2], [3], [4], [5], [6], [7])
             ) AS unPvt
     WHERE unPvt.idWeekDay <> 0
          AND  idSchoolClass IN (4, 5)

     SELECT * 
          FROM dbo.Schedule
               INNER JOIN
               dbo.SchoolClassSchedule
                    ON SchoolClassSchedule.idSchedule = Schedule.idSchedule
     WHERE  idSchoolClass IN (4, 5)

     SELECT * FROM dbo.SchoolClassTimeTable WHERE idSchoolClass IN (4)

*/