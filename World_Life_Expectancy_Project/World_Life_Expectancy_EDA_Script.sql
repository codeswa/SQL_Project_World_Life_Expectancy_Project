# 2) EXPLORATORY DATA ANALYSIS(EDA):
SELECT * FROM world_life_expectancy;

-- The Average Life expectancy and Increase in Life expectancy for each country over 15 years:
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS AVG_Life_Exp, 
MIN(`Life expectancy`) AS MIN_Life_Exp, MAX(`Life expectancy`) AS MAX_Life_Exp, 
ROUND(MAX(`Life expectancy`)-MIN(`Life expectancy`),1) AS Life_Exp_Increase_Over_15Years
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Country
ORDER BY Life_Exp_Increase_Over_15Years DESC;
-- Findings: Countries like 'Haiti', 'Zimbabwe', 'Eritrea' have the highest life expectancy increase over 15 yrs. Whereas, countries like 'Guyana', 'Seychelles', 'Kuwait' have the lowest.


-- The Average Life expectancy in the whole world every year:
SELECT Year, ROUND(AVG(`Life expectancy`),1) AS AVG_Life_Exp_In_World_EveryYear
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY YEAR DESC;
-- Findings: Average life expentancy in world has gradually increased over 15 yrs


-- Average of all the average Life expectancy by country
WITH AVG_Of_AVG_Life_Exp AS (
SELECT ROUND(AVG(AVG_Life_Exp),1)
FROM (
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS AVG_Life_Exp
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Country) AS AVG_Life_Exp_Table
)
SELECT * FROM AVG_Of_AVG_Life_Exp;
-- Findings: Average of Life expectancy for each country is '69.2' yrs


-- Correlation of average Life expectancy and average GDP by country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS AVG_Life_Exp, ROUND(AVG(GDP),1) AS AVG_GDP
FROM world_life_expectancy
WHERE `Life expectancy` > 0 AND GDP > 0
GROUP BY Country
ORDER BY AVG_GDP;


-- To find relation between GDP and Life expectancy. We divide the group into 2: Higher and Lower than the mid value.
SELECT 
	SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS Higher_GDP_Count, -- how many(count) rows have a Higher GDP
    ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),1) AS Higher_AVG_Life_Exp,
    SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Lower_GDP_Count, -- how many(count) rows have a Lower GDP
    ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),1) AS Lower_AVG_Life_Exp
FROM world_life_expectancy;
-- OR
SELECT COUNT(GDP) AS Higher_GDP_Count, ROUND(AVG(`Life expectancy`),1) AS Higher_AVG_Life_Exp
FROM world_life_expectancy
WHERE GDP >= 1500;
SELECT COUNT(GDP) AS Lower_GDP_Count, ROUND(AVG(`Life expectancy`),1) AS Lower_AVG_Life_Exp
FROM world_life_expectancy
WHERE GDP <= 1500;
-- Findings: We find out in the output that Higher the GDP, higher is the Life expectancy by approx 10yrs.


-- To check the Average Life expectancy for developing and developed countries:
SELECT Status, COUNT(DISTINCT Country) AS Country_Count, ROUND(AVG(`Life expectancy`),1) AS AVG_Life_Exp_By_Status
FROM world_life_expectancy
GROUP BY Status;
-- Findings: Developed countries have higher life expectancy than developing countries


-- Correlation of average Life expectancy and average BMI by country
SELECT Country, ROUND(AVG(`Life expectancy`),1) AS AVG_Life_Exp, 
ROUND(AVG(BMI),1) AS AVG_BMI
FROM world_life_expectancy
WHERE `Life expectancy` > 0 AND BMI > 0
GROUP BY Country
ORDER BY AVG_BMI DESC;


-- To find total Adult mortality in each country over 15 years using rolling total
SELECT Country, Year, `Adult Mortality`, MAX(Rolling_Total)
FROM
(SELECT Country, Year, `Adult Mortality`, SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy) AS T
GROUP BY Country
ORDER BY  MAX(Rolling_Total) DESC
;
-- Findings: 'Lesotho' and 'Zimbabwe' are the top 2 countries that had highest Adult Mortality in 15 yrs