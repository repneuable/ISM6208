------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------
-- ########################################
-- ##### EXPLORING TABLES BEFORE MERGE
-- ########################################

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- CPI
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM CPI_MEDIAN WHERE ROWNUM < 11;
SELECT * FROM CPI_ALL_ITEMS_URBAN_PCTCHG WHERE ROWNUM < 11;
SELECT * FROM CPI_ALL_ITEMS_URBAN WHERE ROWNUM < 11;
SELECT * FROM CPI_ALL WHERE ROWNUM < 11;

-- Difference in date ranges
------ (1983 -> 5/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_MEDIAN; 
------ (1960 -> 3/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_ALL_ITEMS_URBAN_PCTCHG;
------ (1960 -> 3/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_ALL_ITEMS_URBAN;
------ (1960 -> 3/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM CPI_ALL; 

SELECT * FROM CPI_MERGED WHERE ROWNUM < 11;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  M2
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Difference in date ranges
------ (1959 -> 3/1/2017)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM M2_US;
------ (1959 -> 4/1/2023)
SELECT MIN(RECORD_DATE) AS min, MAX(RECORD_DATE) as max FROM M2_REAL_US;

SELECT * FROM M2_US WHERE ROWNUM < 11;
SELECT * FROM M2_REAL_US WHERE ROWNUM < 11;

SELECT * FROM M2_MERGED WHERE ROWNUM < 11;
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--  PCE
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT * FROM PCE WHERE ROWNUM < 11;
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

SELECT * FROM US_HH_DEBT_GDP WHERE ROWNUM < 11;
SELECT * FROM REAL_GDP_PER_CAPITA WHERE ROWNUM < 11;
SELECT * FROM REAL_GDP WHERE ROWNUM < 11;

SELECT * FROM GDP_MERGED WHERE ROWNUM < 11;
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

