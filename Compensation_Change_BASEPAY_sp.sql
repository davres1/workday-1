DROP TABLE IF EXISTS `oneerp.process_request_comp_change_Allowance`;
CREATE TABLE `oneerp.process_request_comp_change_Allowance`(
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
  `Expected_End_Date` STRING,
  `legacy_id` STRING,
  `LegacySystem`  STRING
) ;

DROP TABLE IF EXISTS `workday.workday_request_comp_change_Allowance`;
CREATE TABLE `workday.workday_request_comp_change_Allowance`(
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
  `Expected_End_Date` STRING,
  `legacy_id` STRING,
  `LegacySystem`  STRING
) ;

INSERT into `oneerp.process_request_comp_change_Allowance`
--MTN
SELECT CAST(legacy.Employee_ID AS STRING) AS Employee_ID,
cpos.Position_ID as Position_ID,
FORMAT_DATE('%Y-%m-%d',CAST(comp.`EFFECT_DATE` AS DATE)) as Compensation_Change_Date,
'' as Compensation_Change_On_Next_Pay_Period,
'' as Reason_Reference_ID,
comp.pay_code as Allowance_Plan_ID,
'' as Allowance_Percent,
COALESCE(SAFE_CAST(comp.RATE AS STRING), '') as Allowance_Amount,
'' as Allowance_Currency_ID,
'' as Allowance_Frequency_ID,
FORMAT_DATE('%Y-%m-%d',CAST(comp.end_date AS DATE)) as Expected_End_Date,
legacy.LegacyEmployee                                           AS legacy_id,
    legacy.LegacySystem                                             AS LegacySystem
from `prj-pvt-oneerp-data-raw-78c9.lawson_mtn.standtime` comp
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` legacy
        ON CAST(comp.Employee AS STRING) = legacy.LegacyEmployee
        AND legacy.LegacySystem = 'MTN'
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_create_position` cpos
        ON CAST(comp.Employee AS STRING) = cpos.LegacyEmployee
union all
SELECT
  CAST(legacy.Employee_ID AS STRING) AS Employee_ID,
  cpos.Position_ID AS Position_ID,
  FORMAT_DATE('%Y-%m-%d', CAST(comp.DateRange_Begin AS DATE)) AS Compensation_Change_Date,
  FORMAT_DATE('%Y-%m-%d', CAST(comp.DateRange_Begin AS DATE)) AS Compensation_Change_On_Next_Pay_Period,
  'Request_Compensation_Change_Conversion_Conversion' AS Reason_Reference_ID,
  map.WD_Allowance_Plan_ID AS Allowance_Plan_ID,
  '' AS Allowance_Percent,
  COALESCE(SAFE_CAST(comp.AllowanceAmount AS STRING), '') AS Allowance_Amount,
  'USD' AS Allowance_Currency_ID,
  'Biweekly' AS Allowance_Frequency_ID,
  FORMAT_DATE('%Y-%m-%d', CAST(comp.DateRange_end AS DATE)) AS Expected_End_Date,
  legacy.LegacyEmployee AS legacy_id,
  legacy.LegacySystem AS LegacySystem
FROM
  `prj-pvt-oneerp-data-raw-78c9.oneerp_data.dlghr_employeeallowance` AS comp
LEFT JOIN
  `prj-dev-ss-oneerp.oneerp.process_addonly_employee` AS legacy
    ON CAST(comp.Employee AS STRING) = legacy.LegacyEmployee
LEFT JOIN
  `prj-dev-ss-oneerp.oneerp.process_create_position` AS cpos
    ON CAST(comp.Employee AS STRING) = cpos.LegacyEmployee
LEFT JOIN `prj-qa-ss-oneerp.oneerp.map_allowanceplan` map
       ON map.LegacyID = comp.CreatePayCode and map.SystemIdentifier='INF'
where comp.DateRange_Begin >= current_date()
;

INSERT into `workday.workday_request_comp_change_Allowance` 
select * from `oneerp.process_request_comp_change_Allowance`;
