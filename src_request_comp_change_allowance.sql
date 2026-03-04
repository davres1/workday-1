DROP TABLE IF EXISTS `src_request_comp_change_allowance`;
CREATE TABLE `src_request_comp_change_allowance`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Allowance_Plan_Data_Replace` TEXT,
  `Allowance_Plan_ID` TEXT,
  `Allowance_Plan_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Allowance_Currency_ID` TEXT,
  `Allowance_Currency_Reference_ID_Type` TEXT,
  `Allowance_Frequency_ID` TEXT,
  `Allowance_Frequency_Reference_ID_Type` TEXT,
  `Expected_End_Date` TEXT,
  `Reimbursement_Start_Date` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Allowance_Percent` TEXT,
  `Allowance_Amount` TEXT
)


INSERT INTO `your_project.your_dataset.src_request_comp_change_allowance`
(
    Employee_ID,
    Employee_Reference_ID_Type,
    Position_ID,
    Position_Reference_ID_Type,
    Employee_Visibility_Date,
    Compensation_Change_Date,
    Compensation_Change_On_Next_Pay_Period,
    Reason_Reference_ID,
    Reason_Reference_ID_Type,
    Allowance_Plan_Data_Replace,
    Allowance_Plan_ID,
    Allowance_Plan_Reference_ID_Type,
    Manage_by_Compensation_Basis_Override_Amount,
    Allowance_Currency_ID,
    Allowance_Currency_Reference_ID_Type,
    Allowance_Frequency_ID,
    Allowance_Frequency_Reference_ID_Type,
    Expected_End_Date,
    Reimbursement_Start_Date,
    Actual_End_Date,
    Fixed_for_Manage_by_Basis_Total,
    Allowance_Percent,
    Allowance_Amount
)
WITH chi_data AS (
    SELECT
        SAFE_CAST(allow.EMPLOYEE AS STRING)                     AS legacy_employee_id,
        COALESCE(
            allow.EFFECTIVE_DATE,
            allow.BEGIN_DATE,
            CURRENT_DATE()
        )                                                       AS effective_dt,
        allow.END_DATE                                          AS expected_end_dt,
        UPPER(TRIM(COALESCE(allow.PAY_CODE, allow.EARNING_CODE, allow.DED_CODE))) 
                                                                AS lawson_code,
        allow.AMOUNT                                            AS raw_amount,
        UPPER(TRIM(allow.AMOUNT_TYPE))                          AS amount_type,     
        UPPER(TRIM(allow.FREQUENCY))                            AS lawson_freq,
        allow.POSITION                                          AS legacy_position,
        allow.LAST_UPDATE                                       AS last_update_ts,
        emp.EMP_STATUS                                          AS emp_status
    FROM `prj
    INNER JOIN `prj
           ON allow.EMPLOYEE = emp.EMPLOYEE
    WHERE 
        emp.EMP_STATUS NOT IN ('T', 'R', 'C', 'Z', 'X')     
        AND (allow.END_DATE IS NULL OR allow.END_DATE >= CURRENT_DATE())
        AND SAFE_CAST(allow.AMOUNT AS FLOAT64) IS NOT NULL
        AND SAFE_CAST(allow.AMOUNT AS FLOAT64) > 0
)
SELECT
    c.legacy_employee_id                                        AS Employee_ID,
    'Legacy_Employee_ID'                                        AS Employee_Reference_ID_Type,
    NULLIF(c.legacy_position, '')                               AS Position_ID,
    NULL                                                        AS Position_Reference_ID_Type,
    NULL                                                        AS Employee_Visibility_Date,
    FORMAT_DATE('%Y
    '0'                                                         AS Compensation_Change_On_Next_Pay_Period,  
    'Request_Compensation_Change_Conversion_Conversion'         AS Reason_Reference_ID,
    'General_Event_Subcategory_ID'                              AS Reason_Reference_ID_Type,
    '0'                                                         AS Allowance_Plan_Data_Replace,   
    CASE c.lawson_code
        WHEN 'MOBIL'     THEN 'Allowance_Mobile'
        WHEN 'CELL'      THEN 'Cell_Phone_Allowance'
        WHEN 'CAR'       THEN 'Car_Allowance'
        WHEN 'MEAL'      THEN 'Meal_Allowance'
        WHEN 'UNIF'      THEN 'Uniform_Allowance'
        WHEN 'TOOL'      THEN 'Tool_Allowance'
        WHEN 'EDU'       THEN 'Education_Allowance'
        ELSE CONCAT('Unknown_Allowance_', c.lawson_code)
    END                                                         AS Allowance_Plan_ID,
    'Compensation_Plan_ID'                                      AS Allowance_Plan_Reference_ID_Type,
    NULL                                                        AS Manage_by_Compensation_Basis_Override_Amount,
    'USD'                                                       AS Allowance_Currency_ID,
    'Currency_ID'                                               AS Allowance_Currency_Reference_ID_Type,
    CASE c.lawson_freq
        WHEN 'M'    THEN 'Monthly'
        WHEN 'BW'   THEN 'Biweekly'
        WHEN 'W'    THEN 'Weekly'
        WHEN 'A'    THEN 'Annually'
        WHEN 'SM'   THEN 'Semimonthly'
        ELSE 'Monthly'   
    END                                                         AS Allowance_Frequency_ID,
    'Frequency_ID'                                              AS Allowance_Frequency_Reference_ID_Type,
    FORMAT_DATE('%Y
    NULL                                                        AS Reimbursement_Start_Date,
    NULL                                                        AS Actual_End_Date,
    NULL                                                        AS Fixed_for_Manage_by_Basis_Total,
    CASE 
        WHEN c.amount_type IN ('P', 'PERCENT') 
             AND SAFE_CAST(c.raw_amount AS FLOAT64) BETWEEN 0 AND 1 
        THEN FORMAT('%.4f', SAFE_CAST(c.raw_amount AS FLOAT64))
        ELSE NULL
    END                                                         AS Allowance_Percent,
    CASE 
        WHEN c.amount_type IN ('A', 'AMOUNT', 'FIXED') 
             AND SAFE_CAST(c.raw_amount AS FLOAT64) > 0 
        THEN FORMAT('%.2f', SAFE_CAST(c.raw_amount AS FLOAT64))
        ELSE NULL
    END                                                         AS Allowance_Amount
FROM chi_data c
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY 
        c.legacy_employee_id,
        c.lawson_code,
        c.effective_dt
    ORDER BY 
        c.last_update_ts DESC NULLS LAST,
        c.effective_dt DESC
) = 1
ORDER BY 
    Employee_ID,
    Compensation_Change_Date
;