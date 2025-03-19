# PROJECT: World Life Expectancy:

# 1) DATA CLEANING
USE world_life_expectancy_project;
SELECT * FROM world_life_expectancy;

###############################################################
-- # REMOVING DUPLICATES:

-- First Identify duplicates based on unique column. Here we are concatenating Country and Year columns to create a unique column
SELECT Country, Year, 
CONCAT(Country,Year) AS candidate_key,
COUNT(CONCAT(Country,Year)) as count_candidate_key
FROM world_life_expectancy
GROUP BY candidate_key
HAVING count_candidate_key > 1
;

-- Check if ROW_ID has only unique values
SELECT ROW_ID, COUNT(ROW_ID)
FROM world_life_expectancy
GROUP BY ROW_ID
HAVING COUNT(ROW_ID)> 1;
-- OR
SELECT COUNT(DISTINCT ROW_ID) FROM world_life_expectancy;  -- Output: 2941
SELECT COUNT(*) FROM world_life_expectancy; -- Output: 2941 Therefore, no duplicate ROW_ID (ROW_ID has only unique values)

-- Identify duplicates using row_number() window function
SELECT * FROM world_life_expectancy
WHERE ROW_ID IN (
	SELECT ROW_ID FROM (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY ROW_ID) AS row_num
	FROM world_life_expectancy) AS T
	WHERE row_num >1);

-- Delete duplicates using row_number() window function
DELETE FROM world_life_expectancy
WHERE ROW_ID IN (
	SELECT ROW_ID FROM (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY ROW_ID) AS row_num
	FROM world_life_expectancy) AS T
	WHERE row_num >1);

########################################################
-- # CHECK FOR MISSING DATA:

