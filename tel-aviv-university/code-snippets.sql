SQL sub queries ###
SQL sub queries ###

,CASE 
  WHEN RIGHT(c.idnumber, 1) = '1' THEN 'סמסטר א'
  WHEN RIGHT(c.idnumber, 1) = '2' THEN 'סמסטר ב'
  WHEN RIGHT(c.idnumber, 1) = '3' THEN 'סמסטר קיץ'
  WHEN RIGHT(c.idnumber, 1) = '0' THEN 'שנתי'
END AS "Course Semester"

,(SELECT GROUP_CONCAT( DISTINCT 
MID( u.firstname, 35, LOCATE(  '</span><span lang="en"', u.firstname ) -35 ),' ', 
MID( u.lastname, 35, LOCATE(  '</span><span lang="en"', u.lastname ) -35 ),'<br/>') AS Teacher
FROM mdl_role_assignments AS ra
JOIN mdl_context AS ctx ON ra.contextid = ctx.id AND ctx.contextlevel = 50 
JOIN mdl_user AS u ON u.id = ra.userid
WHERE ra.roleid = 3 AND ctx.instanceid = c.id
) AS "Teachers in course"

,MID( c.fullname, 35, LOCATE(  '</span><span lang="en"', c.fullname ) -35 ) AS "Course name"

,MID( cc.name, 35, LOCATE(  '</span><span lang="en"', cc.name ) -35 ) AS "Course Category"

,(SELECT MID( fcc.name, 35, LOCATE(  '</span><span lang="en"', fcc.name ) -35 ) 
  FROM mdl_course_categories AS fcc WHERE fcc.id = MID( cc.path, LOCATE ('/', cc.path, 2) + 1 , 
  LOCATE ('/', cc.path, LOCATE ('/', cc.path, 2) + 1) - LOCATE ('/', cc.path, 2) - 1 ) ) AS "Course School"

,(SELECT MID( scc.name, 35, LOCATE(  '</span><span lang="en"', scc.name ) -35 ) 
  FROM mdl_course_categories AS scc WHERE scc.id = MID( cc.path, 2 , LOCATE ('/', cc.path, 2) - 2) ) AS "Course Faculty"
