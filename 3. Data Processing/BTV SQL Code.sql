---USER PROFILES TABLE QUERIES---

---1. Viewing all the columns in the table
SELECT*
FROM workspace.default.btv_user_profiles;


---2. Viewing the different gender classifications in the dataset
SELECT DISTINCT gender
FROM workspace.default.btv_user_profiles;


---3. Counting the numbers per gender classification (male highest, female lowest)
SELECT gender,
       COUNT(gender) AS total_per_gender_classification
FROM workspace.default.btv_user_profiles
GROUP BY gender
ORDER BY total DESC;


---4. Viewing the different race classifications in the dataset
SELECT DISTINCT race
FROM workspace.default.btv_user_profiles;


---5. Counting the numbers per race classification (black highest, coloured lowest)
SELECT race,
       COUNT(race) AS total_per_race_classification
FROM workspace.default.btv_user_profiles
GROUP BY race
ORDER BY total DESC;


---6. Viewing the different provinces in the dataset
SELECT DISTINCT province
FROM workspace.default.btv_user_profiles;


---7. Counting the numbers per province (Gauteng highest, Northern Cape lowest)
SELECT province,
       COUNT(province) AS total_user_per_province
FROM workspace.default.btv_user_profiles
GROUP BY province
ORDER BY total DESC;


---8. Viewing the youngest and oldest ages in the dataset (youngest is 0, oldest 114)
SELECT MIN(age) AS youngest_age,
       MAX(age) AS oldest_age
FROM workspace.default.btv_user_profiles;


---9. Trying to view more realistic youngest and oldest ages in the dataset (youngest is 9, oldest is 79)
SELECT MIN(age) AS youngest_age,
       MAX(age) AS oldest_age
FROM  workspace.default.btv_user_profiles
WHERE age BETWEEN 1 AND 90;


---10. Classifying the different age groups as age buckets 
SELECT COUNT(age) AS total,
   CASE
       WHEN age = 0 THEN 'unknown'
       WHEN age BETWEEN 1 AND 12 THEN 'kid'
       WHEN age BETWEEN 13 AND 19 THEN 'teenager'
       WHEN age BETWEEN 20 AND 35 THEN 'youth'
       WHEN age BETWEEN 36 AND 55 THEN 'middle_aged'
       WHEN age BETWEEN 56 AND 70 THEN 'senior'
       ELSE 'elderly'
    END AS age_buckets
FROM workspace.default.btv_user_profiles
GROUP BY age_buckets;

---Checking for NULLS (no NULLS)
SELECT userID,
       name,
       surname,
       email,
       gender,
       race,
       age,
       province
FROM workspace.default.btv_user_profiles
WHERE userID IS NULL
AND name IS NULL
AND surname IS NULL
AND email IS NULL
AND gender IS NULL
AND race IS NULL
AND age IS NULL
AND province IS NULL;

---VIEWERSHIP TABLE QUERIES---

---11. Viewing all the columns in the table
SELECT*
FROM workspace.default.btv_viewership;


---12. Viewing the different channels in the dataset (21 different channels)
SELECT DISTINCT channel2
FROM workspace.default.btv_viewership;


---13. Checking for the first and last record dates (first record: 1 Jan 2016, last record: 31 March 2016)
SELECT MIN(recorddate2) AS first_record_date,
      MAX(recorddate2) AS last_record_date
FROM workspace.default.btv_viewership;


---14. Converting the UTC time to SA time
SELECT date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') AS SA_time
FROM workspace.default.btv_viewership;

---15. Splitting the date and time
SELECT date_format(recorddate2, 'yyyy-MM-dd') AS date,
       date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') AS time
FROM workspace.default.btv_viewership;


---16. Complete table with split date and converted time
SELECT userID0,
       channel2,
       date_format(recorddate2, 'yyyy-MM-dd') AS date,
       date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') AS converted_time,
       `Duration 2`,
       userid4
