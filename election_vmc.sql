--- add for hah org

SELECT
  emp.empid AS Role_ID_Reference_ID,
  emp.COUNTRY_CD AS Country_Reference_ID,
  'USD' AS Currency_Reference_ID,
  'REGULAR_PAYMENTS' AS Payment_Election_Rule_Reference_ID,
  emp.PRIORITY AS Order,
  'Direct_Deposit' AS Payment_Type_Reference_ID,
 emp.COUNTRY_CD AS Country_Reference_ID,

  'USD' AS Currency_Reference_ID,
  emp.NICKNAME AS Bank_Account_Nickname,
  bank.BANK_NM AS Bank_Account_Name,
  '' AS Roll_Number,
 emp.ACCOUNT_TYPE AS Account_Type_Code,
  bank.BANK_NM AS Bank_Name,
  Cbank.ACCOUNT_NUM AS Account_Number,
  emp.BANK_CD AS Bank_ID_Number,
  emp.account_type AS Account_Type_Reference_ID,
  '' AS IBAN,
  '' AS BIC,
  '' AS Branch_Name,
  '' AS Branch_ID_Number,
  '' AS Check_Digit,
  PS_DIR_DEP_DISTRIB.DEPOSIT_AMTAS Distribution_Amount,
  PS_DIR_DEP_DISTRIB.AMOUNT_PCT AS Distribution_Percentage,
  PS_DIR_DEP_DISTRIB.DEPOSIT_TYPE AS Distribution_Balance
FROM 
  `prj-dev-ss-oneerp.hah_psoft_hrp.ps_dir_dep_distrib` emp `prj-dev-ss-oneerp.hah_psoft_hrp.ps_bank_ec_tbl` bank
