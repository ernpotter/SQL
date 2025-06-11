USE DATABASE til_playground;
USE SCHEMA preppin_data_inputs;


--- preppin data week 5 -----

-- Input data
-- Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'
-- Change transaction date to the just be the month of the transaction
-- Total up the transaction values so you have one row for each bank and month combination
-- Rank each bank for their value of transactions each month against the other banks. 1st is the highest value of transactions, 3rd the lowest. 
-- Without losing all of the other data fields, find:
    -- The average rank a bank has across all of the months, call this field 'Avg Rank per Bank'
    -- The average transaction value per rank, call this field 'Avg Transaction Value per Rank'
-- Output the data


WITH CTE AS (
SELECT
SPLIT_PART(transaction_code, '-', 1) bank,
MONTHNAME(TO_DATE(transaction_date, 'dd/mm/yyyy hh24:mi:ss')) month,
SUM(value) total_value,
RANK() OVER (PARTITION BY month ORDER BY total_value DESC) rnk
FROM PD2023_WK01
GROUP BY 1,2
)

, AVG_RANK AS (
SELECT 
bank,
AVG(rnk) avg_rank_per_bank
FROM CTE
GROUP BY 1
)

, AVG_TRANS AS (
SELECT 
rnk,
AVG(total_value) avg_transation_value_per_rank
FROM CTE
GROUP BY 1
)

SELECT 
c.*,
ar.avg_rank_per_bank,
at.avg_transation_value_per_rank
FROM CTE as c
INNER JOIN AVG_RANK as ar ON ar.bank = c.bank
INNER JOIN AVG_TRANS as at ON at.rnk = c.rnk;
