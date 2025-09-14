USE [cloud_timesheet]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[timesheet_attendance_autoById_Row]
	@Id bigint  = 2
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @btResult BIT = 0
BEGIN TRY
	BEGIN 
		--Lấy
		SELECT aa.id, aa.employee_id,hr.name,aa.description, aa.start_date, aa.end_date
		FROM timesheet_attendance_auto aa 
		INNER JOIN dbo.hr_employee hr ON aa.employee_id = hr.id
		WHERE aa.id = @Id
	END 
END TRY
BEGIN CATCH
	BEGIN
	   BEGIN
			DECLARE @strErrContent VARCHAR(50),    
			@intErrorNumber INT,    
			@intErrorSeverity INT,    
			@intErrorState INT,    
			@strErrorProcedure NVARCHAR(126),    
			@intErrorLine INT,    
			@strErrorMessage NVARCHAR(4000);    
		 --SET @strErrContent = 'p_TProductByIdnufacturerID_Rows Error';    
			 SET @intErrorNumber = ERROR_NUMBER();    
			 SET @intErrorSeverity = ERROR_SEVERITY();    
			 SET @intErrorState = ERROR_STATE();    
			 SET @strErrorProcedure = ERROR_PROCEDURE();    
			 SET @intErrorLine = ERROR_LINE();    
			 SET @strErrorMessage = ERROR_MESSAGE();    
			/*EXEC p_TDBErrLog_Create @strErrContent, @intErrorNumber, @intErrorSeverity, @intErrorState,     
			 @strErrorProcedure, @intErrorLine, @strErrorMessage;    */
				RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState, @strErrorProcedure, @intErrorLine);    
    
				SET @btResult = 1;
			END
	END
END CATCH
RETURN @btResult
GO
