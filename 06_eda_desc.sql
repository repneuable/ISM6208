------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------
-- ########################################
-- ##### EDA, CORRELATION, AGGREGATION
-- ########################################

-- Average Consumer Price Index by year and quarter
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, AVG(cpi.value_cpi_all_urban) AS AVG_CPI
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN CPI cpi ON fd.DIM_CPI_KEY = cpi.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR;

/*
1998	4	2.507
1999	1	1.710
1999	2	1.858
1999	3	2.411
*/

-- Total Federal Reserve Bank Debt and Total Public Debt by year and quarter
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, SUM(fed_debt.value_fed_debt_frb) AS TOTAL_FED_RESERVE_BANK_DEBT, SUM(fed_debt.value_fed_total_debt) AS TOTAL_PUBLIC_DEBT
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN FED_DEBT fed_debt ON fd.DIM_FED_DEBT_KEY = fed_debt.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR;


/*          
1998	3	446	    5526193
1998	4	452.1	5614217
1999	1	465.7	5651615
*/

--Average Unemployment Rate by year and quarter
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, ROUND(AVG(unemp.value_unemp_rate),3) AS AVG_UNEMP_RATE
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN UNEMP unemp ON fd.DIM_UNEMP_KEY = unemp.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR;

/*
2021	1	6.2
2021	2	5.933
2021	3	5.133
2021	4	4.2
2022	1	3.8
2022	2	3.6
2022	3	3.567
2022	4	3.6
*/

--Median Sales Price of Houses Sold for the United States (MSPUS) by year and quarter
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, ROUND(AVG(TO_NUMBER(REPLACE(REPLACE(mspus.mspus,'$', ''), ',', ''))),3) AS AVG_MSPUS
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN MSPUS mspus ON fd.DIM_MSPUS_KEY = mspus.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR;

/*
2022	1	433100
2022	2	449300
2022	3	468000
2022	4	479500
2023	1	436800
*/


-- Correlation between CPI and Federal Reserve Rate
SELECT CORR(AVG_CPI, AVG_FED_RATE) as CPI_FEDRATE_CORRELATION
FROM 
    (SELECT dd.YEAR_NBR, dd.QUARTER_NBR, 
    AVG(cpi.value_cpi_all_urban) AS AVG_CPI, 
    AVG(fed_rate.value_fed_funds_eff_rate) AS AVG_FED_RATE
    FROM FACT_DATA fd
    JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
    JOIN CPI cpi ON fd.DIM_CPI_KEY = cpi.SURROGATE_KEY
    JOIN FED_RATE fed_rate ON fd.DIM_FED_RATE_KEY = fed_rate.SURROGATE_KEY
    GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR);

/*
0.2580810188828583316375466634633843890365
*/

-- Value of 0.2581 is a positive but relatively weak relationship 
-- between the two variables. This means that as the CPI tends to increase, 
-- the Federal Reserve Rate also tends to increase, but this relationship 
-- is not very strong.
-- The fact that it's not a strong correlation (1.0 or close to it) 
-- might suggest that there are many other factors influencing the 
-- Federal Reserve Rate, or that the response of the Federal Reserve 
-- to changes in inflation isn't perfectly consistent or immediate.

-- Seasonality analysis on Unemployment Rates  
SELECT dd.MONTH_NBR, dd.QUARTER_NBR, ROUND(AVG(unemp.value_unemp_rate),3) AS AVG_UNEMP_RATE,
    COUNT(*) as COUNT
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN UNEMP unemp ON fd.DIM_UNEMP_KEY = unemp.SURROGATE_KEY
GROUP BY CUBE (dd.MONTH_NBR, dd.QUARTER_NBR);
-- Using the CUBE function, we can generate a report that 
-- allows us to analyze seasonality across different metrics.
-- This query will return the average unemployment rate for 
-- each month and quarter, as well as combinations of these 
-- (e.g., all quarters combined for each month, and all months 
-- combined for each quarter).
/*
		5.743	3727
	1	5.699	929
	2	5.818	934
	3	5.749	932
	4	5.706	932
1		5.705	315
1	1	5.705	315
2		5.692	296
2	1	5.692	296
3		5.699	318
3	1	5.699	318
4		5.834	310
4	2	5.834	310
5		5.804	318
5	2	5.804	318
6		5.815	306
6	2	5.815	306
*/

