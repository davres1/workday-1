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
  `Distribution_Balance` STRING
);

-- Initialize workday delivery table
DROP TABLE IF EXISTS `prj-dev-ss-oneerp.workday.workday_submit_payment_election_enrollment`;
CREATE TABLE `prj-dev-ss-oneerp.workday.workday_submit_payment_election_enrollment` AS
SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`
WHERE 1=0;  -- Empty table with same schema

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
  Distribution_Balance
)
WITH
  base_data_chi AS (
    SELECT
      emp.EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
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
      emp.EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_mtn.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_mtn.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
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
      emp.EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH_DIST_NBR,
      lce.DESCRIPTION,
      lce.EBNK_ACCT_NBR,
      lce.EBANK_ID,
      lce.ACCOUNT_TYPE,
      lce.DEPOSIT_AMT,
      lce.NET_PERCENT,
      lce.COUNTRY_CODE
    FROM
      `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.employee` emp
    LEFT JOIN
      `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.emachdepst` lce
      ON emp.EMPLOYEE = lce.EMPLOYEE AND lce.END_DATE IS NULL
    WHERE
      emp.EMP_STATUS NOT IN ('C1', 'C2', 'T2', 'W2', 'S1')
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
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END 
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_sta
  )
-- CHI: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
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
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance
FROM 
  ranked_data_chi r

UNION ALL

-- CHI: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
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
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance
FROM
  ranked_data_chi r
WHERE
  r.DEFAULT_FLAG = 'Y'

UNION ALL

-- MTN: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
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
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance
FROM 
  ranked_data_mtn r

UNION ALL

-- MTN: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
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
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance
FROM
  ranked_data_mtn r
WHERE
  r.DEFAULT_FLAG = 'Y'

UNION ALL

-- STA: Regular Payments (all accounts)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
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
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance
FROM 
  ranked_data_sta r

UNION ALL

-- STA: Supplemental Payments (defaults only)
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
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
  CAST(CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance
FROM
  ranked_data_sta r
WHERE
  r.DEFAULT_FLAG = 'Y';

-- Copy from process to workday delivery table
INSERT INTO `prj-dev-ss-oneerp.workday.workday_submit_payment_election_enrollment`
SELECT * FROM `prj-dev-ss-oneerp.oneerp.process_submit_payment_election_enrollment`;