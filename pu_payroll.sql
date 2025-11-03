-- Drop and create process table
DROP TABLE IF EXISTS `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`;
CREATE TABLE `oneerp.process_Put_Payroll_Payee_FICA_OASDIs` (
  Add_Only STRING,
  Payroll_Payee_FICA_Reference_ID STRING,
  Payroll_Payee_FICA_Reference_ID_Type STRING,
  ID STRING,
  Worker_Reference_ID STRING,
  Worker_Reference_ID_Type STRING,
  Position_Reference_ID STRING,
  Position_Reference_ID_Type STRING,
  All_Positions STRING,
  Effective_As_Of STRING,
  Apply_To_Worker STRING,
  Exempt_from_OASDI STRING,
  OASDI_Reason_for_Exemption_Reference_ID STRING,
  OASDI_Reason_for_Exemption_Reference_ID_Type STRING
);

-- Drop and create workday table
DROP TABLE IF EXISTS `workday.workday_Put_Payroll_Payee_FICA_OASDIs`;
CREATE TABLE `workday.workday_Put_Payroll_Payee_FICA_OASDIs` (
  Add_Only STRING,
  Payroll_Payee_FICA_Reference_ID STRING,
  Payroll_Payee_FICA_Reference_ID_Type STRING,
  ID STRING,
  Worker_Reference_ID STRING,
  Worker_Reference_ID_Type STRING,
  Position_Reference_ID STRING,
  Position_Reference_ID_Type STRING,
  All_Positions STRING,
  Effective_As_Of STRING,
  Apply_To_Worker STRING,
  Exempt_from_OASDI STRING,
  OASDI_Reason_for_Exemption_Reference_ID STRING,
  OASDI_Reason_for_Exemption_Reference_ID_Type STRING
);

-- Insert into process table (WITH clause inside INSERT; all numeric source columns CAST to STRING)
INSERT INTO `oneerp.process_Put_Payroll_Payee_FICA_OASDIs` (
  Add_Only,
  Payroll_Payee_FICA_Reference_ID,
  Payroll_Payee_FICA_Reference_ID_Type,
  ID,
  Worker_Reference_ID,
  Worker_Reference_ID_Type,
  Position_Reference_ID,
  Position_Reference_ID_Type,
  All_Positions,
  Effective_As_Of,
  Apply_To_Worker,
  Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID,
  OASDI_Reason_for_Exemption_Reference_ID_Type
)
WITH payroll_data AS (
  SELECT
    e.EMPLOYEE AS Worker_Reference_ID,
    pos.Position AS Position_Reference_ID,
    '1' AS All_Positions,
    pos.End_Date AS Effective_As_Of,
    'NeedClarificationfromWD' AS Apply_To_Worker,
    CASE 
      WHEN e.TERM_DATE = DATE '1700-01-01'
        AND e.EMP_STATUS NOT LIKE 'T%'
        AND EXISTS (
          SELECT 1 
          FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emdedmastr` edm
          JOIN `prj-dev-ss-oneerp.lawson_chi.dedcode` dc 
            ON edm.Ded_Code = dc.Ded_Code
          WHERE edm.EMPLOYEE = e.EMPLOYEE
            AND edm.End_Date <> DATE '1700-01-01'
            AND dc.TAX_CATEGORY IN (3, 4)
        )
      THEN 1 
      ELSE 0 
    END AS Exempt_from_OASDI,
    '' AS OASDI_Reason_for_Exemption_Reference_ID
  FROM
    `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` e
  LEFT JOIN
    `prj-pvt-oneerp-data-raw-78c9.lawson_chi.paemppos` pos
    ON e.EMPLOYEE = pos.EMPLOYEE
    AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
  UNION ALL
  SELECT
    e.EMPLOYEE AS Worker_Reference_ID,
    pos.Position AS Position_Reference_ID,
    '1' AS All_Positions,
    pos.End_Date AS Effective_As_Of,
    'NeedClarificationfromWD' AS Apply_To_Worker,
    CASE 
      WHEN e.TERM_DATE = DATE '1700-01-01'
        AND e.EMP_STATUS NOT LIKE 'T%'
        AND EXISTS (
          SELECT 1 
          FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.emdedmastr` edm
          JOIN `prj-dev-ss-oneerp.lawson_dh.dedcode` dc 
            ON edm.Ded_Code = dc.Ded_Code
          WHERE edm.EMPLOYEE = e.EMPLOYEE
            AND edm.End_Date <> DATE '1700-01-01'
            AND dc.TAX_CATEGORY IN (3, 5)
        )
      THEN 1 
      ELSE 0 
    END AS Exempt_from_OASDI,
    '' AS OASDI_Reason_for_Exemption_Reference_ID
  FROM
    `prj-pvt-oneerp-data-raw-78c9.lawson_dh.employee` e
  LEFT JOIN
    `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemppos` pos
    ON e.EMPLOYEE = pos.EMPLOYEE
    AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
)
SELECT
  CAST(NULL AS STRING) AS Add_Only,
  CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID,
  CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID_Type,
  CAST(NULL AS STRING) AS ID,
  CAST(Worker_Reference_ID AS STRING) AS Worker_Reference_ID,
  CAST(NULL AS STRING) AS Worker_Reference_ID_Type,
  CAST(Position_Reference_ID AS STRING) AS Position_Reference_ID,
  CAST(NULL AS STRING) AS Position_Reference_ID_Type,
  All_Positions,
  CAST(Effective_As_Of AS STRING) AS Effective_As_Of,
  Apply_To_Worker,
  CAST(Exempt_from_OASDI AS STRING) AS Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID,
  CAST(NULL AS STRING) AS OASDI_Reason_for_Exemption_Reference_ID_Type
