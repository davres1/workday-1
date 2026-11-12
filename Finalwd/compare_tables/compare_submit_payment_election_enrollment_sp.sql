-- QA is the older baseline; DEV is the current state.
-- Match on: LegacySystem, LegacyID, Payment_Election_Higher_Order_Rule_ID, Payment_Election_Rule_ID, Election_Order.
-- Duplicate keys: remove identical copies first, then pair remaining rows by full-row sort.
-- Without a unique row ID, pairing multiple changed rows within one key is deterministic but inferred.
-- As in compare_example.sql, NULL and empty non-key values compare as equal.
-- Run after creating this procedure:
-- CALL `prj-dev-ss-oneerp.oneerp.prc_compare_submit_payment_election_enrollment`();
CREATE OR REPLACE PROCEDURE `prj-dev-ss-oneerp.oneerp.prc_compare_submit_payment_election_enrollment`()
BEGIN
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
  -- Cancel identical rows one-for-one, including repeated copies.
  qa_numbered AS (
    SELECT src.*,
      ROW_NUMBER() OVER (
        PARTITION BY IFNULL(src.`Retain_Unused_Worker_Bank_Accounts`, ''),
        IFNULL(src.`Worker_Reference_ID`, ''),
        IFNULL(src.`Worker_Reference_ID_Type`, ''),
        IFNULL(src.`Worker_Country_Reference_ID`, ''),
        IFNULL(src.`Worker_Country_Reference_ID_Type`, ''),
        IFNULL(src.`Worker_Currency_Reference_ID`, ''),
        IFNULL(src.`Worker_Currency_Reference_ID_Type`, ''),
        src.`Payment_Election_Higher_Order_Rule_ID`,
        IFNULL(src.`Payment_Election_Higher_Order_Rule_ID_Type`, ''),
        src.`Election_Order`,
        src.`Payment_Election_Rule_ID`,
        IFNULL(src.`Payment_Election_Rule_ID_Type`, ''),
        IFNULL(src.`Payment_Election_Rule_Country`, ''),
        IFNULL(src.`Payment_Election_Rule_Country_Type`, ''),
        IFNULL(src.`Payment_Election_Rule_Currency_ID`, ''),
        IFNULL(src.`Payment_Election_Rule_Currency_ID_Type`, ''),
        IFNULL(src.`Payment_Type_Reference_ID`, ''),
        IFNULL(src.`Payment_Type_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Account_Country_Reference_ID`, ''),
        IFNULL(src.`Bank_Account_Country_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Account_Currency_Reference_ID`, ''),
        IFNULL(src.`Bank_Account_Currency_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Account_Nickname`, ''),
        IFNULL(src.`Bank_Account_Name`, ''),
        IFNULL(src.`Bank_Account_Number`, ''),
        IFNULL(src.`Roll_Number`, ''),
        IFNULL(src.`Bank_Account_Type_Code`, ''),
        IFNULL(src.`Bank_Account_Type_Reference_ID`, ''),
        IFNULL(src.`Bank_Account_Type_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Name`, ''),
        IFNULL(src.`Bank_Account_IBAN`, ''),
        IFNULL(src.`Bank_Account_ID_Number`, ''),
        IFNULL(src.`Bank_Account_BIC`, ''),
        IFNULL(src.`Bank_Account_Branch_Name`, ''),
        IFNULL(src.`Bank_Account_Branch_ID_Number`, ''),
        IFNULL(src.`Bank_Account_Check_Digit`, ''),
        IFNULL(src.`Distribution_Amount`, ''),
        IFNULL(src.`Distribution_Percentage`, ''),
        IFNULL(src.`Distribution_Balance`, ''),
        src.`LegacySystem`,
        src.`LegacyID`
        ORDER BY TO_JSON_STRING(src)
      ) AS exact_occurrence
    FROM `prj-qa-ss-oneerp.oneerp.process_submit_payment_election_enrollment` AS src
  ),
  dev_numbered AS (
    SELECT src.*,
      ROW_NUMBER() OVER (
        PARTITION BY IFNULL(src.`Retain_Unused_Worker_Bank_Accounts`, ''),
        IFNULL(src.`Worker_Reference_ID`, ''),
        IFNULL(src.`Worker_Reference_ID_Type`, ''),
        IFNULL(src.`Worker_Country_Reference_ID`, ''),
        IFNULL(src.`Worker_Country_Reference_ID_Type`, ''),
        IFNULL(src.`Worker_Currency_Reference_ID`, ''),
        IFNULL(src.`Worker_Currency_Reference_ID_Type`, ''),
        src.`Payment_Election_Higher_Order_Rule_ID`,
        IFNULL(src.`Payment_Election_Higher_Order_Rule_ID_Type`, ''),
        src.`Election_Order`,
        src.`Payment_Election_Rule_ID`,
        IFNULL(src.`Payment_Election_Rule_ID_Type`, ''),
        IFNULL(src.`Payment_Election_Rule_Country`, ''),
        IFNULL(src.`Payment_Election_Rule_Country_Type`, ''),
        IFNULL(src.`Payment_Election_Rule_Currency_ID`, ''),
        IFNULL(src.`Payment_Election_Rule_Currency_ID_Type`, ''),
        IFNULL(src.`Payment_Type_Reference_ID`, ''),
        IFNULL(src.`Payment_Type_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Account_Country_Reference_ID`, ''),
        IFNULL(src.`Bank_Account_Country_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Account_Currency_Reference_ID`, ''),
        IFNULL(src.`Bank_Account_Currency_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Account_Nickname`, ''),
        IFNULL(src.`Bank_Account_Name`, ''),
        IFNULL(src.`Bank_Account_Number`, ''),
        IFNULL(src.`Roll_Number`, ''),
        IFNULL(src.`Bank_Account_Type_Code`, ''),
        IFNULL(src.`Bank_Account_Type_Reference_ID`, ''),
        IFNULL(src.`Bank_Account_Type_Reference_ID_Type`, ''),
        IFNULL(src.`Bank_Name`, ''),
        IFNULL(src.`Bank_Account_IBAN`, ''),
        IFNULL(src.`Bank_Account_ID_Number`, ''),
        IFNULL(src.`Bank_Account_BIC`, ''),
        IFNULL(src.`Bank_Account_Branch_Name`, ''),
        IFNULL(src.`Bank_Account_Branch_ID_Number`, ''),
        IFNULL(src.`Bank_Account_Check_Digit`, ''),
        IFNULL(src.`Distribution_Amount`, ''),
        IFNULL(src.`Distribution_Percentage`, ''),
        IFNULL(src.`Distribution_Balance`, ''),
        src.`LegacySystem`,
        src.`LegacyID`
        ORDER BY TO_JSON_STRING(src)
      ) AS exact_occurrence
    FROM `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment` AS src
  ),
  dev_unmatched AS (
    SELECT d.*
    FROM dev_numbered AS d
    WHERE NOT EXISTS (
      SELECT 1 FROM qa_numbered AS q
      WHERE d.exact_occurrence = q.exact_occurrence
        AND (IFNULL(d.`Retain_Unused_Worker_Bank_Accounts`, '') = IFNULL(q.`Retain_Unused_Worker_Bank_Accounts`, '') OR (IFNULL(d.`Retain_Unused_Worker_Bank_Accounts`, '') IS NULL AND IFNULL(q.`Retain_Unused_Worker_Bank_Accounts`, '') IS NULL))
        AND (IFNULL(d.`Worker_Reference_ID`, '') = IFNULL(q.`Worker_Reference_ID`, '') OR (IFNULL(d.`Worker_Reference_ID`, '') IS NULL AND IFNULL(q.`Worker_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Worker_Reference_ID_Type`, '') = IFNULL(q.`Worker_Reference_ID_Type`, '') OR (IFNULL(d.`Worker_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Worker_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Worker_Country_Reference_ID`, '') = IFNULL(q.`Worker_Country_Reference_ID`, '') OR (IFNULL(d.`Worker_Country_Reference_ID`, '') IS NULL AND IFNULL(q.`Worker_Country_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Worker_Country_Reference_ID_Type`, '') = IFNULL(q.`Worker_Country_Reference_ID_Type`, '') OR (IFNULL(d.`Worker_Country_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Worker_Country_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Worker_Currency_Reference_ID`, '') = IFNULL(q.`Worker_Currency_Reference_ID`, '') OR (IFNULL(d.`Worker_Currency_Reference_ID`, '') IS NULL AND IFNULL(q.`Worker_Currency_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Worker_Currency_Reference_ID_Type`, '') = IFNULL(q.`Worker_Currency_Reference_ID_Type`, '') OR (IFNULL(d.`Worker_Currency_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Worker_Currency_Reference_ID_Type`, '') IS NULL))
        AND (d.`Payment_Election_Higher_Order_Rule_ID` = q.`Payment_Election_Higher_Order_Rule_ID` OR (d.`Payment_Election_Higher_Order_Rule_ID` IS NULL AND q.`Payment_Election_Higher_Order_Rule_ID` IS NULL))
        AND (IFNULL(d.`Payment_Election_Higher_Order_Rule_ID_Type`, '') = IFNULL(q.`Payment_Election_Higher_Order_Rule_ID_Type`, '') OR (IFNULL(d.`Payment_Election_Higher_Order_Rule_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Higher_Order_Rule_ID_Type`, '') IS NULL))
        AND (d.`Election_Order` = q.`Election_Order` OR (d.`Election_Order` IS NULL AND q.`Election_Order` IS NULL))
        AND (d.`Payment_Election_Rule_ID` = q.`Payment_Election_Rule_ID` OR (d.`Payment_Election_Rule_ID` IS NULL AND q.`Payment_Election_Rule_ID` IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_ID_Type`, '') = IFNULL(q.`Payment_Election_Rule_ID_Type`, '') OR (IFNULL(d.`Payment_Election_Rule_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Country`, '') = IFNULL(q.`Payment_Election_Rule_Country`, '') OR (IFNULL(d.`Payment_Election_Rule_Country`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Country`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Country_Type`, '') = IFNULL(q.`Payment_Election_Rule_Country_Type`, '') OR (IFNULL(d.`Payment_Election_Rule_Country_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Country_Type`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Currency_ID`, '') = IFNULL(q.`Payment_Election_Rule_Currency_ID`, '') OR (IFNULL(d.`Payment_Election_Rule_Currency_ID`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Currency_ID`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Currency_ID_Type`, '') = IFNULL(q.`Payment_Election_Rule_Currency_ID_Type`, '') OR (IFNULL(d.`Payment_Election_Rule_Currency_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Currency_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Payment_Type_Reference_ID`, '') = IFNULL(q.`Payment_Type_Reference_ID`, '') OR (IFNULL(d.`Payment_Type_Reference_ID`, '') IS NULL AND IFNULL(q.`Payment_Type_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Payment_Type_Reference_ID_Type`, '') = IFNULL(q.`Payment_Type_Reference_ID_Type`, '') OR (IFNULL(d.`Payment_Type_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Type_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Country_Reference_ID`, '') = IFNULL(q.`Bank_Account_Country_Reference_ID`, '') OR (IFNULL(d.`Bank_Account_Country_Reference_ID`, '') IS NULL AND IFNULL(q.`Bank_Account_Country_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Country_Reference_ID_Type`, '') = IFNULL(q.`Bank_Account_Country_Reference_ID_Type`, '') OR (IFNULL(d.`Bank_Account_Country_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Bank_Account_Country_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Currency_Reference_ID`, '') = IFNULL(q.`Bank_Account_Currency_Reference_ID`, '') OR (IFNULL(d.`Bank_Account_Currency_Reference_ID`, '') IS NULL AND IFNULL(q.`Bank_Account_Currency_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Currency_Reference_ID_Type`, '') = IFNULL(q.`Bank_Account_Currency_Reference_ID_Type`, '') OR (IFNULL(d.`Bank_Account_Currency_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Bank_Account_Currency_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Nickname`, '') = IFNULL(q.`Bank_Account_Nickname`, '') OR (IFNULL(d.`Bank_Account_Nickname`, '') IS NULL AND IFNULL(q.`Bank_Account_Nickname`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Name`, '') = IFNULL(q.`Bank_Account_Name`, '') OR (IFNULL(d.`Bank_Account_Name`, '') IS NULL AND IFNULL(q.`Bank_Account_Name`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Number`, '') = IFNULL(q.`Bank_Account_Number`, '') OR (IFNULL(d.`Bank_Account_Number`, '') IS NULL AND IFNULL(q.`Bank_Account_Number`, '') IS NULL))
        AND (IFNULL(d.`Roll_Number`, '') = IFNULL(q.`Roll_Number`, '') OR (IFNULL(d.`Roll_Number`, '') IS NULL AND IFNULL(q.`Roll_Number`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Type_Code`, '') = IFNULL(q.`Bank_Account_Type_Code`, '') OR (IFNULL(d.`Bank_Account_Type_Code`, '') IS NULL AND IFNULL(q.`Bank_Account_Type_Code`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Type_Reference_ID`, '') = IFNULL(q.`Bank_Account_Type_Reference_ID`, '') OR (IFNULL(d.`Bank_Account_Type_Reference_ID`, '') IS NULL AND IFNULL(q.`Bank_Account_Type_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Type_Reference_ID_Type`, '') = IFNULL(q.`Bank_Account_Type_Reference_ID_Type`, '') OR (IFNULL(d.`Bank_Account_Type_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Bank_Account_Type_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Name`, '') = IFNULL(q.`Bank_Name`, '') OR (IFNULL(d.`Bank_Name`, '') IS NULL AND IFNULL(q.`Bank_Name`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_IBAN`, '') = IFNULL(q.`Bank_Account_IBAN`, '') OR (IFNULL(d.`Bank_Account_IBAN`, '') IS NULL AND IFNULL(q.`Bank_Account_IBAN`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_ID_Number`, '') = IFNULL(q.`Bank_Account_ID_Number`, '') OR (IFNULL(d.`Bank_Account_ID_Number`, '') IS NULL AND IFNULL(q.`Bank_Account_ID_Number`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_BIC`, '') = IFNULL(q.`Bank_Account_BIC`, '') OR (IFNULL(d.`Bank_Account_BIC`, '') IS NULL AND IFNULL(q.`Bank_Account_BIC`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Branch_Name`, '') = IFNULL(q.`Bank_Account_Branch_Name`, '') OR (IFNULL(d.`Bank_Account_Branch_Name`, '') IS NULL AND IFNULL(q.`Bank_Account_Branch_Name`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Branch_ID_Number`, '') = IFNULL(q.`Bank_Account_Branch_ID_Number`, '') OR (IFNULL(d.`Bank_Account_Branch_ID_Number`, '') IS NULL AND IFNULL(q.`Bank_Account_Branch_ID_Number`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Check_Digit`, '') = IFNULL(q.`Bank_Account_Check_Digit`, '') OR (IFNULL(d.`Bank_Account_Check_Digit`, '') IS NULL AND IFNULL(q.`Bank_Account_Check_Digit`, '') IS NULL))
        AND (IFNULL(d.`Distribution_Amount`, '') = IFNULL(q.`Distribution_Amount`, '') OR (IFNULL(d.`Distribution_Amount`, '') IS NULL AND IFNULL(q.`Distribution_Amount`, '') IS NULL))
        AND (IFNULL(d.`Distribution_Percentage`, '') = IFNULL(q.`Distribution_Percentage`, '') OR (IFNULL(d.`Distribution_Percentage`, '') IS NULL AND IFNULL(q.`Distribution_Percentage`, '') IS NULL))
        AND (IFNULL(d.`Distribution_Balance`, '') = IFNULL(q.`Distribution_Balance`, '') OR (IFNULL(d.`Distribution_Balance`, '') IS NULL AND IFNULL(q.`Distribution_Balance`, '') IS NULL))
        AND (d.`LegacySystem` = q.`LegacySystem` OR (d.`LegacySystem` IS NULL AND q.`LegacySystem` IS NULL))
        AND (d.`LegacyID` = q.`LegacyID` OR (d.`LegacyID` IS NULL AND q.`LegacyID` IS NULL))
    )
  ),
  qa_unmatched AS (
    SELECT q.*
    FROM qa_numbered AS q
    WHERE NOT EXISTS (
      SELECT 1 FROM dev_numbered AS d
      WHERE d.exact_occurrence = q.exact_occurrence
        AND (IFNULL(d.`Retain_Unused_Worker_Bank_Accounts`, '') = IFNULL(q.`Retain_Unused_Worker_Bank_Accounts`, '') OR (IFNULL(d.`Retain_Unused_Worker_Bank_Accounts`, '') IS NULL AND IFNULL(q.`Retain_Unused_Worker_Bank_Accounts`, '') IS NULL))
        AND (IFNULL(d.`Worker_Reference_ID`, '') = IFNULL(q.`Worker_Reference_ID`, '') OR (IFNULL(d.`Worker_Reference_ID`, '') IS NULL AND IFNULL(q.`Worker_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Worker_Reference_ID_Type`, '') = IFNULL(q.`Worker_Reference_ID_Type`, '') OR (IFNULL(d.`Worker_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Worker_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Worker_Country_Reference_ID`, '') = IFNULL(q.`Worker_Country_Reference_ID`, '') OR (IFNULL(d.`Worker_Country_Reference_ID`, '') IS NULL AND IFNULL(q.`Worker_Country_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Worker_Country_Reference_ID_Type`, '') = IFNULL(q.`Worker_Country_Reference_ID_Type`, '') OR (IFNULL(d.`Worker_Country_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Worker_Country_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Worker_Currency_Reference_ID`, '') = IFNULL(q.`Worker_Currency_Reference_ID`, '') OR (IFNULL(d.`Worker_Currency_Reference_ID`, '') IS NULL AND IFNULL(q.`Worker_Currency_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Worker_Currency_Reference_ID_Type`, '') = IFNULL(q.`Worker_Currency_Reference_ID_Type`, '') OR (IFNULL(d.`Worker_Currency_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Worker_Currency_Reference_ID_Type`, '') IS NULL))
        AND (d.`Payment_Election_Higher_Order_Rule_ID` = q.`Payment_Election_Higher_Order_Rule_ID` OR (d.`Payment_Election_Higher_Order_Rule_ID` IS NULL AND q.`Payment_Election_Higher_Order_Rule_ID` IS NULL))
        AND (IFNULL(d.`Payment_Election_Higher_Order_Rule_ID_Type`, '') = IFNULL(q.`Payment_Election_Higher_Order_Rule_ID_Type`, '') OR (IFNULL(d.`Payment_Election_Higher_Order_Rule_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Higher_Order_Rule_ID_Type`, '') IS NULL))
        AND (d.`Election_Order` = q.`Election_Order` OR (d.`Election_Order` IS NULL AND q.`Election_Order` IS NULL))
        AND (d.`Payment_Election_Rule_ID` = q.`Payment_Election_Rule_ID` OR (d.`Payment_Election_Rule_ID` IS NULL AND q.`Payment_Election_Rule_ID` IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_ID_Type`, '') = IFNULL(q.`Payment_Election_Rule_ID_Type`, '') OR (IFNULL(d.`Payment_Election_Rule_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Country`, '') = IFNULL(q.`Payment_Election_Rule_Country`, '') OR (IFNULL(d.`Payment_Election_Rule_Country`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Country`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Country_Type`, '') = IFNULL(q.`Payment_Election_Rule_Country_Type`, '') OR (IFNULL(d.`Payment_Election_Rule_Country_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Country_Type`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Currency_ID`, '') = IFNULL(q.`Payment_Election_Rule_Currency_ID`, '') OR (IFNULL(d.`Payment_Election_Rule_Currency_ID`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Currency_ID`, '') IS NULL))
        AND (IFNULL(d.`Payment_Election_Rule_Currency_ID_Type`, '') = IFNULL(q.`Payment_Election_Rule_Currency_ID_Type`, '') OR (IFNULL(d.`Payment_Election_Rule_Currency_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Election_Rule_Currency_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Payment_Type_Reference_ID`, '') = IFNULL(q.`Payment_Type_Reference_ID`, '') OR (IFNULL(d.`Payment_Type_Reference_ID`, '') IS NULL AND IFNULL(q.`Payment_Type_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Payment_Type_Reference_ID_Type`, '') = IFNULL(q.`Payment_Type_Reference_ID_Type`, '') OR (IFNULL(d.`Payment_Type_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Payment_Type_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Country_Reference_ID`, '') = IFNULL(q.`Bank_Account_Country_Reference_ID`, '') OR (IFNULL(d.`Bank_Account_Country_Reference_ID`, '') IS NULL AND IFNULL(q.`Bank_Account_Country_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Country_Reference_ID_Type`, '') = IFNULL(q.`Bank_Account_Country_Reference_ID_Type`, '') OR (IFNULL(d.`Bank_Account_Country_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Bank_Account_Country_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Currency_Reference_ID`, '') = IFNULL(q.`Bank_Account_Currency_Reference_ID`, '') OR (IFNULL(d.`Bank_Account_Currency_Reference_ID`, '') IS NULL AND IFNULL(q.`Bank_Account_Currency_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Currency_Reference_ID_Type`, '') = IFNULL(q.`Bank_Account_Currency_Reference_ID_Type`, '') OR (IFNULL(d.`Bank_Account_Currency_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Bank_Account_Currency_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Nickname`, '') = IFNULL(q.`Bank_Account_Nickname`, '') OR (IFNULL(d.`Bank_Account_Nickname`, '') IS NULL AND IFNULL(q.`Bank_Account_Nickname`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Name`, '') = IFNULL(q.`Bank_Account_Name`, '') OR (IFNULL(d.`Bank_Account_Name`, '') IS NULL AND IFNULL(q.`Bank_Account_Name`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Number`, '') = IFNULL(q.`Bank_Account_Number`, '') OR (IFNULL(d.`Bank_Account_Number`, '') IS NULL AND IFNULL(q.`Bank_Account_Number`, '') IS NULL))
        AND (IFNULL(d.`Roll_Number`, '') = IFNULL(q.`Roll_Number`, '') OR (IFNULL(d.`Roll_Number`, '') IS NULL AND IFNULL(q.`Roll_Number`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Type_Code`, '') = IFNULL(q.`Bank_Account_Type_Code`, '') OR (IFNULL(d.`Bank_Account_Type_Code`, '') IS NULL AND IFNULL(q.`Bank_Account_Type_Code`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Type_Reference_ID`, '') = IFNULL(q.`Bank_Account_Type_Reference_ID`, '') OR (IFNULL(d.`Bank_Account_Type_Reference_ID`, '') IS NULL AND IFNULL(q.`Bank_Account_Type_Reference_ID`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Type_Reference_ID_Type`, '') = IFNULL(q.`Bank_Account_Type_Reference_ID_Type`, '') OR (IFNULL(d.`Bank_Account_Type_Reference_ID_Type`, '') IS NULL AND IFNULL(q.`Bank_Account_Type_Reference_ID_Type`, '') IS NULL))
        AND (IFNULL(d.`Bank_Name`, '') = IFNULL(q.`Bank_Name`, '') OR (IFNULL(d.`Bank_Name`, '') IS NULL AND IFNULL(q.`Bank_Name`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_IBAN`, '') = IFNULL(q.`Bank_Account_IBAN`, '') OR (IFNULL(d.`Bank_Account_IBAN`, '') IS NULL AND IFNULL(q.`Bank_Account_IBAN`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_ID_Number`, '') = IFNULL(q.`Bank_Account_ID_Number`, '') OR (IFNULL(d.`Bank_Account_ID_Number`, '') IS NULL AND IFNULL(q.`Bank_Account_ID_Number`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_BIC`, '') = IFNULL(q.`Bank_Account_BIC`, '') OR (IFNULL(d.`Bank_Account_BIC`, '') IS NULL AND IFNULL(q.`Bank_Account_BIC`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Branch_Name`, '') = IFNULL(q.`Bank_Account_Branch_Name`, '') OR (IFNULL(d.`Bank_Account_Branch_Name`, '') IS NULL AND IFNULL(q.`Bank_Account_Branch_Name`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Branch_ID_Number`, '') = IFNULL(q.`Bank_Account_Branch_ID_Number`, '') OR (IFNULL(d.`Bank_Account_Branch_ID_Number`, '') IS NULL AND IFNULL(q.`Bank_Account_Branch_ID_Number`, '') IS NULL))
        AND (IFNULL(d.`Bank_Account_Check_Digit`, '') = IFNULL(q.`Bank_Account_Check_Digit`, '') OR (IFNULL(d.`Bank_Account_Check_Digit`, '') IS NULL AND IFNULL(q.`Bank_Account_Check_Digit`, '') IS NULL))
        AND (IFNULL(d.`Distribution_Amount`, '') = IFNULL(q.`Distribution_Amount`, '') OR (IFNULL(d.`Distribution_Amount`, '') IS NULL AND IFNULL(q.`Distribution_Amount`, '') IS NULL))
        AND (IFNULL(d.`Distribution_Percentage`, '') = IFNULL(q.`Distribution_Percentage`, '') OR (IFNULL(d.`Distribution_Percentage`, '') IS NULL AND IFNULL(q.`Distribution_Percentage`, '') IS NULL))
        AND (IFNULL(d.`Distribution_Balance`, '') = IFNULL(q.`Distribution_Balance`, '') OR (IFNULL(d.`Distribution_Balance`, '') IS NULL AND IFNULL(q.`Distribution_Balance`, '') IS NULL))
        AND (d.`LegacySystem` = q.`LegacySystem` OR (d.`LegacySystem` IS NULL AND q.`LegacySystem` IS NULL))
        AND (d.`LegacyID` = q.`LegacyID` OR (d.`LegacyID` IS NULL AND q.`LegacyID` IS NULL))
    )
  ),
  dev AS (
    SELECT remaining.* EXCEPT (exact_occurrence),
      ROW_NUMBER() OVER (
        PARTITION BY `LegacySystem`, `LegacyID`, `Payment_Election_Higher_Order_Rule_ID`, `Payment_Election_Rule_ID`, `Election_Order`
        ORDER BY TO_JSON_STRING(remaining)
      ) AS comparison_occurrence
    FROM dev_unmatched AS remaining
  ),
  qa AS (
    SELECT remaining.* EXCEPT (exact_occurrence),
      ROW_NUMBER() OVER (
        PARTITION BY `LegacySystem`, `LegacyID`, `Payment_Election_Higher_Order_Rule_ID`, `Payment_Election_Rule_ID`, `Election_Order`
        ORDER BY TO_JSON_STRING(remaining)
      ) AS comparison_occurrence
    FROM qa_unmatched AS remaining
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
      SELECT 1 FROM qa WHERE dev.comparison_occurrence = qa.comparison_occurrence
      AND (dev.`LegacySystem` = qa.`LegacySystem` OR (dev.`LegacySystem` IS NULL AND qa.`LegacySystem` IS NULL))
      AND (dev.`LegacyID` = qa.`LegacyID` OR (dev.`LegacyID` IS NULL AND qa.`LegacyID` IS NULL))
      AND (dev.`Payment_Election_Higher_Order_Rule_ID` = qa.`Payment_Election_Higher_Order_Rule_ID` OR (dev.`Payment_Election_Higher_Order_Rule_ID` IS NULL AND qa.`Payment_Election_Higher_Order_Rule_ID` IS NULL))
      AND (dev.`Payment_Election_Rule_ID` = qa.`Payment_Election_Rule_ID` OR (dev.`Payment_Election_Rule_ID` IS NULL AND qa.`Payment_Election_Rule_ID` IS NULL))
      AND (dev.`Election_Order` = qa.`Election_Order` OR (dev.`Election_Order` IS NULL AND qa.`Election_Order` IS NULL))
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
      SELECT 1 FROM dev WHERE dev.comparison_occurrence = qa.comparison_occurrence
      AND (dev.`LegacySystem` = qa.`LegacySystem` OR (dev.`LegacySystem` IS NULL AND qa.`LegacySystem` IS NULL))
      AND (dev.`LegacyID` = qa.`LegacyID` OR (dev.`LegacyID` IS NULL AND qa.`LegacyID` IS NULL))
      AND (dev.`Payment_Election_Higher_Order_Rule_ID` = qa.`Payment_Election_Higher_Order_Rule_ID` OR (dev.`Payment_Election_Higher_Order_Rule_ID` IS NULL AND qa.`Payment_Election_Higher_Order_Rule_ID` IS NULL))
      AND (dev.`Payment_Election_Rule_ID` = qa.`Payment_Election_Rule_ID` OR (dev.`Payment_Election_Rule_ID` IS NULL AND qa.`Payment_Election_Rule_ID` IS NULL))
      AND (dev.`Election_Order` = qa.`Election_Order` OR (dev.`Election_Order` IS NULL AND qa.`Election_Order` IS NULL))
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
    INNER JOIN qa ON dev.comparison_occurrence = qa.comparison_occurrence
      AND (dev.`LegacySystem` = qa.`LegacySystem` OR (dev.`LegacySystem` IS NULL AND qa.`LegacySystem` IS NULL))
      AND (dev.`LegacyID` = qa.`LegacyID` OR (dev.`LegacyID` IS NULL AND qa.`LegacyID` IS NULL))
      AND (dev.`Payment_Election_Higher_Order_Rule_ID` = qa.`Payment_Election_Higher_Order_Rule_ID` OR (dev.`Payment_Election_Higher_Order_Rule_ID` IS NULL AND qa.`Payment_Election_Higher_Order_Rule_ID` IS NULL))
      AND (dev.`Payment_Election_Rule_ID` = qa.`Payment_Election_Rule_ID` OR (dev.`Payment_Election_Rule_ID` IS NULL AND qa.`Payment_Election_Rule_ID` IS NULL))
      AND (dev.`Election_Order` = qa.`Election_Order` OR (dev.`Election_Order` IS NULL AND qa.`Election_Order` IS NULL))
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
