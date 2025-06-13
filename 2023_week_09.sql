USE DATABASE TIL_PLAYGROUND;
USE SCHEMA preppin_data_inputs;

--- preppin data week 9 ---

--Input the data
--For the Transaction Path table:
    -- Make sure field naming convention matches the other tables
        -- i.e. instead of Account_From it should be Account From
-- Filter out the cancelled transactions
-- Split the flow into incoming and outgoing transactions 
-- Bring the data together with the Balance as of 31st Jan 
-- Work out the order that transactions occur for each account
    -- Hint: where multiple transactions happen on the same day, assume the highest value transactions happen first
-- Use a running sum to calculate the Balance for each account on each day (hint)
-- The Transaction Value should be null for 31st Jan, as this is the starting balance
-- Output the data

WITH CTE AS (
--incoming
SELECT 
tp.transaction_id,
tp.account_to account_number,
td.transaction_date,
value
FROM PD2023_WK07_TRANSACTION_PATH tp
INNER JOIN PD2023_WK07_TRANSACTION_DETAIL td ON td.transaction_id = tp. transaction_id
WHERE cancelled_ <> 'Y'

UNION ALL

--outgoing
SELECT 
tp.transaction_id,
tp.account_from account_number,
td.transaction_date,
(-1)*value value
FROM PD2023_WK07_TRANSACTION_PATH tp
INNER JOIN PD2023_WK07_TRANSACTION_DETAIL td ON td.transaction_id = tp. transaction_id
WHERE cancelled_ <> 'Y'

UNION ALL

--jan 31 balance
SELECT 
NULL transaction_id,
account_number,
'2023-01-31' transaction_date,
NULL value
FROM PD2023_WK07_ACCOUNT_INFORMATION
WHERE balance_date = '2023-01-31'
)

SELECT 
c.account_number,
c.transaction_date balance_date,
c.value,
SUM(COALESCE(value, 0)) OVER (PARTITION BY c.account_number ORDER BY c.transaction_date, c.value DESC) + ai.balance account_balance
FROM CTE c
INNER JOIN PD2023_WK07_ACCOUNT_INFORMATION ai ON ai.account_number = c.account_number
WHERE balance_date = '2023-01-31'
ORDER BY 1,2,3 DESC;
