------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------
-- ########################################
-- ##### CREATING ROLLUP TABLES BY QUARTER
-- ########################################


CREATE TABLE CPI_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(VALUE_CPI_ALL_URBAN),3) AS AVG_VALUE_CPI_ALL_URBAN,
  ROUND(AVG(VALUE_CPI_ALL_URBAN_PCTCHG),3) AS AVG_VALUE_CPI_ALL_URBAN_PCTCHG,
  ROUND(AVG(VALUE_CPI_ALL),3) AS AVG_VALUE_CPI_ALL,
  ROUND(AVG(VALUE_CPI_MEDIAN),3) AS AVG_VALUE_CPI_MEDIAN,
  COUNT(*) AS COUNT
FROM 
  CPI_MERGED cpi
JOIN 
  DATE_DIM dd ON cpi.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;
  
SELECT * FROM CPI_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE FED_DEBT_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(VALUE_FED_DEBT_FRB),3) AS AVG_VALUE_FED_DEBT_FRB,
  ROUND(AVG(VALUE_FED_DEBT_GDP),3) AS AVG_VALUE_FED_DEBT_GDP,
  ROUND(AVG(VALUE_FED_DEBT),3) AS AVG_VALUE_FED_DEBT,
  ROUND(AVG(VALUE_FED_TOTAL_DEBT),3) AS AVG_VALUE_FED_TOTAL_DEBT,
  ROUND(AVG(VALUE_FED_GROSS_DEBT_GDP),3) AS AVG_VALUE_FED_GROSS_DEBT_GDP,
  ROUND(AVG(VALUE_FED_DEBT_PCT_INC),3) AS AVG_VALUE_FED_DEBT_PCT_INC,
  ROUND(AVG(VALUE_MTG_DEBT_PCT_INC),3) AS AVG_VALUE_MTG_DEBT_PCT_INC,
  COUNT(*) AS COUNT
FROM 
  FED_DEBT_MERGED fdm
JOIN 
  DATE_DIM dd ON fdm.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;


SELECT * FROM FED_DEBT_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--VALUE_TREASURY_YIELD column originally VARCHAR2 data type 
--because the import include text with just a period punctuation mark.
UPDATE FED_RATE_MERGED
SET VALUE_TREASURY_YIELD = NULL
WHERE VALUE_TREASURY_YIELD = '.';

CREATE TABLE FED_RATE_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(VALUE_MTG_AVG_30),3) AS AVG_VALUE_MTG_AVG_30,
  ROUND(AVG(VALUE_REAL_INR_RATE_10YR),3) AS AVG_VALUE_REAL_INR_RATE_10YR,
  ROUND(AVG(VALUE_FED_DEBT),3) AS AVG_VALUE_FED_DEBT,
  ROUND(AVG(VALUE_FED_FUNDS_EFF_RATE),3) AS AVG_VALUE_FED_FUNDS_EFF_RATE,
  ROUND(AVG(VALUE_INT_RATE_RESERVE),3) AS AVG_VALUE_INT_RATE_RESERVE,
  ROUND(AVG(TO_NUMBER(VALUE_TREASURY_YIELD)),3) AS AVG_VALUE_TREASURY_YIELD,
  COUNT(*) AS COUNT
FROM 
  FED_RATE_MERGED frm
JOIN 
  DATE_DIM dd ON frm.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;

SELECT * FROM FED_RATE_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE GDP_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(VALUE_REAL_GDP),3) AS AVG_VALUE_REAL_GDP,
  ROUND(AVG(VALUE_REAL_GDP_PER_CAPITA),3) AS AVG_VALUE_REAL_GDP_PER_CAPITA,
  ROUND(AVG(VALUE_US_HH_DEBT),3) AS AVG_VALUE_US_HH_DEBT,
  COUNT(*) AS COUNT
FROM 
  GDP_MERGED gdp
JOIN 
  DATE_DIM dd ON gdp.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;

