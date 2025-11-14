-- Initialize process table
DROP TABLE IF EXISTS `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`;
CREATE TABLE `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`(
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

-- Initialize workday delivery table
DROP TABLE IF EXISTS `prj-dev-ss-oneerp.workday.workday_submit_payment_election_enrollment`;
CREATE TABLE `prj-dev-ss-oneerp.workday.workday_submit_payment_election_enrollment` AS
SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`
WHERE 1=0; -- Empty table with same schema

-- Truncate tables
TRUNCATE TABLE `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`;
TRUNCATE TABLE `prj-dev-ss-oneerp.workday.workday_submit_payment_election_enrollment`;

-- Process raw source system tables into the process table
INSERT INTO `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment` (
  Retain_Unused_Worker_Bank_Accounts,
  Worker_Reference_ID,
  Worker_Reference_ID_Type,
  Worker_Country_Reference_ID,
  Worker_Country_Reference_ID_Type,
  Worker_Currency_Reference_ID,
  Worker_Currency_Reference_ID_Type,
  Payment_Election_Higher_Order_Rule_ID,
  Payment_Election_Higher_Order_Rule_ID_Type,
  Election_Order,
  Payment_Election_Rule_ID,
  Payment_Election_Rule_ID_Type,
  Payment_Election_Rule_Country,
  Payment_Election_Rule_Country_Type,
  Payment_Election_Rule_Currency_ID,
  Payment_Election_Rule_Currency_ID_Type,
  Payment_Type_Reference_ID,
  Payment_Type_Reference_ID_Type,
  Bank_Account_Country_Reference_ID,
  Bank_Account_Country_Reference_ID_Type,
  Bank_Account_Currency_Reference_ID,
  Bank_Account_Currency_Reference_ID_Type,
  Bank_Account_Nickname,
  Bank_Account_Name,
  Bank_Account_Number,
  Roll_Number,
  Bank_Account_Type_Code,
  Bank_Account_Type_Reference_ID,
  Bank_Account_Type_Reference_ID_Type,
  Bank_Name,
  Bank_Account_IBAN,
  Bank_Account_ID_Number,
  Bank_Account_BIC,
  Bank_Account_Branch_Name,
  Bank_Account_Branch_ID_Number,
  Bank_Account_Check_Digit,
  Distribution_Amount,
  Distribution_Percentage,
  Distribution_Balance,
  LegacySystem,
  LegacyID
)
WITH
  base_data_chi AS (
    SELECT
      CAST(emp.EMPLOYEE AS STRING) AS LegacyID,
      legacy.WorkForceID AS EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT,
      legacy.SystemIdentifier AS LegacySystem
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON CAST(emp.EMPLOYEE AS STRING) = legacy.LegacyID -- FIX: Cast to STRING
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
      AND legacy.SystemIdentifier = 'CHI/Infor'
  ),
  ranked_data_chi AS (
    SELECT
      EMPLOYEE,
      DEFAULT_FLAG,
      ACH_DIST_NBR,
      DESCRIPTION,
      EBNK_ACCT_NBR,
      EBANK_ID,
      ACCOUNT_TYPE,
      DEPOSIT_AMT,
      NET_PERCENT,
      LegacySystem,
      LegacyID,
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_chi
  ),
  base_data_mtn AS (
    SELECT
      CAST(emp.EMPLOYEE AS STRING) AS LegacyID,
      legacy.WorkForceID AS EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT,
      legacy.SystemIdentifier AS LegacySystem
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_mtn.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_mtn.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON CAST(emp.EMPLOYEE AS STRING) = legacy.LegacyID -- FIX: Cast to STRING
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
      AND legacy.SystemIdentifier = 'MNT'
  ),
  ranked_data_mtn AS (
    SELECT
      EMPLOYEE,
      DEFAULT_FLAG,
      ACH_DIST_NBR,
      DESCRIPTION,
      EBNK_ACCT_NBR,
      EBANK_ID,
      ACCOUNT_TYPE,
      DEPOSIT_AMT,
      NET_PERCENT,
      LegacySystem,
      LegacyID,
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_mtn
  ),
  base_data_sta AS (
    SELECT
      CAST(emp.EMPLOYEE AS STRING) AS LegacyID,
      legacy.WorkForceID AS EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT,
      lce.COUNTRY_CODE,
      legacy.SystemIdentifier AS LegacySystem
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON CAST(emp.EMPLOYEE AS STRING) = legacy.LegacyID -- FIX: Cast to STRING
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
      AND legacy.SystemIdentifier = 'STA'
  ),
  ranked_data_sta AS (
    SELECT
      EMPLOYEE,
      DEFAULT_FLAG,
      ACH_DIST_NBR,
      DESCRIPTION,
      EBNK_ACCT_NBR,
      EBANK_ID,
      ACCOUNT_TYPE,
      DEPOSIT_AMT,
      NET_PERCENT,
      COUNTRY_CODE,
      LegacySystem,
      LegacyID,
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_sta
  ),
  base_data_dh AS (
    SELECT
      CAST(emp.EMPLOYEE AS STRING) AS LegacyID,
      legacy.WorkForceID AS EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT,
      lce.COUNTRY_CODE,
      legacy.SystemIdentifier AS LegacySystem
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_dh.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_dh.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON CAST(emp.EMPLOYEE AS STRING) = legacy.LegacyID -- FIX: Cast to STRING
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
      AND LEFT(emp.EMP_STATUS, 1) NOT IN ('Z', 'T')
      AND legacy.SystemIdentifier = 'DH'
  ),
  ranked_data_dh AS (
    SELECT
      EMPLOYEE,
      DEFAULT_FLAG,
      ACH_DIST_NBR,
      DESCRIPTION,
      EBNK_ACCT_NBR,
      EBANK_ID,
      ACCOUNT_TYPE,
      DEPOSIT_AMT,
      NET_PERCENT,
      COUNTRY_CODE,
      LegacySystem,
      LegacyID,
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_dh
  ),
  base_data_hah AS (
    SELECT
      distrib.EMPLID AS LegacyID,
      legacy.WorkForceID AS EMPLOYEE,
      CASE WHEN distrib.DEPOSIT_TYPE = 'B' THEN 'Y' ELSE 'N' END AS DEFAULT_FLAG,
      distrib.PRIORITY AS ACH_DIST_NBR,
      bank.BANK_NM AS DESCRIPTION,
      distrib.ACCOUNT_NUM AS EBNK_ACCT_NBR,
      distrib.BANK_CD AS EBANK_ID,
      distrib.ACCOUNT_TYPE AS ACCOUNT_TYPE,
      distrib.DEPOSIT_AMT AS DEPOSIT_AMT,
      distrib.AMOUNT_PCT AS NET_PERCENT,
      distrib.COUNTRY_CD AS COUNTRY_CODE,
      distrib.NICK_NAME AS NICKNAME,
      legacy.SystemIdentifier AS LegacySystem
    FROM
      `prj-dev-ss-oneerp.hah_psoft_hrp.ps_dir_dep_distrib` distrib
    LEFT JOIN
      `prj-dev-ss-oneerp.hah_psoft_hrp.ps_bank_ec_tbl` bank
      ON distrib.BANK_CD = bank.BANK_CD
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON distrib.EMPLID = legacy.LegacyID
    WHERE
      legacy.SystemIdentifier = 'H@H'
  ),
  ranked_data_hah AS (
    SELECT
      EMPLOYEE,
      DEFAULT_FLAG,
      ACH_DIST_NBR,
      DESCRIPTION,
      EBNK_ACCT_NBR,
      EBANK_ID,
      ACCOUNT_TYPE,
      DEPOSIT_AMT,
      NET_PERCENT,
      COUNTRY_CODE,
      NICKNAME,
      LegacySystem,
      LegacyID,
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_hah
  ),
  base_data_vmc AS (
    SELECT
      emp.EMPLOYEE_NUMBER AS LegacyID,
      legacy.WorkForceID AS Worker_Reference_ID,
      distrib.Worker_Country_Reference_ID,
      distrib.Worker_Currency_Reference_ID,
      distrib.Payment_Election_Higher_Order_Rule_ID,
      distrib.Election_Order,
      distrib.Payment_Type_Reference_ID,
      distrib.Bank_Account_Country_Reference_ID,
      distrib.Bank_Account_Currency_Reference_ID,
      distrib.Bank_Account_Nickname,
      distrib.Bank_Account_Name,
      distrib.Roll_Number,
      '' as  Bank_Account_Type_Code,
      distrib.Bank_Name,
      distrib.Bank_Account_Number,
      distrib.Bank_Account_ID_Number,
      distrib.Bank_Account_Type_Reference_ID,
      distrib.Bank_Account_IBAN,
      distrib.Bank_Account_BIC,
      distrib.Bank_Account_Branch_Name,
      distrib.Bank_Account_Branch_ID_Number,
      distrib.Bank_Account_Check_Digit,
      distrib.Distribution_Amount,
      distrib.Distribution_Percentage,
      distrib.Distribution_Balance,
      legacy.SystemIdentifier AS LegacySystem
    FROM
      `prj-dev-ss-oneerp.vmmc_erp.vmc_pay_direct_deposit` distrib
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.vmmc_erp.per_all_people_f` emp
      ON emp.EMPLOYEE_NUMBER = distrib.Worker_Reference_ID
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON emp.EMPLOYEE_NUMBER = legacy.LegacyID -- Assumes EMPLOYEE_NUMBER is STRING/LegacyID is STRING
    WHERE
      emp.current_employee_flag = 'Y'
      AND emp.effective_end_date >= CURRENT_DATE()
      AND emp.effective_start_date <= CURRENT_DATE()
      AND legacy.SystemIdentifier = 'VMC'
  ),
  ranked_data_vmc AS (
    SELECT
      Worker_Reference_ID,
      Worker_Country_Reference_ID,
      Worker_Currency_Reference_ID,
      Payment_Election_Higher_Order_Rule_ID,
      Election_Order,
      Payment_Type_Reference_ID,
      Bank_Account_Country_Reference_ID,
      Bank_Account_Currency_Reference_ID,
      Bank_Account_Nickname,
      Bank_Account_Name,
      Roll_Number,
      Bank_Account_Type_Code,
      Bank_Name,
      Bank_Account_Number,
      Bank_Account_ID_Number,
      Bank_Account_Type_Reference_ID,
      Bank_Account_IBAN,
      Bank_Account_BIC,
      Bank_Account_Branch_Name,
      Bank_Account_Branch_ID_Number,
      Bank_Account_Check_Digit,
      Distribution_Amount,
      Distribution_Percentage,
      Distribution_Balance,
      LegacySystem,
      LegacyID,
      ROW_NUMBER() OVER (PARTITION BY Worker_Reference_ID ORDER BY CAST(Election_Order AS INT64)) AS non_default_rank, -- Assuming Election_Order is pre-ranked
      COUNT(*) OVER (PARTITION BY Worker_Reference_ID) AS distribution_count,
      CASE WHEN Distribution_Balance = '1' THEN 'Y' ELSE 'N' END AS DEFAULT_FLAG -- Derive DEFAULT_FLAG from Distribution_Balance
    FROM
      base_data_vmc
  )
