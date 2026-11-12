-- QA is the older baseline; DEV is the current state.
-- Match on: LegacySystem, LegacyID, Payment_Election_Higher_Order_Rule_ID, Payment_Election_Rule_ID, Election_Order.
-- As in compare_example.sql, NULL and empty non-key values compare as equal.
-- Run after creating this procedure:
-- CALL `prj-dev-ss-oneerp.oneerp.prc_compare_submit_payment_election_enrollment`();
CREATE OR REPLACE PROCEDURE `prj-dev-ss-oneerp.oneerp.prc_compare_submit_payment_election_enrollment`()
BEGIN
  -- Reject ambiguous keys before replacing the previous comparison results.
  ASSERT NOT EXISTS (
    SELECT 1 FROM `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`
    GROUP BY `LegacySystem`, `LegacyID`, `Payment_Election_Higher_Order_Rule_ID`, `Payment_Election_Rule_ID`, `Election_Order` HAVING COUNT(*) > 1
  ) AS 'DEV has duplicate comparison keys';
  ASSERT NOT EXISTS (
    SELECT 1 FROM `prj-qa-ss-oneerp.oneerp.process_submit_payment_election_enrollment`
    GROUP BY `LegacySystem`, `LegacyID`, `Payment_Election_Higher_Order_Rule_ID`, `Payment_Election_Rule_ID`, `Election_Order` HAVING COUNT(*) > 1
  ) AS 'QA has duplicate comparison keys';

  CREATE OR REPLACE TABLE `prj-dev-ss-oneerp.oneerp.compare_submit_payment_election_enrollment` (
  `Change_Type` STRING,
  `Changed_Columns` STRING,
  `Old_Values` STRING,
  `Retain_Unused_Worker_Bank_Accounts` STRING,
  `Worker_Reference_ID` STRING,
  `Worker_Reference_ID_Type` STRING,
  `Worker_Country_Reference_ID` STRING,
  `Worker_Country_Reference_ID_Type` STRING,
  `Worker_Currency_Reference_ID` STRING,
  `Worker_Currency_Reference_ID_Type` STRING,
  `Payment_Election_Higher_Order_Rule_ID` STRING,
  `Payment_Election_Higher_Order_Rule_ID_Type` STRING,
  `Election_Order` STRING,
  `Payment_Election_Rule_ID` STRING,
  `Payment_Election_Rule_ID_Type` STRING,
  `Payment_Election_Rule_Country` STRING,
  `Payment_Election_Rule_Country_Type` STRING,
  `Payment_Election_Rule_Currency_ID` STRING,
  `Payment_Election_Rule_Currency_ID_Type` STRING,
  `Payment_Type_Reference_ID` STRING,
  `Payment_Type_Reference_ID_Type` STRING,
  `Bank_Account_Country_Reference_ID` STRING,
  `Bank_Account_Country_Reference_ID_Type` STRING,
  `Bank_Account_Currency_Reference_ID` STRING,
  `Bank_Account_Currency_Reference_ID_Type` STRING,
  `Bank_Account_Nickname` STRING,
  `Bank_Account_Name` STRING,
  `Bank_Account_Number` STRING,
  `Roll_Number` STRING,
  `Bank_Account_Type_Code` STRING,
  `Bank_Account_Type_Reference_ID` STRING,
  `Bank_Account_Type_Reference_ID_Type` STRING,
  `Bank_Name` STRING,
  `Bank_Account_IBAN` STRING,
  `Bank_Account_ID_Number` STRING,
  `Bank_Account_BIC` STRING,
  `Bank_Account_Branch_Name` STRING,
  `Bank_Account_Branch_ID_Number` STRING,
  `Bank_Account_Check_Digit` STRING,
  `Distribution_Amount` STRING,
  `Distribution_Percentage` STRING,
  `Distribution_Balance` STRING,
  `LegacySystem` STRING,
  `LegacyID` STRING
  );

  INSERT INTO `prj-dev-ss-oneerp.oneerp.compare_submit_payment_election_enrollment`
  WITH
  qa AS (
    SELECT * FROM `prj-qa-ss-oneerp.oneerp.process_submit_payment_election_enrollment`
  ),
  dev AS (
    SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`
  ),
  new_records AS (
    SELECT 'NEW' AS Change_Type,
      CAST(NULL AS STRING) AS Changed_Columns,
      CAST(NULL AS STRING) AS Old_Values,
      dev.`Retain_Unused_Worker_Bank_Accounts`,
      dev.`Worker_Reference_ID`,
      dev.`Worker_Reference_ID_Type`,
      dev.`Worker_Country_Reference_ID`,
      dev.`Worker_Country_Reference_ID_Type`,
      dev.`Worker_Currency_Reference_ID`,
      dev.`Worker_Currency_Reference_ID_Type`,
      dev.`Payment_Election_Higher_Order_Rule_ID`,
      dev.`Payment_Election_Higher_Order_Rule_ID_Type`,
      dev.`Election_Order`,
      dev.`Payment_Election_Rule_ID`,
      dev.`Payment_Election_Rule_ID_Type`,
      dev.`Payment_Election_Rule_Country`,
      dev.`Payment_Election_Rule_Country_Type`,
      dev.`Payment_Election_Rule_Currency_ID`,
      dev.`Payment_Election_Rule_Currency_ID_Type`,
      dev.`Payment_Type_Reference_ID`,
      dev.`Payment_Type_Reference_ID_Type`,
      dev.`Bank_Account_Country_Reference_ID`,
      dev.`Bank_Account_Country_Reference_ID_Type`,
      dev.`Bank_Account_Currency_Reference_ID`,
      dev.`Bank_Account_Currency_Reference_ID_Type`,
      dev.`Bank_Account_Nickname`,
      dev.`Bank_Account_Name`,
      dev.`Bank_Account_Number`,
      dev.`Roll_Number`,
      dev.`Bank_Account_Type_Code`,
      dev.`Bank_Account_Type_Reference_ID`,
      dev.`Bank_Account_Type_Reference_ID_Type`,
      dev.`Bank_Name`,
      dev.`Bank_Account_IBAN`,
      dev.`Bank_Account_ID_Number`,
      dev.`Bank_Account_BIC`,
      dev.`Bank_Account_Branch_Name`,
      dev.`Bank_Account_Branch_ID_Number`,
      dev.`Bank_Account_Check_Digit`,
      dev.`Distribution_Amount`,
      dev.`Distribution_Percentage`,
      dev.`Distribution_Balance`,
      dev.`LegacySystem`,
      dev.`LegacyID`
    FROM dev
    WHERE NOT EXISTS (
      SELECT 1 FROM qa WHERE dev.`LegacySystem` IS NOT DISTINCT FROM qa.`LegacySystem`
      AND dev.`LegacyID` IS NOT DISTINCT FROM qa.`LegacyID`
      AND dev.`Payment_Election_Higher_Order_Rule_ID` IS NOT DISTINCT FROM qa.`Payment_Election_Higher_Order_Rule_ID`
      AND dev.`Payment_Election_Rule_ID` IS NOT DISTINCT FROM qa.`Payment_Election_Rule_ID`
      AND dev.`Election_Order` IS NOT DISTINCT FROM qa.`Election_Order`
    )
  ),
  deleted_records AS (
    SELECT 'DEL' AS Change_Type,
      CAST(NULL AS STRING) AS Changed_Columns,
      CAST(NULL AS STRING) AS Old_Values,
      qa.`Retain_Unused_Worker_Bank_Accounts`,
      qa.`Worker_Reference_ID`,
      qa.`Worker_Reference_ID_Type`,
      qa.`Worker_Country_Reference_ID`,
      qa.`Worker_Country_Reference_ID_Type`,
      qa.`Worker_Currency_Reference_ID`,
      qa.`Worker_Currency_Reference_ID_Type`,
      qa.`Payment_Election_Higher_Order_Rule_ID`,
      qa.`Payment_Election_Higher_Order_Rule_ID_Type`,
      qa.`Election_Order`,
      qa.`Payment_Election_Rule_ID`,
      qa.`Payment_Election_Rule_ID_Type`,
      qa.`Payment_Election_Rule_Country`,
      qa.`Payment_Election_Rule_Country_Type`,
      qa.`Payment_Election_Rule_Currency_ID`,
      qa.`Payment_Election_Rule_Currency_ID_Type`,
      qa.`Payment_Type_Reference_ID`,
      qa.`Payment_Type_Reference_ID_Type`,
      qa.`Bank_Account_Country_Reference_ID`,
      qa.`Bank_Account_Country_Reference_ID_Type`,
      qa.`Bank_Account_Currency_Reference_ID`,
      qa.`Bank_Account_Currency_Reference_ID_Type`,
      qa.`Bank_Account_Nickname`,
      qa.`Bank_Account_Name`,
      qa.`Bank_Account_Number`,
      qa.`Roll_Number`,
      qa.`Bank_Account_Type_Code`,
      qa.`Bank_Account_Type_Reference_ID`,
      qa.`Bank_Account_Type_Reference_ID_Type`,
      qa.`Bank_Name`,
      qa.`Bank_Account_IBAN`,
      qa.`Bank_Account_ID_Number`,
      qa.`Bank_Account_BIC`,
      qa.`Bank_Account_Branch_Name`,
      qa.`Bank_Account_Branch_ID_Number`,
      qa.`Bank_Account_Check_Digit`,
      qa.`Distribution_Amount`,
      qa.`Distribution_Percentage`,
      qa.`Distribution_Balance`,
      qa.`LegacySystem`,
      qa.`LegacyID`
    FROM qa
    WHERE NOT EXISTS (
      SELECT 1 FROM dev WHERE dev.`LegacySystem` IS NOT DISTINCT FROM qa.`LegacySystem`
      AND dev.`LegacyID` IS NOT DISTINCT FROM qa.`LegacyID`
      AND dev.`Payment_Election_Higher_Order_Rule_ID` IS NOT DISTINCT FROM qa.`Payment_Election_Higher_Order_Rule_ID`
      AND dev.`Payment_Election_Rule_ID` IS NOT DISTINCT FROM qa.`Payment_Election_Rule_ID`
      AND dev.`Election_Order` IS NOT DISTINCT FROM qa.`Election_Order`
    )
  ),
  matched_records AS (
    SELECT
      (
        SELECT STRING_AGG(col, ', ' ORDER BY ordinal)
        FROM UNNEST([
          IF(IFNULL(dev.`Retain_Unused_Worker_Bank_Accounts`, '') != IFNULL(qa.`Retain_Unused_Worker_Bank_Accounts`, ''), 'Retain_Unused_Worker_Bank_Accounts', NULL),
          IF(IFNULL(dev.`Worker_Reference_ID`, '') != IFNULL(qa.`Worker_Reference_ID`, ''), 'Worker_Reference_ID', NULL),
          IF(IFNULL(dev.`Worker_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Reference_ID_Type`, ''), 'Worker_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Worker_Country_Reference_ID`, '') != IFNULL(qa.`Worker_Country_Reference_ID`, ''), 'Worker_Country_Reference_ID', NULL),
          IF(IFNULL(dev.`Worker_Country_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Country_Reference_ID_Type`, ''), 'Worker_Country_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Worker_Currency_Reference_ID`, '') != IFNULL(qa.`Worker_Currency_Reference_ID`, ''), 'Worker_Currency_Reference_ID', NULL),
          IF(IFNULL(dev.`Worker_Currency_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Currency_Reference_ID_Type`, ''), 'Worker_Currency_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Payment_Election_Higher_Order_Rule_ID_Type`, '') != IFNULL(qa.`Payment_Election_Higher_Order_Rule_ID_Type`, ''), 'Payment_Election_Higher_Order_Rule_ID_Type', NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_ID_Type`, '') != IFNULL(qa.`Payment_Election_Rule_ID_Type`, ''), 'Payment_Election_Rule_ID_Type', NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Country`, '') != IFNULL(qa.`Payment_Election_Rule_Country`, ''), 'Payment_Election_Rule_Country', NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Country_Type`, '') != IFNULL(qa.`Payment_Election_Rule_Country_Type`, ''), 'Payment_Election_Rule_Country_Type', NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Currency_ID`, '') != IFNULL(qa.`Payment_Election_Rule_Currency_ID`, ''), 'Payment_Election_Rule_Currency_ID', NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Currency_ID_Type`, '') != IFNULL(qa.`Payment_Election_Rule_Currency_ID_Type`, ''), 'Payment_Election_Rule_Currency_ID_Type', NULL),
          IF(IFNULL(dev.`Payment_Type_Reference_ID`, '') != IFNULL(qa.`Payment_Type_Reference_ID`, ''), 'Payment_Type_Reference_ID', NULL),
          IF(IFNULL(dev.`Payment_Type_Reference_ID_Type`, '') != IFNULL(qa.`Payment_Type_Reference_ID_Type`, ''), 'Payment_Type_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Bank_Account_Country_Reference_ID`, '') != IFNULL(qa.`Bank_Account_Country_Reference_ID`, ''), 'Bank_Account_Country_Reference_ID', NULL),
          IF(IFNULL(dev.`Bank_Account_Country_Reference_ID_Type`, '') != IFNULL(qa.`Bank_Account_Country_Reference_ID_Type`, ''), 'Bank_Account_Country_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Bank_Account_Currency_Reference_ID`, '') != IFNULL(qa.`Bank_Account_Currency_Reference_ID`, ''), 'Bank_Account_Currency_Reference_ID', NULL),
          IF(IFNULL(dev.`Bank_Account_Currency_Reference_ID_Type`, '') != IFNULL(qa.`Bank_Account_Currency_Reference_ID_Type`, ''), 'Bank_Account_Currency_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Bank_Account_Nickname`, '') != IFNULL(qa.`Bank_Account_Nickname`, ''), 'Bank_Account_Nickname', NULL),
          IF(IFNULL(dev.`Bank_Account_Name`, '') != IFNULL(qa.`Bank_Account_Name`, ''), 'Bank_Account_Name', NULL),
          IF(IFNULL(dev.`Bank_Account_Number`, '') != IFNULL(qa.`Bank_Account_Number`, ''), 'Bank_Account_Number', NULL),
          IF(IFNULL(dev.`Roll_Number`, '') != IFNULL(qa.`Roll_Number`, ''), 'Roll_Number', NULL),
          IF(IFNULL(dev.`Bank_Account_Type_Code`, '') != IFNULL(qa.`Bank_Account_Type_Code`, ''), 'Bank_Account_Type_Code', NULL),
          IF(IFNULL(dev.`Bank_Account_Type_Reference_ID`, '') != IFNULL(qa.`Bank_Account_Type_Reference_ID`, ''), 'Bank_Account_Type_Reference_ID', NULL),
          IF(IFNULL(dev.`Bank_Account_Type_Reference_ID_Type`, '') != IFNULL(qa.`Bank_Account_Type_Reference_ID_Type`, ''), 'Bank_Account_Type_Reference_ID_Type', NULL),
          IF(IFNULL(dev.`Bank_Name`, '') != IFNULL(qa.`Bank_Name`, ''), 'Bank_Name', NULL),
          IF(IFNULL(dev.`Bank_Account_IBAN`, '') != IFNULL(qa.`Bank_Account_IBAN`, ''), 'Bank_Account_IBAN', NULL),
          IF(IFNULL(dev.`Bank_Account_ID_Number`, '') != IFNULL(qa.`Bank_Account_ID_Number`, ''), 'Bank_Account_ID_Number', NULL),
          IF(IFNULL(dev.`Bank_Account_BIC`, '') != IFNULL(qa.`Bank_Account_BIC`, ''), 'Bank_Account_BIC', NULL),
          IF(IFNULL(dev.`Bank_Account_Branch_Name`, '') != IFNULL(qa.`Bank_Account_Branch_Name`, ''), 'Bank_Account_Branch_Name', NULL),
          IF(IFNULL(dev.`Bank_Account_Branch_ID_Number`, '') != IFNULL(qa.`Bank_Account_Branch_ID_Number`, ''), 'Bank_Account_Branch_ID_Number', NULL),
          IF(IFNULL(dev.`Bank_Account_Check_Digit`, '') != IFNULL(qa.`Bank_Account_Check_Digit`, ''), 'Bank_Account_Check_Digit', NULL),
          IF(IFNULL(dev.`Distribution_Amount`, '') != IFNULL(qa.`Distribution_Amount`, ''), 'Distribution_Amount', NULL),
          IF(IFNULL(dev.`Distribution_Percentage`, '') != IFNULL(qa.`Distribution_Percentage`, ''), 'Distribution_Percentage', NULL),
          IF(IFNULL(dev.`Distribution_Balance`, '') != IFNULL(qa.`Distribution_Balance`, ''), 'Distribution_Balance', NULL)
        ]) AS col WITH OFFSET AS ordinal
        WHERE col IS NOT NULL
      ) AS Changed_Columns,
      (
        SELECT STRING_AGG(col, ', ' ORDER BY ordinal)
        FROM UNNEST([
          IF(IFNULL(dev.`Retain_Unused_Worker_Bank_Accounts`, '') != IFNULL(qa.`Retain_Unused_Worker_Bank_Accounts`, ''), CONCAT('Retain_Unused_Worker_Bank_Accounts:', IFNULL(qa.`Retain_Unused_Worker_Bank_Accounts`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Reference_ID`, '') != IFNULL(qa.`Worker_Reference_ID`, ''), CONCAT('Worker_Reference_ID:', IFNULL(qa.`Worker_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Reference_ID_Type`, ''), CONCAT('Worker_Reference_ID_Type:', IFNULL(qa.`Worker_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Country_Reference_ID`, '') != IFNULL(qa.`Worker_Country_Reference_ID`, ''), CONCAT('Worker_Country_Reference_ID:', IFNULL(qa.`Worker_Country_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Country_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Country_Reference_ID_Type`, ''), CONCAT('Worker_Country_Reference_ID_Type:', IFNULL(qa.`Worker_Country_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Currency_Reference_ID`, '') != IFNULL(qa.`Worker_Currency_Reference_ID`, ''), CONCAT('Worker_Currency_Reference_ID:', IFNULL(qa.`Worker_Currency_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Worker_Currency_Reference_ID_Type`, '') != IFNULL(qa.`Worker_Currency_Reference_ID_Type`, ''), CONCAT('Worker_Currency_Reference_ID_Type:', IFNULL(qa.`Worker_Currency_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Election_Higher_Order_Rule_ID_Type`, '') != IFNULL(qa.`Payment_Election_Higher_Order_Rule_ID_Type`, ''), CONCAT('Payment_Election_Higher_Order_Rule_ID_Type:', IFNULL(qa.`Payment_Election_Higher_Order_Rule_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_ID_Type`, '') != IFNULL(qa.`Payment_Election_Rule_ID_Type`, ''), CONCAT('Payment_Election_Rule_ID_Type:', IFNULL(qa.`Payment_Election_Rule_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Country`, '') != IFNULL(qa.`Payment_Election_Rule_Country`, ''), CONCAT('Payment_Election_Rule_Country:', IFNULL(qa.`Payment_Election_Rule_Country`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Country_Type`, '') != IFNULL(qa.`Payment_Election_Rule_Country_Type`, ''), CONCAT('Payment_Election_Rule_Country_Type:', IFNULL(qa.`Payment_Election_Rule_Country_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Currency_ID`, '') != IFNULL(qa.`Payment_Election_Rule_Currency_ID`, ''), CONCAT('Payment_Election_Rule_Currency_ID:', IFNULL(qa.`Payment_Election_Rule_Currency_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Election_Rule_Currency_ID_Type`, '') != IFNULL(qa.`Payment_Election_Rule_Currency_ID_Type`, ''), CONCAT('Payment_Election_Rule_Currency_ID_Type:', IFNULL(qa.`Payment_Election_Rule_Currency_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Type_Reference_ID`, '') != IFNULL(qa.`Payment_Type_Reference_ID`, ''), CONCAT('Payment_Type_Reference_ID:', IFNULL(qa.`Payment_Type_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Payment_Type_Reference_ID_Type`, '') != IFNULL(qa.`Payment_Type_Reference_ID_Type`, ''), CONCAT('Payment_Type_Reference_ID_Type:', IFNULL(qa.`Payment_Type_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Country_Reference_ID`, '') != IFNULL(qa.`Bank_Account_Country_Reference_ID`, ''), CONCAT('Bank_Account_Country_Reference_ID:', IFNULL(qa.`Bank_Account_Country_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Country_Reference_ID_Type`, '') != IFNULL(qa.`Bank_Account_Country_Reference_ID_Type`, ''), CONCAT('Bank_Account_Country_Reference_ID_Type:', IFNULL(qa.`Bank_Account_Country_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Currency_Reference_ID`, '') != IFNULL(qa.`Bank_Account_Currency_Reference_ID`, ''), CONCAT('Bank_Account_Currency_Reference_ID:', IFNULL(qa.`Bank_Account_Currency_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Currency_Reference_ID_Type`, '') != IFNULL(qa.`Bank_Account_Currency_Reference_ID_Type`, ''), CONCAT('Bank_Account_Currency_Reference_ID_Type:', IFNULL(qa.`Bank_Account_Currency_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Nickname`, '') != IFNULL(qa.`Bank_Account_Nickname`, ''), CONCAT('Bank_Account_Nickname:', IFNULL(qa.`Bank_Account_Nickname`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Name`, '') != IFNULL(qa.`Bank_Account_Name`, ''), CONCAT('Bank_Account_Name:', IFNULL(qa.`Bank_Account_Name`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Number`, '') != IFNULL(qa.`Bank_Account_Number`, ''), CONCAT('Bank_Account_Number:', IFNULL(qa.`Bank_Account_Number`, 'NULL')), NULL),
          IF(IFNULL(dev.`Roll_Number`, '') != IFNULL(qa.`Roll_Number`, ''), CONCAT('Roll_Number:', IFNULL(qa.`Roll_Number`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Type_Code`, '') != IFNULL(qa.`Bank_Account_Type_Code`, ''), CONCAT('Bank_Account_Type_Code:', IFNULL(qa.`Bank_Account_Type_Code`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Type_Reference_ID`, '') != IFNULL(qa.`Bank_Account_Type_Reference_ID`, ''), CONCAT('Bank_Account_Type_Reference_ID:', IFNULL(qa.`Bank_Account_Type_Reference_ID`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Type_Reference_ID_Type`, '') != IFNULL(qa.`Bank_Account_Type_Reference_ID_Type`, ''), CONCAT('Bank_Account_Type_Reference_ID_Type:', IFNULL(qa.`Bank_Account_Type_Reference_ID_Type`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Name`, '') != IFNULL(qa.`Bank_Name`, ''), CONCAT('Bank_Name:', IFNULL(qa.`Bank_Name`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_IBAN`, '') != IFNULL(qa.`Bank_Account_IBAN`, ''), CONCAT('Bank_Account_IBAN:', IFNULL(qa.`Bank_Account_IBAN`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_ID_Number`, '') != IFNULL(qa.`Bank_Account_ID_Number`, ''), CONCAT('Bank_Account_ID_Number:', IFNULL(qa.`Bank_Account_ID_Number`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_BIC`, '') != IFNULL(qa.`Bank_Account_BIC`, ''), CONCAT('Bank_Account_BIC:', IFNULL(qa.`Bank_Account_BIC`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Branch_Name`, '') != IFNULL(qa.`Bank_Account_Branch_Name`, ''), CONCAT('Bank_Account_Branch_Name:', IFNULL(qa.`Bank_Account_Branch_Name`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Branch_ID_Number`, '') != IFNULL(qa.`Bank_Account_Branch_ID_Number`, ''), CONCAT('Bank_Account_Branch_ID_Number:', IFNULL(qa.`Bank_Account_Branch_ID_Number`, 'NULL')), NULL),
          IF(IFNULL(dev.`Bank_Account_Check_Digit`, '') != IFNULL(qa.`Bank_Account_Check_Digit`, ''), CONCAT('Bank_Account_Check_Digit:', IFNULL(qa.`Bank_Account_Check_Digit`, 'NULL')), NULL),
          IF(IFNULL(dev.`Distribution_Amount`, '') != IFNULL(qa.`Distribution_Amount`, ''), CONCAT('Distribution_Amount:', IFNULL(qa.`Distribution_Amount`, 'NULL')), NULL),
          IF(IFNULL(dev.`Distribution_Percentage`, '') != IFNULL(qa.`Distribution_Percentage`, ''), CONCAT('Distribution_Percentage:', IFNULL(qa.`Distribution_Percentage`, 'NULL')), NULL),
          IF(IFNULL(dev.`Distribution_Balance`, '') != IFNULL(qa.`Distribution_Balance`, ''), CONCAT('Distribution_Balance:', IFNULL(qa.`Distribution_Balance`, 'NULL')), NULL)
        ]) AS col WITH OFFSET AS ordinal
        WHERE col IS NOT NULL
      ) AS Old_Values,
      dev.`Retain_Unused_Worker_Bank_Accounts`,
    dev.`Worker_Reference_ID`,
    dev.`Worker_Reference_ID_Type`,
    dev.`Worker_Country_Reference_ID`,
    dev.`Worker_Country_Reference_ID_Type`,
    dev.`Worker_Currency_Reference_ID`,
    dev.`Worker_Currency_Reference_ID_Type`,
    dev.`Payment_Election_Higher_Order_Rule_ID`,
    dev.`Payment_Election_Higher_Order_Rule_ID_Type`,
    dev.`Election_Order`,
    dev.`Payment_Election_Rule_ID`,
    dev.`Payment_Election_Rule_ID_Type`,
    dev.`Payment_Election_Rule_Country`,
    dev.`Payment_Election_Rule_Country_Type`,
    dev.`Payment_Election_Rule_Currency_ID`,
    dev.`Payment_Election_Rule_Currency_ID_Type`,
    dev.`Payment_Type_Reference_ID`,
    dev.`Payment_Type_Reference_ID_Type`,
    dev.`Bank_Account_Country_Reference_ID`,
    dev.`Bank_Account_Country_Reference_ID_Type`,
    dev.`Bank_Account_Currency_Reference_ID`,
    dev.`Bank_Account_Currency_Reference_ID_Type`,
    dev.`Bank_Account_Nickname`,
    dev.`Bank_Account_Name`,
    dev.`Bank_Account_Number`,
    dev.`Roll_Number`,
    dev.`Bank_Account_Type_Code`,
    dev.`Bank_Account_Type_Reference_ID`,
    dev.`Bank_Account_Type_Reference_ID_Type`,
    dev.`Bank_Name`,
    dev.`Bank_Account_IBAN`,
    dev.`Bank_Account_ID_Number`,
    dev.`Bank_Account_BIC`,
    dev.`Bank_Account_Branch_Name`,
    dev.`Bank_Account_Branch_ID_Number`,
    dev.`Bank_Account_Check_Digit`,
    dev.`Distribution_Amount`,
    dev.`Distribution_Percentage`,
    dev.`Distribution_Balance`,
    dev.`LegacySystem`,
    dev.`LegacyID`
    FROM dev
    INNER JOIN qa ON dev.`LegacySystem` IS NOT DISTINCT FROM qa.`LegacySystem`
      AND dev.`LegacyID` IS NOT DISTINCT FROM qa.`LegacyID`
      AND dev.`Payment_Election_Higher_Order_Rule_ID` IS NOT DISTINCT FROM qa.`Payment_Election_Higher_Order_Rule_ID`
      AND dev.`Payment_Election_Rule_ID` IS NOT DISTINCT FROM qa.`Payment_Election_Rule_ID`
      AND dev.`Election_Order` IS NOT DISTINCT FROM qa.`Election_Order`
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
