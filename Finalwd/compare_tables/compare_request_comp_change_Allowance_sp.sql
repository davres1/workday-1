-- QA is the older baseline; DEV is the current state.
-- Match on: Legacy_System, Legacy_ID, Position_ID, Allowance_Plan_ID.
-- As in compare_example.sql, NULL and empty non-key values compare as equal.
-- Run after creating this procedure:
-- CALL `prj-dev-ss-oneerp.oneerp.prc_compare_request_comp_change_Allowance`();
CREATE OR REPLACE PROCEDURE `prj-dev-ss-oneerp.oneerp.prc_compare_request_comp_change_Allowance`()
BEGIN
  -- Reject ambiguous keys before replacing the previous comparison results.
  ASSERT NOT EXISTS (
    SELECT 1 FROM `prj-dev-ss-oneerp.oneerp.process_request_comp_change_Allowance`
    GROUP BY `Legacy_System`, `Legacy_ID`, `Position_ID`, `Allowance_Plan_ID` HAVING COUNT(*) > 1
  ) AS 'DEV has duplicate comparison keys';
  ASSERT NOT EXISTS (
    SELECT 1 FROM `prj-qa-ss-oneerp.oneerp.process_request_comp_change_Allowance`
    GROUP BY `Legacy_System`, `Legacy_ID`, `Position_ID`, `Allowance_Plan_ID` HAVING COUNT(*) > 1
  ) AS 'QA has duplicate comparison keys';

  CREATE OR REPLACE TABLE `prj-dev-ss-oneerp.oneerp.compare_request_comp_change_Allowance` (
  `Change_Type` STRING,
  `Changed_Columns` STRING,
  `Old_Values` STRING,
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

  INSERT INTO `prj-dev-ss-oneerp.oneerp.compare_request_comp_change_Allowance`
  WITH
  qa AS (
    SELECT * FROM `prj-qa-ss-oneerp.oneerp.process_request_comp_change_Allowance`
  ),
  dev AS (
    SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_request_comp_change_Allowance`
  ),
  new_records AS (
    SELECT 'NEW' AS Change_Type,
      CAST(NULL AS STRING) AS Changed_Columns,
      CAST(NULL AS STRING) AS Old_Values,
      dev.`Legacy_System`,
      dev.`Legacy_ID`,
      dev.`Employee_ID`,
      dev.`Position_ID`,
      dev.`Compensation_Change_Date`,
      dev.`Compensation_Change_On_Next_Pay_Period`,
      dev.`Reason_Reference_ID`,
      dev.`Allowance_Plan_ID`,
      dev.`Allowance_Percent`,
      dev.`Allowance_Amount`,
      dev.`Allowance_Currency_ID`,
      dev.`Allowance_Frequency_ID`,
      dev.`Expected_End_Date`
    FROM dev
    WHERE NOT EXISTS (
      SELECT 1 FROM qa WHERE dev.`Legacy_System` IS NOT DISTINCT FROM qa.`Legacy_System`
      AND dev.`Legacy_ID` IS NOT DISTINCT FROM qa.`Legacy_ID`
      AND dev.`Position_ID` IS NOT DISTINCT FROM qa.`Position_ID`
      AND dev.`Allowance_Plan_ID` IS NOT DISTINCT FROM qa.`Allowance_Plan_ID`
    )
  ),
  deleted_records AS (
    SELECT 'DEL' AS Change_Type,
      CAST(NULL AS STRING) AS Changed_Columns,
      CAST(NULL AS STRING) AS Old_Values,
      qa.`Legacy_System`,
      qa.`Legacy_ID`,
      qa.`Employee_ID`,
      qa.`Position_ID`,
      qa.`Compensation_Change_Date`,
      qa.`Compensation_Change_On_Next_Pay_Period`,
      qa.`Reason_Reference_ID`,
      qa.`Allowance_Plan_ID`,
      qa.`Allowance_Percent`,
      qa.`Allowance_Amount`,
      qa.`Allowance_Currency_ID`,
      qa.`Allowance_Frequency_ID`,
      qa.`Expected_End_Date`
    FROM qa
    WHERE NOT EXISTS (
      SELECT 1 FROM dev WHERE dev.`Legacy_System` IS NOT DISTINCT FROM qa.`Legacy_System`
      AND dev.`Legacy_ID` IS NOT DISTINCT FROM qa.`Legacy_ID`
      AND dev.`Position_ID` IS NOT DISTINCT FROM qa.`Position_ID`
      AND dev.`Allowance_Plan_ID` IS NOT DISTINCT FROM qa.`Allowance_Plan_ID`
    )
  ),
  matched_records AS (
    SELECT
      (
        SELECT STRING_AGG(col, ', ' ORDER BY ordinal)
        FROM UNNEST([
          IF(IFNULL(dev.`Employee_ID`, '') != IFNULL(qa.`Employee_ID`, ''), 'Employee_ID', NULL),
          IF(IFNULL(dev.`Compensation_Change_Date`, '') != IFNULL(qa.`Compensation_Change_Date`, ''), 'Compensation_Change_Date', NULL),
          IF(IFNULL(dev.`Compensation_Change_On_Next_Pay_Period`, '') != IFNULL(qa.`Compensation_Change_On_Next_Pay_Period`, ''), 'Compensation_Change_On_Next_Pay_Period', NULL),
          IF(IFNULL(dev.`Reason_Reference_ID`, '') != IFNULL(qa.`Reason_Reference_ID`, ''), 'Reason_Reference_ID', NULL),
          IF(IFNULL(dev.`Allowance_Percent`, '') != IFNULL(qa.`Allowance_Percent`, ''), 'Allowance_Percent', NULL),
          IF(IFNULL(dev.`Allowance_Amount`, '') != IFNULL(qa.`Allowance_Amount`, ''), 'Allowance_Amount', NULL),
          IF(IFNULL(dev.`Allowance_Currency_ID`, '') != IFNULL(qa.`Allowance_Currency_ID`, ''), 'Allowance_Currency_ID', NULL),
          IF(IFNULL(dev.`Allowance_Frequency_ID`, '') != IFNULL(qa.`Allowance_Frequency_ID`, ''), 'Allowance_Frequency_ID', NULL),
          IF(IFNULL(dev.`Expected_End_Date`, '') != IFNULL(qa.`Expected_End_Date`, ''), 'Expected_End_Date', NULL)
        ]) AS col WITH OFFSET AS ordinal
        WHERE col IS NOT NULL
      ) AS Changed_Columns,
      (
        SELECT STRING_AGG(col, ', ' ORDER BY ordinal)
        FROM UNNEST([
          IF(IFNULL(dev.`Employee_ID`, '') != IFNULL(qa.`Employee_ID`, ''), CONCAT('Employee_ID:', IFNULL(qa.`Employee_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Compensation_Change_Date`, '') != IFNULL(qa.`Compensation_Change_Date`, ''), CONCAT('Compensation_Change_Date:', IFNULL(qa.`Compensation_Change_Date`, 'NULL')), NULL),
          IF(IFNULL(dev.`Compensation_Change_On_Next_Pay_Period`, '') != IFNULL(qa.`Compensation_Change_On_Next_Pay_Period`, ''), CONCAT('Compensation_Change_On_Next_Pay_Period:', IFNULL(qa.`Compensation_Change_On_Next_Pay_Period`, 'NULL')), NULL),
          IF(IFNULL(dev.`Reason_Reference_ID`, '') != IFNULL(qa.`Reason_Reference_ID`, ''), CONCAT('Reason_Reference_ID:', IFNULL(qa.`Reason_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Allowance_Percent`, '') != IFNULL(qa.`Allowance_Percent`, ''), CONCAT('Allowance_Percent:', IFNULL(qa.`Allowance_Percent`, 'NULL')), NULL),
          IF(IFNULL(dev.`Allowance_Amount`, '') != IFNULL(qa.`Allowance_Amount`, ''), CONCAT('Allowance_Amount:', IFNULL(qa.`Allowance_Amount`, 'NULL')), NULL),
          IF(IFNULL(dev.`Allowance_Currency_ID`, '') != IFNULL(qa.`Allowance_Currency_ID`, ''), CONCAT('Allowance_Currency_ID:', IFNULL(qa.`Allowance_Currency_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Allowance_Frequency_ID`, '') != IFNULL(qa.`Allowance_Frequency_ID`, ''), CONCAT('Allowance_Frequency_ID:', IFNULL(qa.`Allowance_Frequency_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Expected_End_Date`, '') != IFNULL(qa.`Expected_End_Date`, ''), CONCAT('Expected_End_Date:', IFNULL(qa.`Expected_End_Date`, 'NULL')), NULL)
        ]) AS col WITH OFFSET AS ordinal
        WHERE col IS NOT NULL
      ) AS Old_Values,
      dev.`Legacy_System`,
    dev.`Legacy_ID`,
    dev.`Employee_ID`,
    dev.`Position_ID`,
    dev.`Compensation_Change_Date`,
    dev.`Compensation_Change_On_Next_Pay_Period`,
    dev.`Reason_Reference_ID`,
    dev.`Allowance_Plan_ID`,
    dev.`Allowance_Percent`,
    dev.`Allowance_Amount`,
    dev.`Allowance_Currency_ID`,
    dev.`Allowance_Frequency_ID`,
    dev.`Expected_End_Date`
    FROM dev
    INNER JOIN qa ON dev.`Legacy_System` IS NOT DISTINCT FROM qa.`Legacy_System`
      AND dev.`Legacy_ID` IS NOT DISTINCT FROM qa.`Legacy_ID`
      AND dev.`Position_ID` IS NOT DISTINCT FROM qa.`Position_ID`
      AND dev.`Allowance_Plan_ID` IS NOT DISTINCT FROM qa.`Allowance_Plan_ID`
  ),
  changed_records AS (
    SELECT 'CHG' AS Change_Type, matched_records.*
    FROM matched_records
    WHERE Changed_Columns IS NOT NULL
  )
  SELECT * FROM new_records
  UNION ALL
  SELECT * FROM changed_records
  UNION ALL
  SELECT * FROM deleted_records;
END;
