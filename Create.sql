USE [cloud_timesheet]
GO

/****** Object:  StoredProcedure [dbo].[timesheet_attendance_auto_Create]    Script Date: 21/09/2021 10:08:12 SA ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[timesheet_attendance_auto_Create]
	@Id bigint,
	@uId bigint,
	@job_id bigint,
	@employee_id bigint,
	@description nvarchar(max),
	@start_date date,
	@end_date date
AS 
SET NOCOUNT ON;    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @btResult BIT = 0
DECLARE @return_value INT = -1
BEGIN TRY
	BEGIN
		--IF (EXISTS(SELECT * FROM timesheet_attendance_auto 
		--				WHERE deleted <> 'true' AND employee_id = @employee_id
		--						AND ((@start_date >= start_date AND @start_date <= end_date)
		--						OR (@end_date >= start_date AND @end_date <= end_date)
		--						OR (start_date >= @start_date AND start_date <= @end_date))))
		--	SET @return_value = -2;
		--else
		--begin
			IF (@Id <0)
			BEGIN
				INSERT INTO timesheet_attendance_auto
					(
						employee_id, 
						job_id,
						start_date, 
						end_date,
						description,
						active,
						create_uid,
						create_date,
						deleted
					)
					VALUES 
					(
						@employee_id,
						@job_id,
						@start_date,
						@end_date,
						@description,
						'true',
						@uId,
						GETDATE(),
						'false'
					)

					SET @Id = SCOPE_IDENTITY()
					SET @return_value = 1;
			END
			ELSE
			BEGIN
				UPDATE timesheet_attendance_auto
				SET description = @description, start_date = @start_date, end_date = @end_date, write_uid = @uId , write_date = GETDATE()
				WHERE id = @Id 
				SET @return_value = 1;
			END
		--end

		-- Output
		SELECT @Id AS Id, @return_value AS Result
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
END CATCH;
RETURN @btResult
GO
