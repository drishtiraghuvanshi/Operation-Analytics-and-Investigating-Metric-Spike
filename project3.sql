create database job_db;
use job_db;
CREATE TABLE job_data (
  ds date,
  job_id int,
  actor_id int,
  event varchar(50),
  language varchar (50),
  time_spent int,
  org varchar(50)
);
ALTER TABLE job_data MODIFY ds varchar (100);


Show variables like 'secure_file_priv';

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/job_data.csv"
into table job_data
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;

select * from job_data;
alter table job_data add column date datetime;
SELECT ds 
FROM job_data
WHERE STR_TO_DATE(ds, '%d/%m/%y') IS NULL;
SET SQL_SAFE_UPDATES = 0;

UPDATE job_data
SET date = STR_TO_DATE(ds, '%m/%d/%Y');

alter table job_data drop column ds;

alter table job_data change column date ds datetime;

SELECT 
    DATE(ds) AS review_date,
    HOUR(ds) AS review_hour,
    COUNT(*) AS jobs_reviewed
FROM 
    job_data
WHERE 
    ds BETWEEN '2020-11-01 00:00:00' AND '2020-11-30 23:59:59'
GROUP BY 
    review_date, review_hour
ORDER BY 
    review_date, review_hour;
    
    WITH daily_throughput AS (
    SELECT 
        ds, 
        COUNT(*) AS daily_throughput
    FROM 
        job_data
    GROUP BY 
        ds
)
SELECT 
    ds,
    daily_throughput,
    AVG(daily_throughput) OVER (
        ORDER BY ds
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_avg
FROM 
    daily_throughput
ORDER BY 
    ds;

SELECT *
FROM job_data
WHERE ds >= CURDATE() - INTERVAL 30 DAY;

SELECT 
    language,
    COUNT(*) AS language_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM job_data), 2) AS percentage_share
FROM 
    job_data
GROUP BY 
    language
ORDER BY 
    percentage_share DESC;

SELECT 
    *, 
    COUNT(*) AS duplicate_count
FROM 
    job_data
GROUP BY 
   job_id, actor_id, event, language, time_spent, org, ds
HAVING 
    COUNT(*) > 1;




