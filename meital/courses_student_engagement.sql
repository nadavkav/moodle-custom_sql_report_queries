Courses - student assignments, forums, and questionnaires activity ###
Courses - student assignments, forums, and questionnaires activity ###

SELECT 
#course.fullname as CourseName,ra.userid as CodeStudent,

(SELECT concat('<a target="_new" href="%%WWWROOT%%/report/outline/user.php?id=',u.id,'&course=',course.id,'&mode=complete">', 
			   MID( u.firstname, 35, LOCATE(  '</span><span lang="en"', u.firstname ) -35 ), ' ',
			   MID( u.lastname, 35, LOCATE(  '</span><span lang="en"', u.lastname ) -35 ),'</a>') FROM mdl_user AS u WHERE u.id = ra.userid) AS Student
  
,(select count(*) 
from mdl_assign_submission as mas
join mdl_assign as ma on ma.id=mas.assignment
where ra.userid=mas.userid and ma.course=course.id) as "submissions in Current course"

,(select count(*) 
from mdl_assign_submission as mas
join mdl_assign as ma on ma.id=mas.assignment
where ra.userid=mas.userid) as "submissions in All courses"

,(select count(*) from mdl_assign where course=course.id and id not in
(select mas.assignment
from mdl_assign_submission as mas
join mdl_assign as ma on ma.id=mas.assignment
where  ra.userid=mas.userid and ma.course=course.id)) as "Not submitted yet in current Course"

,(select count(*) from mdl_assign where course in (select con.instanceid
from mdl_role_assignments as mra join 
mdl_context as con on mra.contextid=con.id and con.contextlevel=50
where roleid=5 and userid= ra.userid)
and id not in
(select mas.assignment
from mdl_assign_submission as mas
join mdl_assign as ma on ma.id=mas.assignment
where  ra.userid=mas.userid and ma.course=course.id)) as "Not submited yet in all Courses"

,(SELECT COUNT( * ) FROM mdl_assign_grades AS ag
JOIN mdl_assign AS a ON a.id = ag.assignment
WHERE ag.userid = ra.userid and a.course= course.id
and ag.grade not like 'NULL') AS "number of assign got grade In Current Course"

,(SELECT ROUND(AVG( ag.grade )) FROM mdl_assign_grades AS ag
JOIN mdl_assign AS a ON a.id = ag.assignment
WHERE ag.userid = ra.userid and a.course= course.id
and ag.grade not like 'NULL') AS "Average Assignments grade"

,(SELECT COUNT(*)   
FROM mdl_log AS l
WHERE l.course = course.id AND l.userid =ra.userid
AND module NOT IN ( 'file', 'resource', 'url', 'book', 'folder', 'tab', 'label', 'page' ) ) AS Activities_Hits

,(SELECT COUNT(*)   
FROM mdl_log AS l
WHERE l.course = course.id AND l.userid =ra.userid
AND module IN ( 'file', 'resource', 'url', 'book', 'folder', 'tab', 'label', 'page' ) ) AS Resources_Hits

, (SELECT COUNT( * ) 
FROM mdl_forum_posts AS fp
JOIN mdl_forum_discussions AS fd ON fp.discussion = fd.id
WHERE fd.course = course.id AND fp.userid = ra.userid
) AS "Posts in Forums"

, (SELECT COUNT( * ) 
FROM mdl_forum_discussions AS fd
WHERE fd.course = course.id AND fd.userid = ra.userid
) AS "Discussions in Forums"

,(SELECT COUNT(*)
FROM mdl_questionnaire_attempts AS qa
JOIN mdl_questionnaire AS q ON q.id = qa.qid
JOIN mdl_questionnaire_response AS qr ON qr.id = qa.rid
WHERE qa.userid = ra.userid
) AS "Submitted Questionnaires"

FROM mdl_role_assignments AS ra
JOIN mdl_context AS context ON ra.contextid = context.id AND context.contextlevel =50
JOIN mdl_course AS course ON course.id = context.instanceid
WHERE ra.roleid=5 
%%FILTER_COURSES:course.id%%

# A specific course id
#WHERE c.id = 3123

# Current course
#WHERE c.id = %%COURSEID%%
