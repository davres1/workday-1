CREATE OR REPLACE PROCEDURE `prj-qa-ss-oneerp.oneerp.prc_Request_Compensation_Change_Allowance_sp`()
OPTIONS(strict_mode=false)
BEGIN
  -- 1. Clear existing data
  TRUNCATE TABLE `oneerp.process_request_comp_change_Allowance`;
  TRUNCATE TABLE `workday.workday_request_comp_change_Allowance`;

  -- 2. Insert into first table
  -- We explicitly cast the date to STRING to match your table schema
  INSERT INTO `oneerp.process_request_comp_change_Allowance` (
    Legacy_System, 
    Legacy_ID, 
    Employee_ID, 
    Position_ID, 
    Compensation_Change_Date, 
    Reason_Reference_ID, 
    Allowance_Plan_ID
  )
  SELECT 
    legacy.LegacySystem,
    legacy.LegacyEmployee,  
    main.EmployeeID,
    main.PositionID,
    CAST(SAFE.PARSE_DATE('%m/%e/%Y', main.PositionFillEffectiveDateorConversionPositionStartDate) AS STRING),
    'Request_Compensation_Change_Conversion_Conversion',
    CAST(main.Column1 AS STRING)
  FROM `prj-qa-ss-oneerp.oneerp.Comp_Allowance_DCDD` AS main
  LEFT JOIN `prj-qa-ss-oneerp.oneerp.process_addonly_employee` AS legacy
    ON main.EmployeeID = legacy.Employee_ID;

  -- 3. Insert into second table
  INSERT INTO `workday.workday_request_comp_change_Allowance`
  SELECT * FROM `oneerp.process_request_comp_change_Allowance`;

END;

BEGIN
  CALL `prj-qa-ss-oneerp.oneerp.prc_Request_Compensation_Change_Allowance_sp`();
END;
