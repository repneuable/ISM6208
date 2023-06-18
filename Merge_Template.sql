-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- FED Rate
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE FED_RATE_MERGED AS
SELECT 
  RECORD_DATE,
  MAX(Value_mtg_avg_30) as Value_mtg_avg_30, 
  MAX(Value_real_inr_rate_10yr) as Value_real_inr_rate_10yr, 
  MAX(Value_fed_debt) as Value_fed_debt, 
  MAX(Value_fed_funds_eff_rate) as Value_fed_funds_eff_rate, 
  MAX(Value_int_rate_reserve) as Value_int_rate_reserve, 
  MAX(Value_treasury_yield) as Value_treasury_yield
FROM (
  SELECT RECORD_DATE, MORTGAGE30US as Value_mtg_avg_30, NULL as Value_real_inr_rate_10yr, NULL as Value_fed_debt, NULL as Value_fed_funds_eff_rate, NULL as Value_int_rate_reserve, NULL as Value_treasury_yield FROM MTG_AVG_30YR_FIXED_RATE_US
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_mtg_avg_30, REAINTRATREARAT10Y as Value_real_inr_rate_10yr, NULL as Value_fed_debt, NULL as Value_fed_funds_eff_rate, NULL as Value_int_rate_reserve, NULL as Value_treasury_yield FROM REAL_INTEREST_RATE_10YR
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_mtg_avg_30, NULL as Value_real_inr_rate_10yr, GFDEBTN as Value_fed_debt, NULL as Value_fed_funds_eff_rate, NULL as Value_int_rate_reserve, NULL as Value_treasury_yield FROM FED_DEBT_TOTAL_PUBLIC_DEBT
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_mtg_avg_30, NULL as Value_real_inr_rate_10yr, NULL as Value_fed_debt, DFF as Value_fed_funds_eff_rate, NULL as Value_int_rate_reserve, NULL as Value_treasury_yield FROM FED_FUNDS_EFFECTIVE_RATE
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_mtg_avg_30, NULL as Value_real_inr_rate_10yr, NULL as Value_fed_debt, NULL as Value_fed_funds_eff_rate, IORB as Value_int_rate_reserve, NULL as Value_treasury_yield FROM INT_RATE_RESERVE_BAL
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_mtg_avg_30, NULL as Value_real_inr_rate_10yr, NULL as Value_fed_debt, NULL as Value_fed_funds_eff_rate, NULL as Value_int_rate_reserve, DGS10 as Value_treasury_yield FROM TREASURY_YIELD_10YR
) 
GROUP BY RECORD_DATE;





-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CPI
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE CPI_MERGED AS
SELECT 
  RECORD_DATE,
  MAX(Value_cpi_all_urban) as Value_cpi_all_urban, 
  MAX(Value_cpi_all_urban_pctchg) as Value_cpi_all_urban_pctchg, 
  MAX(Value_cpi_all) as Value_cpi_all, 
  MAX(Value_cpi_median) as Value_cpi_median
FROM (
  SELECT RECORD_DATE, MEDCPIM158SFRBCLE as Value_cpi_all_urban, NULL as Value_cpi_all_urban_pctchg, NULL as Value_cpi_all, NULL as Value_cpi_median FROM CPI_MEDIAN
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_cpi_all_urban, CPALTT01USM657N as Value_cpi_all_urban_pctchg, NULL as Value_cpi_all, NULL as Value_cpi_median FROM CPI_ALL_ITEMS_URBAN_PCTCHG
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_cpi_all_urban, NULL as Value_cpi_all_urban_pctchg, CPALTT01USM657N as Value_cpi_all, NULL as Value_cpi_median FROM CPI_ALL_ITEMS_URBAN
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_cpi_all_urban, NULL as Value_cpi_all_urban_pctchg, NULL as Value_cpi_all, USACPIALLMINMEI as Value_cpi_median FROM CPI_ALL
) 
GROUP BY RECORD_DATE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Create new table with FISCAL QUARTER
CREATE TABLE CPI_MERGED_BQ AS SELECT * FROM CPI_MERGED;
ALTER TABLE CPI_MERGED_BQ ADD (FISCAL_QUARTER VARCHAR2(5));
UPDATE CPI_MERGED_BQ SET FISCAL_QUARTER = 'Q' || TO_CHAR(RECORD_DATE, 'Q');
SELECT * FROM CPI_MERGED_BQ;