-- CHI: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  'USA' AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(CASE
    WHEN r.DEFAULT_FLAG = 'Y' THEN r.distribution_count
    ELSE r.non_default_rank
  END AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  'USA' AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_chi r
UNION ALL
-- CHI: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  'USA' AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(r.distribution_count AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  'USA' AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_chi r
WHERE
  r.DEFAULT_FLAG = 'Y'
UNION ALL
-- MTN: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  'USA' AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(CASE
    WHEN r.DEFAULT_FLAG = 'Y' THEN r.distribution_count
    ELSE r.non_default_rank
  END AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  'USA' AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_mtn r
UNION ALL
-- MTN: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  'USA' AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(r.distribution_count AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  'USA' AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_mtn r
WHERE
  r.DEFAULT_FLAG = 'Y'
UNION ALL
-- STA: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(CASE
    WHEN r.DEFAULT_FLAG = 'Y' THEN r.distribution_count
    ELSE r.non_default_rank
  END AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_sta r
UNION ALL
-- STA: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(r.distribution_count AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_sta r
WHERE
  r.DEFAULT_FLAG = 'Y'
UNION ALL
-- HAH: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(CASE
    WHEN r.DEFAULT_FLAG = 'Y' THEN r.distribution_count
    ELSE r.non_default_rank
  END AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  r.NICKNAME AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_hah r
UNION ALL
-- HAH: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.EMPLOYEE AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(r.distribution_count AS STRING) AS Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  COALESCE(r.COUNTRY_CODE, 'USA') AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  r.NICKNAME AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  CAST(r.EBNK_ACCT_NBR AS STRING) AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.DESCRIPTION AS Bank_Name,
  '' AS Bank_Account_IBAN,
  CAST(r.EBANK_ID AS STRING) AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS STRING), '') AS Distribution_Amount,
  COALESCE(CAST(CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS STRING), '') AS Distribution_Percentage,
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_hah r
WHERE
  r.DEFAULT_FLAG = 'Y'
UNION ALL
-- VMC: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  r.Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  r.Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  r.Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  r.Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  r.Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  r.Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  r.Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  r.Bank_Account_Nickname,
  r.Bank_Account_Name,
  r.Bank_Account_Number,
  r.Roll_Number,
  r.Bank_Account_Type_Code,
  r.Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.Bank_Name,
  r.Bank_Account_IBAN,
  r.Bank_Account_ID_Number,
  r.Bank_Account_BIC,
  r.Bank_Account_Branch_Name,
  r.Bank_Account_Branch_ID_Number,
  r.Bank_Account_Check_Digit,
  r.Distribution_Amount,
  r.Distribution_Percentage,
  r.Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_vmc r
UNION ALL
-- VMC: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  r.Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  r.Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  r.Election_Order,
  '' AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,
  '' AS Payment_Election_Rule_Country_Type,
  '' AS Payment_Election_Rule_Currency_ID,
  '' AS Payment_Election_Rule_Currency_ID_Type,
  r.Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  r.Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  r.Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,
  r.Bank_Account_Nickname,
  r.Bank_Account_Name,
  r.Bank_Account_Number,
  r.Roll_Number,
  r.Bank_Account_Type_Code,
  r.Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.Bank_Name,
  r.Bank_Account_IBAN,
  r.Bank_Account_ID_Number,
  r.Bank_Account_BIC,
  r.Bank_Account_Branch_Name,
  r.Bank_Account_Branch_ID_Number,
  r.Bank_Account_Check_Digit,
  r.Distribution_Amount,
  r.Distribution_Percentage,
  r.Distribution_Balance,
  r.LegacySystem,
  r.LegacyID
FROM
  ranked_data_vmc r
WHERE
  r.DEFAULT_FLAG = 'Y' -- Filter for the default account