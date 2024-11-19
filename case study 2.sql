SELECT 
    user_id, 
    YEAR(occurred_at) AS year,
    WEEK(occurred_at) AS week_number,
    COUNT(*) AS weekly_engagement
FROM 
    email_event
GROUP BY 
    user_id, year, week_number
ORDER BY 
    year DESC, week_number DESC, user_id;

SELECT 
    DATE(occurred_at) AS date,
    COUNT(DISTINCT user_id) AS new_users
FROM 
    events
GROUP BY 
    DATE(occurred_at)
ORDER BY 
    date;
    
   WITH UserActivation AS (
    SELECT
        user_id,
        MIN(activated_at) AS activation_date,
        WEEK(MIN(activated_at)) AS activation_week
    FROM users
    GROUP BY user_id
),
UserEngagement AS (
    SELECT
        e.user_id,
        WEEK(e.occurred_at) AS engagement_week,
        COUNT(DISTINCT e.event_name) AS engagement_count 
    FROM events e
    WHERE e.event_name IN ('login', 'home_page', 'like_message', 'view_inbox', 'search_run')
    GROUP BY e.user_id, engagement_week
)
SELECT
    ua.activation_week,
    ue.engagement_week,
    COUNT(DISTINCT ue.user_id) AS engaged_users,
    COUNT(DISTINCT ua.user_id) AS total_users_in_cohort,
    (COUNT(DISTINCT ue.user_id) / COUNT(DISTINCT ua.user_id)) * 100 AS engagement_percentage
FROM UserActivation ua
LEFT JOIN UserEngagement ue
    ON ua.user_id = ue.user_id
    AND ue.engagement_week >= ua.activation_week 
GROUP BY ua.activation_week, ue.engagement_week
HAVING COUNT(DISTINCT ue.user_id) > 0 
ORDER BY ua.activation_week DESC, ue.engagement_week DESC;

SELECT
    WEEK(e.occurred_at) AS engagement_week,
    e.device, 
    COUNT(DISTINCT e.user_id) AS engaged_users, 
    COUNT(e.event_name) AS total_events 
FROM
    events e
WHERE
    e.event_name IN ('login', 'home_page', 'like_message', 'view_inbox', 'search_run') 
GROUP BY
    engagement_week, e.device
ORDER BY
    engagement_week DESC, e.device;

SELECT
    COUNT(*) AS total_email_event, 
    COUNT(DISTINCT CASE WHEN action = 'email_open' THEN user_id END) AS distinct_email_opens, 
    COUNT(DISTINCT CASE WHEN action = 'sent_weekly_digest' THEN user_id END) AS distinct_email_sent, 
    ROUND(
        (COUNT(DISTINCT CASE WHEN action = 'email_open' THEN user_id END) / 
        COUNT(DISTINCT CASE WHEN action = 'sent_weekly_digest' THEN user_id END)) * 100, 
        2
    ) AS email_engagement_rate
FROM
    email_event
WHERE
    action IN ('sent_weekly_digest', 'email_open');



