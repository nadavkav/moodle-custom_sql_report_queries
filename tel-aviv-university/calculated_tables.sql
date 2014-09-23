=== moodle-reports.tau.ac.il === calculated/static tables 
=========================================================

=== mdl_role_assignments_courseid
- role_assignments + context (courseid) + cc.path

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

--- daily update with...

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

=== mdl_log_calculated
--
-- Table structure for table `mdl_log_calculated`
--
CREATE TABLE IF NOT EXISTS `mdl_log_calculated` (
  `id` bigint(10) NOT NULL,
  `time` bigint(10) NOT NULL,
  `module_id` bigint(10) NOT NULL,
  `module_action` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `module_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `user_id` bigint(10) NOT NULL,
  `user_roleid` bigint(10) NOT NULL,
  `course_id` bigint(10) NOT NULL,
  `course_idnumber` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `course_category` bigint(10) NOT NULL,
  `course_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `major_categoryid` bigint(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--
-- Indexes for table `mdl_log_calculated`
--
ALTER TABLE `mdl_log_calculated`
 ADD PRIMARY KEY (`id`), ADD KEY `mdl_log_calc_cidrid_ix` (`course_id`,`user_roleid`), 
 ADD KEY `mdl_log_calc_userhit_ix` (`user_roleid`,`course_path`,`module_name`), 
 ADD KEY `mdl_log_calc_userviewhit_ix` (`course_id`,`user_roleid`,`module_action`), 
 ADD KEY `mdl_log_calc_multi_ix` (`user_roleid`,`module_name`,`course_path`,`course_id`,`time`), 
 ADD KEY `mdl_log_calc_mnameaction_ix` (`module_name`,`module_action`,`course_path`,`course_id`,`time`), 
 ADD KEY `mdl_log_calc_majorcatid_ix` (`major_categoryid`);

--- daily update with...
INSERT LOW_PRIORITY  IGNORE INTO mdl_log_calculated

SELECT 
l.id, 
l.time, 
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
LEFT JOIN mdl_role_assignments AS ra ON ra.contextid = context.id AND l.userid = ra.userid

WHERE l.id > 36000000 
#AND l.id < 31000000

=== mdl_log_calculated_more
--
-- Table structure for table `mdl_log_calculated_more`
--
CREATE TABLE IF NOT EXISTS `mdl_log_calculated_more` (
  `id` bigint(10) NOT NULL,
  `course` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `studentcount` bigint(10) NOT NULL,
  `teachercount` bigint(10) NOT NULL,
  `teacheracount` bigint(10) NOT NULL,
  `totalhits` bigint(10) NOT NULL,
  `totalteacherhit` bigint(10) NOT NULL,
  `totalstudenthit` bigint(10) NOT NULL,
  `uniquestudents` bigint(10) NOT NULL,
  `studantviews` bigint(10) NOT NULL,
  `studantviewsunique` bigint(10) NOT NULL,
  `teachernews` bigint(10) NOT NULL,
  `teacheranews` bigint(10) NOT NULL,
  `teachers` text CHARACTER SET utf8 COLLATE utf8_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--
-- Indexes for table `mdl_log_calculated_more`
--
ALTER TABLE `mdl_log_calculated_more`
 ADD PRIMARY KEY (`id`);
 
--- daily update with...
REPLACE INTO mdl_role_assignments_courseid

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


=== mdl_files_calculated
--
-- Table structure for table `mdl_files_calculated`
--
CREATE TABLE IF NOT EXISTS `mdl_files_calculated` (
  `id` bigint(10) NOT NULL,
  `contextid` bigint(10) NOT NULL,
  `component` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `filearea` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `filepath` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `filesize` bigint(10) NOT NULL,
  `mimetype` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `author` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `license` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `timecreated` bigint(10) NOT NULL,
  `courseid` bigint(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Calculated version of mdl_files + extra courseid field';
--
-- Indexes for table `mdl_files_calculated`
--
ALTER TABLE `mdl_files_calculated`
 ADD PRIMARY KEY (`id`), 
 ADD KEY `mdl_filescalc_courseid_ix` (`courseid`), 
 ADD KEY `mdl_filescalc_mime_ix` (`mimetype`);

--- daily update with...
INSERT LOW_PRIORITY IGNORE INTO mdl_files_calculated
SELECT id, contextid, component, filearea, filepath, filename, filesize, mimetype, author, license, timecreated
, (SELECT 
(SELECT con.instanceid
FROM mdl_context AS con
WHERE con.id = SUBSTRING_INDEX( SUBSTRING_INDEX( context.path, '/' , - 2 ) , '/', 1 )
) AS courseid
FROM mdl_context AS context
WHERE context.id = f.contextid
) AS courseid
FROM mdl_files AS f
WHERE filesize >0
