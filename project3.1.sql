use job_db;
CREATE TABLE email_event (
user_id int,
occurred_at datetime,
action varchar(100),
user_type int
);
ALTER TABLE email_event MODIFY occurred_at varchar (100);

Load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Case Study 2-20241118T080836Z-001/Case Study 2/email_events.csv"
into table email_event
fields terminated by ','
enclosed by '"'
lines terminated by'\n'
ignore 1 rows;

select * from email_event;

alter table email_event add column created_at datetime;
SELECT occurred_at 
FROM email_event 
WHERE STR_TO_DATE(occurred_at, '%d-%m-%y %H:%i:%s') IS NULL;

UPDATE email_event
SET created_at = STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i');

alter table email_event drop column occurred_at;

alter table email_event change column created_at occurred_at datetime;