SELECT * FROM GDP_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE MORT_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  REGIONTYPE,
  DELINQ_TIME,
  ROUND(AVG(MORTGAGEDATA),3) AS AVG_MORTGAGEDATA,
  COUNT(*) AS COUNT
FROM 
  MORT_MERGED mort
JOIN 
  DATE_DIM dd ON mort.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR,
  mort.REGIONTYPE,
  mort.DELINQ_TIME;

SELECT * FROM MORT_Q 
WHERE DELINQ_TIME = '30-89'
ORDER BY YEAR_NBR,QUARTER_NBR;

SELECT * FROM MORT_Q 
WHERE DELINQ_TIME = '90-180'
ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE MSPUS_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(TO_NUMBER(REPLACE(REPLACE(MSPUS,'$', ''), ',', ''))),3) AS AVG_MSPUS,
  COUNT(*) AS COUNT
FROM 
  MSPUS m
JOIN 
  DATE_DIM dd ON m.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;
  
SELECT * FROM MSPUS_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE PCE_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(PCEC),3) AS AVG_PCE,
  COUNT(*) AS COUNT
FROM 
  PCE p
JOIN 
  DATE_DIM dd ON p.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;
  
SELECT * FROM PCE_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CREATE TABLE UNEMP_QUARTER_ROLLUP AS
SELECT 
  dd.YEAR_NBR,
  dd.QUARTER_NBR,
  ROUND(AVG(VALUE_UNEMP_RATE),3) AS AVG_VALUE_UNEMP_RATE,
  ROUND(AVG(VALUE_UNEMP_LEVEL),3) AS AVG_VALUE_UNEMP_LEVEL,
  ROUND(AVG(VALUE_UNEMP_NONCYC),3) AS AVG_VALUE_UNEMP_NONCYC,
  ROUND(AVG(VALUE_UNEMP_CLAIMS),3) AS AVG_VALUE_UNEMP_CLAIMS,
  COUNT(*) AS COUNT
FROM 
  UNEMP_MERGED un
JOIN 
  DATE_DIM dd ON un.DATE_KEY = dd.JULIAN_DAY_KEY
GROUP BY 
  dd.YEAR_NBR, 
  dd.QUARTER_NBR;
  
SELECT * FROM UNEMP_QUARTER_ROLLUP ORDER BY YEAR_NBR,QUARTER_NBR;

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ########################################
-- ##### RENAMING TABLES
-- ########################################

ALTER TABLE CPI_QUARTER_ROLLUP RENAME TO CPI_Q;
ALTER TABLE FED_DEBT_QUARTER_ROLLUP RENAME TO FED_DEBT_Q;
ALTER TABLE FED_RATE_QUARTER_ROLLUP RENAME TO FED_RATE_Q;
ALTER TABLE GDP_QUARTER_ROLLUP RENAME TO GDP_Q;
ALTER TABLE M2_QUARTER_ROLLUP RENAME TO M2_Q;
ALTER TABLE MORT_QUARTER_ROLLUP RENAME TO MORT_Q;
ALTER TABLE MSPUS_QUARTER_ROLLUP RENAME TO MSPUS_Q;
ALTER TABLE PCE_QUARTER_ROLLUP RENAME TO PCE_Q;
ALTER TABLE UNEMP_QUARTER_ROLLUP RENAME TO UNEMP_Q;


ALTER TABLE CPI_MERGED RENAME TO CPI;
ALTER TABLE FED_DEBT_MERGED RENAME TO FED_DEBT;
ALTER TABLE FED_RATE_MERGED RENAME TO FED_RATE;
ALTER TABLE GDP_MERGED RENAME TO GDP;
ALTER TABLE M2_MERGED RENAME TO M2;
ALTER TABLE MORT_MERGED RENAME TO MORT;
ALTER TABLE UNEMP_MERGED RENAME TO UNEMP;

--commit;