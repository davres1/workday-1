DROP TABLE IF EXISTS `oneerp.process_request_one_time_payment`;
CREATE TABLE `oneerp.process_request_one_time_payment`(
  `Employee_Reference_ID` STRING,
  `Position_Reference_ID` STRING,
  `Employee_Visibility_Date` STRING,
  `Effective_Date` STRING,
  `Reason_Reference_ID` STRING,
  `One_Time_Payment_Plan_Reference_ID` STRING,
  `Scheduled_Payment_Date` STRING,
  `Clawback_Date` STRING,
  `Coverage_Start_Date` STRING,
  `Coverage_End_Date` STRING,
    `Amount` STRING,
  `Percent` STRING,
  `Currency_Reference_ID` STRING,
  `OTP_Comment` STRING,
  `Do_Not_Pay` STRING,
  legacy_id STRING,
   LegacySystem  STRING

);

DROP TABLE IF EXISTS `workday.workday_request_one_time_payment`;

CREATE TABLE `workday.workday_request_one_time_payment`(
  `Employee_Reference_ID` STRING,
  `Position_Reference_ID` STRING,
  `Employee_Visibility_Date` STRING,
  `Effective_Date` STRING,  
  `Reason_Reference_ID` STRING,
  `One_Time_Payment_Plan_Reference_ID` STRING,
  `Scheduled_Payment_Date` STRING,
  `Clawback_Date` STRING,
  `Coverage_Start_Date` STRING,
  `Coverage_End_Date` STRING,
    `Amount` STRING,
  `Percent` STRING,
  `Currency_Reference_ID` STRING,
  `OTP_Comment` STRING,
  `Do_Not_Pay` STRING,
  legacy_id STRING,
   LegacySystem  STRING

);

-- =============================================
-- INSERT into process table (MTN)
-- =============================================
INSERT INTO `oneerp.process_request_one_time_payment`
--MTN
SELECT 
    CAST(legacy.Employee_ID AS STRING)                              AS Employee_Reference_ID,
    cpos.Position_ID                                                AS Position_Reference_ID,
    ''                                                              AS Employee_Visibility_Date,
    FORMAT_DATE('%Y-%m-%d', CAST(comp.EFFECT_DATE AS DATE))         AS Effective_Date,
    ''                                                              AS Reason_Reference_ID,
    comp.pay_code                                                   AS One_Time_Payment_Plan_Reference_ID,   -- using raw pay_code
    FORMAT_DATE('%Y-%m-%d', CAST(comp.EFFECT_DATE AS DATE))         AS Scheduled_Payment_Date,   -- assuming EFFECT_DATE = payment date
    ''                                                              AS Clawback_Date,
    ''                                                              AS Coverage_Start_Date,
    ''                                                              AS Coverage_End_Date,
    COALESCE(SAFE_CAST(comp.rate AS STRING), '')                    AS Amount,          -- Safe cast for BIGNUMERIC
    ''                                                              AS Percent,
    'USD'                                                           AS Currency_Reference_ID,
    ''                                                              AS OTP_Comment,
    ''                                                              AS Do_Not_Pay,
    legacy.LegacyEmployee                                           AS legacy_id,
    legacy.LegacySystem                                             AS LegacySystem
FROM `prj-pvt-oneerp-data-raw-78c9.lawson_mtn.standtime` comp
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` legacy
       ON CAST(comp.Employee AS STRING) = legacy.LegacyEmployee
      AND legacy.LegacySystem = 'MTN'
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_create_position` cpos
       ON CAST(comp.Employee AS STRING) = cpos.LegacyEmployee
WHERE TRIM(comp.pay_code) IN ('730', '724', '901', '729', '722')  and legacy.LegacySystem ='MTN' 
and CAST(comp.EFFECT_DATE AS DATE) >= current_date()
  --AND comp.EFFECT_DATE 'IS NOT NULL'
   --AND comp.end_date IS NULL        
union all
SELECT 
    CAST(legacy.Employee_ID AS STRING)                              AS Employee_Reference_ID,
    cpos.Position_ID                                                AS Position_Reference_ID,
    ''                                                              AS Employee_Visibility_Date,
    FORMAT_DATE('%Y-%m-%d', CAST(comp.PaymentDate AS DATE))         AS Effective_Date,
    ''                                                              AS Reason_Reference_ID,
    `WD_One-Time_Payment_Plan_ID`                                                 AS One_Time_Payment_Plan_Reference_ID,   -- using raw pay_code
    FORMAT_DATE('%Y-%m-%d', CAST(comp.PaymentDate AS DATE))         AS Scheduled_Payment_Date,   -- assuming EFFECT_DATE = payment date
    ''                                                              AS Clawback_Date,
    ''                                                              AS Coverage_Start_Date,
    ''                                                              AS Coverage_End_Date,
    COALESCE(SAFE_CAST(comp.IncentiveAmount AS STRING), '')                    AS Amount,          -- Safe cast for BIGNUMERIC
    ''                                                              AS Percent,
    'USD'                                                           AS Currency_Reference_ID,
    comp.SpecialInstructions                                                             AS OTP_Comment,
    ''                                                              AS Do_Not_Pay,
    legacy.LegacyEmployee                                           AS legacy_id,
    legacy.LegacySystem                                             AS LegacySystem
FROM `prj-pvt-oneerp-data-raw-78c9.oneerp_data.ghr_employeespecialincentivepayout_csh` comp
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` legacy
       ON CAST(comp.Employee AS STRING) = legacy.LegacyEmployee
      AND legacy.LegacySystem = 'INF'
LEFT JOIN `prj-dev-ss-oneerp.oneerp.process_create_position` cpos
       ON CAST(comp.Employee AS STRING) = cpos.LegacyEmployee
LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_requestOTP` map
       ON TRIM(map.LegacyID) = TRIM(comp.PayCode) and map.SystemIdentifier='INF'
WHERE legacy.LegacySystem ='INF' and comp.payoutstatus in (2,4)
and CAST(comp.PaymentDate AS DATE) >= current_date()
  --AND comp.EFFECT_DATE 'IS NOT NULL'
   --AND comp.end_date IS NULL                        
;

INSERT into `workday.workday_request_one_time_payment` 
select * from `oneerp.process_request_one_time_payment`;