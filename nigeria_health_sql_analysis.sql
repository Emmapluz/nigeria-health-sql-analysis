

-- Nigeria Life Expectancy Trend

SELECT 
    Location,
    Period,
    ROUND(First_Tooltip, 2) AS LifeExpectancy_Years
FROM [dbo].[LifeExpectancy]
WHERE Location = 'Nigeria'
    AND Dim1 = 'Both sexes'
ORDER BY Period


-- Top 10 Countries by Life Expectancy (2019)

SELECT TOP 10
    Location,
    Period,
    First_Tooltip AS LifeExpectancy_Years
FROM LifeExpectancy
WHERE Period = 2019
    AND Dim1 = 'Both sexes'
ORDER BY First_Tooltip DESC



-- Nigeria vs Global Average Life Expectancy (2019)

SELECT 
    Location,
    ROUND(First_Tooltip, 2) AS LifeExpectancy_Years,
    CASE 
        WHEN First_Tooltip >= (
            SELECT AVG(First_Tooltip) 
            FROM LifeExpectancy 
            WHERE Period = 2019 
                AND Dim1 = 'Both sexes'
        ) THEN 'Above Global Average'
        ELSE 'Below Global Average'
    END AS GlobalComparison
FROM LifeExpectancy
WHERE Period = 2019
    AND Dim1 = 'Both sexes'
    AND Location IN (
        'Nigeria', 
        'Ghana', 
        'Kenya', 
        'South Africa',
        'Ethiopia', 
        'Egypt', 
        'Algeria',
        'Morocco',
        'Tanzania',
        'Rwanda'
    )
ORDER BY First_Tooltip DESC


-- Nigeria Maternal Mortality Classification

SELECT 
    Location,
    Period,
    CAST(
        LEFT(
            First_Tooltip, 
            CHARINDEX(' ', First_Tooltip + ' ') - 1
        ) 
    AS DECIMAL(10,1)) AS MaternalMortality_Per100k,
    CASE 
        WHEN CAST(
            LEFT(
                First_Tooltip, 
                CHARINDEX(' ', First_Tooltip + ' ') - 1
            ) 
        AS DECIMAL(10,1)) >= 1000 
            THEN 'Critical — above 1000'
        WHEN CAST(
            LEFT(
                First_Tooltip, 
                CHARINDEX(' ', First_Tooltip + ' ') - 1
            ) 
        AS DECIMAL(10,1)) >= 500 
            THEN 'Very High — 500 to 999'
        WHEN CAST(
            LEFT(
                First_Tooltip, 
                CHARINDEX(' ', First_Tooltip + ' ') - 1
            ) 
        AS DECIMAL(10,1)) >= 300 
            THEN 'High — 300 to 499'
        WHEN CAST(
            LEFT(
                First_Tooltip, 
                CHARINDEX(' ', First_Tooltip + ' ') - 1
            ) 
        AS DECIMAL(10,1)) >= 100 
            THEN 'Elevated — 100 to 299'
        ELSE 'Moderate — below 100'
    END AS SeverityLevel
FROM MaternalMortality
WHERE Location = 'Nigeria'
ORDER BY Period


-- Malaria Incidence Comparison — 
-- Nigeria vs Selected African Countries
SELECT 
    Location,
    Period,
    ROUND(First_Tooltip, 2) AS MalariaIncidence_Per1000,
    CASE
        WHEN First_Tooltip >= 300 
            THEN 'Very High Burden'
        WHEN First_Tooltip >= 100 
            THEN 'High Burden'
        WHEN First_Tooltip >= 50  
            THEN 'Moderate Burden'
        ELSE 'Lower Burden'
    END AS BurdenLevel
FROM MalariaIncidence
WHERE Period = (
        SELECT MAX(Period) 
        FROM MalariaIncidence
    )
    AND Location IN (
        'Nigeria',
        'Ghana',
        'Kenya',
        'Uganda',
        'Tanzania',
        'Cameroon',
        'Mozambique',
        'Democratic Republic of the Congo',
        'Mali',
        'Burkina Faso'
    )
ORDER BY First_Tooltip DESC


-- QNigeria Complete Health Profile
SELECT 
    'Life Expectancy (years)' AS Indicator,
    CAST(First_Tooltip AS NVARCHAR(20)) AS Value,
    Period AS Year
FROM LifeExpectancy
WHERE Location = 'Nigeria'
    AND Dim1 = 'Both sexes'
    AND Period = (
        SELECT MAX(Period) 
        FROM LifeExpectancy 
        WHERE Location = 'Nigeria' 
            AND Dim1 = 'Both sexes'
    )

UNION ALL

SELECT 
    'Infant Mortality (per 1,000 births)',
    CAST(
        CAST(
            LEFT(
                First_Tooltip,
                CHARINDEX(' ', First_Tooltip + ' ') - 1
            )
        AS DECIMAL(10,1))
    AS NVARCHAR(20)),
    Period
FROM InfantMortality
WHERE Location = 'Nigeria'
    AND Dim1 = 'Both sexes'
    AND Period = (
        SELECT MAX(Period) 
        FROM InfantMortality 
        WHERE Location = 'Nigeria' 
            AND Dim1 = 'Both sexes'
    )

UNION ALL

SELECT 
    'Maternal Mortality (per 100,000 births)',
    CAST(
        CAST(
            LEFT(
                First_Tooltip,
                CHARINDEX(' ', First_Tooltip + ' ') - 1
            )
        AS DECIMAL(10,1))
    AS NVARCHAR(20)),
    Period
FROM MaternalMortality
WHERE Location = 'Nigeria'
    AND Period = (
        SELECT MAX(Period) 
        FROM MaternalMortality 
        WHERE Location = 'Nigeria'
    )

UNION ALL

SELECT 
    'Malaria Incidence (per 1,000 at risk)',
    CAST(First_Tooltip AS NVARCHAR(20)),
    Period
FROM MalariaIncidence
WHERE Location = 'Nigeria'
    AND Period = (
        SELECT MAX(Period) 
        FROM MalariaIncidence 
        WHERE Location = 'Nigeria'
    )