USE [cloud_timesheet]
GO
/****** Object:  StoredProcedure [dbo].[timesheet_templateFilter_Rows]    Script Date: 02/12/2021 02:17:42 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE proc timesheet_cycle_Filter_Rows
	@page INT = 1,     
	@page_size INT = 100,   
	@strsort_option nvarchar(40) = 'name',    
	@strsort_type nvarchar(40) = 'ASC',
	@search_text nvarchar(500) = N''
	--@company_id BIGINT = 1
as
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @btResult BIT = 0
BEGIN TRY
	BEGIN
		
		SELECT * FROM 
		(
			SELECT ROW_NUMBER() OVER (ORDER BY name ASC) NUM, *
			FROM
			(
				select id,name,STRING_AGG(scope_object, ', ') AS scope_object,STRING_AGG(scope_role, ', ') AS scope_role, active
				from template_scope
				group by id, name, active
			)temp
			WHERE name LIKE  N'%' + @search_text +'%'
		) AA
		WHERE num > ((@page -1) * @page_size) AND NUM <= (@page * @page_size)

	
	SELECT TotalCount = COUNT(*)
	FROM 
	(
		select id,name,STRING_AGG(scope_object, ', ') AS scope_object,STRING_AGG(scope_role, ', ') AS scope_role, active
		from template_scope
		group by id, name, active
	) temp
	WHERE name LIKE N'%' + @search_text + '%'
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
