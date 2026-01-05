-- =============================================================================
-- FIXED: Moving DH CTEs to the top level
-- =============================================================================

DROP TABLE IF EXISTS `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`;

CREATE TABLE `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`(
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
  OASDI_Reason_for_Exemption_Reference_ID_Type STRING,
  LegacySystem STRING,
  LegacyID STRING,
  LawsonLegacyID STRING);

DROP TABLE IF EXISTS `workday.workday_Put_Payroll_Payee_FICA_OASDIs`;

CREATE TABLE `workday.workday_Put_Payroll_Payee_FICA_OASDIs`(
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
  OASDI_Reason_for_Exemption_Reference_ID_Type STRING);


INSERT INTO `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
-- START OF TOP-LEVEL CTES
WITH
Dh_Unique_Deductions AS (
    -- Get only ONE deduction record per employee (the one with the latest End_Date)
    SELECT
        edm.EMPLOYEE,
        edm.End_Date,
        ROW_NUMBER()
          OVER (PARTITION BY edm.EMPLOYEE ORDER BY edm.End_Date DESC) AS rn
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.emdedmastr` edm
    JOIN `prj-dev-ss-oneerp.lawson_dh.dedcode` dc
      ON edm.Ded_Code = dc.Ded_Code
    WHERE
      DATE(edm.End_Date) != DATE '1700-01-01'
      AND dc.TAX_CATEGORY IN (3)  and dc.Tax_Auth_Type = 'FD'
  ),
