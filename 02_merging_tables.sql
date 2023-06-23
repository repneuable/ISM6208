------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------
-- ########################################
-- ##### MERGING COMMON TABLES
-- ########################################
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  CPI
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
--  FED RATE
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
--  M2
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE M2_MERGED AS
SELECT a.RECORD_DATE, a.M2REAL AS Value_m2_real_us,
       b.MYAGM2USM052S AS Value_m2_us
FROM M2_REAL_US a
LEFT JOIN M2_US b
    ON a.RECORD_DATE = b.RECORD_DATE;

CREATE TABLE M2_MERGED AS
SELECT 
  RECORD_DATE,
  MAX(Value_m2_real_us) as Value_m2_real_us, 
  MAX(Value_m2_us) as Value_m2_us
FROM (
  SELECT RECORD_DATE, M2REAL as Value_m2_real_us, NULL as Value_m2_us FROM M2_REAL_US
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_m2_real_us, MYAGM2USM052S as Value_m2_us FROM M2_US
) 
GROUP BY RECORD_DATE;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  PCE
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- N/A

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  GDP
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE GDP_MERGED AS
SELECT 
  RECORD_DATE,
  MAX(Value_real_gdp) as Value_real_gdp, 
  MAX(Value_real_gdp_per_capita) as Value_real_gdp_per_capita, 
  MAX(Value_us_hh_debt) as Value_us_hh_debt
FROM (
  SELECT RECORD_DATE, GDPC1 as Value_real_gdp, NULL as Value_real_gdp_per_capita, NULL as Value_us_hh_debt FROM REAL_GDP
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_real_gdp, A939RX0Q048SBEA as Value_real_gdp_per_capita, NULL as Value_us_hh_debt FROM REAL_GDP_PER_CAPITA
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_real_gdp, NULL as Value_real_gdp_per_capita, HDTGPDUSQ163N as Value_us_hh_debt FROM US_HH_DEBT_GDP
) 
GROUP BY RECORD_DATE;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  FED Debt
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE FED_DEBT_MERGED AS
SELECT 
  RECORD_DATE,
  MAX(Value_fed_debt_frb) as Value_fed_debt_frb, 
  MAX(Value_fed_debt_gdp) as Value_fed_debt_gdp, 
  MAX(Value_fed_debt) as Value_fed_debt, 
  MAX(Value_fed_total_debt) as Value_fed_total_debt, 
  MAX(Value_fed_gross_debt_gdp) as Value_fed_gross_debt_gdp, 
  MAX(Value_fed_debt_pct_inc) as Value_fed_debt_pct_inc, 
  MAX(Value_mtg_debt_pct_inc) as Value_mtg_debt_pct_inc
FROM (
  SELECT RECORD_DATE, FDHBFRBN as Value_fed_debt_frb, NULL as Value_fed_debt_gdp, NULL as Value_fed_debt, NULL as Value_fed_total_debt, NULL as Value_fed_gross_debt_gdp, NULL as Value_fed_debt_pct_inc, NULL as Value_mtg_debt_pct_inc FROM FED_DEBT_FRB
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_fed_debt_frb, GFDEGDQ188S as Value_fed_debt_gdp, NULL as Value_fed_debt, NULL as Value_fed_total_debt, NULL as Value_fed_gross_debt_gdp, NULL as Value_fed_debt_pct_inc, NULL as Value_mtg_debt_pct_inc FROM FED_DEBT_GDP_PCT
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_fed_debt_frb, NULL as Value_fed_debt_gdp, GFDEBTN as Value_fed_debt, NULL as Value_fed_total_debt, NULL as Value_fed_gross_debt_gdp, NULL as Value_fed_debt_pct_inc, NULL as Value_mtg_debt_pct_inc FROM FED_TOTAL_DEBT
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_fed_debt_frb, NULL as Value_fed_debt_gdp, NULL as Value_fed_debt, GFDEBTN as Value_fed_total_debt, NULL as Value_fed_gross_debt_gdp, NULL as Value_fed_debt_pct_inc, NULL as Value_mtg_debt_pct_inc FROM FED_TOTAL_PUBLIC_DEBT
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_fed_debt_frb, NULL as Value_fed_debt_gdp, NULL as Value_fed_debt, NULL as Value_fed_total_debt, GFDGDPA188S as Value_fed_gross_debt_gdp, NULL as Value_fed_debt_pct_inc, NULL as Value_mtg_debt_pct_inc FROM GROSS_DEBT_PCT_GDP
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_fed_debt_frb, NULL as Value_fed_debt_gdp, NULL as Value_fed_debt, NULL as Value_fed_total_debt, NULL as Value_fed_gross_debt_gdp, TDSP as Value_fed_debt_pct_inc, NULL as Value_mtg_debt_pct_inc FROM DEBT_SERVICE_PCT_INCOME
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_fed_debt_frb, NULL as Value_fed_debt_gdp, NULL as Value_fed_debt, NULL as Value_fed_total_debt, NULL as Value_fed_gross_debt_gdp, NULL as Value_fed_debt_pct_inc, MDSP as Value_mtg_debt_pct_inc FROM MTG_DEBT_SERVICE_PCT_INCOME
) 
GROUP BY RECORD_DATE;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Unemployment Rate
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
CREATE TABLE UNEMP_MERGED AS
SELECT 
  RECORD_DATE,
  MAX(Value_unemp_rate) as Value_unemp_rate, 
  MAX(Value_unemp_level) as Value_unemp_level, 
  MAX(Value_unemp_noncyc) as Value_unemp_noncyc, 
  MAX(Value_unemp_claims) as Value_unemp_claims
