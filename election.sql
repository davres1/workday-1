SELECT
  lce.EMPLOYEE AS Worker_Reference_ID,
  'USA' AS Worker_Country_Reference_ID,
  'USD' AS Worker_Currency_Reference_ID,
  lce.DEFAULT_FLAG,
  CASE
    WHEN lce.default_flag = 'Y' THEN 'Y'
    ELSE NULL
END
  AS Election_Order,
  'Direct_deposit' AS Payment_Type_Reference_ID,
  'USA' AS Bank_Account_Country_Reference_ID,
  'USD' AS Bank_Account_Currency_Reference_ID
FROM
  `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emachdepst` lce
JOIN
  `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` emp
ON
  lce.EMPLOYEE = emp.EMPLOYEE
LEFT JOIN
  prj-dev-ss-oneerp.oneerp.map_employee mep
ON
  mep.SystemIdentifier = 'INF'
  AND CAST(lce.EMPLOYEE AS STRING) = mep.LegacyID
LEFT JOIN
  prj-dev-ss-oneerp.oneerp.map_bankaccount mba
ON
  mba.LegacySystem = 'INF' /* replace lce.BANK_ACCT with the actual bank account identifier column in emachdepst */
  AND CAST(lce. AS STRING) = mba.LegacyBankAccountID
LEFT JOIN
  prj-dev-ss-oneerp.oneerp.map_country mct
ON
  mct.LegacySystem = 'INF' /* replace with actual country column if present */
  AND 'USA' = mct.CountryCode
LEFT JOIN
  prj-dev-ss-oneerp.oneerp.map_currency mcr
ON
  mcr.LegacySystem = 'INF' /* replace with actual currency column if present */
  AND 'USD' = mcr.CurrencyCode
LEFT JOIN
  prj-dev-ss-oneerp.oneerp.map_paymenttype mpt
ON
  mpt.LegacySystem = 'INF' /* replace with actual payment type column if present */
  AND 'Direct_deposit' = mpt.LegacyPaymentType
WHERE
  lce.END_DATE IS NULL