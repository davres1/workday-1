-- =============================================================================
-- put_patroll_FICA_main.sql – FINAL CONSOLIDATED SCRIPT (ALL LEFT JOINED)
-- =============================================================================

DROP TABLE IF EXISTS `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`;
CREATE TABLE `oneerp.process_Put_Payroll_Payee_FICA_OASDIs` (
  Add_Only                              STRING,
  Payroll_Payee_FICA_Reference_ID       STRING,
  Payroll_Payee_FICA_Reference_ID_Type  STRING,
  ID                                    STRING,
  Worker_Reference_ID                   STRING,
  Worker_Reference_ID_Type              STRING,
  Position_Reference_ID                 STRING,
  Position_Reference_ID_Type            STRING,
  All_Positions                         STRING,
  Effective_As_Of                       STRING,
  Apply_To_Worker                       STRING,
  Exempt_from_OASDI                     STRING,
  OASDI_Reason_for_Exemption_Reference_ID STRING,
  OASDI_Reason_for_Exemption_Reference_ID_Type STRING,
  LegacySystem                          STRING,
  LegacyID                              STRING
);

DROP TABLE IF EXISTS `workday.workday_Put_Payroll_Payee_FICA_OASDIs`;
CREATE TABLE `workday.workday_Put_Payroll_Payee_FICA_OASDIs` (
  Add_Only                              STRING,
  Payroll_Payee_FICA_Reference_ID       STRING,
  Payroll_Payee_FICA_Reference_ID_Type  STRING,
  ID                                    STRING,
  Worker_Reference_ID                   STRING,
  Worker_Reference_ID_Type              STRING,
  Position_Reference_ID                 STRING,
  Position_Reference_ID_Type            STRING,
  All_Positions                         STRING,
  Effective_As_Of                       STRING,
  Apply_To_Worker                       STRING,
  Exempt_from_OASDI                     STRING,
  OASDI_Reason_for_Exemption_Reference_ID STRING,
  OASDI_Reason_for_Exemption_Reference_ID_Type STRING
);

---