FROM workspace.default.btv_viewership;

---17. Grouping the viewership times into time buckets
SELECT recorddate2,
   CASE
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN 'Early_Morning'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN 'Early_Afternoon'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '15:00:00' AND '17:59:59' THEN 'Late_Afternoon'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '18:00:00' AND '20:59:59' THEN 'Evening'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '21:00:00' AND '23:59:59' THEN 'Night'
    END AS time_classification
FROM workspace.default.btv_viewership;

---18. Extracting the day names, month names and days of the month from the record date
SELECT recorddate2,
       Dayname(recorddate2) AS day_name,
       Monthname(recorddate2) AS month_name,
       Dayofmonth(recorddate2) AS day_of_month
FROM workspace.default.btv_viewership;

---19. Finding the total number of views (10000 views)
SELECT COUNT(*) AS total_views
FROM workspace.default.btv_viewership;

---20. Finding the total number of unique users (4386 users)
SELECT COUNT(DISTINCT userID0) AS total_unique_users
FROM workspace.default.btv_viewership;

---21. Finding the total number of seconds viewed (5482803 total seconds)
SELECT 
    SUM(
        HOUR(`Duration 2`) * 3600 +
        MINUTE(`Duration 2`) * 60 +
        SECOND(`Duration 2`)
    ) AS total_seconds_viewed
FROM workspace.default.btv_viewership;

---22. Finding the total number of views per channel
SELECT channel2,
       COUNT(channel2) AS total_views_per_channel
FROM workspace.default.btv_viewership
GROUP BY channel2
ORDER BY total DESC;

---22. Dealing with the NULLS (no NULLS)
SELECT userID0,
       channel2,
       recorddate2,
       `Duration 2`
FROM workspace.default.btv_viewership
WHERE userID0 IS NULL
AND channel2 IS NULL
AND recorddate2 IS NULL
AND `Duration 2` IS NULL;

---23. Joining the 2 tables using JOINS (Full Outer Join also works)
SELECT userID,
       name,
       surname,
       email,
       gender,
       race,
       age,
       province,
       channel2,
       recorddate2,
       `Duration 2`
FROM workspace.default.btv_user_profiles AS A
INNER JOIN workspace.default.btv_viewership AS B
ON A.userID = B.userID0;

---24. FINAL BIG QUERY FOR THE FINAL CLEANED DATASET
SELECT userID,
       gender,
       race,
       age,
       province,
       channel2,
       date_format(recorddate2, 'yyyy-MM-dd') AS date,
       date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') AS SA_time,
       `Duration 2`,
       Dayname(recorddate2) AS day_name,
       Monthname(recorddate2) AS month_name,
       Dayofmonth(recorddate2) AS day_of_month,
   CASE
       WHEN age = 0 THEN 'unknown'
       WHEN age BETWEEN 1 AND 12 THEN 'kid'
       WHEN age BETWEEN 13 AND 19 THEN 'teenager'
       WHEN age BETWEEN 20 AND 35 THEN 'youth'
       WHEN age BETWEEN 36 AND 55 THEN 'middle_aged'
       WHEN age BETWEEN 56 AND 70 THEN 'senior'
       ELSE 'elderly'
    END AS age_buckets,
    CASE
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '00:00:00' AND '05:59:59' THEN 'Early_Morning'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN 'Morning'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '12:00:00' AND '14:59:59' THEN 'Early_Afternoon'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '15:00:00' AND '17:59:59' THEN 'Late_Afternoon'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '18:00:00' AND '20:59:59' THEN 'Evening'
       WHEN date_format(recorddate2 + INTERVAL '2 hour', 'HH:mm:ss') BETWEEN '21:00:00' AND '23:59:59' THEN 'Night'
    END AS time_classification
FROM workspace.default.btv_user_profiles AS A
INNER JOIN workspace.default.btv_viewership AS B
ON A.userID = B.userID0;
