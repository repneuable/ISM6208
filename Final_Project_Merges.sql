------------------------------------------------------------
------------------------------------------------------------
--@Title:    Final Project Data Importing & Cleaning
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------

-- Get list of all 34 tables in 9 categories
-- SELECT table_name FROM user_tables;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CPI
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM CPI_MEDIAN WHERE ROWNUM < 11;
SELECT * FROM CPI_ALL_ITEMS_URBAN_PCTCHG WHERE ROWNUM < 11;
SELECT * FROM CPI_ALL_ITEMS_URBAN WHERE ROWNUM < 11;
SELECT * FROM CPI_ALL WHERE ROWNUM < 11;

SELECT * FROM CPI_MERGED WHERE ROWNUM < 11;
SELECT * FROM CPI_MERGED_BQ WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  M2
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM M2_US WHERE ROWNUM < 11;
SELECT * FROM M2_REAL_US WHERE ROWNUM < 11;

SELECT * FROM M2_MERGED WHERE ROWNUM < 11;
SELECT * FROM M2_MERGED_BQ WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  PCE
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM PCE WHERE ROWNUM < 11;
SELECT * FROM PCE_BQ WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  GDP
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM US_HH_DEBT_GDP WHERE ROWNUM < 11;
SELECT * FROM REAL_GDP_PER_CAPITA WHERE ROWNUM < 11;
SELECT * FROM REAL_GDP WHERE ROWNUM < 11;

