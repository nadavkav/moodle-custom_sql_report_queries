Categories - Stats for teachers and students hits ###
Categories - Stats for teachers and students hits + activies + modules ###

SELECT mcc.id AS mccid, mcc.name 

,(SELECT COUNT( * ) 
FROM mdl_course AS c
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE cc.path LIKE CONCAT( '%', mccid, '%' )
) As Courses

,(SELECT COUNT(DISTINCT ra.userid) 
FROM mdl_role_assignments AS ra
JOIN mdl_context AS context ON context.id = ra.contextid AND context.contextlevel =50
JOIN mdl_course AS c ON c.id = context.instanceid
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE ra.roleid =3 AND cc.path LIKE CONCAT( '%', mccid, '%' )
) AS "Unique Teachers"

,(SELECT COUNT(DISTINCT ra.userid) 
FROM mdl_role_assignments AS ra
JOIN mdl_context AS context ON context.id = ra.contextid AND context.contextlevel =50
JOIN mdl_course AS c ON c.id = context.instanceid
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE ra.roleid =5 AND cc.path LIKE CONCAT( '%', mccid, '%' )
) AS "Unique Students"

,(SELECT COUNT(*) 
FROM mdl_role_assignments AS ra
JOIN mdl_context AS context ON context.id = ra.contextid AND context.contextlevel =50
JOIN mdl_course AS c ON c.id = context.instanceid
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE ra.roleid =5 AND cc.path LIKE CONCAT( '%', mccid, '%' )
) AS "Students"

,(SELECT COUNT( * ) 
FROM mdl_log AS l
JOIN mdl_course AS c ON c.id = l.course
JOIN mdl_course_categories AS cc ON cc.id = c.category
JOIN mdl_context AS context ON context.instanceid = c.id AND context.contextlevel =50
JOIN mdl_role_assignments AS ra ON ra.contextid = context.id AND l.userid = ra.userid
WHERE ra.roleid = 5 AND cc.path LIKE CONCAT( '%', mccid, '%' ) 
#AND l.action = 'view'
) AS "Student Activity" 

,(SELECT COUNT( * ) 
FROM mdl_course_modules AS cm
JOIN mdl_course AS c ON cm.course = c.id
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE cc.path LIKE CONCAT( '%', mccid, '%' )
) As "Course Modules"

,(SELECT COUNT( * ) 
FROM mdl_log AS l
JOIN mdl_course AS c ON c.id = l.course
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE cc.path LIKE CONCAT( '%', mccid, '%' ) 
#AND l.action = 'view'
) AS "Total Course Activity" 

,(SELECT AVG( views ) 
FROM (
 SELECT c.id, cc.path, DATE_FORMAT( FROM_UNIXTIME( l.time ) ,  '%d-%m' ) , COUNT( * ) AS Views
 FROM mdl_log AS l
 JOIN mdl_course AS c ON c.id = l.course
 JOIN mdl_course_categories AS cc ON cc.id = c.category
 GROUP BY c.id, DATE_FORMAT( FROM_UNIXTIME( l.time ) ,  '%d-%m' )
 ) AS CourseViews
 WHERE path LIKE CONCAT( '%', mccid, '%' ) 
) AS "AVG Course Activity - day" 

,(SELECT AVG( views ) 
FROM (
 SELECT c.id, cc.path, DATE_FORMAT( FROM_UNIXTIME( l.time ) ,  '%d-%m' ) , COUNT( * ) AS Views
 FROM mdl_log AS l
 JOIN mdl_course AS c ON c.id = l.course
 JOIN mdl_course_categories AS cc ON cc.id = c.category
 GROUP BY c.id, DATE_FORMAT( FROM_UNIXTIME( l.time ) ,  '%Y-%m' )
 ) AS CourseViews
 WHERE path LIKE CONCAT( '%', mccid, '%' ) 
) AS "AVG Course Activity - Month" 

,(SELECT COUNT( * ) 
FROM mdl_log AS l
JOIN mdl_course AS c ON c.id = l.course
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE cc.path LIKE CONCAT( '%', mccid, '%' ) 
AND l.module != 'course'
) AS "Module Activity" 

FROM mdl_course_categories AS mcc
WHERE mcc.depth = 1