FROM payroll_data
ORDER BY Worker_Reference_ID, Effective_As_Of;

-- Insert into workday table (same structure; all numeric source columns CAST to STRING)
INSERT INTO `workday.workday_Put_Payroll_Payee_FICA_OASDIs` (
  Add_Only,
  Payroll_Payee_FICA_Reference_ID,
  Payroll_Payee_FICA_Reference_ID_Type,
  ID,
  Worker_Reference_ID,
  Worker_Reference_ID_Type,
  Position_Reference_ID,
  Position_Reference_ID_Type,
  All_Positions,
  Effective_As_Of,
  Apply_To_Worker,
  Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID,
  OASDI_Reason_for_Exemption_Reference_ID_Type
)
WITH payroll_data AS (
  SELECT
    e.EMPLOYEE AS Worker_Reference_ID,
    pos.Position AS Position_Reference_ID,
    '1' AS All_Positions,
    pos.End_Date AS Effective_As_Of,
    'NeedClarificationfromWD' AS Apply_To_Worker,
    CASE 
      WHEN e.TERM_DATE = DATE '1700-01-01'
        AND e.EMP_STATUS NOT LIKE 'T%'
        AND EXISTS (
          SELECT 1 
          FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emdedmastr` edm
          JOIN `prj-dev-ss-oneerp.lawson_chi.dedcode` dc 
            ON edm.Ded_Code = dc.Ded_Code
          WHERE edm.EMPLOYEE = e.EMPLOYEE
            AND edm.End_Date <> DATE '1700-01-01'
            AND dc.TAX_CATEGORY IN (3, 4)
        )
      THEN 1 
      ELSE 0 
    END AS Exempt_from_OASDI,
    '' AS OASDI_Reason_for_Exemption_Reference_ID
  FROM
    `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` e
  LEFT JOIN
    `prj-pvt-oneerp-data-raw-78c9.lawson_chi.paemppos` pos
    ON e.EMPLOYEE = pos.EMPLOYEE
    AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
  UNION ALL
  SELECT
    e.EMPLOYEE AS Worker_Reference_ID,
    pos.Position AS Position_Reference_ID,
    '1' AS All_Positions,
    pos.End_Date AS Effective_As_Of,
    'NeedClarificationfromWD' AS Apply_To_Worker,
    CASE 
      WHEN e.TERM_DATE = DATE '1700-01-01'
        AND e.EMP_STATUS NOT LIKE 'T%'
        AND EXISTS (
          SELECT 1 
          FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.emdedmastr` edm
          JOIN `prj-dev-ss-oneerp.lawson_dh.dedcode` dc 
            ON edm.Ded_Code = dc.Ded_Code
          WHERE edm.EMPLOYEE = e.EMPLOYEE
            AND edm.End_Date <> DATE '1700-01-01'
            AND dc.TAX_CATEGORY IN (3, 5)
        )
      THEN 1 
      ELSE 0 
    END AS Exempt_from_OASDI,
    '' AS OASDI_Reason_for_Exemption_Reference_ID
  FROM
    `prj-pvt-oneerp-data-raw-78c9.lawson_dh.employee` e
  LEFT JOIN
    `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemppos` pos
    ON e.EMPLOYEE = pos.EMPLOYEE
    AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
)
SELECT
  CAST(NULL AS STRING) AS Add_Only,
  CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID,
  CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID_Type,
  CAST(NULL AS STRING) AS ID,
  CAST(Worker_Reference_ID AS STRING) AS Worker_Reference_ID,
  CAST(NULL AS STRING) AS Worker_Reference_ID_Type,
  CAST(Position_Reference_ID AS STRING) AS Position_Reference_ID,
  CAST(NULL AS STRING) AS Position_Reference_ID_Type,
  All_Positions,
  CAST(Effective_As_Of AS STRING) AS Effective_As_Of,
  Apply_To_Worker,
  CAST(Exempt_from_OASDI AS STRING) AS Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID,
  CAST(NULL AS STRING) AS OASDI_Reason_for_Exemption_Reference_ID_Type
FROM payroll_data
ORDER BY Worker_Reference_ID, Effective_As_Of;