-- in combination with MSPUS (fewer rows)
SELECT dd.MONTH_NBR, dd.QUARTER_NBR, ROUND(AVG(unemp.value_unemp_rate),3) AS AVG_UNEMP_RATE,
    ROUND(AVG(TO_NUMBER(REPLACE(REPLACE(mspus.mspus,'$', ''), ',', ''))),3) AS AVG_MSPUS,
    COUNT(*) as COUNT
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN UNEMP unemp ON fd.DIM_UNEMP_KEY = unemp.SURROGATE_KEY
JOIN MSPUS mspus ON fd.DIM_MSPUS_KEY = mspus.SURROGATE_KEY
GROUP BY CUBE (dd.MONTH_NBR, dd.QUARTER_NBR);

/*      UNEMP   MSPSUS
4		6.082	147216.667	60
4	2	6.082	147216.667	60
7		5.988	147998.333	60
7	3	5.988	147998.333	60
10		5.898	151531.667	60
10	4	5.898	151531.667	60
*/


-- Comparisons between Total Debt and GDP
-- This query will compare the total debt and average real GDP by year. 
-- By analyzing the results, you can see how total debt changes in relation to GDP.
SELECT dd.YEAR_NBR, SUM(fed_debt.value_fed_total_debt) AS TOTAL_DEBT, AVG(gdp.value_real_gdp) AS AVG_GDP
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN FED_DEBT fed_debt ON fd.DIM_FED_DEBT_KEY = fed_debt.SURROGATE_KEY
JOIN GDP gdp ON fd.DIM_GDP_KEY = gdp.SURROGATE_KEY
GROUP BY dd.YEAR_NBR
ORDER BY dd.YEAR_NBR;

/*      TOTAL_DEBT  GDP
2019	89971945	19036.05225
2020	104394243	18509.14275
2021	114708140	19609.81175
2022	123318143	20014.12825
2023	31458438	20246.439

*/

-- Evaluating 5 tables at once 
SELECT dd.YEAR_NBR, dd.QUARTER_NBR, 
    AVG(cpi.value_cpi_all_urban) AS AVG_CPI, 
    AVG(fed_rate.value_fed_funds_eff_rate) AS AVG_FED_RATE,
    AVG(gdp.value_real_gdp_per_capita) AS AVG_GDP_PER_CAPITA,
    AVG(unemp.value_unemp_rate) AS AVG_UNEMP_RATE,
    ROUND(AVG(TO_NUMBER(REPLACE(REPLACE(mspus.mspus,'$', ''), ',', ''))),3) AS AVG_MSPUS
FROM FACT_DATA fd
JOIN DATE_DIM dd ON fd.DATE_KEY = dd.JULIAN_DAY_KEY
JOIN CPI cpi ON fd.DIM_CPI_KEY = cpi.SURROGATE_KEY
JOIN FED_RATE fed_rate ON fd.DIM_FED_RATE_KEY = fed_rate.SURROGATE_KEY
JOIN GDP gdp ON fd.DIM_GDP_KEY = gdp.SURROGATE_KEY
JOIN UNEMP unemp ON fd.DIM_UNEMP_KEY = unemp.SURROGATE_KEY
JOIN MSPUS mspus ON fd.DIM_MSPUS_KEY = mspus.SURROGATE_KEY
GROUP BY dd.YEAR_NBR, dd.QUARTER_NBR
ORDER BY dd.YEAR_NBR, dd.QUARTER_NBR;

/*          CPI       FED_RATE   GDP  UNEMP  MSPUS
2022	1	6.992826311	0.07	59836	4	433100
2022	2	6.030320223	0.33	59688	3.6	449300
2022	3	6.423611019	1.58	60080	3.5	468000
2022	4	6.507748044	3.08	60376	3.7	479500

*/


