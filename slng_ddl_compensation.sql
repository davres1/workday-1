/*
    Staging Table: compensation
    Version: AutoCreated
    Comments: DDL created from https://app.smartsheet.com/sheets/FHw3c6hXHpQM2XhHrcFJmMpxJC3r8Cc4JPpvv3r1?view=grid
*/

/* NO LONGER SETTING UP AS AN SP
USE hellboy;     
DROP PROCEDURE IF EXISTS `sp_slng_ddl_compensation`;
-- DELIMITER $$   -- *** Comment out the delimiter declaration to load via SLNG *** -- 
CREATE DEFINER=`slng_user`@`%` PROCEDURE `sp_slng_ddl_compensation`()
  STAGING:BEGIN
*/

/*** Start of Add_Stock_Grant_DCDD Section created from https://app.smartsheet.com/sheets/ff2vXCMpRV78r86rpFcwrqcvMXqR6RxmGVpGgmW1?view=grid ***/

DROP TABLE IF EXISTS `src_add_stock_grant`;
CREATE TABLE `src_add_stock_grant`(
  `Effective_Date` TEXT,
  `Employee_Reference_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_Reference_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Stock_Plan_Reference_ID` TEXT,
  `Stock_Plan_Reference_ID_Type` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Stock_Grant_Reference_ID` TEXT,
  `Grant_Type_Reference_ID` TEXT,
  `Grant_Type_Reference_ID_Type` TEXT,
  `Grant_ID` TEXT,
  `Grant_Date` TEXT,
  `Vesting_Schedule_Reference_ID` TEXT,
  `Vesting_Schedule_Reference_ID_Type` TEXT,
  `Vest_From_Date` TEXT,
  `Expiration_Date` TEXT,
  `Grant_Amount_Currency_Reference_ID` TEXT,
  `Grant_Amount_Currency_Reference_ID_Type` TEXT,
  `Shares_Granted` TEXT,
  `Grant_Percent` TEXT,
  `Grant_Amount` TEXT,
  `Grant_Price` TEXT,
  `Grant_Price_Currency_Reference_ID` TEXT,
  `Grant_Price_Currency_Reference_ID_Type` TEXT,
  `Options_Pricing_Factor` TEXT,
  `Board_Approved` TEXT,
  `Comments` TEXT,
  `Shares_Vested` TEXT,
  `Shares_Unvested` TEXT,
  `Long_Term_Cash_Amount_Vested` TEXT,
  `Long_Term_Cash_Amount_Unvested` TEXT,
  `Vesting_Price` TEXT,
  `Vested_As_Of` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Add_Stock_Grant_DCDD Section ***/


/*** Start of Put_Previous_System_Compensation_History_DCDD Section created from https://app.smartsheet.com/sheets/MCrprm6P9QcMjM5h84xFm7cJXP376PMCjxQCWmX1?view=grid ***/

DROP TABLE IF EXISTS `src_put_previous_system_compensation_history`;
CREATE TABLE `src_put_previous_system_compensation_history`(
  `Worker_Reference_ID` TEXT,
  `Worker_Reference_ID_Type` TEXT,
  `Add_Only` TEXT,
  `Delete` TEXT,
  `Previous_System_Compensation_History_Reference_ID` TEXT,
  `Previous_System_Compensation_History_Reference_ID_Type` TEXT,
  `Previous_System_Compensation_History_Detail_Data_ID` TEXT,
  `Worker_History_Name` TEXT,
  `Action_Date` TEXT,
  `Reason` TEXT,
  `Amount` TEXT,
  `Currency_Reference_ID` TEXT,
  `Currency_Reference_ID_Type` TEXT,
  `Frequency_Reference_ID` TEXT,
  `Frequency_Reference_ID_Type` TEXT,
  `Amount_Change` TEXT,
  `Description` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Put_Previous_System_Compensation_History_DCDD Section ***/


/*** Start of Request_Bonus_Payment_DCDD Section created from https://app.smartsheet.com/sheets/5rwjmWXPxwg8Q322gjFPwHVFHf99CJH93Q6x8RG1?view=grid ***/

DROP TABLE IF EXISTS `src_request_bonus_payment`;
CREATE TABLE `src_request_bonus_payment`(
  `Employee_Reference_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_Reference_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Effective_Date` TEXT,
  `Visibility_Date` TEXT,
  `Bonus_Compensation_Snapshot_Date` TEXT,
  `Eligible_Earnings_Override_Period_Reference` TEXT,
  `Eligible_Earnings_Override_Period_Reference_Type` TEXT,
  `Bonus_Reason_Reference` TEXT,
  `Bonus_Reason_Reference_Type` TEXT,
  `Bonus_Plan_Reference_ID` TEXT,
  `Bonus_Plan_Reference_ID_Type` TEXT,
  `Coverage_Start_Date` TEXT,
  `Coverage_End_Date` TEXT,
  `Currency_Reference_ID` TEXT,
  `Currency_Reference_ID_Type` TEXT,
  `Request_Bonus_Comment` TEXT,
  `Percent` TEXT,
  `Amount` TEXT,
  `Ignore_Plan_Assignment` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Bonus_Payment_DCDD Section ***/


/*** Start of Request_Compensation_Change_ALLOWANCE_DCDD Section created from https://app.smartsheet.com/sheets/rhfjQFw6v85f9rMp9JCQ952JpV5QrMjQXWG3QpH1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_allowance`;
CREATE TABLE `src_request_compensation_allowance`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Allowance_Plan_Data_Replace` TEXT,
  `Allowance_Plan_ID` TEXT,
  `Allowance_Plan_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Allowance_Currency_ID` TEXT,
  `Allowance_Currency_Reference_ID_Type` TEXT,
  `Allowance_Frequency_ID` TEXT,
  `Allowance_Frequency_Reference_ID_Type` TEXT,
  `Expected_End_Date` TEXT,
  `Reimbursement_Start_Date` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Allowance_Percent` TEXT,
  `Allowance_Amount` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_ALLOWANCE_DCDD Section ***/


/*** Start of Request_Compensation_Change_BASEPAY_DCDD Section created from https://app.smartsheet.com/sheets/XJ9gVm7Q4VXmJjRWgPp78r5p26XhMhrMRgwmgmg1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_basepay`;
CREATE TABLE `src_request_compensation_basepay`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Pay_Plan_Data_Replace` TEXT,
  `Pay_Plan_Reference_ID` TEXT,
  `Pay_Plan_Reference_ID_Type` TEXT,
  `Pay_Plan_Currency_Reference_ID` TEXT,
  `Pay_Plan_Currency_Reference_ID_Type` TEXT,
  `Pay_Plan_Frequency_ID` TEXT,
  `Pay_Plan_Frequency_ID_Type` TEXT,
  `Pay_Plan_Expected_End_Date` TEXT,
  `Pay_Plan_Actual_End_Date` TEXT,
  `Pay_Plan_Amount` TEXT,
  `Pay_Plan_Percent_Change` TEXT,
  `Pay_Plan_Amount_Change` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_BASEPAY_DCDD Section ***/


/*** Start of Request_Compensation_Change_BONUS_DCDD Section created from https://app.smartsheet.com/sheets/5RjMphxV2fCgqpV2WH35xgp4hg6XFv55mr8McXf1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_bonus`;
CREATE TABLE `src_request_compensation_bonus`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Bonus_Plan_Data_Replace` TEXT,
  `Bonus_Plan_Reference_ID` TEXT,
  `Bonus_Plan_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Bonus_Guaranteed_Minimum` TEXT,
  `Percent_Assigned` TEXT,
  `Bonus_Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Bonus_Individual_Target_Amount` TEXT,
  `Bonus_Individual_Target_Percent` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_BONUS_DCDD Section ***/


/*** Start of Request_Compensation_Change_CALCPLAN_DCDD Section created from https://app.smartsheet.com/sheets/G6M3PFHfJQ4F6vWJhqwqrCjQv6C8gWR3HJW2hh31?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_calcplan`;
CREATE TABLE `src_request_compensation_calcplan`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Calculated_Plan_Data_Replace` TEXT,
  `Calculated_Plan_ID` TEXT,
  `Calculated_Plan_Reference_ID_Type` TEXT,
  `Calculated_Plan_Override_Amount` TEXT,
  `Calculated_Plan_Currency_ID` TEXT,
  `Calculated_Plan_Currency_ID_Type` TEXT,
  `Calculated_Plan_Frequency_ID` TEXT,
  `Calculated_Plan_Frequency_ID_Type` TEXT,
  `Actual_End_Date` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_CALCPLAN_DCDD Section ***/


/*** Start of Request_Compensation_Change_COMMISSION_DCDD Section created from https://app.smartsheet.com/sheets/rgrGGM6wfX23w83mQxWV3cwHCJCGqqRF4VpWprH1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_commission`;
CREATE TABLE `src_request_compensation_commission`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Commission_Plan_Data_Replace` TEXT,
  `Commission_Plan_Reference_ID` TEXT,
  `Commission_Plan_Reference_ID_Type` TEXT,
  `Target_Amount` TEXT,
  `Target_Percent` TEXT,
  `Commission_Currency_Reference_ID` TEXT,
  `Commission_Currency_Reference_ID_Type` TEXT,
  `Commission_Frequency_Reference_ID` TEXT,
  `Commission_Frequency_Reference_ID_Type` TEXT,
  `Draw_Amount` TEXT,
  `Draw_Frequency_Reference_ID` TEXT,
  `Draw_Frequency_Reference_ID_Type` TEXT,
  `Draw_Currency_Reference_ID` TEXT,
  `Draw_Currency_Reference_ID_Type` TEXT,
  `Draw_Duration` TEXT,
  `Recoverable` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_COMMISSION_DCDD Section ***/


/*** Start of Request_Compensation_Change_DCDD Section created from https://app.smartsheet.com/sheets/M833VJXp5HGwcM2gq9H9PjwpGQ7JH4XqHx7GvJP1?view=grid ***/

DROP TABLE IF EXISTS `src_request_comp_change`;
CREATE TABLE `src_request_comp_change`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Pay_Plan_Data_Replace` TEXT,
  `Pay_Plan_Reference_ID` TEXT,
  `Pay_Plan_Reference_ID_Type` TEXT,
  `Pay_Plan_Currency_Reference_ID` TEXT,
  `Pay_Plan_Currency_Reference_ID_Type` TEXT,
  `Pay_Plan_Frequency_ID` TEXT,
  `Pay_Plan_Frequency_ID_Type` TEXT,
  `Pay_Plan_Expected_End_Date` TEXT,
  `Pay_Plan_Actual_End_Date` TEXT,
  `Pay_Plan_Amount` TEXT,
  `Pay_Plan_Percent_Change` TEXT,
  `Pay_Plan_Amount_Change` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_allowance`;
CREATE TABLE `src_request_comp_change_allowance`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Allowance_Plan_Data_Replace` TEXT,
  `Allowance_Plan_ID` TEXT,
  `Allowance_Plan_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Allowance_Currency_ID` TEXT,
  `Allowance_Currency_Reference_ID_Type` TEXT,
  `Allowance_Frequency_ID` TEXT,
  `Allowance_Frequency_Reference_ID_Type` TEXT,
  `Expected_End_Date` TEXT,
  `Reimbursement_Start_Date` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Allowance_Percent` TEXT,
  `Allowance_Amount` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_bonus`;
CREATE TABLE `src_request_comp_change_bonus`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Bonus_Plan_Data_Replace` TEXT,
  `Bonus_Plan_Reference_ID` TEXT,
  `Bonus_Plan_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Bonus_Guaranteed_Minimum` TEXT,
  `Percent_Assigned` TEXT,
  `Bonus_Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Bonus_Individual_Target_Amount` TEXT,
  `Bonus_Individual_Target_Percent` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_calcplan`;
CREATE TABLE `src_request_comp_change_calcplan`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Calculated_Plan_Data_Replace` TEXT,
  `Calculated_Plan_ID` TEXT,
  `Calculated_Plan_Reference_ID_Type` TEXT,
  `Calculated_Plan_Override_Amount` TEXT,
  `Calculated_Plan_Currency_ID` TEXT,
  `Calculated_Plan_Currency_ID_Type` TEXT,
  `Calculated_Plan_Frequency_ID` TEXT,
  `Calculated_Plan_Frequency_ID_Type` TEXT,
  `Actual_End_Date` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_commission`;
CREATE TABLE `src_request_comp_change_commission`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Commission_Plan_Data_Replace` TEXT,
  `Commission_Plan_Reference_ID` TEXT,
  `Commission_Plan_Reference_ID_Type` TEXT,
  `Target_Amount` TEXT,
  `Commission_Currency_Reference_ID` TEXT,
  `Commission_Currency_Reference_ID_Type` TEXT,
  `Commission_Frequency_Reference_ID` TEXT,
  `Commission_Frequency_Reference_ID_Type` TEXT,
  `Draw_Amount` TEXT,
  `Draw_Frequency_Reference_ID` TEXT,
  `Draw_Frequency_Reference_ID_Type` TEXT,
  `Draw_Duration` TEXT,
  `Recoverable` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_merit`;
CREATE TABLE `src_request_comp_change_merit`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Merit_Plan_Data_Replace` TEXT,
  `Merit_Plan_Reference_ID` TEXT,
  `Merit_Plan_Reference_ID_Type` TEXT,
  `Merit_Individual_Target_Amount` TEXT,
  `Merit_Individual_Target_Percent` TEXT,
  `Guaranteed_Minimum` TEXT,
  `Merit_Actual_End_Date` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_period_salary`;
CREATE TABLE `src_request_comp_change_period_salary`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Period_Salary_Plan_Data_Replace` TEXT,
  `Period_Salary_Plan_Reference_ID` TEXT,
  `Period_Salary_Plan_Reference_ID_Type` TEXT,
  `Compensation_Period_Reference_ID` TEXT,
  `Compensation_Period_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Period_Salary_Currency_Reference_ID` TEXT,
  `Period_Salary_Currency_Reference_ID_Type` TEXT,
  `Compensation_Period_Multiplier` TEXT,
  `Period_Salary_Frequency_Reference_ID` TEXT,
  `Period_Salary_Frequency_Reference_ID_Type` TEXT,
  `Actual_End_Date` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_remove`;
CREATE TABLE `src_request_comp_change_remove`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Compensation_Plan_Reference_ID` TEXT,
  `Compensation_Plan_Reference_ID_Type` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_stock`;
CREATE TABLE `src_request_comp_change_stock`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Stock_Plan_Data_Replace` TEXT,
  `Stock_Plan_Reference_ID` TEXT,
  `Stock_Plan_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Stock_Currency_Reference_ID` TEXT,
  `Stock_Currency_Reference_ID_Type` TEXT,
  `Stock_Actual_End_Date` TEXT,
  `Stock_Fixed_for_Manage_by_Basis_Total` TEXT,
  `Individual_Target_Shares` TEXT,
  `Individual_Target_Percent` TEXT,
  `Individual_Target_Amount` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_unit`;
CREATE TABLE `src_request_comp_change_unit`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Unit_Salary_Plan_Data_Replace` TEXT,
  `Unit_Salary_Plan_Reference_ID` TEXT,
  `Unit_Salary_Plan_Reference_ID_Type` TEXT,
  `Per_Unit_Amount` TEXT,
  `Unit_Currency_Reference_ID` TEXT,
  `Unit_Currency_Reference_ID_Type` TEXT,
  `Default_Units` TEXT,
  `Unit_Frequency_Reference_ID` TEXT,
  `Unit_Frequency_Reference_ID_Type` TEXT,
  `Actual_End_Date` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';


DROP TABLE IF EXISTS `src_request_comp_change_unit_allowance`;
CREATE TABLE `src_request_comp_change_unit_allowance`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Unit_Allowance_Plan_Data_Replace` TEXT,
  `Unit_Allowance_Plan_ID` TEXT,
  `Unit_Allowance_Plan_Reference_ID_Type` TEXT,
  `Unit_Allowance_Number_of_Units` TEXT,
  `Unit_Allowance_Frequency_ID` TEXT,
  `Unit_Allowance_Frequency_ID_Type` TEXT,
  `Unit_Allowance_Per_Unit_Amount` TEXT,
  `Unit_Allowance_Currency_ID` TEXT,
  `Unit_Allowance_Currency_ID_Type` TEXT,
  `Reimbursement_Start_Date` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_DCDD Section ***/


/*** Start of Request_Compensation_Change_MERIT_DCDD Section created from https://app.smartsheet.com/sheets/g45q47vg3xhjc7mhQjjrvgFw85cHH7GCrJCJQf91?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_merit`;
CREATE TABLE `src_request_compensation_merit`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Merit_Plan_Data_Replace` TEXT,
  `Merit_Plan_Reference_ID` TEXT,
  `Merit_Plan_Reference_ID_Type` TEXT,
  `Merit_Individual_Target_Amount` TEXT,
  `Merit_Individual_Target_Percent` TEXT,
  `Guaranteed_Minimum` TEXT,
  `Merit_Actual_End_Date` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_MERIT_DCDD Section ***/


/*** Start of Request_Compensation_Change_PERIODSALARY_DCDD Section created from https://app.smartsheet.com/sheets/XvfgVc76pWrRVg74gx2hhMPx927cf9xggmq5Xjv1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_periodsalary`;
CREATE TABLE `src_request_compensation_periodsalary`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Period_Salary_Plan_Data_Replace` TEXT,
  `Period_Salary_Plan_Reference_ID` TEXT,
  `Period_Salary_Plan_Reference_ID_Type` TEXT,
  `Compensation_Period_Reference_ID` TEXT,
  `Compensation_Period_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Period_Salary_Currency_Reference_ID` TEXT,
  `Period_Salary_Currency_Reference_ID_Type` TEXT,
  `Compensation_Period_Multiplier` TEXT,
  `Period_Salary_Frequency_Reference_ID` TEXT,
  `Period_Salary_Frequency_Reference_ID_Type` TEXT,
  `Actual_End_Date` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_PERIODSALARY_DCDD Section ***/


/*** Start of Request_Compensation_Change_REMOVEPLANS_DCDD Section created from https://app.smartsheet.com/sheets/m4Gx4P9jc8pjXmr5hqGq5938vjPQ7qQWCGQ3MQH1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_removeplans`;
CREATE TABLE `src_request_compensation_removeplans`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Compensation_Plan_Reference_ID` TEXT,
  `Compensation_Plan_Reference_ID_Type` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_REMOVEPLANS_DCDD Section ***/


/*** Start of Request_Compensation_Change_STOCK_DCDD Section created from https://app.smartsheet.com/sheets/ghVFpM6ghCJJXRxpHXhMHm39QjW595v9cwJ5GVH1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_stock`;
CREATE TABLE `src_request_compensation_stock`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Stock_Plan_Data_Replace` TEXT,
  `Stock_Plan_Reference_ID` TEXT,
  `Stock_Plan_Reference_ID_Type` TEXT,
  `Manage_by_Compensation_Basis_Override_Amount` TEXT,
  `Stock_Currency_Reference_ID` TEXT,
  `Stock_Currency_Reference_ID_Type` TEXT,
  `Stock_Actual_End_Date` TEXT,
  `Stock_Fixed_for_Manage_by_Basis_Total` TEXT,
  `Individual_Target_Shares` TEXT,
  `Individual_Target_Percent` TEXT,
  `Individual_Target_Amount` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_STOCK_DCDD Section ***/


/*** Start of Request_Compensation_Change_UNITALLOWANCE_DCDD Section created from https://app.smartsheet.com/sheets/2gfXPrr25FwGFWwV8cRWJmqRxFCpPPQpPH5hCg31?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_unitallowance`;
CREATE TABLE `src_request_compensation_unitallowance`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Unit_Allowance_Plan_Data_Replace` TEXT,
  `Unit_Allowance_Plan_ID` TEXT,
  `Unit_Allowance_Plan_ID_Type` TEXT,
  `Unit_Allowance_Number_of_Units` TEXT,
  `Unit_Allowance_Frequency_ID` TEXT,
  `Unit_Allowance_Frequency_ID_Type` TEXT,
  `Unit_Allowance_Per_Unit_Amount` TEXT,
  `Unit_Allowance_Currency_ID` TEXT,
  `Unit_Allowance_Currency_ID_Type` TEXT,
  `Reimbursement_Start_Date` TEXT,
  `Actual_End_Date` TEXT,
  `Fixed_for_Manage_by_Basis_Total` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_UNITALLOWANCE_DCDD Section ***/


/*** Start of Request_Compensation_Change_UNITSALARY_DCDD Section created from https://app.smartsheet.com/sheets/mpCg6RPH98GWw6R6Hw8c7pMqPF3FhFm9597hrCP1?view=grid ***/

DROP TABLE IF EXISTS `src_request_compensation_unitsalary`;
CREATE TABLE `src_request_compensation_unitsalary`(
  `Employee_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `Compensation_Change_Date` TEXT,
  `Compensation_Change_On_Next_Pay_Period` TEXT,
  `Override_Compensation_Basis_Calculation` TEXT,
  `Compensation_Package_Reference_ID` TEXT,
  `Compensation_Package_Reference_ID_Type` TEXT,
  `Compensation_Grade_Reference_ID` TEXT,
  `Compensation_Grade_Reference_ID_Type` TEXT,
  `Compensation_Grade_Profile_Reference_ID` TEXT,
  `Compensation_Grade_Profile_Reference_ID_Type` TEXT,
  `Compensation_Step_Reference_ID` TEXT,
  `Compensation_Step_Reference_ID_Type` TEXT,
  `Progression_Start_Date` TEXT,
  `Unit_Salary_Plan_Data_Replace` TEXT,
  `Unit_Salary_Plan_Reference_ID` TEXT,
  `Unit_Salary_Plan_Reference_ID_Type` TEXT,
  `Per_Unit_Amount` TEXT,
  `Unit_Currency_Reference_ID` TEXT,
  `Unit_Currency_Reference_ID_Type` TEXT,
  `Default_Units` TEXT,
  `Unit_Frequency_Reference_ID` TEXT,
  `Unit_Frequency_Reference_ID_Type` TEXT,
  `Actual_End_Date` TEXT,
  `Primary_Compensation_Basis` TEXT,
  `Primary_Compensation_Basis_Amount_Change` TEXT,
  `Primary_Compensation_Basis_Percent_Change` TEXT,
  `Skip` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_Compensation_Change_UNITSALARY_DCDD Section ***/


/*** Start of Request_One_Time_Payment_DCDD Section created from https://app.smartsheet.com/sheets/wmvGXCRXfW99RRM9PXMg6x3JRcWvq2ff5R2QVhJ1?view=grid ***/

DROP TABLE IF EXISTS `src_request_one_time_payment`;
CREATE TABLE `src_request_one_time_payment`(
  `Employee_Reference_ID` TEXT,
  `Employee_Reference_ID_Type` TEXT,
  `Position_Reference_ID` TEXT,
  `Position_Reference_ID_Type` TEXT,
  `Effective_Date` TEXT,
  `Employee_Visibility_Date` TEXT,
  `Reason_Reference_ID` TEXT,
  `Reason_Reference_ID_Type` TEXT,
  `One_Time_Payment_Plan_Reference_ID` TEXT,
  `One_Time_Payment_Plan_Reference_ID_Type` TEXT,
  `Scheduled_Payment_Date` TEXT,
  `Clawback_Date` TEXT,
  `Coverage_Start_Date` TEXT,
  `Coverage_End_Date` TEXT,
  `Currency_Reference_ID` TEXT,
  `Currency_Reference_ID_Type` TEXT,
  `OTP_Comment` TEXT,
  `Do_Not_Pay` TEXT,
  `Costing_Company_Reference_ID` TEXT,
  `Costing_Company_Reference_ID_Type` TEXT,
  `One_Time_Payment_Worktags_Reference_ID` TEXT,
  `One_Time_Payment_Worktags_Reference_ID_Type` TEXT,
  `One_Time_Payment_Worktags_Reference_ID_Parent_ID` TEXT,
  `One_Time_Payment_Worktags_Reference_ID_Parent_Type` TEXT,
  `Amount` TEXT,
  `Percent` TEXT
) ENGINE=InnoDB ENCRYPTION='Y' COMMENT '';

/*** End of Request_One_Time_Payment_DCDD Section ***/


/* NO LONGER SETTING UP AS AN SP
SET autocommit=1;
END STAGING;
*/