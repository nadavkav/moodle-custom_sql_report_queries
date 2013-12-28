Courses - resources and activities ###
Courses - resources and activities ###

SELECT c.id, concat('<a target="_new" href="%%WWWROOT%%/course/view.php?id=',c.id,'">',c.fullname,'</a>') AS Course 

,cc.name AS Category
#,MID( cc.name, 35, LOCATE(  '</span><span lang="en"', cc.name ) -35 ) AS Category

,COUNT(l.id) hits

,CASE 
  WHEN c.visible LIKE '1' THEN 'Yes'
  WHEN c.visible LIKE '0' THEN 'No'
END AS Available

,(SELECT COUNT(*) FROM  `mdl_course_sections` WHERE  `course` =c.id) AS Sections

,(SELECT GROUP_CONCAT(
MID( u.firstname, 35, LOCATE(  '</span><span lang="en"', u.firstname ) -35 ),' ', 
MID( u.lastname, 35, LOCATE(  '</span><span lang="en"', u.lastname ) -35 ),'<br/>') AS Teacher
FROM mdl_role_assignments AS ra
JOIN mdl_context AS ctx ON ra.contextid = ctx.id AND ctx.contextlevel = 50 
JOIN mdl_user AS u ON u.id = ra.userid
WHERE ra.roleid = 3 AND ctx.instanceid = l.course
) AS Teachers
 
,(SELECT COUNT(*) FROM mdl_course_modules cm WHERE cm.course = l.course) Modules
 
,(SELECT COUNT(*) FROM mdl_course_modules cm JOIN mdl_modules AS m ON m.id = cm.module 
  WHERE cm.course = c.id AND m.name IN ('url', 'folder', 'resource', 'file', 'book', 'tab', 'label', 'page') ) AS Resources

,(SELECT COUNT(*) FROM mdl_course_modules cm JOIN mdl_modules AS m ON m.id = cm.module 
  WHERE cm.course = c.id AND m.name NOT IN ('url', 'folder', 'resource', 'file', 'book', 'tab', 'label', 'page') ) AS Activities

,(SELECT COUNT( ra.userid ) AS Users FROM mdl_role_assignments AS ra
JOIN mdl_context AS ctx ON ra.contextid = ctx.id
WHERE ra.roleid = 5 AND ctx.instanceid = c.id) AS Students

,(SELECT COUNT( ra.userid ) AS Users FROM mdl_role_assignments AS ra
JOIN mdl_context AS ctx ON ra.contextid = ctx.id
WHERE ra.roleid = 4 AND ctx.instanceid = c.id) AS Assistants

,(SELECT COUNT( ra.userid ) AS Users FROM mdl_role_assignments AS ra
JOIN mdl_context AS ctx ON ra.contextid = ctx.id
WHERE ra.roleid = 3 AND ctx.instanceid = c.id) AS TeacherCount
 
FROM mdl_log l 
JOIN mdl_course c ON l.course = c.id
JOIN mdl_course_categories AS cc ON cc.id = c.category
GROUP BY c.id
HAVING Modules > 2
ORDER BY hits DESC
