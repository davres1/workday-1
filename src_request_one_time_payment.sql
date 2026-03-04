DROP TABLE IF EXISTS `src_request_one_time_payment`;
CREATE TABLE `src_request_one_time_payment`(
  `Employee_Reference_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_Reference_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Effective_Date` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `One_Time_Payment_Plan_Reference_ID` TEXT,
  `One_Time_Payment_Plan_Reference_ID_Type` TEXT,
  `Scheduled_Payment_Date` TEXT,
  `Clawback_Date` TEXT,
  `Coverage_Start_Date` TEXT,
  `Coverage_End_Date` TEXT,
  `Currency_Reference_ID` TEXT,
  `Currency_Reference_ID_Type` TEXT,
  `OTP_Comment` TEXT,
  `Do_Not_Pay` TEXT,
  `Costing_Company_Reference_ID` TEXT,
  `Costing_Company_Reference_ID_Type` TEXT,
  `One_Time_Payment_Worktags_Reference_ID` TEXT,
  `One_Time_Payment_Worktags_Reference_ID_Type` TEXT,
  `One_Time_Payment_Worktags_Reference_ID_Parent_ID` TEXT,
  `One_Time_Payment_Worktags_Reference_ID_Parent_Type` TEXT,
  `Amount` TEXT,
  `Percent` TEXT
)


WITH chi_data AS (
  SELECT
    esp.EmployeeID                                 AS legacy_employee_id,
    me.WorkdayWorkerID                             AS Employee_Reference_ID,
    me.WorkdayWorkerID_Type                        AS Employee_Reference_ID_Type,  
    DATE(esp.PaymentDate)                          AS Effective_Date,              
    CASE 
      WHEN UPPER(esp.PayCode) IN ('SIGNING_BONUS', 'SIGNON', 'SIBON') 
        THEN 'Signing_Bonus'
      WHEN UPPER(esp.PayCode) IN ('SPECIAL_INC', 'SPIF', 'INCENTIVE') 
        THEN 'Special_Incentive'
      WHEN UPPER(esp.PayCode) LIKE '%RETENTION%' 
        THEN 'Retention_Bonus'
      ELSE 'One_Time_Payment_Default'               
    END                                            AS One_Time_Payment_Plan_Reference_ID,
    CAST(esp.Amount AS STRING)                     AS Amount,
    ''                                           AS Percent,                     
    'USD'                                          AS Currency_Reference_ID,
    'Currency_ID'                                  AS Currency_Reference_ID_Type,  
    ''                                           AS Position_Reference_ID,
    ''                                           AS Position_Reference_ID_Type,
    DATE(esp.PaymentDate)                          AS Scheduled_Payment_Date,      
    ''                                           AS Clawback_Date,
    ''                                           AS Coverage_Start_Date,
    ''                                           AS Coverage_End_Date,
    'Special Incentive Payout - ' || 
      FORMAT_DATE('%Y%m%d', esp.PaymentDate)       AS OTP_Comment,
    'N'                                            AS Do_Not_Pay,
    ''                                           AS Costing_Company_Reference_ID,
    ''                                           AS Costing_Company_Reference_ID_Type,
    ''                                           AS One_Time_Payment_Worktags_Reference_ID,
    ''                                           AS One_Time_Payment_Worktags_Reference_ID_Type
  FROM `your-project.your_dataset.EmployeeSpecialIncentivePayout` esp
  LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` me
    ON CAST(esp.EmployeeID AS STRING) = me.LegacyID
   AND me.SystemIdentifier IN ('CHI')   
  LEFT JOIN `your-project.your_dataset.Position_Extract` pos   
    ON me.WorkdayWorkerID = pos.Worker_Reference_ID
   AND pos.JobLevel IN ('875', '900', '925', '950')
  WHERE esp.PaymentDate IS NOT ''
    AND esp.Amount > 0
    AND pos.JobLevel IS ''                               
    AND me.WorkdayWorkerID IS NOT ''                     
)
SELECT
  Employee_Reference_ID,
  Employee_Reference_ID_Type,
  Effective_Date,
  One_Time_Payment_Plan_Reference_ID,
  Currency_Reference_ID,
  Currency_Reference_ID_Type,
  Amount,
  Percent,
  Scheduled_Payment_Date,
  OTP_Comment,
  Do_Not_Pay,
  Position_Reference_ID,
  Position_Reference_ID_Type,
  Clawback_Date,
  Coverage_Start_Date,
  Coverage_End_Date,
  Costing_Company_Reference_ID,
  Costing_Company_Reference_ID_Type
FROM chi_data
WHERE One_Time_Payment_Plan_Reference_ID != 'One_Time_Payment_Default'
ORDER BY Effective_Date DESC, Employee_Reference_ID
;