INSERT INTO `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`
WITH payroll_data AS (

  -- CHI (Chicago)
  SELECT
    CAST(e.EMPLOYEE AS STRING)                    AS Worker_Reference_ID,
    CAST(pos.Position AS STRING)                  AS Position_Reference_ID,
    '1'                                           AS All_Positions,
    TIMESTAMP(pos.End_Date)                       AS Effective_As_Of_TS,
    ''                                            AS Apply_To_Worker,
    CASE WHEN EXISTS (
      SELECT 1 FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.emdedmastr` edm
      JOIN `prj-dev-ss-oneerp.lawson_chi.dedcode` dc ON edm.Ded_Code = dc.Ded_Code
      WHERE edm.EMPLOYEE = e.EMPLOYEE AND edm.Company = 8900
        AND edm.End_Date <> DATE '1700-01-01' AND dc.TAX_CATEGORY IN (3, 4)
    ) THEN 1 ELSE 0 END                           AS Exempt_from_OASDI,
    ''                                            AS OASDI_Reason_for_Exemption_Reference_ID,
    'CHI'                                         AS LegacySystem,
    CAST(e.EMPLOYEE AS STRING)                    AS LegacyID
  FROM `prj-pvt-oneerp-data-raw-78c9.lawson_chi.employee` e
  LEFT JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_chi.paemppos` pos
    ON e.EMPLOYEE = pos.EMPLOYEE AND e.COMPANY = 8900
   AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
  -- LEFT JOIN ADDED HERE
  LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
    ON CAST(e.EMPLOYEE AS STRING) = legacy.LegacyID AND legacy.SystemIdentifier = 'INF'
  WHERE e.emp_status NOT IN ('T2', 'C1', 'C2')

  UNION ALL

  -- VMC
  SELECT
    Worker_Reference_ID,
    Position_Reference_ID,
    All_Positions,
    SAFE.PARSE_TIMESTAMP('%Y-%m-%d%E*T%H:%M:%S', Effective_As_Of) AS Effective_As_Of_TS,
    ''                                            AS Apply_To_Worker,
    CAST(Exempt_from_OASDI AS INT64) AS Exempt_from_OASDI,
    OASDI_Reason_for_Exemption_Reference_ID,
    'VMC'                                         AS LegacySystem,
    Worker_Reference_ID                           AS LegacyID
  FROM `prj-dev-ss-oneerp.vmmc_erp.vmc_pay_FICA_OASDIs`
  -- LEFT JOIN ADDED HERE (Needs to join on Worker_Reference_ID which serves as LegacyID here)
  LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
    ON Worker_Reference_ID = legacy.LegacyID 

  UNION ALL

  -- DH (Dartmouth-Hitchcock)
  SELECT
    CAST(pa.Mb_Nbr AS STRING)                     AS Worker_Reference_ID,
    CAST(pos.Position AS STRING)                  AS Position_Reference_ID,
    '1'                                           AS All_Positions,
    TIMESTAMP(pos.End_Date)                       AS Effective_As_Of_TS,
    ''                                            AS Apply_To_Worker,
    CASE WHEN EXISTS (
      SELECT 1 FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.emdedmastr` edm
      JOIN `prj-dev-ss-oneerp.lawson_dh.dedcode` dc ON edm.Ded_Code = dc.Ded_Code
      WHERE edm.EMPLOYEE = pa.EMPLOYEE
        AND edm.End_Date <> DATE '1700-01-01' AND dc.TAX_CATEGORY IN (3, 4)
    ) THEN 1 ELSE 0 END                           AS Exempt_from_OASDI,
    ''                                            AS OASDI_Reason_for_Exemption_Reference_ID,
    'DH'                                         AS LegacySystem,
    CAST(pa.EMPLOYEE AS STRING)                   AS LegacyID
  FROM `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemployee` pa
  JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_dh.employee` emp
    ON pa.EMPLOYEE = emp.EMPLOYEE  AND emp.company=pa.company AND emp.COMPANY = 100
  JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_dh.paemppos` pos
    ON pa.EMPLOYEE = pos.EMPLOYEE
   AND (pos.End_Date = DATE '1700-01-01' OR pos.End_Date >= CURRENT_DATE())
  -- LEFT JOIN ADDED HERE
  LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
    ON CAST(pa.EMPLOYEE AS STRING) = legacy.LegacyID AND legacy.SystemIdentifier = 'INF'
  WHERE pa.Company = 100 AND emp.emp_status NOT IN ('T2', 'ZI', 'ZA')

  UNION ALL

  -- STA (St. Alexius) - FINAL ROBUST VERSION with LEFT JOIN
  SELECT DISTINCT
    CAST(emp.EMPLOYEE AS STRING)                  AS Worker_Reference_ID,
    CAST(pos.R_POSITION AS STRING)                AS Position_Reference_ID,
    '1'                                           AS All_Positions,
    
    -- MAPPED: EMDEDMASTR.EFFECT_DATE
    TIMESTAMP(edm_main.EFFECT_DATE)               AS Effective_As_Of_TS, 
    
    'WIP'                                         AS Apply_To_Worker, 
    
    -- MAPPED: Check PRTAXLOC for DED_CODE 1003, 1004
    CASE WHEN EXISTS (
      SELECT 1 FROM `prj-dev-ss-oneerp.lawson_stalexius.prtaxloc` ptl_sub
      WHERE CAST(ptl_sub.EMPLOYEE AS STRING) = CAST(emp.EMPLOYEE AS STRING)
        AND ptl_sub.COMPANY = 100
        AND ptl_sub.RECORD_TYPE = 'D'
        AND TRIM(CAST(ptl_sub.DED_CODE AS STRING)) IN ('1003', '1004')
    ) THEN 1 ELSE 0 END                           AS Exempt_from_OASDI,
    
    '21-Nov-25: Not found in Lawson'              AS OASDI_Reason_for_Exemption_Reference_ID,
    'STA'                                         AS LegacySystem,
    CAST(emp.EMPLOYEE AS STRING)                  AS LegacyID

  FROM `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.employee` emp
  
  -- Join Position
  JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.paemppos` pos
    ON CAST(emp.EMPLOYEE AS STRING) = CAST(pos.EMPLOYEE AS STRING)
   AND (DATE(pos.End_Date) = DATE '1753-01-01' OR DATE(pos.End_Date) >= CURRENT_DATE())

  -- Join EMDEDMASTR (Using Safe Casts)
  JOIN `prj-pvt-oneerp-data-raw-78c9.lawson_stalexius.emdedmastr` edm_main
    ON CAST(emp.EMPLOYEE AS STRING) = CAST(edm_main.EMPLOYEE AS STRING)


  -- Join PRTAXLOC (Using Safe Casts)
  JOIN `prj-dev-ss-oneerp.lawson_stalexius.prtaxloc` ptl
    ON CAST(edm_main.EMPLOYEE AS STRING) = CAST(ptl.EMPLOYEE AS STRING)


  -- Join DEDCODE (Trimming and Casting to ensure match)
  JOIN `prj-dev-ss-oneerp.lawson_stalexius.dedcode` dc
    ON TRIM(CAST(edm_main.DED_CODE AS STRING)) = TRIM(CAST(dc.DED_CODE AS STRING))

   
  -- LEFT JOIN ADDED HERE
  LEFT JOIN `prj-dev-ss-oneerp.oneerp.map_employee` legacy
    ON CAST(emp.EMPLOYEE AS STRING) = legacy.LegacyID

  WHERE  emp.EMP_STATUS NOT IN ('TP','TS','CT','C1')
    
    -- Filter on Tax Category and Authority Type
    AND (SAFE_CAST(dc.TAX_CATEGORY AS INT64) IN (3, 4) OR CAST(dc.TAX_CATEGORY AS STRING) IN ('3', '4'))
    AND TRIM(dc.TAX_AUTH_TYPE) = 'FD'

)
-- Final projection – Fixed: Explicitly cast NULL columns to STRING
SELECT
  CAST(NULL AS STRING) AS Add_Only,
  CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID,
  CAST(NULL AS STRING) AS Payroll_Payee_FICA_Reference_ID_Type,
  CAST(NULL AS STRING) AS ID,
  Worker_Reference_ID, -- NOTE: This is still the Legacy ID. Change to legacy.<column> if needed.
  CAST(NULL AS STRING) AS Worker_Reference_ID_Type,
  Position_Reference_ID,
  CAST(NULL AS STRING) AS Position_Reference_ID_Type,
  All_Positions,
  FORMAT_TIMESTAMP('%Y-%m-%dT00:00:00', Effective_As_Of_TS) AS Effective_As_Of,
  Apply_To_Worker,
  CAST(Exempt_from_OASDI AS STRING) AS Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID,
  CAST(NULL AS STRING) AS OASDI_Reason_for_Exemption_Reference_ID_Type,
  LegacySystem,
  LegacyID
FROM payroll_data;

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
  OASDI_Reason_for_Exemption_Reference_ID_Type
)
SELECT
  Add_Only, Payroll_Payee_FICA_Reference_ID, Payroll_Payee_FICA_Reference_ID_Type, ID,
  Worker_Reference_ID, Worker_Reference_ID_Type, Position_Reference_ID, Position_Reference_ID_Type,
  All_Positions, Effective_As_Of, Apply_To_Worker, Exempt_from_OASDI,
  OASDI_Reason_for_Exemption_Reference_ID, OASDI_Reason_for_Exemption_Reference_ID_Type
FROM `oneerp.process_Put_Payroll_Payee_FICA_OASDIs`;