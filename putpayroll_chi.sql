WITH
  base_data_sta AS (
    SELECT
      emp.EMPLOYEE,
      lce.DEFAULT_FLAG,
      lce.ACH-DIST-ORDER,
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
      ACH-DIST-ORDER,
      DESCRIPTION,
      EBNK_ACCT_NBR,
      EBANK_ID,
      ACCOUNT_TYPE,
      DEPOSIT_AMT,
      NET_PERCENT,
      COUNTRY_CODE,
      AUTO-DEPOSIT
      COUNT(ACH_DIST_NBR) OVER (PARTITION BY EMPLOYEE) AS distribution_count,
      DENSE_RANK() OVER (
        PARTITION BY EMPLOYEE, CASE WHEN DEFAULT_FLAG = 'Y' THEN 'N' ELSE 'Y' END 
        ORDER BY CAST(ACH_DIST_NBR AS INT64)
      ) AS non_default_rank
    FROM
      base_data_sta
  )
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  CAST(r.EMPLOYEE AS STRING) AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  r.COUNTRY_CODE AS Worker_Country_Reference_ID,
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
  r.ACH-DIST-ORDER AS Payment_Type_Reference_ID,
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
  ranked_data_sta r
