USE DATABASE TIL_PLAYGROUND;
USE SCHEMA preppin_data_inputs;

--- preppin data week 7 ---

-- Input the data
-- For the Transaction Path table:
    -- Make sure field naming convention matches the other tables
        -- i.e. instead of Account_From it should be Account From
-- For the Account Information table:
    -- Make sure there are no null values in the Account Holder ID
    -- Ensure there is one row per Account Holder ID
        -- Joint accounts will have 2 Account Holders, we want a row for each of them
-- For the Account Holders table:
    -- Make sure the phone numbers start with 07
-- Bring the tables together
-- Filter out cancelled transactions 
-- Filter to transactions greater than £1,000 in value 
-- Filter out Platinum accounts
-- Output the data

WITH ACCOUNT_INFORMATION AS (
SELECT
account_number,
account_type,
value as account_holder_id,
balance_date,
seq,
index
FROM PD2023_WK07_ACCOUNT_INFORMATION, LATERAL SPLIT_TO_TABLE(account_holder_id, ', ')
WHERE account_holder_id IS NOT NULL
)


SELECT 
tp.transaction_id,
tp.account_to,
td.transaction_date,
td.value,
ai.account_number,
ai.account_type,
ai.balance_date,
ah.name,
ah.date_of_birth,
'0' || ah.contact_number as contact_number,
ah.first_line_of_address
FROM PD2023_WK07_ACCOUNT_HOLDERS as ah
INNER JOIN ACCOUNT_INFORMATION as ai ON ai.account_holder_id = ah.account_holder_id
INNER JOIN PD2023_WK07_TRANSACTION_PATH as tp ON tp.account_from = ai.account_number
INNER JOIN PD2023_WK07_TRANSACTION_DETAIL as td ON td.transaction_id = tp.transaction_id
WHERE
    cancelled_ <> 'Y'
    AND value > 1000
    AND account_type <> 'Platinum';
