Generate a “Calculated” mdl_log table###
Creating a special “calculated” mdl_log table to save CPU power###

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

ALTER TABLE `mdl_log_calculated` ADD PRIMARY KEY (`id`);
ALTER TABLE `mdl_log_calculated` ADD KEY `mdl_log_calc_cidrid_ix` (`course_id`,`user_roleid`);
ALTER TABLE `mdl_log_calculated` 
    ADD KEY `mdl_log_calc_userhit_ix` (`user_roleid`,`course_path`,`module_name`);
ALTER TABLE `mdl_log_calculated` 
    ADD KEY `mdl_log_calc_userviewhit_ix` (`course_id`,`user_roleid`,`module_action`);

SELECT mdl_log + extra calculated data (testing)
================================================

SELECT l.id, l.time, 
l.cmid AS module_id,
l.action AS module_action, 
l.module AS module_name, 
l.userid AS user_id, 
ra.roleid AS user_roleid, 
l.course AS course_id, 
c.idnumber AS course_idnumber, 
c.category AS course_category, 
cc.path AS course_path
FROM mdl_log AS l
JOIN mdl_course AS c ON c.id = l.course
JOIN mdl_course_categories AS cc ON cc.id = c.category
JOIN mdl_context AS context ON l.course = context.instanceid AND context.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.contextid = context.id
where l.id < 1300

INSERT INTO mdl_log_calculated
==============================

INSERT LOW_PRIORITY  IGNORE INTO mdl_log_calculated
SELECT l.id, l.time, 
l.cmid AS module_id,
l.action AS module_action, 
l.module AS module_name, 
l.userid AS user_id, 
ra.roleid AS user_roleid, 
l.course AS course_id, 
c.idnumber AS course_idnumber, 
c.category AS course_category, 
cc.path AS course_path
FROM mdl_log AS l
LEFT JOIN mdl_course AS c ON c.id = l.course
LEFT JOIN mdl_course_categories AS cc ON cc.id = c.category
LEFT JOIN mdl_context AS context ON l.course = context.instanceid AND context.contextlevel = 50
LEFT JOIN mdl_role_assignments AS ra ON ra.contextid = context.id
#where l.id < 50000
