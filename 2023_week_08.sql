USE DATABASE TIL_PLAYGROUND;
USE SCHEMA preppin_data_inputs;

--- preppin data week 8 ---
-- Input each of the 12 monthly files
-- Create a 'file date' using the month found in the file name
    -- The Null value should be replaced as 1
-- Clean the Market Cap value to ensure it is the true value as 'Market Capitalisation'
    -- Remove any rows with 'n/a'
-- Categorise the Purchase Price into groupings
    -- 0 to 24,999.99 as 'Low'
    -- 25,000 to 49,999.99 as 'Medium'
    -- 50,000 to 74,999.99 as 'High'
    -- 75,000 to 100,000 as 'Very High'
-- Categorise the Market Cap into groupings
    -- Below $100M as 'Small'
    -- Between $100M and below $1B as 'Medium'
    -- Between $1B and below $100B as 'Large' 
    -- $100B and above as 'Huge'
-- Rank the highest 5 purchases per combination of: file date, Purchase Price Categorisation and Market Capitalisation Categorisation.
-- Output only records with a rank of 1 to 5

WITH CTE AS (
SELECT *, 'PD2023_WK08_01' file_name
FROM PD2023_WK08_01

UNION ALL

SELECT *, 'PD2023_WK08_02' file_name
FROM PD2023_WK08_02

UNION ALL

SELECT *, 'PD2023_WK08_03' file_name
FROM PD2023_WK08_03

UNION ALL

SELECT *, 'PD2023_WK08_04' file_name
FROM PD2023_WK08_04

UNION ALL

SELECT *, 'PD2023_WK08_05' file_name
FROM PD2023_WK08_05

UNION ALL

SELECT *, 'PD2023_WK08_06' file_name
FROM PD2023_WK08_06

UNION ALL

SELECT *, 'PD2023_WK08_07' file_name
FROM PD2023_WK08_07

UNION ALL

SELECT *, 'PD2023_WK08_08' file_name
FROM PD2023_WK08_08

UNION ALL

SELECT *, 'PD2023_WK08_09' file_name
FROM PD2023_WK08_09

UNION ALL

SELECT *, 'PD2023_WK08_10' file_name
FROM PD2023_WK08_10

UNION ALL

SELECT *, 'PD2023_WK08_11' file_name
FROM PD2023_WK08_11

UNION ALL

SELECT *, 'PD2023_WK08_12' file_name
FROM PD2023_WK08_12
)

, OUTPUT AS (
SELECT *,
DATE_FROM_PARTS('2023', SPLIT_PART(file_name, '_', 3), '01') file_date,
CASE
    WHEN market_cap LIKE '%M' THEN ROUND((REPLACE(REPLACE(market_cap, '$', ''), 'M', '')*1000000), 2)
    WHEN market_cap LIKE '%B' THEN ROUND((REPLACE(REPLACE(market_cap, '$', ''), 'B', '')*1000000000),2)
    ELSE ROUND(REPLACE(market_cap, '$', ''),2)
END as market_capitalisation,
REPLACE(purchase_price, '$', ''):: int purchase_price2,
CASE
    WHEN purchase_price2 <=24999.99 THEN 'Low'
    WHEN purchase_price2 <=49999.99 THEN 'Medium'
    WHEN purchase_price2 <=74999.99 THEN 'High'
    WHEN purchase_price2 <=100000 THEN 'Very High'
END as purchase_group,
CASE
    WHEN market_capitalisation < 100000000 THEN 'Samll'
    WHEN market_capitalisation < 1000000000 THEN 'Medium'
    WHEN market_capitalisation < 100000000000 THEN 'Large'
    ELSE 'Huge'
END as market_group ,
RANK() OVER (PARTITION BY file_date, purchase_group, market_group ORDER BY REPLACE(purchase_price, '$', ''):: int DESC) rnk
FROM CTE
WHERE market_cap <> 'n/a'
)

SELECT
market_group, 
purchase_group,
file_date,
ticker,
sector,
market,
stock_name,
market_cap,
purchase_price,
rnk as rank
FROM OUTPUT
WHERE rnk < 6;
