--how many users
select count(*) from users;
--1020926
--how many sessions
select count(*) from sessions;
--5408063
--how many flights
select count(*) from flights;
--1901038
--how many hotels
select count(*) from hotels;
--1918617
--how many unique hotels
select count(distinct hotel_name) from hotels;
--2798
--Query the users table to get a breakdown of users by gender, marital status, and whether they have children.
--gender distribution
SELECT COUNT(gender), gender
FROM users
GROUP BY gender
--family status with respect to the gender
SELECT
    gender,
    CASE
        WHEN married = 'yes' AND has_children = 'yes' THEN 'Married with Children'
        WHEN married = 'yes' AND has_children = 'no' THEN 'Married without Children'
        WHEN married = 'no' AND has_children = 'yes' THEN 'Single with Children'
        WHEN married = 'no' AND has_children = 'no' THEN 'Single without Children'
  			WHEN married IS NULL OR has_children IS NULL THEN 'UNKNOWN'
    END AS family_status,
    COUNT(*) AS user_count
FROM users
GROUP BY family_status, gender;
--distribution of the user's birth year
WITH age_table AS (
  SELECT
  			*,
  			DATE_PART('year', AGE(birthdate)) AS age
  FROM users
)
SELECT
			CASE
      		WHEN age > 90 THEN '90>'
      		WHEN age > 80 THEN '81_90'
          WHEN age > 70 THEN '71_80'
          WHEN age > 60 THEN '61_70'
          WHEN age > 50 THEN '51_60'
          WHEN age > 40 THEN '41_50'
          WHEN age > 30 THEN '31_40'
          WHEN age > 20 THEN '21_30'
          WHEN age <= 20 THEN '20<='
          ELSE 'UNKNOWN' END
      AS "age_group",
      COUNT(*) num_users
FROM age_table
GROUP BY age_group
ORDER BY age_group;
--compare 2006 with other nearby years
SELECT
    EXTRACT(YEAR FROM birthdate) AS birth_year,
    COUNT(*) AS user_count
FROM users
WHERE EXTRACT(YEAR FROM birthdate) BETWEEN 2000 AND 2010
GROUP BY birth_year
ORDER BY birth_year;
--The massive spike in users born in 2006 (43,360 compared to around 7,000-13,000 in other years)
--strongly suggests a data issue or anomaly.
--conclusion: The fact that 2006 is the most common birth year suggests a systematic error,
--default value, or intentional manipulation rather than a real trend
--Check account creation dates for 2006-born users
SELECT EXTRACT(YEAR FROM sign_up_date), COUNT(*)
FROM users
WHERE EXTRACT(YEAR FROM birthdate) = 2006
GROUP BY 1
ORDER BY 1;
--Check account creation dates for all users show that this increase in 2023 registeration is among the whole users
SELECT EXTRACT(YEAR FROM sign_up_date), COUNT(*)
FROM users
GROUP BY 1
ORDER BY 1;
--almost 11000 of the users born in 2006 have children which seem unrealistic
SELECT has_children, count(*)
from users
WHERE EXTRACT(YEAR FROM birthdate) = 2006
group by has_children
--The average “customer age” of users
SELECT
    ROUND(AVG(EXTRACT(YEAR FROM AGE(current_date, sign_up_date)) * 12 + EXTRACT(MONTH FROM AGE(current_date, sign_up_date)))) AS average_customer_age_months
FROM users;
--the top 10 most popular hotels (longest stay and most number of bookings)
SELECT
			hotel_name,
      SUM(nights) AS num_nights,
      COUNT(*) AS num_bookings,
      ROUND(AVG(nights),1) AS avg_stay
FROM hotels
GROUP BY hotel_name
ORDER BY num_bookings DESC
--ORDER BY num_nights DESC
LIMIT 10
--the top most expensive hotels
SELECT
			hotel_name,
      ROUND(AVG(hotel_per_room_usd),2) AS avg_price_per_room,
      ROUND(SUM(nights),1) AS sum_stay
FROM hotels
GROUP BY hotel_name
ORDER BY avg_price_per_room DESC
LIMIT 10
--What is the most used airline in the last 6 months of recorded data?
SELECT
    trip_airline,
    COUNT(*) AS number_of_flights
FROM flights
WHERE return_time >= (SELECT MAX(return_time) FROM flights) - INTERVAL '6 months'
GROUP BY trip_airline
ORDER BY number_of_flights DESC
;
--What is the average number of seats booked on flights via TravelTide?
SELECT
			ROUND(AVG(seats),1) AS avg_seats_booked
FROM flights
--What is the variability of the price for the same flight routes over different seasons?
WITH seasonal_avg AS (
    SELECT
        CASE
            WHEN origin_airport < destination_airport
            THEN CONCAT(origin_airport, '-', destination_airport)
            ELSE CONCAT(destination_airport, '-', origin_airport)
        END AS route,
        EXTRACT(QUARTER FROM departure_time) AS season,
        AVG(base_fare_usd) AS avg_price_per_season
    FROM flights
    GROUP BY route, season
)
SELECT
    route,
    STDDEV(avg_price_per_season) AS seasonal_price_variability
FROM seasonal_avg
GROUP BY route
ORDER BY route;









