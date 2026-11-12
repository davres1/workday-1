-- QA is the older baseline; DEV is the current state.
-- Match on: LegacySystem, LegacyID, Position_Reference_ID.
-- As in compare_example.sql, NULL and empty non-key values compare as equal.
-- Run after creating this procedure:
-- CALL `prj-dev-ss-oneerp.oneerp.prc_compare_Put_Payroll_Payee_FICA_OASDIs`();
CREATE OR REPLACE PROCEDURE `prj-dev-ss-oneerp.oneerp.prc_compare_Put_Payroll_Payee_FICA_OASDIs`()
BEGIN
  -- Reject ambiguous keys before replacing the previous comparison results.
  ASSERT NOT EXISTS (
    SELECT 1 FROM `prj-dev-ss-oneerp.oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
    GROUP BY `LegacySystem`, `LegacyID`, `Position_Reference_ID` HAVING COUNT(*) > 1
  ) AS 'DEV has duplicate comparison keys';
  ASSERT NOT EXISTS (
    SELECT 1 FROM `prj-qa-ss-oneerp.oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
    GROUP BY `LegacySystem`, `LegacyID`, `Position_Reference_ID` HAVING COUNT(*) > 1
  ) AS 'QA has duplicate comparison keys';

  CREATE OR REPLACE TABLE `prj-dev-ss-oneerp.oneerp.compare_Put_Payroll_Payee_FICA_OASDIs` (
  `Change_Type` STRING,
  `Changed_Columns` STRING,
  `Old_Values` STRING,
  `Add_Only` STRING,
  `Payroll_Payee_FICA_Reference_ID` STRING,
  `Payroll_Payee_FICA_Reference_ID_Type` STRING,
  `ID` STRING,
  `Worker_Reference_ID` STRING,
  `Worker_Reference_ID_Type` STRING,
  `Position_Reference_ID` STRING,
  `Position_Reference_ID_Type` STRING,
  `All_Positions` STRING,
  `Effective_As_Of` STRING,
  `Apply_To_Worker` STRING,
  `Exempt_from_OASDI` STRING,
  `OASDI_Reason_for_Exemption_Reference_ID` STRING,
  `OASDI_Reason_for_Exemption_Reference_ID_Type` STRING,
  `LegacySystem` STRING,
  `LegacyID` STRING,
  `LawsonLegacyID` STRING
  );

  INSERT INTO `prj-dev-ss-oneerp.oneerp.compare_Put_Payroll_Payee_FICA_OASDIs`
  WITH
  qa AS (
    SELECT * FROM `prj-qa-ss-oneerp.oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
  ),
  dev AS (
    SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
  ),
  new_records AS (
    SELECT 'NEW' AS Change_Type,
      CAST(NULL AS STRING) AS Changed_Columns,
      CAST(NULL AS STRING) AS Old_Values,
      dev.`Add_Only`,
      dev.`Payroll_Payee_FICA_Reference_ID`,
      dev.`Payroll_Payee_FICA_Reference_ID_Type`,
      dev.`ID`,
      dev.`Worker_Reference_ID`,
      dev.`Worker_Reference_ID_Type`,
      dev.`Position_Reference_ID`,
      dev.`Position_Reference_ID_Type`,
      dev.`All_Positions`,
      dev.`Effective_As_Of`,
      dev.`Apply_To_Worker`,
      dev.`Exempt_from_OASDI`,
      dev.`OASDI_Reason_for_Exemption_Reference_ID`,
      dev.`OASDI_Reason_for_Exemption_Reference_ID_Type`,
      dev.`LegacySystem`,
      dev.`LegacyID`,
      dev.`LawsonLegacyID`
    FROM dev
    WHERE NOT EXISTS (
      SELECT 1 FROM qa WHERE dev.`LegacySystem` IS NOT DISTINCT FROM qa.`LegacySystem`
      AND dev.`LegacyID` IS NOT DISTINCT FROM qa.`LegacyID`
      AND dev.`Position_Reference_ID` IS NOT DISTINCT FROM qa.`Position_Reference_ID`
    )
  ),
  deleted_records AS (
    SELECT 'DEL' AS Change_Type,
      CAST(NULL AS STRING) AS Changed_Columns,
      CAST(NULL AS STRING) AS Old_Values,
      qa.`Add_Only`,
      qa.`Payroll_Payee_FICA_Reference_ID`,
      qa.`Payroll_Payee_FICA_Reference_ID_Type`,
      qa.`ID`,
      qa.`Worker_Reference_ID`,
      qa.`Worker_Reference_ID_Type`,
      qa.`Position_Reference_ID`,
      qa.`Position_Reference_ID_Type`,
      qa.`All_Positions`,
      qa.`Effective_As_Of`,
      qa.`Apply_To_Worker`,
      qa.`Exempt_from_OASDI`,
      qa.`OASDI_Reason_for_Exemption_Reference_ID`,
      qa.`OASDI_Reason_for_Exemption_Reference_ID_Type`,
      qa.`LegacySystem`,
      qa.`LegacyID`,
      qa.`LawsonLegacyID`
    FROM qa
    WHERE NOT EXISTS (
      SELECT 1 FROM dev WHERE dev.`LegacySystem` IS NOT DISTINCT FROM qa.`LegacySystem`
      AND dev.`LegacyID` IS NOT DISTINCT FROM qa.`LegacyID`
      AND dev.`Position_Reference_ID` IS NOT DISTINCT FROM qa.`Position_Reference_ID`
    )
  ),
  matched_records AS (
    SELECT
      (
        SELECT STRING_AGG(col, ', ' ORDER BY ordinal)
        FROM UNNEST([
          IF(IFNULL(dev.`Add_Only`, '') != IFNULL(qa.`Add_Only`, ''), 'Add_Only', NULL),
          IF(IFNULL(dev.`Payroll_Payee_FICA_Reference_ID`, '') != IFNULL(qa.`Payroll_Payee_FICA_Reference_ID`, ''), 'Payroll_Payee_FICA_Reference_ID', NULL),
          IF(IFNULL(dev.`Payroll_Payee_FICA_Reference_ID_Type`, '') != IFNULL(qa.`Payroll_Payee_FICA_Reference_ID_Type`, ''), 'Payroll_Payee_FICA_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`ID`, '') != IFNULL(qa.`ID`, ''), 'ID', NULL),
          IF(IFNULL(dev.`Worker_Reference_ID`, '') != IFNULL(qa.`Worker_Reference_ID`, ''), 'Worker_Reference_ID', NULL),
          IF(IFNULL(dev.`Worker_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Reference_ID_Type`, ''), 'Worker_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Position_Reference_ID_Type`, '') != IFNULL(qa.`Position_Reference_ID_Type`, ''), 'Position_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`All_Positions`, '') != IFNULL(qa.`All_Positions`, ''), 'All_Positions', NULL),
          IF(IFNULL(dev.`Effective_As_Of`, '') != IFNULL(qa.`Effective_As_Of`, ''), 'Effective_As_Of', NULL),
          IF(IFNULL(dev.`Apply_To_Worker`, '') != IFNULL(qa.`Apply_To_Worker`, ''), 'Apply_To_Worker', NULL),
          IF(IFNULL(dev.`Exempt_from_OASDI`, '') != IFNULL(qa.`Exempt_from_OASDI`, ''), 'Exempt_from_OASDI', NULL),
          IF(IFNULL(dev.`OASDI_Reason_for_Exemption_Reference_ID`, '') != IFNULL(qa.`OASDI_Reason_for_Exemption_Reference_ID`, ''), 'OASDI_Reason_for_Exemption_Reference_ID', NULL),
          IF(IFNULL(dev.`OASDI_Reason_for_Exemption_Reference_ID_Type`, '') != IFNULL(qa.`OASDI_Reason_for_Exemption_Reference_ID_Type`, ''), 'OASDI_Reason_for_Exemption_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`LawsonLegacyID`, '') != IFNULL(qa.`LawsonLegacyID`, ''), 'LawsonLegacyID', NULL)
        ]) AS col WITH OFFSET AS ordinal
        WHERE col IS NOT NULL
      ) AS Changed_Columns,
      (
        SELECT STRING_AGG(col, ', ' ORDER BY ordinal)
        FROM UNNEST([
          IF(IFNULL(dev.`Add_Only`, '') != IFNULL(qa.`Add_Only`, ''), CONCAT('Add_Only:', IFNULL(qa.`Add_Only`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payroll_Payee_FICA_Reference_ID`, '') != IFNULL(qa.`Payroll_Payee_FICA_Reference_ID`, ''), CONCAT('Payroll_Payee_FICA_Reference_ID:', IFNULL(qa.`Payroll_Payee_FICA_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payroll_Payee_FICA_Reference_ID_Type`, '') != IFNULL(qa.`Payroll_Payee_FICA_Reference_ID_Type`, ''), CONCAT('Payroll_Payee_FICA_Reference_ID_Type:', IFNULL(qa.`Payroll_Payee_FICA_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`ID`, '') != IFNULL(qa.`ID`, ''), CONCAT('ID:', IFNULL(qa.`ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Reference_ID`, '') != IFNULL(qa.`Worker_Reference_ID`, ''), CONCAT('Worker_Reference_ID:', IFNULL(qa.`Worker_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Reference_ID_Type`, ''), CONCAT('Worker_Reference_ID_Type:', IFNULL(qa.`Worker_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Position_Reference_ID_Type`, '') != IFNULL(qa.`Position_Reference_ID_Type`, ''), CONCAT('Position_Reference_ID_Type:', IFNULL(qa.`Position_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`All_Positions`, '') != IFNULL(qa.`All_Positions`, ''), CONCAT('All_Positions:', IFNULL(qa.`All_Positions`, 'NULL')), NULL),
          IF(IFNULL(dev.`Effective_As_Of`, '') != IFNULL(qa.`Effective_As_Of`, ''), CONCAT('Effective_As_Of:', IFNULL(qa.`Effective_As_Of`, 'NULL')), NULL),
          IF(IFNULL(dev.`Apply_To_Worker`, '') != IFNULL(qa.`Apply_To_Worker`, ''), CONCAT('Apply_To_Worker:', IFNULL(qa.`Apply_To_Worker`, 'NULL')), NULL),
          IF(IFNULL(dev.`Exempt_from_OASDI`, '') != IFNULL(qa.`Exempt_from_OASDI`, ''), CONCAT('Exempt_from_OASDI:', IFNULL(qa.`Exempt_from_OASDI`, 'NULL')), NULL),
          IF(IFNULL(dev.`OASDI_Reason_for_Exemption_Reference_ID`, '') != IFNULL(qa.`OASDI_Reason_for_Exemption_Reference_ID`, ''), CONCAT('OASDI_Reason_for_Exemption_Reference_ID:', IFNULL(qa.`OASDI_Reason_for_Exemption_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`OASDI_Reason_for_Exemption_Reference_ID_Type`, '') != IFNULL(qa.`OASDI_Reason_for_Exemption_Reference_ID_Type`, ''), CONCAT('OASDI_Reason_for_Exemption_Reference_ID_Type:', IFNULL(qa.`OASDI_Reason_for_Exemption_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`LawsonLegacyID`, '') != IFNULL(qa.`LawsonLegacyID`, ''), CONCAT('LawsonLegacyID:', IFNULL(qa.`LawsonLegacyID`, 'NULL')), NULL)
        ]) AS col WITH OFFSET AS ordinal
        WHERE col IS NOT NULL
      ) AS Old_Values,
      dev.`Add_Only`,
    dev.`Payroll_Payee_FICA_Reference_ID`,
    dev.`Payroll_Payee_FICA_Reference_ID_Type`,
    dev.`ID`,
    dev.`Worker_Reference_ID`,
    dev.`Worker_Reference_ID_Type`,
    dev.`Position_Reference_ID`,
    dev.`Position_Reference_ID_Type`,
    dev.`All_Positions`,
    dev.`Effective_As_Of`,
    dev.`Apply_To_Worker`,
    dev.`Exempt_from_OASDI`,
    dev.`OASDI_Reason_for_Exemption_Reference_ID`,
    dev.`OASDI_Reason_for_Exemption_Reference_ID_Type`,
    dev.`LegacySystem`,
    dev.`LegacyID`,
    dev.`LawsonLegacyID`
    FROM dev
    INNER JOIN qa ON dev.`LegacySystem` IS NOT DISTINCT FROM qa.`LegacySystem`
      AND dev.`LegacyID` IS NOT DISTINCT FROM qa.`LegacyID`
      AND dev.`Position_Reference_ID` IS NOT DISTINCT FROM qa.`Position_Reference_ID`
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
