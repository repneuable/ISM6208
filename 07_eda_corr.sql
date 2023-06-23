------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------
-- ########################################
-- ##### CORRELATION, ANALYSIS ON ROLLUP TABLES
-- ########################################

-- MSPUS and Unemployment
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, 
    AVG(unemp.value_unemp_rate) AS AVG_UNEMP_RATE,
    ROUND(AVG(TO_NUMBER(REPLACE(REPLACE(mspus.mspus,'$', ''), ',', ''))),3) AS AVG_MSPUS
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN UNEMP unemp ON fd.DIM_UNEMP_KEY = unemp.SURROGATE_KEY
JOIN MSPUS mspus ON fd.DIM_MSPUS_KEY = mspus.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR;

/*          UNEMP   MSPUS
2022	1	4	    433100
2022	2	3.6	    449300
2022	3	3.5	    468000
2022	4	3.7	    479500
*/

-- MSPUS and Unemployment Correlation
SELECT CORR(AVG_UNEMP_RATE, AVG_MSPUS) as UNEMP_MSPUS_CORRELATION
FROM 
(
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, 
    AVG(unemp.value_unemp_rate) AS AVG_UNEMP_RATE,
    ROUND(AVG(TO_NUMBER(REPLACE(REPLACE(mspus.mspus,'$', ''), ',', ''))),3) AS AVG_MSPUS
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN UNEMP unemp ON fd.DIM_UNEMP_KEY = unemp.SURROGATE_KEY
JOIN MSPUS mspus ON fd.DIM_MSPUS_KEY = mspus.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR
);

/*
-0.0813106153287223549228005050633544562138
*/

-- Value of -0.08131 indicates a weak negative relationship
-- To a very small extent, as unemployment rates go up, 
-- the median sales price of houses sold tends to go down, and 
-- vice versa. (Housing prices more dynamic than this simple case)

-------- ROLLUP TABLES

-- Comparing GDP quarterly averages over the years
SELECT gdpq.YEAR_NBR, AVG(gdpq.AVG_VALUE_REAL_GDP) AS AVG_GDP_PER_YEAR
FROM GDP_Q gdpq
GROUP BY gdpq.YEAR_NBR
ORDER BY gdpq.YEAR_NBR;

-- In this query, since the data is pre-aggregated by quarter, 
-- it's a simpler step to then average over the year. 
-- ithout pre-aggregation, we'd need to work out how to average 
-- over the correct date intervals ourselves.

/*      AVG_GDP_PER_YEAR
2013	16553.3475
2014	16932.05175
2015	17390.29525
2016	17680.27375
2017	18076.6515
2018	18609.07825
2019	19036.05225
2020	18509.14275
2021	19609.81175
2022	20014.12825
2023	20246.439
*/

-- Seeing CPI changes over time
SELECT cpiq.YEAR_NBR, cpiq.QUARTER_NBR, cpiq.AVG_VALUE_CPI_ALL
FROM CPI_Q cpiq
ORDER BY cpiq.YEAR_NBR, cpiq.QUARTER_NBR;

/*          AVG_VALUE_CPI_ALL
2018	1	0.408
2018	2	0.324
2018	3	0.06
2018	4	-0.159
2019	1	0.393
2019	2	0.254
2019	3	0.08
2019	4	0.028
*/

-- Correlation between unemployment and federal reserve interest rate by quarter
SELECT CORR(unempq.AVG_VALUE_UNEMP_RATE, fedq.AVG_VALUE_INT_RATE_RESERVE) AS UNEMP_FED_INT_RATE_CORR
FROM UNEMP_Q unempq
JOIN FED_RATE_Q fedq ON unempq.YEAR_NBR = fedq.YEAR_NBR AND unempq.QUARTER_NBR = fedq.QUARTER_NBR;

/*
-0.6111712411651055435156189445908111549633
*/

-- Value of -0.611 indicates a moderately strong negative relationship. 
-- As the unemployment rate tends to increase, the Federal Interest Rate 
-- tends to decrease, and vice versa. The relationship between unemployment 
-- and interest rates in reality is influenced by a multitude of factors.