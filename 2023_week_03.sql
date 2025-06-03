USE DATABASE til_playground;
USE SCHEMA preppin_data_inputs;

--- preppin data week 3 ---

--Input the data
--For the transactions file:
    --Filter the transactions to just look at DSB (help)
    --These will be transactions that contain DSB in the Transaction Code field
    --Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values
    --Change the date to be the quarter (help)
    --Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) (help)
--For the targets file:
    --Pivot the quarterly targets so we have a row for each Type of Transaction and each Quarter (help)
    -- Rename the fields
    --Remove the 'Q' from the quarter field and make the data type numeric (help)
--Join the two datasets together (help)
    --You may need more than one join clause!
--Remove unnecessary fields
--Calculate the Variance to Target for each row (help)
--Output the data


WITH transactions AS (
SELECT
CASE
    WHEN online_or_in_person = 1 THEN 'Online'
    ELSE 'In-Person'
END online_or_in_person,
QUARTER(TO_DATE(transaction_date, 'dd/mm/yyyy hh24:mi:ss')) quarter,
SUM(value) as value
FROM PD2023_WK01
WHERE transaction_code LIKE 'DSB-%'
GROUP BY 1,2
)

SELECT 
tg.online_or_in_person,
REPLACE(tg.quarter, 'Q', '')::int quarter,
tg.quarterly_target,
t.value,
t.value - tg.quarterly_target variance_from_target
FROM PD2023_WK03_TARGETS
    UNPIVOT (quarterly_target FOR quarter IN (q1, q2, q3, q4)) as tg
INNER JOIN transactions as t ON tg.online_or_in_person = t.online_or_in_person AND REPLACE(tg.quarter, 'Q', '')::int = t.quarter;
