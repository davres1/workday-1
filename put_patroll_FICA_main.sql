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

-- ===============================================
-- MAIN INSERT INTO PROCESS TABLE
-- ===============================================
INSERT INTO `oneerp.process_Put_Payroll_Payee_FICA_OASDIs` (
    Add_Only, Payroll_Payee_FICA_Reference_ID, Payroll_Payee_FICA_Reference_ID_Type, ID,
    Worker_Reference_ID, Worker_Reference_ID_Type, Position_Reference_ID, Position_Reference_ID_Type,
    All_Positions, Effective_As_Of, Apply_To_Worker, Exempt_from_OASDI,
    OASDI_Reason_for_Exemption_Reference_ID, OASDI_Reason_for_Exemption_Reference_ID_Type
)
WITH payroll_data AS (

    -- CHI: Aligned to DATETIME and INT64
    SELECT
        CAST(e.EMPLOYEE AS STRING) AS Worker_Reference_ID,
        CAST(pos.Position AS STRING) AS Position_Reference_ID,
        '1' AS All_Positions,
        CAST(pos.End_Date AS DATETIME) AS Effective_As_Of,
        'NeedClarificationfromWD' AS Apply_To_Worker,
        CASE WHEN EXISTS (
            SELECT 1
            FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emdedmastr` edm
            JOIN `prj-dev-ss-oneerp.lawson_chi.dedcode` dc
            ON edm.Ded_Code = dc.Ded_Code
            WHERE edm.EMPLOYEE = e.EMPLOYEE
            AND edm.Company = 8900
            AND edm.End_Date <> DATE '1700-01-01'
            AND dc.TAX_CATEGORY IN (3, 4)
        ) THEN 1 ELSE 0 END AS Exempt_from_OASDI,
        '' AS OASDI_Reason_for_Exemption_Reference_ID
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` e
    LEFT JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_chi.paemppos` pos
    ON e.EMPLOYEE = pos.EMPLOYEE
    AND e.COMPANY = pos.COMPANY
    AND e.COMPANY = 8900
    AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
    WHERE e.emp_status NOT IN ('T2', 'C1', 'C2')

    UNION ALL

    -- VMC: FIX APPLIED HERE for Exempt_from_OASDI (Column 6)
    SELECT
        Worker_Reference_ID,
        Position_Reference_ID,
        All_Positions,
        CAST(Effective_As_Of AS DATETIME) AS Effective_As_Of,
        Apply_To_Worker,
        CAST(Exempt_from_OASDI AS INT64) AS Exempt_from_OASDI, -- *** FIXED TO INT64 ***
        OASDI_Reason_for_Exemption_Reference_ID
    FROM `prj-dev-ss-oneerp.vmmc_erp.vmc_pay_FICA_OASDIs`

    UNION ALL

    -- DH: Aligned to DATETIME and INT64
    SELECT
        CAST(pa.Mb_Nbr AS STRING) AS Worker_Reference_ID,
        CAST(pos.Position AS STRING) AS Position_Reference_ID,
        '1' AS All_Positions,
        CAST(pos.End_Date AS DATETIME) AS Effective_As_Of,
        'NeedClarificationfromWD' AS Apply_To_Worker,
        CASE WHEN EXISTS (
            SELECT 1
            FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.emdedmastr` edm
            JOIN `prj-dev-ss-oneerp.lawson_dh.dedcode` dc
            ON edm.Ded_Code = dc.Ded_Code
            WHERE edm.EMPLOYEE = pa.EMPLOYEE
            AND edm.End_Date <> DATE '1700-01-01'
            AND dc.TAX_CATEGORY IN (3, 5)
        ) THEN 1 ELSE 0 END AS Exempt_from_OASDI,
        '' AS OASDI_Reason_for_Exemption_Reference_ID
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemployee` pa
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_dh.employee` emp
    ON pa.EMPLOYEE = emp.EMPLOYEE
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemppos` pos
    ON pa.EMPLOYEE = pos.EMPLOYEE
    AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
    WHERE pa.Company = 100
    AND emp.emp_status NOT IN ('T2', 'ZI', 'ZA')

    UNION ALL

    -- STA: Aligned to DATETIME and INT64
    SELECT
        CAST(emp.EMPLOYEE AS STRING) AS Worker_Reference_ID,
        CAST(pos.R_POSITION AS STRING) AS Position_Reference_ID,
        '1' AS All_Positions,
        CAST(pos.End_Date AS DATETIME) AS Effective_As_Of,
        'NeedClarificationfromWD' AS Apply_To_Worker,
        CASE WHEN EXISTS (
            SELECT 1
            FROM `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.emdedmastr` edm
            WHERE edm.EMPLOYEE = emp.EMPLOYEE
            AND edm.COMPANY = 100
            AND DATE(edm.END_DATE) = DATE '1753-01-01'
            AND TRIM(edm.DED_CODE) IN ('1004', '1005')
        ) THEN 1 ELSE 0 END AS Exempt_from_OASDI,
        '' AS OASDI_Reason_for_Exemption_Reference_ID
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.employee` emp
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.paemppos` pos
    ON emp.EMPLOYEE = pos.EMPLOYEE
    AND (DATE(pos.End_Date) = DATE '1753-01-01' OR DATE(pos.End_Date) >= CURRENT_DATE())
    WHERE emp.EMP_STATUS NOT IN ('TP','TS','CT','C1')

)
-- Final projection with proper casting to STRING for the target table
SELECT
    CAST(NULL AS STRING) AS Add_Only,
    CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID,
    CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID_Type,
    CAST(NULL AS STRING) AS ID,
    Worker_Reference_ID,
    CAST(NULL AS STRING) AS Worker_Reference_ID_Type,
    Position_Reference_ID,
    CAST(NULL AS STRING) AS Position_Reference_ID_Type,
    All_Positions,
    CAST(Effective_As_Of AS STRING) AS Effective_As_Of,
    Apply_To_Worker,
    CAST(Exempt_from_OASDI AS STRING) AS Exempt_from_OASDI,
    OASDI_Reason_for_Exemption_Reference_ID,
    CAST(NULL AS STRING) AS OASDI_Reason_for_Exemption_Reference_ID_Type
FROM payroll_data;
-- INSERT INTO WORKDAY TABLE (Unchanged)
INSERT INTO `workday.workday_Put_Payroll_Payee_FICA_OASDIs` (
    Add_Only, Payroll_Payee_FICA_Reference_ID, Payroll_Payee_FICA_Reference_ID_Type, ID,
    Worker_Reference_ID, Worker_Reference_ID_Type, Position_Reference_ID, Position_Reference_ID_Type,
    All_Positions, Effective_As_Of, Apply_To_Worker, Exempt_from_OASDI,
    OASDI_Reason_for_Exemption_Reference_ID, OASDI_Reason_for_Exemption_Reference_ID_Type
)
SELECT
    Add_Only, Payroll_Payee_FICA_Reference_ID, Payroll_Payee_FICA_Reference_ID_Type, ID,
    Worker_Reference_ID, Worker_Reference_ID_Type, Position_Reference_ID, Position_Reference_ID_Type,
    All_Positions, Effective_As_Of, Apply_To_Worker, Exempt_from_OASDI,
    OASDI_Reason_for_Exemption_Reference_ID, OASDI_Reason_for_Exemption_Reference_ID_Type
FROM `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`;