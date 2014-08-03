Generate a “Calculated” mdl_log table###
Creating a special “calculated” Moodle 2.7 mdl_logstore_standard_log table to save CPU power###

CREATE TABLE
============

CREATE TABLE IF NOT EXISTS `mdl_log_calculated` (
`id` bigint(10) NOT NULL,
`time` bigint(10) NOT NULL,
`module_id` bigint(10) NOT NULL,
`module_action` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
`module_name` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
`user_id` bigint(10) NOT NULL,
`user_roleid` bigint(10) NOT NULL,
`course_id` bigint(10) NOT NULL,
`course_idnumber` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
`course_category` bigint(10) NOT NULL,
`course_path` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


SELECT mdl_log + extra calculated data (testing)
================================================

SELECT l.id, l.timecreated, 
l.objectid AS module_id,
l.action AS module_action, 
l.target AS module_name, 
l.userid AS user_id, 
ra.roleid AS user_roleid, 
l.courseid AS course_id, 
c.idnumber AS course_idnumber, 
c.category AS course_category, 
cc.path AS course_path
FROM mdl_logstore_standard_log AS l
LEFT JOIN mdl_course AS c ON c.id = l.courseid
LEFT JOIN mdl_course_categories AS cc ON cc.id = c.category
LEFT JOIN mdl_context AS context ON l.contextid = context.id AND context.contextlevel = 50
LEFT JOIN mdl_role_assignments AS ra ON ra.contextid = context.id
where l.id < 1300

INSERT INTO mdl_log_calculated (mdl_logstore_standard_log)
==========================================================

INSERT LOW_PRIORITY  IGNORE INTO mdl_log_calculated
SELECT l.id, l.timecreated, 
l.objectid AS module_id,
l.action AS module_action, 
l.target AS module_name, 
l.userid AS user_id, 
ra.roleid AS user_roleid, 
l.courseid AS course_id, 
c.idnumber AS course_idnumber, 
c.category AS course_category, 
cc.path AS course_path
FROM mdl_logstore_standard_log AS l
LEFT JOIN mdl_course AS c ON c.id = l.courseid
LEFT JOIN mdl_course_categories AS cc ON cc.id = c.category
LEFT JOIN mdl_context AS context ON l.contextid = context.id AND context.contextlevel = 50
LEFT JOIN mdl_role_assignments AS ra ON ra.contextid = context.id
#where l.id < 50000
