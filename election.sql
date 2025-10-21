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
  )

-- CHI: Regular Payments (all accounts)
SELECT
  r.EMPLOYEE AS Worker_Reference_ID,
  'USA' AS Worker_Country_Reference_ID,
  'USD' AS Worker_Currency_Reference_ID,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  CASE
    WHEN r.DEFAULT_FLAG = 'Y' THEN GREATEST(CAST(r.ACH_DIST_NBR AS INT64), r.distribution_count)
    ELSE r.non_default_rank
  END AS Election_Order,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  'USA' AS Bank_Account_Country_Reference_ID,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Nickname,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  r.DESCRIPTION AS Bank_Name,
  r.EBNK_ACCT_NBR AS Bank_Account_Number,
  r.EBANK_ID AS Bank_Account_ID_Number,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_IBAN,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS Distribution_Amount,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS Distribution_Percentage,
  CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS Distribution_Balance
FROM 
  ranked_data_chi r

UNION ALL

-- CHI: Supplemental Payments (defaults only)
SELECT
  r.EMPLOYEE AS Worker_Reference_ID,
  'USA' AS Worker_Country_Reference_ID,
  'USD' AS Worker_Currency_Reference_ID,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  r.distribution_count AS Election_Order,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  'USA' AS Bank_Account_Country_Reference_ID,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Nickname,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  r.DESCRIPTION AS Bank_Name,
  r.EBNK_ACCT_NBR AS Bank_Account_Number,
  r.EBANK_ID AS Bank_Account_ID_Number,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_IBAN,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS Distribution_Amount,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS Distribution_Percentage,
  CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS Distribution_Balance
FROM
  ranked_data_chi r
WHERE
  r.DEFAULT_FLAG = 'Y'

UNION ALL

-- MTN: Regular Payments (all accounts)
SELECT
  r.EMPLOYEE AS Worker_Reference_ID,
  'USA' AS Worker_Country_Reference_ID,
  'USD' AS Worker_Currency_Reference_ID,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  CASE
    WHEN r.DEFAULT_FLAG = 'Y' THEN GREATEST(CAST(r.ACH_DIST_NBR AS INT64), r.distribution_count)
    ELSE r.non_default_rank
  END AS Election_Order,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  'USA' AS Bank_Account_Country_Reference_ID,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Nickname,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  r.DESCRIPTION AS Bank_Name,
  r.EBNK_ACCT_NBR AS Bank_Account_Number,
  r.EBANK_ID AS Bank_Account_ID_Number,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_IBAN,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS Distribution_Amount,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS Distribution_Percentage,
  CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS Distribution_Balance
FROM 
  ranked_data_mtn r

UNION ALL

-- MTN: Supplemental Payments (defaults only)
SELECT
  r.EMPLOYEE AS Worker_Reference_ID,
  'USA' AS Worker_Country_Reference_ID,
  'USD' AS Worker_Currency_Reference_ID,
  'SUPPLEMENTAL_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  r.distribution_count AS Election_Order,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  'USA' AS Bank_Account_Country_Reference_ID,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Nickname,
  '' AS Bank_Account_Nickname,
  r.DESCRIPTION AS Bank_Account_Name,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  r.DESCRIPTION AS Bank_Name,
  r.EBNK_ACCT_NBR AS Bank_Account_Number,
  r.EBANK_ID AS Bank_Account_ID_Number,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_IBAN,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.DEPOSIT_AMT ELSE NULL END AS Distribution_Amount,
  CASE WHEN r.DEFAULT_FLAG != 'Y' THEN r.NET_PERCENT ELSE NULL END AS Distribution_Percentage,
  CASE WHEN r.DEFAULT_FLAG = 'Y' THEN 1 ELSE 0 END AS Distribution_Balance
FROM
  ranked_data_mtn r
WHERE
  r.DEFAULT_FLAG = 'Y';