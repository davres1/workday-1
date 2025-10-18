SELECT
  lce.EMPLOYEE AS Worker_Reference_ID,
  'USA' AS Worker_Country_Reference_ID,
  'USD' AS Worker_Currency_Reference_ID,
  lce.DEFAULT_FLAG,
  CASE
    WHEN lce.default_flag = 'Y' THEN 'SUPPLEMENTAL_PAYMENTS'
    ELSE 'REGULAR_PAYMENTS'
END
  AS Payment_Election_Rule_ID,
   --lce.DST_ORDER,
  'Direct_Deposit' as Payment_Type_Reference_ID,
  'USA' as Bank_Account_Country_Reference_ID,
  'USD' as Bank_Account_Currency_Reference_ID
FROM
  `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emachdepst` lce,`prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` emp
where
  lce.EMPLOYEE(+) = emp.EMPLOYEE and lce.END_DATE IS NULL and emp.EMP_STATUS not in ('C1','C2','T2','W2','S1')



