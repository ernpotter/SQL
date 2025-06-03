USE DATABASE til_playground;
USE SCHEMA preppin_data_inputs;

--- preppin data week 2 ---

--Input the data
--In the Transactions table, there is a Sort Code field which contains dashes. We need to remove these so just have a 6 digit string (hint)
--Use the SWIFT Bank Code lookup table to bring in additional information about the SWIFT code and Check Digits of the receiving bank account (hint)
--Add a field for the Country Code (hint)
    --Hint: all these transactions take place in the UK so the Country Code should be GB
--Create the IBAN as above (hint)
    --Hint: watch out for trying to combine sting fields with numeric fields - check data types
--Remove unnecessary fields (hint)



SELECT transaction_id,
'GB' || check_digits || swift_code || REPLACE(sort_code,'-','') || account_number as iban
FROM PD2023_WK02_TRANSACTIONS as t
INNER JOIN PD2023_WK02_SWIFT_CODES as sc ON sc.bank = t.bank;
