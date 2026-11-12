BEGIN

-- First, create the compare table
CREATE OR REPLACE TABLE `prj-dev-ss-oneerp.oneerp.compare_request_compensation_basepay` (
  `Change_Type` STRING,
  `Changed_Columns` STRING,
  `Old_Values` STRING,
  `Employee_ID` STRING,
  `Employee_Reference_ID_Type` STRING,
  `Position_ID` STRING,
  `Position_Reference_ID_Type` STRING,
  `Employee_Visibility_Date` STRING,
  `Reason_Reference_ID` STRING,
  `Reason_Reference_ID_Type` STRING,
  `Compensation_Change_Date` STRING,
  `Compensation_Change_On_Next_Pay_Period` STRING,
  `Override_Compensation_Basis_Calculation` STRING,
  `Compensation_Package_Reference_ID` STRING,
  `Compensation_Package_Reference_ID_Type` STRING,
  `Compensation_Grade_Reference_ID` STRING,
  `Compensation_Grade_Reference_ID_Type` STRING,
  `Compensation_Grade_Profile_Reference_ID` STRING,
  `Compensation_Grade_Profile_Reference_ID_Type` STRING,
  `Compensation_Step_Reference_ID` STRING,
  `Compensation_Step_Reference_ID_Type` STRING,
  `Progression_Start_Date` STRING,
  `Pay_Plan_Data_Replace` STRING,
  `Pay_Plan_Reference_ID` STRING,
  `Pay_Plan_Reference_ID_Type` STRING,
  `Pay_Plan_Currency_Reference_ID` STRING,
  `Pay_Plan_Currency_Reference_ID_Type` STRING,
  `Pay_Plan_Frequency_ID` STRING,
  `Pay_Plan_Frequency_ID_Type` STRING,
  `Pay_Plan_Expected_End_Date` STRING,
  `Pay_Plan_Actual_End_Date` STRING,
  `Pay_Plan_Amount` STRING,
  `Pay_Plan_Percent_Change` STRING,
  `Pay_Plan_Amount_Change` STRING,
  `Primary_Compensation_Basis` STRING,
  `Primary_Compensation_Basis_Amount_Change` STRING,
  `Primary_Compensation_Basis_Percent_Change` STRING,
  `Skip` STRING,
  `LegacySystem` STRING,
  `LegacyEmployee` STRING,
  `LegacyJobProfile` STRING,
  `LegacyPrimary` STRING
);

