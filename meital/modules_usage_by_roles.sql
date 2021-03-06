Modules usage by role ###
Modules (Resources and Activities) system wide usage by role
(Based on a pre generated static data table which was created on a nightly run) ###

=== 1. Create a table to hold the data generated by the following nightly cron sql queries

CREATE TABLE IF NOT EXISTS `stats_log_activity` (
  `time` datetime NOT NULL,
  `activitytype` varchar(50) NOT NULL,
  `module` varchar(50) NOT NULL,
  `counter` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

=== 2. Create an sql report which is set to run on a nightly cron (you can run it manually too)

INSERT INTO stats_log_activity (time, activitytype, module, counter)
SELECT NOW() as Time, "StudentAll" as type, m.name
,(SELECT COUNT(*) 
  FROM ( SELECT l.course, c.category, l.module, l.action, ra.userid, ra.roleid
         FROM mdl_log AS l
         JOIN mdl_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
         JOIN mdl_role_assignments AS ra ON ra.userid = l.userid AND ra.contextid = context.id
         JOIN mdl_course AS c ON c.id = l.course
         #JOIN mdl_course_categories AS cc ON cc.id = c.category
       ) AS stats_log_context_role_course 
WHERE roleid = 5 AND module LIKE CONCAT('%',m.name,'%') 
) AS Counter
FROM mdl_modules AS m

=== 3. Create an sql report which is set to run on a nightly cron (you can run it manually too)

INSERT INTO stats_log_activity ( TIME, activitytype , module, counter ) 
SELECT NOW( ) AS TIME, "StudentUnique" AS TYPE , m.name
, (SELECT COUNT( DISTINCT userid ) 
FROM (SELECT l.userid, l.course, c.category, l.module, l.action, ra.roleid
FROM mdl_log AS l
JOIN mdl_context AS context ON context.instanceid = l.course
AND context.contextlevel =50
JOIN mdl_role_assignments AS ra ON ra.userid = l.userid
AND ra.contextid = context.id
AND ra.roleid =5
JOIN mdl_course AS c ON c.id = l.course
#JOIN mdl_course_categories AS cc ON cc.id = c.category
#GROUP BY ra.userid
) AS stats_log_context_role_course
WHERE module LIKE CONCAT( '%', m.name, '%' )
) AS Counter
FROM mdl_modules AS m

=== 4. Create an sql report which is set to run on a nightly cron (you can run it manually too)

INSERT INTO stats_log_activity (time, activitytype, module, counter)
SELECT NOW() as Time, "AsistentTeacher" as type, m.name
,(SELECT COUNT(*)  FROM (
SELECT l.course, c.category, l.module, l.action, ra.userid, ra.roleid
FROM mdl_log AS l
JOIN mdl_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.userid = l.userid AND ra.contextid = context.id
JOIN mdl_course AS c ON c.id = l.course
#JOIN mdl_course_categories AS cc ON cc.id = c.category
) AS stats_log_context_role_course
WHERE roleid = 4 AND module LIKE CONCAT('%',m.name,'%') 
) AS  Counter
FROM mdl_modules AS m

=== 5. Create an sql report which is set to run on a nightly cron (you can run it manually too)

INSERT INTO stats_log_activity (time, activitytype, module, counter)
SELECT NOW() as Time, "Teacher" as type, m.name
,(SELECT COUNT(*) FROM (
SELECT l.course, c.category, l.module, l.action, ra.userid, ra.roleid
FROM mdl_log AS l
JOIN mdl_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.userid = l.userid AND ra.contextid = context.id
JOIN mdl_course AS c ON c.id = l.course
#JOIN mdl_course_categories AS cc ON cc.id = c.category
) AS stats_log_context_role_course
WHERE roleid = 3 AND module LIKE CONCAT('%',m.name,'%') 
) AS  Counter
FROM mdl_modules AS m

=== 6. This is the actual report, it is based on all previous reports.

SELECT m.name

,(SELECT counter FROM `stats_log_activity` WHERE module=m.name AND activitytype='StudentAll' 
%%FILTER_STARTTIME:time:>%% %%FILTER_ENDTIME:time:<%%
ORDER BY time DESC LIMIT 1) as All_Student

,(SELECT counter FROM `stats_log_activity` WHERE module=m.name AND activitytype='StudentUnique' 
%%FILTER_STARTTIME:time:>%% %%FILTER_ENDTIME:time:<%%
ORDER BY time DESC LIMIT 1) as Unique_Student

,(SELECT counter FROM `stats_log_activity` WHERE module=m.name AND activitytype='Teacher' 
%%FILTER_STARTTIME:time:>%% %%FILTER_ENDTIME:time:<%%
ORDER BY time DESC LIMIT 1) as Teacher

,(SELECT counter FROM `stats_log_activity` WHERE module=m.name AND activitytype='AsistentTeacher' 
%%FILTER_STARTTIME:time:>%% %%FILTER_ENDTIME:time:<%%
ORDER BY time DESC LIMIT 1) as Asistent_Teacher

,(SELECT COUNT(*)
FROM mdl_course_modules AS cm
JOIN mdl_course AS c ON c.id = cm.course
WHERE cm.module = m.id  
) AS Used_In_Courses

FROM mdl_modules AS m

