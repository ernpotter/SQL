USE DATABASE til_playground;
USE SCHEMA preppin_data_inputs;

--- preppin data week 4 ---

--Input the data
--We want to stack the tables on top of one another, since they have the same fields in each sheet. We can do this one of 2 ways (help):
    --Drag each table into the canvas and use a union step to stack them on top of one another
    --Use a wildcard union in the input step of one of the tables
--Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
--Make a Joining Date field based on the Joining Day, Table Names and the year 2023
--Now we want to reshape our data so we have a field for each demographic, for each new customer (help)
--Make sure all the data types are correct for each field
--Remove duplicates (help)
    --If a customer appears multiple times take their earliest joining date

WITH CTE AS (

SELECT *,
'PD2023_WK04_JANUARY' table_name
FROM PD2023_WK04_JANUARY

UNION ALL

SELECT *,
'PD2023_WK04_FEBRUARY' table_name
FROM PD2023_WK04_FEBRUARY

UNION ALL

SELECT *,
'PD2023_WK04_FEBRUARY' table_name
FROM PD2023_WK04_FEBRUARY

UNION ALL

SELECT *,
'PD2023_WK04_MARCH' table_name
FROM PD2023_WK04_MARCH

UNION ALL

SELECT *,
'PD2023_WK04_APRIL' table_name
FROM PD2023_WK04_APRIL

UNION ALL

SELECT *,
'PD2023_WK04_MAY' table_name
FROM PD2023_WK04_MAY

UNION ALL

SELECT *,
'PD2023_WK04_JUNE' table_name
FROM PD2023_WK04_JUNE

UNION ALL

SELECT *,
'PD2023_WK04_JULY' table_name
FROM PD2023_WK04_JULY

UNION ALL

SELECT *,
'PD2023_WK04_AUGUST' table_name
FROM PD2023_WK04_AUGUST

UNION ALL

SELECT *,
'PD2023_WK04_SEPTEMBER' table_name
FROM PD2023_WK04_SEPTEMBER

UNION ALL

SELECT *,
'PD2023_WK04_OCTOBER' table_name
FROM PD2023_WK04_OCTOBER

UNION ALL

SELECT *,
'PD2023_WK04_NOVEMBER' table_name
FROM PD2023_WK04_NOVEMBER

UNION ALL

SELECT *,
'PD2023_WK04_DECEMBER' table_name
FROM PD2023_WK04_DECEMBER
)

, new_customers AS (
SELECT 
id,
DATE_FROM_PARTS('2023', MONTH(DATE(SPLIT_PART(table_name, '_', 3), 'mmmm')), joining_day) joining_date,
"'Account Type'" account_type,
"'Date of Birth'"::date date_of_birth,
"'Ethnicity'" ethnicity,
ROW_NUMBER() OVER (PARTITION BY id ORDER BY joining_date ASC) as rn
FROM CTE
    PIVOT (MAX(value) FOR demographic IN ('Ethnicity', 'Account Type', 'Date of Birth'))
)

SELECT *
FROM new_customers
WHERE rn = 1; 