-- Now insert the change analysis results
INSERT INTO `prj-dev-ss-oneerp.oneerp.compare_request_compensation_basepay`
WITH
  -- Source of truth: older QA records
  qa AS (
    SELECT * FROM `prj-qa-ss-oneerp.oneerp.process_request_compensation_basepay`
  ),
  -- Current state: newer DEV records
  dev AS (
    SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_request_compensation_basepay`
  ),
  -- Identify NEW records (exist in DEV but not in QA)
  new_records AS (
    SELECT
      'NEW'                        AS Change_Type,
      CAST(NULL AS STRING)         AS Changed_Columns,
      CAST(NULL AS STRING)         AS Old_Values,
      dev.Employee_ID,
      dev.Employee_Reference_ID_Type,
      dev.Position_ID,
      dev.Position_Reference_ID_Type,
      dev.Employee_Visibility_Date,
      dev.Reason_Reference_ID,
      dev.Reason_Reference_ID_Type,
      dev.Compensation_Change_Date,
      dev.Compensation_Change_On_Next_Pay_Period,
      dev.Override_Compensation_Basis_Calculation,
      dev.Compensation_Package_Reference_ID,
      dev.Compensation_Package_Reference_ID_Type,
      dev.Compensation_Grade_Reference_ID,
      dev.Compensation_Grade_Reference_ID_Type,
      dev.Compensation_Grade_Profile_Reference_ID,
      dev.Compensation_Grade_Profile_Reference_ID_Type,
      dev.Compensation_Step_Reference_ID,
      dev.Compensation_Step_Reference_ID_Type,
      dev.Progression_Start_Date,
      dev.Pay_Plan_Data_Replace,
      dev.Pay_Plan_Reference_ID,
      dev.Pay_Plan_Reference_ID_Type,
      dev.Pay_Plan_Currency_Reference_ID,
      dev.Pay_Plan_Currency_Reference_ID_Type,
      dev.Pay_Plan_Frequency_ID,
      dev.Pay_Plan_Frequency_ID_Type,
      dev.Pay_Plan_Expected_End_Date,
      dev.Pay_Plan_Actual_End_Date,
      dev.Pay_Plan_Amount,
      dev.Pay_Plan_Percent_Change,
      dev.Pay_Plan_Amount_Change,
      dev.Primary_Compensation_Basis,
      dev.Primary_Compensation_Basis_Amount_Change,
      dev.Primary_Compensation_Basis_Percent_Change,
      dev.Skip,
      dev.LegacySystem,
      dev.LegacyEmployee,
      dev.LegacyJobProfile,
      dev.LegacyPrimary
    FROM dev
    LEFT JOIN qa
      ON  dev.LegacySystem     = qa.LegacySystem
      AND dev.LegacyEmployee   = qa.LegacyEmployee
      AND dev.LegacyJobProfile = qa.LegacyJobProfile
    WHERE qa.LegacySystem IS NULL
  ),
  -- Identify DELETED records (exist in QA but not in DEV)
  deleted_records AS (
    SELECT
      'DEL'                        AS Change_Type,
      CAST(NULL AS STRING)         AS Changed_Columns,
      CAST(NULL AS STRING)         AS Old_Values,
      qa.Employee_ID,
      qa.Employee_Reference_ID_Type,
      qa.Position_ID,
      qa.Position_Reference_ID_Type,
      qa.Employee_Visibility_Date,
      qa.Reason_Reference_ID,
      qa.Reason_Reference_ID_Type,
      qa.Compensation_Change_Date,
      qa.Compensation_Change_On_Next_Pay_Period,
      qa.Override_Compensation_Basis_Calculation,
      qa.Compensation_Package_Reference_ID,
      qa.Compensation_Package_Reference_ID_Type,
      qa.Compensation_Grade_Reference_ID,
      qa.Compensation_Grade_Reference_ID_Type,
      qa.Compensation_Grade_Profile_Reference_ID,
      qa.Compensation_Grade_Profile_Reference_ID_Type,
      qa.Compensation_Step_Reference_ID,
      qa.Compensation_Step_Reference_ID_Type,
      qa.Progression_Start_Date,
      qa.Pay_Plan_Data_Replace,
      qa.Pay_Plan_Reference_ID,
      qa.Pay_Plan_Reference_ID_Type,
      qa.Pay_Plan_Currency_Reference_ID,
      qa.Pay_Plan_Currency_Reference_ID_Type,
      qa.Pay_Plan_Frequency_ID,
      qa.Pay_Plan_Frequency_ID_Type,
      qa.Pay_Plan_Expected_End_Date,
      qa.Pay_Plan_Actual_End_Date,
      qa.Pay_Plan_Amount,
      qa.Pay_Plan_Percent_Change,
      qa.Pay_Plan_Amount_Change,
      qa.Primary_Compensation_Basis,
      qa.Primary_Compensation_Basis_Amount_Change,
      qa.Primary_Compensation_Basis_Percent_Change,
      qa.Skip,
      qa.LegacySystem,
      qa.LegacyEmployee,
      qa.LegacyJobProfile,
      qa.LegacyPrimary
    FROM qa
    LEFT JOIN dev
      ON  qa.LegacySystem     = dev.LegacySystem
      AND qa.LegacyEmployee   = dev.LegacyEmployee
      AND qa.LegacyJobProfile = dev.LegacyJobProfile
    WHERE dev.LegacySystem IS NULL
  ),
  -- Identify CHANGED records (exist in both but have differences in non-key columns)
  matched_records AS (
    SELECT
      dev.Employee_ID,
      dev.Employee_Reference_ID_Type,
      dev.Position_ID,
      dev.Position_Reference_ID_Type,
      dev.Employee_Visibility_Date,
      dev.Reason_Reference_ID,
      dev.Reason_Reference_ID_Type,
      dev.Compensation_Change_Date,
      dev.Compensation_Change_On_Next_Pay_Period,
      dev.Override_Compensation_Basis_Calculation,
      dev.Compensation_Package_Reference_ID,
      dev.Compensation_Package_Reference_ID_Type,
      dev.Compensation_Grade_Reference_ID,
      dev.Compensation_Grade_Reference_ID_Type,
      dev.Compensation_Grade_Profile_Reference_ID,
      dev.Compensation_Grade_Profile_Reference_ID_Type,
      dev.Compensation_Step_Reference_ID,
      dev.Compensation_Step_Reference_ID_Type,
      dev.Progression_Start_Date,
      dev.Pay_Plan_Data_Replace,
      dev.Pay_Plan_Reference_ID,
      dev.Pay_Plan_Reference_ID_Type,
      dev.Pay_Plan_Currency_Reference_ID,
      dev.Pay_Plan_Currency_Reference_ID_Type,
      dev.Pay_Plan_Frequency_ID,
      dev.Pay_Plan_Frequency_ID_Type,
      dev.Pay_Plan_Expected_End_Date,
      dev.Pay_Plan_Actual_End_Date,
      dev.Pay_Plan_Amount,
      dev.Pay_Plan_Percent_Change,
      dev.Pay_Plan_Amount_Change,
      dev.Primary_Compensation_Basis,
      dev.Primary_Compensation_Basis_Amount_Change,
      dev.Primary_Compensation_Basis_Percent_Change,
      dev.Skip,
      dev.LegacySystem,
      dev.LegacyEmployee,
      dev.LegacyJobProfile,
      dev.LegacyPrimary,
      -- Build Changed_Columns list using UNNEST to filter NULLs
      (
        SELECT STRING_AGG(col, ', ')
        FROM UNNEST([
          IF(IFNULL(dev.Employee_ID,'') != IFNULL(qa.Employee_ID,''), 'Employee_ID', NULL),
          IF(IFNULL(dev.Employee_Reference_ID_Type,'') != IFNULL(qa.Employee_Reference_ID_Type,''), 'Employee_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Position_ID,'') != IFNULL(qa.Position_ID,''), 'Position_ID', NULL),
          IF(IFNULL(dev.Position_Reference_ID_Type,'') != IFNULL(qa.Position_Reference_ID_Type,''), 'Position_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Employee_Visibility_Date,'') != IFNULL(qa.Employee_Visibility_Date,''), 'Employee_Visibility_Date', NULL),
          IF(IFNULL(dev.Reason_Reference_ID,'') != IFNULL(qa.Reason_Reference_ID,''), 'Reason_Reference_ID', NULL),
          IF(IFNULL(dev.Reason_Reference_ID_Type,'') != IFNULL(qa.Reason_Reference_ID_Type,''), 'Reason_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Compensation_Change_Date,'') != IFNULL(qa.Compensation_Change_Date,''), 'Compensation_Change_Date', NULL),
          IF(IFNULL(dev.Compensation_Change_On_Next_Pay_Period,'') != IFNULL(qa.Compensation_Change_On_Next_Pay_Period,''), 'Compensation_Change_On_Next_Pay_Period', NULL),
          IF(IFNULL(dev.Override_Compensation_Basis_Calculation,'') != IFNULL(qa.Override_Compensation_Basis_Calculation,''), 'Override_Compensation_Basis_Calculation', NULL),
          IF(IFNULL(dev.Compensation_Package_Reference_ID,'') != IFNULL(qa.Compensation_Package_Reference_ID,''), 'Compensation_Package_Reference_ID', NULL),
          IF(IFNULL(dev.Compensation_Package_Reference_ID_Type,'') != IFNULL(qa.Compensation_Package_Reference_ID_Type,''), 'Compensation_Package_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Compensation_Grade_Reference_ID,'') != IFNULL(qa.Compensation_Grade_Reference_ID,''), 'Compensation_Grade_Reference_ID', NULL),
          IF(IFNULL(dev.Compensation_Grade_Reference_ID_Type,'') != IFNULL(qa.Compensation_Grade_Reference_ID_Type,''), 'Compensation_Grade_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Compensation_Grade_Profile_Reference_ID,'') != IFNULL(qa.Compensation_Grade_Profile_Reference_ID,''), 'Compensation_Grade_Profile_Reference_ID', NULL),
          IF(IFNULL(dev.Compensation_Grade_Profile_Reference_ID_Type,'') != IFNULL(qa.Compensation_Grade_Profile_Reference_ID_Type,''), 'Compensation_Grade_Profile_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Compensation_Step_Reference_ID,'') != IFNULL(qa.Compensation_Step_Reference_ID,''), 'Compensation_Step_Reference_ID', NULL),
          IF(IFNULL(dev.Compensation_Step_Reference_ID_Type,'') != IFNULL(qa.Compensation_Step_Reference_ID_Type,''), 'Compensation_Step_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Progression_Start_Date,'') != IFNULL(qa.Progression_Start_Date,''), 'Progression_Start_Date', NULL),
          IF(IFNULL(dev.Pay_Plan_Data_Replace,'') != IFNULL(qa.Pay_Plan_Data_Replace,''), 'Pay_Plan_Data_Replace', NULL),
          IF(IFNULL(dev.Pay_Plan_Reference_ID,'') != IFNULL(qa.Pay_Plan_Reference_ID,''), 'Pay_Plan_Reference_ID', NULL),
          IF(IFNULL(dev.Pay_Plan_Reference_ID_Type,'') != IFNULL(qa.Pay_Plan_Reference_ID_Type,''), 'Pay_Plan_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Pay_Plan_Currency_Reference_ID,'') != IFNULL(qa.Pay_Plan_Currency_Reference_ID,''), 'Pay_Plan_Currency_Reference_ID', NULL),
          IF(IFNULL(dev.Pay_Plan_Currency_Reference_ID_Type,'') != IFNULL(qa.Pay_Plan_Currency_Reference_ID_Type,''), 'Pay_Plan_Currency_Reference_ID_Type', NULL),
          IF(IFNULL(dev.Pay_Plan_Frequency_ID,'') != IFNULL(qa.Pay_Plan_Frequency_ID,''), 'Pay_Plan_Frequency_ID', NULL),
          IF(IFNULL(dev.Pay_Plan_Frequency_ID_Type,'') != IFNULL(qa.Pay_Plan_Frequency_ID_Type,''), 'Pay_Plan_Frequency_ID_Type', NULL),
          IF(IFNULL(dev.Pay_Plan_Expected_End_Date,'') != IFNULL(qa.Pay_Plan_Expected_End_Date,''), 'Pay_Plan_Expected_End_Date', NULL),
          IF(IFNULL(dev.Pay_Plan_Actual_End_Date,'') != IFNULL(qa.Pay_Plan_Actual_End_Date,''), 'Pay_Plan_Actual_End_Date', NULL),
          IF(IFNULL(dev.Pay_Plan_Amount,'') != IFNULL(qa.Pay_Plan_Amount,''), 'Pay_Plan_Amount', NULL),
          IF(IFNULL(dev.Pay_Plan_Percent_Change,'') != IFNULL(qa.Pay_Plan_Percent_Change,''), 'Pay_Plan_Percent_Change', NULL),
          IF(IFNULL(dev.Pay_Plan_Amount_Change,'') != IFNULL(qa.Pay_Plan_Amount_Change,''), 'Pay_Plan_Amount_Change', NULL),
          IF(IFNULL(dev.Primary_Compensation_Basis,'') != IFNULL(qa.Primary_Compensation_Basis,''), 'Primary_Compensation_Basis', NULL),
          IF(IFNULL(dev.Primary_Compensation_Basis_Amount_Change,'') != IFNULL(qa.Primary_Compensation_Basis_Amount_Change,''), 'Primary_Compensation_Basis_Amount_Change', NULL),
          IF(IFNULL(dev.Primary_Compensation_Basis_Percent_Change,'') != IFNULL(qa.Primary_Compensation_Basis_Percent_Change,''), 'Primary_Compensation_Basis_Percent_Change', NULL),
          IF(IFNULL(dev.Skip,'') != IFNULL(qa.Skip,''), 'Skip', NULL),
          IF(IFNULL(dev.LegacyPrimary,'') != IFNULL(qa.LegacyPrimary,''), 'LegacyPrimary', NULL)
        ]) AS col
        WHERE col IS NOT NULL
      ) AS Changed_Columns,
      -- Build Old_Values list as column_name:old_value pairs using UNNEST to filter NULLs
      (
        SELECT STRING_AGG(col, ', ')
        FROM UNNEST([
          IF(IFNULL(dev.Employee_ID,'') != IFNULL(qa.Employee_ID,''), CONCAT('Employee_ID:', IFNULL(qa.Employee_ID,'NULL')), NULL),
          IF(IFNULL(dev.Employee_Reference_ID_Type,'') != IFNULL(qa.Employee_Reference_ID_Type,''), CONCAT('Employee_Reference_ID_Type:', IFNULL(qa.Employee_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Position_ID,'') != IFNULL(qa.Position_ID,''), CONCAT('Position_ID:', IFNULL(qa.Position_ID,'NULL')), NULL),
          IF(IFNULL(dev.Position_Reference_ID_Type,'') != IFNULL(qa.Position_Reference_ID_Type,''), CONCAT('Position_Reference_ID_Type:', IFNULL(qa.Position_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Employee_Visibility_Date,'') != IFNULL(qa.Employee_Visibility_Date,''), CONCAT('Employee_Visibility_Date:', IFNULL(qa.Employee_Visibility_Date,'NULL')), NULL),
          IF(IFNULL(dev.Reason_Reference_ID,'') != IFNULL(qa.Reason_Reference_ID,''), CONCAT('Reason_Reference_ID:', IFNULL(qa.Reason_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Reason_Reference_ID_Type,'') != IFNULL(qa.Reason_Reference_ID_Type,''), CONCAT('Reason_Reference_ID_Type:', IFNULL(qa.Reason_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Change_Date,'') != IFNULL(qa.Compensation_Change_Date,''), CONCAT('Compensation_Change_Date:', IFNULL(qa.Compensation_Change_Date,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Change_On_Next_Pay_Period,'') != IFNULL(qa.Compensation_Change_On_Next_Pay_Period,''), CONCAT('Compensation_Change_On_Next_Pay_Period:', IFNULL(qa.Compensation_Change_On_Next_Pay_Period,'NULL')), NULL),
          IF(IFNULL(dev.Override_Compensation_Basis_Calculation,'') != IFNULL(qa.Override_Compensation_Basis_Calculation,''), CONCAT('Override_Compensation_Basis_Calculation:', IFNULL(qa.Override_Compensation_Basis_Calculation,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Package_Reference_ID,'') != IFNULL(qa.Compensation_Package_Reference_ID,''), CONCAT('Compensation_Package_Reference_ID:', IFNULL(qa.Compensation_Package_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Package_Reference_ID_Type,'') != IFNULL(qa.Compensation_Package_Reference_ID_Type,''), CONCAT('Compensation_Package_Reference_ID_Type:', IFNULL(qa.Compensation_Package_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Grade_Reference_ID,'') != IFNULL(qa.Compensation_Grade_Reference_ID,''), CONCAT('Compensation_Grade_Reference_ID:', IFNULL(qa.Compensation_Grade_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Grade_Reference_ID_Type,'') != IFNULL(qa.Compensation_Grade_Reference_ID_Type,''), CONCAT('Compensation_Grade_Reference_ID_Type:', IFNULL(qa.Compensation_Grade_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Grade_Profile_Reference_ID,'') != IFNULL(qa.Compensation_Grade_Profile_Reference_ID,''), CONCAT('Compensation_Grade_Profile_Reference_ID:', IFNULL(qa.Compensation_Grade_Profile_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Grade_Profile_Reference_ID_Type,'') != IFNULL(qa.Compensation_Grade_Profile_Reference_ID_Type,''), CONCAT('Compensation_Grade_Profile_Reference_ID_Type:', IFNULL(qa.Compensation_Grade_Profile_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Step_Reference_ID,'') != IFNULL(qa.Compensation_Step_Reference_ID,''), CONCAT('Compensation_Step_Reference_ID:', IFNULL(qa.Compensation_Step_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Compensation_Step_Reference_ID_Type,'') != IFNULL(qa.Compensation_Step_Reference_ID_Type,''), CONCAT('Compensation_Step_Reference_ID_Type:', IFNULL(qa.Compensation_Step_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Progression_Start_Date,'') != IFNULL(qa.Progression_Start_Date,''), CONCAT('Progression_Start_Date:', IFNULL(qa.Progression_Start_Date,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Data_Replace,'') != IFNULL(qa.Pay_Plan_Data_Replace,''), CONCAT('Pay_Plan_Data_Replace:', IFNULL(qa.Pay_Plan_Data_Replace,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Reference_ID,'') != IFNULL(qa.Pay_Plan_Reference_ID,''), CONCAT('Pay_Plan_Reference_ID:', IFNULL(qa.Pay_Plan_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Reference_ID_Type,'') != IFNULL(qa.Pay_Plan_Reference_ID_Type,''), CONCAT('Pay_Plan_Reference_ID_Type:', IFNULL(qa.Pay_Plan_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Currency_Reference_ID,'') != IFNULL(qa.Pay_Plan_Currency_Reference_ID,''), CONCAT('Pay_Plan_Currency_Reference_ID:', IFNULL(qa.Pay_Plan_Currency_Reference_ID,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Currency_Reference_ID_Type,'') != IFNULL(qa.Pay_Plan_Currency_Reference_ID_Type,''), CONCAT('Pay_Plan_Currency_Reference_ID_Type:', IFNULL(qa.Pay_Plan_Currency_Reference_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Frequency_ID,'') != IFNULL(qa.Pay_Plan_Frequency_ID,''), CONCAT('Pay_Plan_Frequency_ID:', IFNULL(qa.Pay_Plan_Frequency_ID,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Frequency_ID_Type,'') != IFNULL(qa.Pay_Plan_Frequency_ID_Type,''), CONCAT('Pay_Plan_Frequency_ID_Type:', IFNULL(qa.Pay_Plan_Frequency_ID_Type,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Expected_End_Date,'') != IFNULL(qa.Pay_Plan_Expected_End_Date,''), CONCAT('Pay_Plan_Expected_End_Date:', IFNULL(qa.Pay_Plan_Expected_End_Date,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Actual_End_Date,'') != IFNULL(qa.Pay_Plan_Actual_End_Date,''), CONCAT('Pay_Plan_Actual_End_Date:', IFNULL(qa.Pay_Plan_Actual_End_Date,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Amount,'') != IFNULL(qa.Pay_Plan_Amount,''), CONCAT('Pay_Plan_Amount:', IFNULL(qa.Pay_Plan_Amount,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Percent_Change,'') != IFNULL(qa.Pay_Plan_Percent_Change,''), CONCAT('Pay_Plan_Percent_Change:', IFNULL(qa.Pay_Plan_Percent_Change,'NULL')), NULL),
          IF(IFNULL(dev.Pay_Plan_Amount_Change,'') != IFNULL(qa.Pay_Plan_Amount_Change,''), CONCAT('Pay_Plan_Amount_Change:', IFNULL(qa.Pay_Plan_Amount_Change,'NULL')), NULL),
          IF(IFNULL(dev.Primary_Compensation_Basis,'') != IFNULL(qa.Primary_Compensation_Basis,''), CONCAT('Primary_Compensation_Basis:', IFNULL(qa.Primary_Compensation_Basis,'NULL')), NULL),
          IF(IFNULL(dev.Primary_Compensation_Basis_Amount_Change,'') != IFNULL(qa.Primary_Compensation_Basis_Amount_Change,''), CONCAT('Primary_Compensation_Basis_Amount_Change:', IFNULL(qa.Primary_Compensation_Basis_Amount_Change,'NULL')), NULL),
          IF(IFNULL(dev.Primary_Compensation_Basis_Percent_Change,'') != IFNULL(qa.Primary_Compensation_Basis_Percent_Change,''), CONCAT('Primary_Compensation_Basis_Percent_Change:', IFNULL(qa.Primary_Compensation_Basis_Percent_Change,'NULL')), NULL),
          IF(IFNULL(dev.Skip,'') != IFNULL(qa.Skip,''), CONCAT('Skip:', IFNULL(qa.Skip,'NULL')), NULL),
          IF(IFNULL(dev.LegacyPrimary,'') != IFNULL(qa.LegacyPrimary,''), CONCAT('LegacyPrimary:', IFNULL(qa.LegacyPrimary,'NULL')), NULL)
        ]) AS col
        WHERE col IS NOT NULL
      ) AS Old_Values
    FROM dev
    INNER JOIN qa
      ON  dev.LegacySystem     = qa.LegacySystem
      AND dev.LegacyEmployee   = qa.LegacyEmployee
      AND dev.LegacyJobProfile = qa.LegacyJobProfile
  ),
  changed_records AS (
    SELECT
      'CHG'           AS Change_Type,
      Changed_Columns,
      Old_Values,
      Employee_ID,
      Employee_Reference_ID_Type,
      Position_ID,
      Position_Reference_ID_Type,
      Employee_Visibility_Date,
      Reason_Reference_ID,
      Reason_Reference_ID_Type,
      Compensation_Change_Date,
      Compensation_Change_On_Next_Pay_Period,
      Override_Compensation_Basis_Calculation,
      Compensation_Package_Reference_ID,
      Compensation_Package_Reference_ID_Type,
      Compensation_Grade_Reference_ID,
      Compensation_Grade_Reference_ID_Type,
      Compensation_Grade_Profile_Reference_ID,
      Compensation_Grade_Profile_Reference_ID_Type,
      Compensation_Step_Reference_ID,
      Compensation_Step_Reference_ID_Type,
      Progression_Start_Date,
      Pay_Plan_Data_Replace,
      Pay_Plan_Reference_ID,
      Pay_Plan_Reference_ID_Type,
      Pay_Plan_Currency_Reference_ID,
      Pay_Plan_Currency_Reference_ID_Type,
      Pay_Plan_Frequency_ID,
      Pay_Plan_Frequency_ID_Type,
      Pay_Plan_Expected_End_Date,
      Pay_Plan_Actual_End_Date,
      Pay_Plan_Amount,
      Pay_Plan_Percent_Change,
      Pay_Plan_Amount_Change,
      Primary_Compensation_Basis,
      Primary_Compensation_Basis_Amount_Change,
      Primary_Compensation_Basis_Percent_Change,
      Skip,
      LegacySystem,
      LegacyEmployee,
      LegacyJobProfile,
      LegacyPrimary
    FROM matched_records
    -- Only include records where at least one non-key column has changed
    WHERE Changed_Columns IS NOT NULL
  )
-- Combine all change types into final result
SELECT * FROM new_records
UNION ALL
SELECT * FROM changed_records
UNION ALL
SELECT * FROM deleted_records;

END