use job_db;
CREATE TABLE users (
user_id int,
created_at varchar(50),
company_id int,
language varchar(50),
activated_at varchar(50),
state varchar(100)
);

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Case Study 2-20241118T080836Z-001/Case Study 2/users.csv"
into table users
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;


select * from users;

alter table users add column created_date datetime;
SELECT created_at
FROM users 
WHERE STR_TO_DATE(created_at, '%d-%m-%y %H:%i:%s') IS NULL;

UPDATE users
SET created_date = STR_TO_DATE(created_at, '%d-%m-%Y %H:%i');

alter table users drop column created_at;

alter table users change column created_date created_at datetime;

alter table users add column activated_date datetime;
SELECT activated_at
FROM users 
WHERE STR_TO_DATE(activated_at, '%d-%m-%y %H:%i:%s') IS NULL;

UPDATE users
SET activated_date = STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i');

alter table users drop column activated_at;

alter table users change column activated_date activated_at datetime;

