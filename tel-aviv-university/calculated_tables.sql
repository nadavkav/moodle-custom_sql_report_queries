=== moodle-reports.tau.ac.il === calculated/static - role_assignments + context (courseid) + cc.path

CREATE TABLE IF NOT EXISTS `mdl_role_assignments_courseid` (
  `contextid` bigint(10) NOT NULL,
  `roleid` bigint(10) NOT NULL,
  `userid` bigint(10) NOT NULL,
  `courseid` bigint(10) NOT NULL,
  `contextlevel` bigint(10) NOT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  KEY `mdl_rac_course_user_ix` (`courseid`,`userid`),
  KEY `mdl_rac_course_role_ix` (`courseid`,`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='static role_assigments + context';

---

INSERT IGNORE INTO mdl_role_assignments_courseid

SELECT 
context.id AS contextid, 
ra.roleid, 
ra.userid, 
context.instanceid AS courseid, 
context.contextlevel,
cc.path AS path

FROM mdl_role_assignments AS ra  
LEFT JOIN mdl_context AS context ON ra.contextid = context.id AND context.contextlevel = 50
 JOIN mdl_course AS c ON c.id = context.instanceid
 JOIN mdl_course_categories AS cc ON c.category = cc.id