Dh_Unique_Positions AS (
      -- Get distinct employees who have valid positions.
      SELECT DISTINCT
        EMPLOYEE
      FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemppos`
      --WHERE (End_Date <> DATE '1700-01-01')
  ),

-- MAIN PAYROLL_DATA CTE (now uses the top-level DH CTEs)
--- CHI - multiple rows for multiple position
payroll_data AS (
    SELECT
      CAST(legacy.WD_Employee AS STRING) AS Worker_Reference_ID,
      '' --cpos.Position_ID           
        AS Position_Reference_ID,
      '' AS All_Positions,
      CAST(edm.End_Date AS TIMESTAMP) AS Effective_As_Of,
      '1' AS Apply_To_Worker,
      CASE
        WHEN
          edm.End_Date <> DATE '1700-01-01'          
          --AND e.Term_Date = DATE '1700-01-01'
          THEN 1
        ELSE NULL
        END AS Exempt_from_OASDI,
      '' AS OASDI_Reason_for_Exemption_Reference_ID,
      'CHI' AS LegacySystem,
      CAST(e.EMPLOYEE AS STRING) AS LegacyID,
      CAST(e.EMPLOYEE AS STRING) AS LawsonLegacyID -- FIX: Populated
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emdedmastr` edm
    JOIN `prj-dev-ss-oneerp.lawson_chi.dedcode` dc
      ON edm.Ded_Code = dc.Ded_Code
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` e
      ON
        edm.EMPLOYEE = e.EMPLOYEE
        AND edm.Company = e.Company
    LEFT JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_chi.paemppos` pos
      ON
        e.EMPLOYEE = pos.EMPLOYEE
        AND e.Company = 8900
        AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON
        CAST(e.EMPLOYEE AS STRING) = legacy.LegacyID
        AND legacy.SystemIdentifier = 'INF'
    LEFT JOIN prj-dev-ss-oneerp.oneerp.process_create_position cpos
        on
        cpos.LegacySystem = 'INF' 
      AND cpos.LegacyEmployee = CAST(e.EMPLOYEE AS STRING)
    WHERE
      edm.Company = 8900
      AND dc.TAX_CATEGORY IN (3) and dc.Tax_Auth_Type = 'FD'
      AND e.emp_status NOT IN ('T2', 'C1', 'C2', 'W2', 'S1')
      AND DATE(edm.End_Date) != DATE '1700-01-01'
    UNION ALL

    -- VMC
    SELECT
      Worker_Reference_ID,
      cpos.Position_ID AS Position_Reference_ID,
      All_Positions,
      SAFE.PARSE_TIMESTAMP('%Y-%m-%d%E*T%H:%M:%S', Effective_As_Of)
        AS Effective_As_Of,
      '' AS Apply_To_Worker,
      CAST(Exempt_from_OASDI AS INT64) AS Exempt_from_OASDI,
      OASDI_Reason_for_Exemption_Reference_ID,
      'VMC' AS LegacySystem,
      Worker_Reference_ID AS LegacyID,
      '' AS LawsonLegacyID
    FROM `prj-dev-ss-oneerp.vmmc_erp.vmc_pay_FICA_OASDIs` emp
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON Worker_Reference_ID = legacy.LegacyID
    LEFT JOIN prj-dev-ss-oneerp.oneerp.process_create_position cpos
    ON cpos.LegacySystem = 'VMC'
      AND  cpos.LegacyEmployee = legacy.LegacyID
      
    UNION ALL

    -- DH
    SELECT
      CAST(legacy.WD_Employee AS STRING) AS Worker_Reference_ID,
      '' --cpos.Position_ID       
        AS Position_Reference_ID,
      '' AS All_Positions,
      TIMESTAMP(ded.End_Date)
        AS Effective_As_Of,
      '1' AS Apply_To_Worker,
      CASE
        WHEN ded.End_Date <> DATE '1700-01-01' THEN 1
        ELSE NULL
        END AS Exempt_from_OASDI,
      '' AS OASDI_Reason_for_Exemption_Reference_ID,
      'DH' AS LegacySystem,
      CAST(pa.Mb_Nbr AS STRING) AS LegacyID,
      CAST(emp.employee AS STRING) AS LawsonLegacyID
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemployee` pa
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_dh.employee` emp
      ON
        pa.EMPLOYEE = emp.EMPLOYEE
        AND emp.company = pa.company
        AND emp.COMPANY = 100

    -- JOIN TO DE-DUPLICATED DEDUCTIONS (Now uses top-level CTE)
    JOIN Dh_Unique_Deductions ded
      ON
        CAST(emp.EMPLOYEE AS STRING) = CAST(ded.EMPLOYEE AS STRING)
        AND ded.rn = 1

    -- JOIN TO DE-DUPLICATED POSITIONS (Now uses top-level CTE)
    JOIN Dh_Unique_Positions pos
      ON pa.EMPLOYEE = pos.EMPLOYEE
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON
        TRIM(CAST(pa.Mb_Nbr AS STRING)) = legacy.LegacyID
        AND legacy.SystemIdentifier = 'INF'
    LEFT JOIN prj-dev-ss-oneerp.oneerp.process_create_position cpos
        on
        cpos.LegacySystem = 'INF' 
      AND cpos.LegacyEmployee = TRIM(CAST(pa.Mb_Nbr AS STRING))
    WHERE
      emp.emp_status NOT IN ('T2', 'ZI', 'ZA')
    UNION ALL

    -- STA (St. Alexius) - NOTE: This section still needs de-duplication logic (like the DH section)
    SELECT DISTINCT
      CAST(legacy.WD_Employee AS STRING) AS Worker_Reference_ID,
      cpos.Position_ID 
        AS Position_Reference_ID,
      '1' AS All_Positions,
      TIMESTAMP(edm_main.EFFECT_DATE) AS Effective_As_Of,
      '' AS Apply_To_Worker,
      CASE
        WHEN
          EXISTS(
            SELECT 1
            FROM `prj-dev-ss-oneerp.lawson_stalexius.prtaxloc` ptl_sub
            WHERE
              CAST(ptl_sub.EMPLOYEE AS STRING) = CAST(emp.EMPLOYEE AS STRING)
              AND ptl_sub.COMPANY = 1
              AND ptl_sub.RECORD_TYPE = 'D'
              AND TRIM(CAST(ptl_sub.DED_CODE AS STRING)) IN ('1003', '1004')
          )
          THEN 1
        ELSE NULL
        END AS Exempt_from_OASDI,
      '' AS OASDI_Reason_for_Exemption_Reference_ID,
      'STA' AS LegacySystem,
      CAST(emp.EMPLOYEE AS STRING) AS LegacyID,
      CAST(emp.EMPLOYEE AS STRING) AS LawsonLegacyID -- FIX: Populated
    FROM `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.employee` emp
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.paemppos` pos
      ON
        CAST(emp.EMPLOYEE AS STRING) = CAST(pos.EMPLOYEE AS STRING)
        AND (
          DATE(pos.End_Date) = DATE '1753-01-01'
          OR DATE(pos.End_Date) >= CURRENT_DATE())
    JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.emdedmastr` edm_main
      ON
        CAST(emp.EMPLOYEE AS STRING) = CAST(edm_main.EMPLOYEE AS STRING)
        AND edm_main.EXEMPTIONS = 99
    JOIN `prj-dev-ss-oneerp.lawson_stalexius.prtaxloc` ptl
      ON
        CAST(edm_main.EMPLOYEE AS STRING) = CAST(ptl.EMPLOYEE AS STRING)
        AND TRIM(ptl.RECORD_TYPE) = 'D'
    JOIN `prj-dev-ss-oneerp.lawson_stalexius.dedcode` dc
      ON
        TRIM(CAST(edm_main.DED_CODE AS STRING))
        = TRIM(CAST(dc.DED_CODE AS STRING))
    LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
      ON CAST(emp.EMPLOYEE AS STRING) = legacy.LegacyID
      and legacy.SystemIdentifier = 'STA'
    LEFT JOIN prj-dev-ss-oneerp.oneerp.process_create_position cpos
    ON cpos.LegacySystem = 'STA' 
      AND  cpos.LegacyEmployee = CAST(emp.EMPLOYEE AS STRING) 
    WHERE
      emp.EMP_STATUS NOT IN ('TP', 'TS', 'CT', 'C1')
      AND (
        SAFE_CAST(ptl.DED_CODE AS INT64) IN (1003, 1004)
        OR CAST(ptl.DED_CODE AS STRING) IN ('1003', '1004'))
      AND DATE(edm_main.End_Date) != DATE '1700-01-01'
      AND ptl.ACTIVE_FLAG = 'A'
  )

-- Final projection
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
  FORMAT_TIMESTAMP('%Y-%m-%dT00:00:00', Effective_As_Of) AS Effective_As_Of,
  Apply_To_Worker,
  CAST(Exempt_from_OASDI AS STRING) AS Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID,
  CAST(NULL AS STRING) AS OASDI_Reason_for_Exemption_Reference_ID_Type,
  LegacySystem,
  LegacyID,
  LawsonLegacyID
FROM payroll_data
WHERE Exempt_from_OASDI IS NOT NULL;

---

-- =============================================================================
-- Final load into Workday table
-- =============================================================================

INSERT INTO `workday.workday_Put_Payroll_Payee_FICA_OASDIs`
  (
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
    OASDI_Reason_for_Exemption_Reference_ID_Type)
SELECT
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
FROM `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
WHERE Exempt_from_OASDI IS NOT NULL;