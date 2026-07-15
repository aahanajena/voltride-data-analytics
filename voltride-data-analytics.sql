--1 Which city–zone–hour combinations have the highest demand and cancellation rates?
SELECT 
    v."City",
    v."Pickup_Zone",
    v."Hour",
    COUNT(*) AS demand,
    AVG(v."Is_Cancelled") AS cancellation_rate
FROM voltride_data v
GROUP BY v."City", v."Pickup_Zone", v."Hour"
ORDER BY demand DESC
LIMIT 10;

--2 What are the main causes of cancellations across zones?
SELECT 
    v."Pickup_Zone",
    v."Cancellation_By",
    COUNT(*) AS total_cancellations
FROM voltride_data v
WHERE v."Is_Cancelled" = 1
GROUP BY v."Pickup_Zone", v."Cancellation_By"
ORDER BY total_cancellations DESC;

--3 Which zones have high demand but low completion rates?
SELECT 
    v."Pickup_Zone",
    COUNT(*) AS demand,
    SUM(CASE WHEN v."Is_Cancelled" = 0 THEN 1 ELSE 0 END) AS completed_rides,
    AVG(v."Is_Cancelled") AS cancellation_rate
FROM voltride_data v
GROUP BY v."Pickup_Zone"
ORDER BY cancellation_rate DESC;

--4 At which battery level bands do cancellation rates spike, and is low battery a primary driver of cancellations?
SELECT 
    battery_band,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN "Is_Cancelled" = 1 THEN 1 ELSE 0 END) AS total_cancellations,
    ROUND(AVG("Is_Cancelled") * 100, 2) AS cancellation_rate_pct
FROM (
    SELECT *,
        CASE 
            WHEN "Battery_Level" < 20 THEN 'Critical (0-20%)'
            WHEN "Battery_Level" < 40 THEN 'Low (20-40%)'
            WHEN "Battery_Level" < 60 THEN 'Medium (40-60%)'
            WHEN "Battery_Level" < 80 THEN 'High (60-80%)'
            ELSE 'Full (80-100%)'
        END AS battery_band
    FROM voltride_data
) v
GROUP BY battery_band
ORDER BY cancellation_rate_pct DESC;

--5 How do peak hours impact demand and cancellations?
SELECT 
    v."Peak_Hour",
    COUNT(*) AS demand,
    AVG(v."Is_Cancelled") AS cancellation_rate
FROM voltride_data v
GROUP BY v."Peak_Hour";

