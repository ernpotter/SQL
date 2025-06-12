USE DATABASE TIL_PLAYGROUND;
USE SCHEMA preppin_data_inputs;

--- preppin data week 6 ---

-- Input the data
-- Reshape the data so we have 5 rows for each customer, with responses for the Mobile App and Online Interface being in separate fields on the same row
-- Clean the question categories so they don't have the platform in from of them
    -- e.g. Mobile App - Ease of Use should be simply Ease of Use
-- Exclude the Overall Ratings, these were incorrectly calculated by the system
-- Calculate the Average Ratings for each platform for each customer 
-- Calculate the difference in Average Rating between Mobile App and Online Interface for each customer
-- Catergorise customers as being:
    -- Mobile App Superfans if the difference is greater than or equal to 2 in the Mobile App's favour
    -- Mobile App Fans if difference >= 1
    -- Online Interface Fan
    -- Online Interface Superfan
    -- Neutral if difference is between 0 and 1
-- Calculate the Percent of Total customers in each category, rounded to 1 decimal place
-- Output the data

WITH SURVEY_RESULTS AS (
SELECT 
customer_id,
SPLIT_PART(topic, '___', 2) as question,
SUM(CASE WHEN topic LIKE 'MOBILE_APP___%' THEN value END)AS mobile_app,
SUM(CASE WHEN topic LIKE 'ONLINE_INTERFACE___%' THEN value END) AS online_interface
FROM PD2023_WK06_DSB_CUSTOMER_SURVEY
UNPIVOT (
    value FOR topic IN (
        MOBILE_APP___EASE_OF_USE, MOBILE_APP___EASE_OF_ACCESS, MOBILE_APP___NAVIGATION, MOBILE_APP___LIKELIHOOD_TO_RECOMMEND, MOBILE_APP___OVERALL_RATING, ONLINE_INTERFACE___EASE_OF_USE, ONLINE_INTERFACE___EASE_OF_ACCESS, ONLINE_INTERFACE___NAVIGATION, ONLINE_INTERFACE___LIKELIHOOD_TO_RECOMMEND, ONLINE_INTERFACE___OVERALL_RATING))
WHERE question <> 'OVERALL_RATING'
GROUP BY 1, 2
ORDER BY customer_id
)

, CATEGORIES AS (
SELECT 
customer_id,
ROUND(AVG(mobile_app), 2) avg_mobile_app_rating,
ROUND(AVG(online_interface), 2) avg_online_interface_rating,
avg_mobile_app_rating - avg_online_interface_rating difference,
CASE
    WHEN difference >= 2 THEN 'mobile_app_superfan'
    WHEN difference >= 1 THEN 'mobile_app_fan'
    WHEN difference <= -2 THEN 'online_interface_superfan'
    WHEN difference <= -1 THEN 'online_interface_fan'
    ELSE 'neutral'
END category
FROM SURVEY_RESULTS
GROUP BY 1
)

SELECT 
category,
COUNT(customer_id) customer_count,
ROUND(100*customer_count/(SELECT COUNT(DISTINCT customer_id) FROM categories),1) percent_of_total
FROM categories
GROUP BY 1;