-- Dynamic query to find missing values in all columns
SELECT CONCAT(
  'CASE WHEN `',
  COLUMN_NAME, '` IS NULL OR `', 
  COLUMN_NAME , '` = \'\' AND `', 
  COLUMN_NAME, '` <> 0 THEN ''',
  COLUMN_NAME,''' END,'
) AS case_col_names
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'world_life_expectancy_project'
AND TABLE_NAME = 'world_life_expectancy';


-- Output of above dynamic query:
CASE WHEN `Country` IS NULL OR `Country` = '' AND `Country` <> 0 THEN 'Country' END,
CASE WHEN `Year` IS NULL OR `Year` = '' AND `Year` <> 0 THEN 'Year' END,
CASE WHEN `Status` IS NULL OR `Status` = '' AND `Status` <> 0 THEN 'Status' END,
CASE WHEN `Life expectancy` IS NULL OR `Life expectancy` = '' AND `Life expectancy` <> 0 THEN 'Life expectancy' END,
CASE WHEN `Adult Mortality` IS NULL OR `Adult Mortality` = '' AND `Adult Mortality` <> 0 THEN 'Adult Mortality' END,
CASE WHEN `infant deaths` IS NULL OR `infant deaths` = '' AND `infant deaths` <> 0 THEN 'infant deaths' END,
CASE WHEN `percentage expenditure` IS NULL OR `percentage expenditure` = '' AND `percentage expenditure` <> 0 THEN 'percentage expenditure' END,
CASE WHEN `Measles` IS NULL OR `Measles` = '' AND `Measles` <> 0 THEN 'Measles' END,
CASE WHEN `BMI` IS NULL OR `BMI` = '' AND `BMI` <> 0 THEN 'BMI' END,
CASE WHEN `under-five deaths` IS NULL OR `under-five deaths` = '' AND `under-five deaths` <> 0 THEN 'under-five deaths' END,
CASE WHEN `Polio` IS NULL OR `Polio` = '' AND `Polio` <> 0 THEN 'Polio' END,
CASE WHEN `Diphtheria` IS NULL OR `Diphtheria` = '' AND `Diphtheria` <> 0 THEN 'Diphtheria' END,
CASE WHEN `HIV/AIDS` IS NULL OR `HIV/AIDS` = '' AND `HIV/AIDS` <> 0 THEN 'HIV/AIDS' END,
CASE WHEN `GDP` IS NULL OR `GDP` = '' AND `GDP` <> 0 THEN 'GDP' END,
CASE WHEN `thinness  1-19 years` IS NULL OR `thinness  1-19 years` = '' AND `thinness  1-19 years` <> 0 THEN 'thinness  1-19 years' END,
CASE WHEN `thinness 5-9 years` IS NULL OR `thinness 5-9 years` = '' AND `thinness 5-9 years` <> 0 THEN 'thinness 5-9 years' END,
CASE WHEN `Schooling` IS NULL OR `Schooling` = '' AND `Schooling` <> 0 THEN 'Schooling' END,
CASE WHEN `Row_ID` IS NULL OR `Row_ID` = '' AND `Row_ID` <> 0 THEN 'Row_ID' END;


-- Check for missing data columns
SELECT 
  *,
  CONCAT_WS(', ',
    CASE WHEN `Country` IS NULL OR `Country` = '' AND `Country` <> 0 THEN 'Country' END,
	CASE WHEN `Year` IS NULL OR `Year` = '' AND `Year` <> 0 THEN 'Year' END,
	CASE WHEN `Status` IS NULL OR `Status` = '' AND `Status` <> 0 THEN 'Status' END,
	CASE WHEN `Life expectancy` IS NULL OR `Life expectancy` = '' AND `Life expectancy` <> 0 THEN 'Life expectancy' END,
	CASE WHEN `Adult Mortality` IS NULL OR `Adult Mortality` = '' AND `Adult Mortality` <> 0 THEN 'Adult Mortality' END,
	CASE WHEN `infant deaths` IS NULL OR `infant deaths` = '' AND `infant deaths` <> 0 THEN 'infant deaths' END,
	CASE WHEN `percentage expenditure` IS NULL OR `percentage expenditure` = '' AND `percentage expenditure` <> 0 THEN 'percentage expenditure' END,
	CASE WHEN `Measles` IS NULL OR `Measles` = '' AND `Measles` <> 0 THEN 'Measles' END,
	CASE WHEN `BMI` IS NULL OR `BMI` = '' AND `BMI` <> 0 THEN 'BMI' END,
	CASE WHEN `under-five deaths` IS NULL OR `under-five deaths` = '' AND `under-five deaths` <> 0 THEN 'under-five deaths' END,
	CASE WHEN `Polio` IS NULL OR `Polio` = '' AND `Polio` <> 0 THEN 'Polio' END,
	CASE WHEN `Diphtheria` IS NULL OR `Diphtheria` = '' AND `Diphtheria` <> 0 THEN 'Diphtheria' END,
	CASE WHEN `HIV/AIDS` IS NULL OR `HIV/AIDS` = '' AND `HIV/AIDS` <> 0 THEN 'HIV/AIDS' END,
	CASE WHEN `GDP` IS NULL OR `GDP` = '' AND `GDP` <> 0 THEN 'GDP' END,
	CASE WHEN `thinness  1-19 years` IS NULL OR `thinness  1-19 years` = '' AND `thinness  1-19 years` <> 0 THEN 'thinness  1-19 years' END,
	CASE WHEN `thinness 5-9 years` IS NULL OR `thinness 5-9 years` = '' AND `thinness 5-9 years` <> 0 THEN 'thinness 5-9 years' END,
	CASE WHEN `Schooling` IS NULL OR `Schooling` = '' AND `Schooling` <> 0 THEN 'Schooling' END,
	CASE WHEN `Row_ID` IS NULL OR `Row_ID` = '' AND `Row_ID` <> 0 THEN 'Row_ID' END
  ) AS missing_columns
FROM world_life_expectancy_backup
HAVING missing_columns IS NOT NULL;

######################################################################
-- # Populate values in missing `Status` column:

SELECT * FROM world_life_expectancy;
SELECT DISTINCT Status FROM world_life_expectancy;

SELECT Country, Year, Status
FROM world_life_expectancy
WHERE Status = '';

SELECT w1.Country, w1.Year, w1.Status, w2.Country, w2.Year, w2.Status
FROM world_life_expectancy w1
JOIN world_life_expectancy w2
ON w1.Country = w2.Country AND w1.Status <> w2.Status
WHERE w1.Status = '' OR w1.Status = NULL;

UPDATE world_life_expectancy w1
JOIN world_life_expectancy w2
ON w1.Country = w2.Country AND w1.Status <> w2.Status
SET w1.Status = w2.Status
WHERE w1.Status = '';
######################################################################
-- # Populate values in missing `Life expectancy` column:

SELECT * FROM world_life_expectancy;

SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = '';

SELECT w1.Country, w1.Year, w1.`Life expectancy`,
w2.Country, w2.Year, w2.`Life expectancy`,
w3.Country, w3.Year, w3.`Life expectancy`,
ROUND((w2.`Life expectancy`+ w3.`Life expectancy`)/2,1)
FROM world_life_expectancy w1
JOIN world_life_expectancy w2 ON w1.Country = w2.Country AND w1.Year = w2.Year - 1
JOIN world_life_expectancy w3 ON w1.Country = w3.Country AND w1.Year = w3.Year + 1
WHERE w1.`Life expectancy` = '';

UPDATE world_life_expectancy w1
JOIN world_life_expectancy w2 ON w1.Country = w2.Country AND w1.Year = w2.Year - 1
JOIN world_life_expectancy w3 ON w1.Country = w3.Country AND w1.Year = w3.Year + 1
SET w1.`Life expectancy` = ROUND((w2.`Life expectancy`+ w3.`Life expectancy`)/2,1)
WHERE w1.`Life expectancy` = '';
######################################################################