SELECT * FROM GDP_MERGED WHERE ROWNUM < 11;
SELECT * FROM GDP_MERGED_BQ WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  FED Rate
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM REAL_INTEREST_RATE_10YR WHERE ROWNUM < 11;
SELECT * FROM MTG_AVG_30YR_FIXED_RATE_US WHERE ROWNUM < 11;
SELECT * FROM FED_DEBT_TOTAL_PUBLIC_DEBT WHERE ROWNUM < 11;
SELECT * FROM FED_FUNDS_EFFECTIVE_RATE WHERE ROWNUM < 11;
SELECT * FROM INT_RATE_RESERVE_BAL WHERE ROWNUM < 11;
SELECT * FROM TREASURY_YIELD_10YR WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  FED Debt
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM FED_DEBT_FRB WHERE ROWNUM < 11;
SELECT * FROM FED_DEBT_GDP_PCT WHERE ROWNUM < 11;
SELECT * FROM FED_TOTAL_DEBT WHERE ROWNUM < 11;
SELECT * FROM FED_TOTAL_PUBLIC_DEBT WHERE ROWNUM < 11;
SELECT * FROM GROSS_DEBT_PCT_GDP WHERE ROWNUM < 11;
SELECT * FROM DEBT_SERVICE_PCT_INCOME WHERE ROWNUM < 11;
SELECT * FROM MTG_DEBT_SERVICE_PCT_INCOME WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Unemployment Rate
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM UNEMP_RATE WHERE ROWNUM < 11;
SELECT * FROM UNEMP_LEVEL  WHERE ROWNUM < 11;
SELECT * FROM NONCYCLICAL_UNEMP_RATE WHERE ROWNUM < 11;
SELECT * FROM SMA_4WK_UNEMP_CLAIMS WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Median Sales Price of Houses US
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 
SELECT * FROM MSPUS WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Mortgage Delinquency Rates
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM MTG_DELINQ_RATES_CO_30_89 WHERE ROWNUM < 11;
SELECT * FROM MORT_DELINQ_RATES_METRO_30_89 WHERE ROWNUM < 11;
SELECT * FROM MORT_DELINQ_RATES_ST_30_89 WHERE ROWNUM < 11;
SELECT * FROM MORT_DELINQ_RATES_CO_90PLUS WHERE ROWNUM < 11;
SELECT * FROM MORT_DELINQ_RATES_METRO_90PLUS WHERE ROWNUM < 11;
SELECT * FROM MORT_DELINQ_RATES_ST_90PLUS WHERE ROWNUM < 11;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CONSOLIDATING TABLES
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CPI 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Difference in date ranges
------ (1983 -> 5/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_MEDIAN; 
------ (1960 -> 3/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_ALL_ITEMS_URBAN_PCTCHG;
------ (1960 -> 3/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_ALL_ITEMS_URBAN;
------ (1960 -> 3/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_ALL; 
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- LEFT JOINS for new table
CREATE TABLE CPI_MERGED AS
SELECT a.RECORD_DATE, a.CPALTT01USM657N AS Value_cpi_all_urban,
       b.CPALTT01USM657N AS Value_cpi_all_urban_pctchg,
       c.USACPIALLMINMEI AS Value_cpi_all,
       d.MEDCPIM158SFRBCLE AS Value_cpi_median
FROM cpi_all_items_urban a
LEFT JOIN cpi_all_items_urban_pctchg b
    ON a.RECORD_DATE = b.RECORD_DATE
LEFT JOIN cpi_all c
    ON a.RECORD_DATE = c.RECORD_DATE
LEFT JOIN cpi_median d
    ON a.RECORD_DATE = d.RECORD_DATE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Show consistent
SELECT COUNT(*) FROM cpi_all_items_urban;           -- 759
SELECT COUNT(*) FROM cpi_all_items_urban_pctchg;    -- 759
SELECT COUNT(*) FROM cpi_all;                       -- 759
SELECT COUNT(*) FROM cpi_median;                    -- 485
SELECT COUNT(*) FROM CPI_MERGED;                    -- 759
SELECT * FROM CPI_MERGED ORDER BY RECORD_DATE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Create new table with FISCAL QUARTER
CREATE TABLE CPI_MERGED_BQ AS SELECT * FROM CPI_MERGED;
ALTER TABLE CPI_MERGED_BQ ADD (FISCAL_QUARTER VARCHAR2(5));
UPDATE CPI_MERGED_BQ SET FISCAL_QUARTER = 'Q' || TO_CHAR(RECORD_DATE, 'Q');
SELECT * FROM CPI_MERGED_BQ;

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  M2
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Difference in date ranges
------ (1959 -> 3/1/2017)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM M2_US;
------ (1959 -> 4/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM M2_REAL_US;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- LEFT JOIN for new table
CREATE TABLE M2_MERGED AS
SELECT a.RECORD_DATE, a.M2REAL AS Value_m2_real_us,
       b.MYAGM2USM052S AS Value_m2_us
FROM M2_REAL_US a
LEFT JOIN M2_US b
    ON a.RECORD_DATE = b.RECORD_DATE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Show consistent
SELECT COUNT(*) FROM M2_REAL_US;    -- 772
SELECT COUNT(*) FROM M2_US;         -- 699
SELECT COUNT(*) FROM M2_MERGED;     -- 772
SELECT * FROM M2_MERGED ORDER BY RECORD_DATE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Create new table with FISCAL QUARTER
CREATE TABLE M2_MERGED_BQ AS SELECT * FROM M2_MERGED;
ALTER TABLE M2_MERGED_BQ ADD (FISCAL_QUARTER VARCHAR2(5));
UPDATE M2_MERGED_BQ SET FISCAL_QUARTER = 'Q' || TO_CHAR(RECORD_DATE, 'Q');
SELECT * FROM M2_MERGED_BQ;

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  PCE
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Create new table with FISCAL QUARTER
CREATE TABLE PCE_BQ AS SELECT * FROM PCE;
ALTER TABLE PCE_BQ ADD (FISCAL_QUARTER VARCHAR2(5));
UPDATE PCE_BQ SET FISCAL_QUARTER = 'Q' || TO_CHAR(RECORD_DATE, 'Q');
SELECT * FROM PCE_BQ;

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  GDP
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Difference in date ranges
------ (1/5/2001 -> 1/22/2010)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM US_HH_DEBT_GDP;
------ (1947 -> 1/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM REAL_GDP_PER_CAPITA;
------ (1947 -> 1/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM REAL_GDP;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- LEFT JOIN for new table
CREATE TABLE GDP_MERGER AS
SELECT a.RECORD_DATE, a.GDPC1 AS Value_real_gdp,
       b.A939RX0Q048SBEA AS Value_real_gdp_per_capita
FROM REAL_GDP a
LEFT JOIN REAL_GDP_PER_CAPITA b
    ON a.RECORD_DATE = b.RECORD_DATE;

-- Use LEFT JOIN and UNION ALL for table with the combined values from 
-- the GDP_MERGER and third table to be merged, with NULL values where
-- there is no match in either respective table.
CREATE TABLE GDP_MERGED AS
SELECT t2.RECORD_DATE, t1.Value_real_gdp, t1.Value_real_gdp_per_capita, t2.HDTGPDUSQ163N
FROM US_HH_DEBT_GDP t2
LEFT JOIN GDP_MERGER t1 ON t2.RECORD_DATE = t1.RECORD_DATE
UNION ALL
SELECT t1.RECORD_DATE, t1.Value_real_gdp, t1.Value_real_gdp_per_capita, NULL AS HDTGPDUSQ163N
FROM GDP_MERGER t1
WHERE t1.RECORD_DATE NOT IN (SELECT RECORD_DATE FROM US_HH_DEBT_GDP);
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Show consistent
SELECT COUNT(*) FROM US_HH_DEBT_GDP;        -- 72
SELECT COUNT(*) FROM REAL_GDP_PER_CAPITA;   -- 305
SELECT COUNT(*) FROM REAL_GDP;              -- 305
SELECT COUNT(*) FROM GDP_MERGED;            -- 377

SELECT * FROM GDP_MERGED ORDER BY RECORD_DATE;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Create new table with FISCAL QUARTER
CREATE TABLE GDP_MERGED_BQ AS SELECT * FROM GDP_MERGED;
ALTER TABLE GDP_MERGED_BQ ADD (FISCAL_QUARTER VARCHAR2(5));
UPDATE GDP_MERGED_BQ SET FISCAL_QUARTER = 'Q' || TO_CHAR(RECORD_DATE, 'Q');
SELECT * FROM GDP_MERGED_BQ;

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  FED Rate
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
-- Create new table with FISCAL QUARTER
CREATE TABLE FED_RATE_MERGED_BQ AS SELECT * FROM FED_RATE_MERGED;
ALTER TABLE FED_RATE_MERGED_BQ ADD (FISCAL_QUARTER VARCHAR2(5));
UPDATE FED_RATE_MERGED_BQ SET FISCAL_QUARTER = 'Q' || TO_CHAR(RECORD_DATE, 'Q');
SELECT * FROM FED_RATE_MERGED_BQ ORDER BY RECORD_DATE;

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  FED Debt
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Median Sales Price of Houses US
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Unemployment Rate
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  Mortgage Delinquency Rates
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
