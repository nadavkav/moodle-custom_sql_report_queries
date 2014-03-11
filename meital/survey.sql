Meital 2014 Survey queries ###
Meital 2014 Survey queries ###

# Count courses with synchronious meetings
SELECT m.name, COUNT(*) 
FROM mdl_course_modules AS cm
JOIN mdl_modules AS m ON m.id = cm.module
WHERE m.name IN ('sookooroo', 'adobe', 'elluminate', 'webex', 'bigbluebutton')
GROUP BY m.id

# Student count in courses dividied by enrollment count 40, <200, <500, >500
SELECT c.id, c.fullname,
(SELECT COUNT( DISTINCT ra.userid ) AS Users
FROM mdl_role_assignments AS ra
JOIN mdl_context AS ctx ON ra.contextid = ctx.id AND ctx.contextlevel = 50
WHERE ra.roleid = 5 AND ctx.instanceid = c.id) AS "Students"
FROM mdl_course AS c
HAVING Students > 0 AND Students <= 40
#HAVING Students <= 200 AND Students > 40
#HAVING Students <= 500 AND Students > 200
#HAVING Students > 500 

# Activities and Resources count in courses, system wide.
SELECT m.name, COUNT(*) 
FROM mdl_course_modules AS cm
JOIN mdl_modules AS m ON m.id = cm.module
GROUP BY m.id

# Active courses (not counting views)
SELECT course, COUNT( * ) AS UsageCount
FROM mdl_log
WHERE ACTION NOT LIKE '%view%'
GROUP BY course
ORDER BY COUNT( * ) DESC
# Set the bar for UsageCount hits
HAVING UsageCount > 1000
