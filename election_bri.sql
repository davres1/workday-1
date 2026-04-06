SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.Position_ID AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  'USA' AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  'REGULAR_PAYMENTS' AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  r.`order` AS Election_Order,                        -- Moved to match position 10
  'REGULAR' AS Payment_Election_Rule_ID,              -- Matches position 11
  '' AS Payment_Election_Rule_ID_Type,                -- ADDED (Missing)
  '' AS Payment_Election_Rule_Country,               -- ADDED (Missing)
  '' AS Payment_Election_Rule_Country_Type,          -- ADDED (Missing)
  '' AS Payment_Election_Rule_Currency_ID,           -- ADDED (Missing)
  '' AS Payment_Election_Rule_Currency_ID_Type,      -- ADDED (Missing)
  'Direct_Deposit' AS Payment_Type_Reference_ID,      -- Matches position 17
  '' AS Payment_Type_Reference_ID_Type,
  'USA' AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,      -- ADDED (Missing)
  '' AS Bank_Account_Nickname,
  '' AS Bank_Account_Name,
  r.account_number AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE 
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA' 
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA' 
    ELSE '' 
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.bank_name AS Bank_Name,
  '' AS Bank_Account_IBAN,
  r.routing_number AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  r.Distribuiton_Amount AS Distribution_Amount,
  r.Distribuiton_Percent AS Distribution_Percentage,
  CAST(CASE WHEN r.Distribuition_Balance = 'REMAINDER' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  legacy.LegacySystem,
  legacy.LegacyEmployee AS LegacyID
FROM `prj-dev-ss-oneerp.oneerp.BRI_Submit_Payment_Election` r
INNER JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` legacy
  ON CAST(r.Position_ID AS STRING) = legacy.LegacyEmployee
  AND legacy.LegacySystem = 'BRI'
UNION all
SELECT
  'N' AS Retain_Unused_Worker_Bank_Accounts,
  r.Position_ID AS Worker_Reference_ID,
  '' AS Worker_Reference_ID_Type,
  'USA' AS Worker_Country_Reference_ID,
  '' AS Worker_Country_Reference_ID_Type,
  'USD' AS Worker_Currency_Reference_ID,
  '' AS Worker_Currency_Reference_ID_Type,
  pay_type.Rule_ID AS Payment_Election_Higher_Order_Rule_ID,
  '' AS Payment_Election_Higher_Order_Rule_ID_Type,
  CAST(r.`order` AS STRING) AS Election_Order,
  COALESCE(r.Payment_Election_Rule_Reference_ID, 'REGULAR') AS Payment_Election_Rule_ID,
  '' AS Payment_Election_Rule_ID_Type,
  '' AS Payment_Election_Rule_Country,                -- Added
  '' AS Payment_Election_Rule_Country_Type,           -- Added
  '' AS Payment_Election_Rule_Currency_ID,            -- Added
  '' AS Payment_Election_Rule_Currency_ID_Type,       -- Added
  'Direct_Deposit' AS Payment_Type_Reference_ID,
  '' AS Payment_Type_Reference_ID_Type,
  'USA' AS Bank_Account_Country_Reference_ID,
  '' AS Bank_Account_Country_Reference_ID_Type,
  'USD' AS Bank_Account_Currency_Reference_ID,
  '' AS Bank_Account_Currency_Reference_ID_Type,      -- Added
  '' AS Bank_Account_Nickname,
  '' AS Bank_Account_Name,
  r.account_number AS Bank_Account_Number,
  '' AS Roll_Number,
  '' AS Bank_Account_Type_Code,
  CASE
    WHEN r.ACCOUNT_TYPE = 'C' THEN 'DDA'
    WHEN r.ACCOUNT_TYPE = 'S' THEN 'SA'
    ELSE ''
  END AS Bank_Account_Type_Reference_ID,
  '' AS Bank_Account_Type_Reference_ID_Type,
  r.bank_name AS Bank_Name,
  '' AS Bank_Account_IBAN,
  r.routing_number AS Bank_Account_ID_Number,
  '' AS Bank_Account_BIC,
  '' AS Bank_Account_Branch_Name,
  '' AS Bank_Account_Branch_ID_Number,
  '' AS Bank_Account_Check_Digit,
  r.Distribuiton_Amount AS Distribution_Amount,
  r.Distribuiton_Percent AS Distribution_Percentage,
  CAST(CASE WHEN r.Distribuition_Balance = 'REMAINDER' THEN 1 ELSE 0 END AS STRING) AS Distribution_Balance,
  legacy.LegacySystem,                                -- Added to match first SQL
  legacy.LegacyEmployee AS LegacyID                   -- Added to match first SQL
FROM `prj-dev-ss-oneerp.oneerp.BRI_Submit_Payment_Election` r
INNER JOIN `prj-dev-ss-oneerp.oneerp.process_addonly_employee` legacy
  ON CAST(r.Position_ID AS STRING) = legacy.LegacyEmployee
  AND legacy.LegacySystem = 'BRI'
CROSS JOIN (
  SELECT 'EXPENSE_PAYMENTS' AS Rule_ID
  UNION ALL
  SELECT 'SUPPLEMENTAL_PAYMENTS' AS Rule_ID
) AS pay_type