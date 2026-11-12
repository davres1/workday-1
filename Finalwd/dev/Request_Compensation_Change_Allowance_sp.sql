CREATE OR REPLACE PROCEDURE `prj-dev-ss-oneerp.oneerp.prc_Request_Compensation_Change_Allowance_sp`()
OPTIONS(strict_mode=false)
BEGIN
DROP TABLE IF EXISTS `oneerp.process_request_comp_change_Allowance`;
CREATE TABLE `oneerp.process_request_comp_change_Allowance`(
`Legacy_System` STRING,
  `Legacy_ID` STRING,
  `Employee_ID` STRING,
  `Position_ID` STRING,
  `Compensation_Change_Date` STRING,
  `Compensation_Change_On_Next_Pay_Period` STRING,
  `Reason_Reference_ID` STRING,
  `Allowance_Plan_ID` STRING,
  `Allowance_Percent` STRING,
  `Allowance_Amount` STRING,
  `Allowance_Currency_ID` STRING,
  `Allowance_Frequency_ID` STRING,
  `Expected_End_Date` STRING
);

DROP TABLE IF EXISTS `workday.workday_request_comp_change_Allowance`;
CREATE TABLE `workday.workday_request_comp_change_Allowance`(
`Legacy_System` STRING,
  `Legacy_ID` STRING,
  `Employee_ID` STRING,
  `Position_ID` STRING,
  `Compensation_Change_Date` STRING,
  `Compensation_Change_On_Next_Pay_Period` STRING,
  `Reason_Reference_ID` STRING,
  `Allowance_Plan_ID` STRING,
  `Allowance_Percent` STRING,
  `Allowance_Amount` STRING,
  `Allowance_Currency_ID` STRING,
  `Allowance_Frequency_ID` STRING,
  `Expected_End_Date` STRING  
);

INSERT INTO `oneerp.process_request_comp_change_Allowance` (
`Legacy_System`,
  `Legacy_ID`,  
  `Employee_ID`, 
  `Position_ID`, 
  `Compensation_Change_Date`, 
  `Compensation_Change_On_Next_Pay_Period`, 
  `Reason_Reference_ID`, 
  `Allowance_Plan_ID`, 
  `Allowance_Percent`, 
  `Allowance_Amount`, 
  `Allowance_Currency_ID`, 
  `Allowance_Frequency_ID`, 
  `Expected_End_Date`
)
SELECT 
legacy.LegacySystem,
  legacy.LegacyEmployee,  
  main.EmployeeID,
  main.PositionID,
  CAST(SAFE.PARSE_DATE('%m/%e/%y', main.PositionFillEffectiveDateorConversionPositionStartDate) AS STRING),
  '',
  'Request_Compensation_Change_Conversion_Conversion',
  CAST(main.Column1 AS STRING),
  '', 
  '', 
  '', 
  '', 
  ''
  --FORMAT_DATE('%Y-%m-%d', SAFE.PARSE_DATE('%m/%e/%Y', main.PositionFillEffectiveDateorConversionPositionStartDate))
FROM `prj-dev-ss-oneerp.oneerp.Comp_Allowance_DCDD` AS main
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` AS legacy
  ON main.EmployeeID = legacy.Employee_ID;

INSERT INTO `workday.workday_request_comp_change_Allowance` (
`Legacy_System`,
  `Legacy_ID`,    
  `Employee_ID`, 
  `Position_ID`, 
  `Compensation_Change_Date`, 
  `Compensation_Change_On_Next_Pay_Period`, 
  `Reason_Reference_ID`, 
  `Allowance_Plan_ID`, 
  `Allowance_Percent`, 
  `Allowance_Amount`, 
  `Allowance_Currency_ID`, 
  `Allowance_Frequency_ID`, 
  `Expected_End_Date`
)
SELECT 
legacy.LegacySystem,
  legacy.LegacyEmployee,
  main.EmployeeID,
  main.PositionID,
  CAST(SAFE.PARSE_DATE('%m/%e/%y', main.PositionFillEffectiveDateorConversionPositionStartDate) AS STRING),
  '',
  'Request_Compensation_Change_Conversion_Conversion',
  CAST(main.Column1 AS STRING),
  '', 
  '', 
  '', 
  '', 
  ''
  --FORMAT_DATE('%Y-%m-%d', SAFE.PARSE_DATE('%m/%e/%Y', main.PositionFillEffectiveDateorConversionPositionStartDate))
FROM `prj-dev-ss-oneerp.oneerp.Comp_Allowance_DCDD` AS main
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` AS legacy
  ON main.EmployeeID = legacy.Employee_ID;
END;
