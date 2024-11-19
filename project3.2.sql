use job_db;
CREATE TABLE events  (
user_id int,
occurred_at varchar(100),
event_type varchar(50),
event_name varchar(50),
location varchar(50),
device varchar(50),
user_type int

);
ALTER TABLE event MODIFY occurred_at varchar (100);

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Case Study 2-20241118T080836Z-001/Case Study 2/events.csv"
into table events
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;

select * from events;

alter table events add column created_at datetime;
SELECT occurred_at 
FROM events 
WHERE STR_TO_DATE(occurred_at, '%d-%m-%y %H:%i:%s') IS NULL;

UPDATE events
SET created_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');

alter table events drop column occurred_at;

alter table events change column created_at occurred_at datetime;
