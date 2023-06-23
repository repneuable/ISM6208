------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------
-- ########################################
-- ##### POPULATING FACT TABLE
-- ########################################

-- Before importing values in the FACT_DATA table, 
-- first ensure the primary key autoincrement
CREATE SEQUENCE fact_id_seq
  START WITH 1
  INCREMENT BY 1;

CREATE OR REPLACE TRIGGER fact_id_trigger
BEFORE INSERT ON FACT_DATA
FOR EACH ROW
BEGIN
  SELECT fact_id_seq.NEXTVAL
  INTO   :new.FACT_ID
  FROM   dual;
END;
/

-- SELECT * FROM FACT_DATA;

-- Insert data from CPI
INSERT INTO FACT_DATA (DATE_KEY, DIM_CPI_KEY)
SELECT dd.JULIAN_DAY_KEY, cpi.SURROGATE_KEY
FROM DATE_DIM dd
LEFT JOIN CPI_MERGED cpi ON dd.CAL_TEXT = TO_CHAR(cpi.RECORD_DATE, 'MM/DD/YYYY');

-- Insert data from FED_DEBT
UPDATE FACT_DATA fd 
SET DIM_FED_DEBT_KEY = 
(
  SELECT frd.SURROGATE_KEY FROM FED_DEBT_MERGED frd 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(frd.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM FED_DEBT_MERGED frd JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(frd.RECORD_DATE, 'MM/DD/YYYY')
  );

-- Insert data from FED_RATE
UPDATE FACT_DATA fd 
SET DIM_FED_RATE_KEY = 
(
  SELECT t.SURROGATE_KEY FROM FED_RATE_MERGED t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM FED_RATE_MERGED t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );
  
-- Insert data from GDP
UPDATE FACT_DATA fd 
SET DIM_GDP_KEY = 
(
  SELECT t.SURROGATE_KEY FROM GDP_MERGED t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM GDP_MERGED t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );

-- Insert data from M2
UPDATE FACT_DATA fd 
SET DIM_M2_KEY = 
(
  SELECT t.SURROGATE_KEY FROM M2_MERGED t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM M2_MERGED t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );

-- Insert data from MORT
UPDATE FACT_DATA fd 
SET DIM_MORT_KEY = 
(
  SELECT t.SURROGATE_KEY FROM MORT_MERGED t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM MORT_MERGED t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );

--********* Above MORT table unable to be added to FACT table as multiple
-- values exist for the same date for various locations.

-- Insert data from MSPUS
UPDATE FACT_DATA fd 
SET DIM_MSPUS_KEY = 
(
  SELECT t.SURROGATE_KEY FROM MSPUS t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM MSPUS t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );
  
-- 100% uploaded

-- Insert data from PCE
UPDATE FACT_DATA fd 
SET DIM_PCE_KEY = 
(
  SELECT t.SURROGATE_KEY FROM PCE t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM PCE t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );
  
-- 293 of 305 added


-- Insert data from UNEMP
UPDATE FACT_DATA fd 
SET DIM_UNEMP_KEY = 
(
  SELECT t.SURROGATE_KEY FROM UNEMP_MERGED t 
  JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY'))
WHERE EXISTS -- only update where a match exists
( 
  SELECT 1 FROM UNEMP_MERGED t JOIN DATE_DIM dd ON dd.JULIAN_DAY_KEY = fd.DATE_KEY
  WHERE dd.CAL_TEXT = TO_CHAR(t.RECORD_DATE, 'MM/DD/YYYY')
  );
-- 3727 of 3791 added

COMMIT;

-- Count of resulting values in FACT_DATA table
/* 
CPI         761
FED_DEBT    245	
FED_RATE    4735	
GDP         365	
M2          772	
MORT        0	
MSPUS       241	
PCE         293	
UNEMP       3727	
ALL         30681
*/

SELECT count(DIM_CPI_KEY), count(DIM_FED_DEBT_KEY), count(DIM_FED_RATE_KEY), count(DIM_GDP_KEY), count(DIM_M2_KEY),count(DIM_MORT_KEY), count(DIM_MSPUS_KEY), count(DIM_PCE_KEY), count(DIM_UNEMP_KEY), count(DATE_KEY) 
FROM FACT_DATA;