FROM (
  SELECT RECORD_DATE, UNRATE as Value_unemp_rate, NULL as Value_unemp_level, NULL as Value_unemp_noncyc, NULL as Value_unemp_claims FROM UNEMP_RATE
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_unemp_rate, UNEMPLOY as Value_unemp_level, NULL as Value_unemp_noncyc, NULL as Value_unemp_claims FROM UNEMP_LEVEL
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_unemp_rate, NULL as Value_unemp_level, NROU as Value_unemp_noncyc, NULL as Value_unemp_claims FROM NONCYCLICAL_UNEMP_RATE
  UNION ALL
  SELECT RECORD_DATE, NULL as Value_unemp_rate, NULL as Value_unemp_level, NULL as Value_unemp_noncyc, CC4WSA as Value_unemp_claims FROM SMA_4WK_UNEMP_CLAIMS
) 
GROUP BY RECORD_DATE;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Median Sales Price of Houses US
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- N/A

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Mortgage Delinquency Rates
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Making columns consistent accross geograhical granularities 
-- This involved making 1 location column for county tables
-- insetad of 2 (county, state) and modifying location code
-- to match state and metro tables
ALTER TABLE MTG_DELINQ_RATES_CO_30_89 ADD LOCATION_NAME VARCHAR(255);
ALTER TABLE MTG_DELINQ_RATES_CO_30_89 ADD CBSACODE VARCHAR(10);
ALTER TABLE MORT_DELINQ_RATES_CO_90PLUS ADD LOCATION_NAME VARCHAR(255);
ALTER TABLE MORT_DELINQ_RATES_CO_90PLUS ADD CBSACODE VARCHAR(10);

UPDATE MTG_DELINQ_RATES_CO_30_89 SET LOCATION_NAME = COUNTY_NAME || ' ' || STATE;
UPDATE MTG_DELINQ_RATES_CO_30_89 SET CBSACODE = FIPSCODE;
UPDATE MORT_DELINQ_RATES_CO_90PLUS SET LOCATION_NAME = COUNTY_NAME || ' ' || STATE;
UPDATE MORT_DELINQ_RATES_CO_90PLUS SET CBSACODE = FIPSCODE;

-- Adding new columns with flag to keep categorization after merging
-- This is necessary as 3 tables are for 30-89 time range
-- and 3 others for 90-180 time range
ALTER TABLE MTG_DELINQ_RATES_CO_30_89 ADD DELINQ_TIME VARCHAR(12);
ALTER TABLE MORT_DELINQ_RATES_METRO_30_89 ADD DELINQ_TIME VARCHAR(12);
ALTER TABLE MORT_DELINQ_RATES_ST_30_89 ADD DELINQ_TIME VARCHAR(12);
ALTER TABLE MORT_DELINQ_RATES_CO_90PLUS ADD DELINQ_TIME VARCHAR(12);
ALTER TABLE MORT_DELINQ_RATES_METRO_90PLUS ADD DELINQ_TIME VARCHAR(12);
ALTER TABLE MORT_DELINQ_RATES_ST_90PLUS ADD DELINQ_TIME VARCHAR(12);

UPDATE MTG_DELINQ_RATES_CO_30_89 SET DELINQ_TIME = '30-89';
UPDATE MORT_DELINQ_RATES_METRO_30_89 SET DELINQ_TIME = '30-89';
UPDATE MORT_DELINQ_RATES_ST_30_89 SET DELINQ_TIME = '30-89';
UPDATE MORT_DELINQ_RATES_CO_90PLUS SET DELINQ_TIME = '90-180';
UPDATE MORT_DELINQ_RATES_METRO_90PLUS SET DELINQ_TIME = '30-89';
UPDATE MORT_DELINQ_RATES_ST_90PLUS SET DELINQ_TIME = '30-89';

-- Create merged table by UNION ALL for all 6 
CREATE TABLE MORT_MERGED AS
SELECT
    REGIONTYPE,CBSACODE,RECORD_DATE,MORTGAGEDATA,LOCATION_NAME,DELINQ_TIME
FROM MTG_DELINQ_RATES_CO_30_89
UNION ALL
SELECT
    REGIONTYPE,CBSACODE,RECORD_DATE,MORTGAGEDATA,LOCATION_NAME,DELINQ_TIME
FROM MORT_DELINQ_RATES_METRO_30_89
UNION ALL
SELECT
    REGIONTYPE,CBSACODE,RECORD_DATE,MORTGAGEDATA,LOCATION_NAME,DELINQ_TIME
FROM MORT_DELINQ_RATES_ST_30_89
UNION ALL
SELECT
    REGIONTYPE,CBSACODE,RECORD_DATE,MORTGAGEDATA,LOCATION_NAME,DELINQ_TIME
FROM MORT_DELINQ_RATES_CO_90PLUS
UNION ALL
SELECT
    REGIONTYPE,CBSACODE,RECORD_DATE,MORTGAGEDATA,LOCATION_NAME,DELINQ_TIME
FROM MORT_DELINQ_RATES_METRO_90PLUS
UNION ALL
SELECT
    REGIONTYPE,CBSACODE,RECORD_DATE,MORTGAGEDATA,LOCATION_NAME,DELINQ_TIME
FROM MORT_DELINQ_RATES_ST_90PLUS;


