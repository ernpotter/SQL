USE DATABASE til_playground;
USE SCHEMA preppin_data_inputs;

--- preppin data week 1 ---

---Input the data (help)
--Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction (help)
    --Rename the new field with the Bank code 'Bank'. 
--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
--Change the date to be the day of the week (help)
--Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways (help):
    --1. Total Values of Transactions by each bank
    --2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
    --3. Total Values by Bank and Customer Code


WITH CTE AS (
SELECT transaction_code,
SPLIT_PART(transaction_code, '-', 1) Bank,
value,
customer_code,
CASE
    WHEN online_or_in_person = 1 THEN 'Online'
    ELSE 'In-Person'
END online_or_in_person,
DAYNAME(TO_TIMESTAMP(transaction_date, 'dd/mm/yyyy hh24:mi:ss')) dow
FROM PD2023_WK01
)

--output 1--
, OUTPUT1 AS (
SELECT bank,
SUM(value) total_value
FROM CTE
GROUP BY bank
)

-- output 2--
, OUTPUT2 AS (
SELECT bank,
dow,
online_or_in_person,
SUM(value) total_value
FROM CTE
GROUP BY 1,2,3
)

--output 3--
SELECT bank,
customer_code,
SUM(value) as total_value
FROM CTE
GROUP BY 1,2;
