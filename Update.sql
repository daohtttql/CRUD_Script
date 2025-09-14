USE [cloud_timesheet]
GO

/****** Object:  StoredProcedure [dbo].[timesheet_attendance_autoById_Delete]    Script Date: 21/09/2021 10:19:50 SA ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[timesheet_attendance_autoById_Delete]
	@Id BIGINT = -1,
	@uId BIGINT =-1
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @btResult BIT = 0
DECLARE @return_value INT = -1
BEGIN TRY
	BEGIN 
		UPDATE timesheet_attendance_auto
		SET deleted = 'true', delete_uid = @uId, delete_date = GETDATE()
		WHERE id = @Id 

		SET @return_value = 1

		SELECT @return_value AS Result
	END 
END TRY
BEGIN CATCH
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
END CATCH
RETURN @btResult
GO
