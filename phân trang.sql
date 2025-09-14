USE [cloud_timesheet]
GO
/****** Object:  StoredProcedure [dbo].[timesheet_dayoffFilter_Rows]    Script Date: 09/10/2021 11:52:23 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROC [dbo].[timesheet_dayoffFilter_Rows_]
	@page int = 1,
	@page_size int = 100,
	@strsort_option nvarchar(40) = 'name',    
	@strsort_type nvarchar(40) = 'ASC',
	@search_text nvarchar(500) = N'',
	@company_id bigint = -1,
	@active bit = 'true'

AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @btResult BIT ;
BEGIN TRY
	BEGIN
		SELECT * FROM 
		(
			SELECT ROW_NUMBER() OVER (ORDER BY name_holiday ASC) NUM_H, *
			FROM
			(
				SELECT do.id id_holiday, do.name name_holiday, do.start_date start_date_holiday, do.end_date end_date_holiday, cf.value as typedate_holiday, cff.value as repeat_holiday
				FROM timesheet_dayoff do 
				LEFT JOIN hr_config cf ON do.type_key = cf.[key]
				LEFT JOIN hr_config cff ON do.repeat_key = cff.[key]
				WHERE do.deleted <> 'true'
				--AND ((df.active = 'true' AND @active = 1) OR (df.active = 'false' AND @active =0))
				AND do.active = @active 
				AND do.company_id = @company_id 
				AND do.type_key ='hr.dateoff.type.holiday'
			)temp
		)AA
		WHERE num_h > ((@page - 1) * @page_size) AND NUM_H <= (@page * @page_size)
		SELECT * FROM 
		(
			SELECT ROW_NUMBER() OVER (ORDER BY name_event ASC) NUM_E, *
			FROM
			(
				SELECT df.id id_event, df.name name_event, df.start_date start_date_event, df.end_date end_date_event, cf.value as typedate_event
				FROM timesheet_dayoff df 
				LEFT JOIN hr_config cf ON df.type_key = cf.[key]
				WHERE df.deleted <> 'true'
				AND ((df.active = 'true' AND @active = 1) OR (df.active = 'false' AND @active =0))
				AND df.company_id = @company_id AND df.type_key = 'hr.dateoff.type.event'
			)temp1
		)AAA
		WHERE num_e > ((@page + -1) * @page_size) AND NUM_E <= (@page * @page_size)
		SELECT * FROM 
		(
			SELECT ROW_NUMBER() OVER (ORDER BY name_reason ASC) NUM_R, *
			FROM
			(
				SELECT df.id id_reason, df.name name_reason, df.start_date start_date_reason, df.end_date end_date_reason, cf.value as typedate_reason
				FROM timesheet_dayoff df 
				LEFT JOIN hr_config cf ON df.type_key = cf.[key]
				WHERE df.deleted <> 'true'
				AND ((df.active = 'true' AND @active = 1) OR (df.active = 'false' AND @active =0))
				AND df.company_id = @company_id AND df.type_key = 'hr.dateoff.type.reason'
			)temp2
		)AAAA
		WHERE num_r > ((@page + -1) * @page_size) AND NUM_R <= (@page * @page_size)
		SELECT TotalCount_holiday = COUNT(*)
		FROM
		(
			SELECT df.id id_holiday, df.name name_holiday, df.start_date start_date_holiday, df.end_date end_date_holiday, cf.value as typedate_holiday, cff.value as repeat_holiday
			FROM timesheet_dayoff df 
			LEFT JOIN hr_config cf ON df.type_key = cf.[key]
			LEFT JOIN hr_config cff ON df.repeat_key = cff.[key]
			WHERE df.deleted <> 'true'
			AND ((df.active = 'true' AND @active = 1) OR (df.active = 'false' AND @active =0))
			AND df.company_id = @company_id AND df.type_key ='hr.dateoff.type.holiday'
		)temp
		SELECT TotalCount_event = COUNT(*)
		FROM
		(
			SELECT df.id id_event, df.name name_event, df.start_date start_date_event, df.end_date end_date_event, cf.value as typedate_event
			FROM timesheet_dayoff df 
			LEFT JOIN hr_config cf ON df.type_key = cf.[key]
			WHERE df.deleted <> 'true'
			AND ((df.active = 'true' AND @active = 1) OR (df.active = 'false' AND @active =0))
			AND df.company_id = @company_id AND df.type_key = 'hr.dateoff.type.event'
		)temp1
		SELECT TotalCount_reason = COUNT(*)
		FROM
		(
			SELECT df.id id_reason, df.name name_reason, df.start_date start_date_reason, df.end_date end_date_reason, cf.value as typedate_reason
			FROM timesheet_dayoff df 
			LEFT JOIN hr_config cf ON df.type_key = cf.[key]
			WHERE df.deleted <> 'true'
			AND ((df.active = 'true' AND @active = 1) OR (df.active = 'false' AND @active =0))
			AND df.company_id = @company_id AND df.type_key = 'hr.dateoff.type.reason'
		)temp2
	SET @btResult = 1
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
    
	 SET @strErrContent = 'p_TProductByIdnufacturerID_Rows Error';    
	 SET @intErrorNumber = ERROR_NUMBER();    
	 SET @intErrorSeverity = ERROR_SEVERITY();    
	 SET @intErrorState = ERROR_STATE();    
	 SET @strErrorProcedure = ERROR_PROCEDURE();    
	 SET @intErrorLine = ERROR_LINE();    
	 SET @strErrorMessage = ERROR_MESSAGE();    
          
	RAISERROR(@strErrorMessage, @intErrorSeverity, @intErrorState, @strErrorProcedure, @intErrorLine);    
    
	SET @btResult = 1;
	END
END CATCH

RETURN @btResult;
