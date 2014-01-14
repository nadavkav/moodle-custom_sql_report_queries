Course modules hits roles ###
Course modules (resources and activities), hits, roles, teachers ###

SELECT 

concat('<a target="_new" href="%%WWWROOT%%/course/view.php?id=',c.id,'">',c.fullname,'</a>') AS Course

# Main / Single teacher
#,( SELECT DISTINCT CONCAT(u.firstname,' ',u.lastname)
#  FROM prefix_role_assignments AS ra
#  JOIN prefix_user AS u ON ra.userid = u.id
#  JOIN prefix_context AS ctx ON ctx.id = ra.contextid
#  WHERE ra.roleid = 3 AND ctx.instanceid = c.id AND ctx.contextlevel = 50 LIMIT 1) AS Teacher

# All teachers in course
,(SELECT GROUP_CONCAT( CONCAT( u.firstname,  " ", u.lastname ) ) 
FROM prefix_course ic
JOIN prefix_context con ON con.instanceid = ic.id
JOIN prefix_role_assignments ra ON con.id = ra.contextid AND con.contextlevel = 50
JOIN prefix_role r ON ra.roleid = r.id
JOIN prefix_user u ON u.id = ra.userid
WHERE r.id = 3 AND ic.id = c.id
GROUP BY ic.id
) AS TeacherNames

# Better performance
,(SELECT COUNT(*) FROM prefix_course_modules cm WHERE cm.course = c.id AND cm.module NOT IN (4,5,14,22,24,29,32,38,39) ) AS "פעילויות"

# Better compatibility across Moodle instances
#,(SELECT COUNT(*) 
# FROM prefix_course_modules cm 
# JOIN prefix_modules AS m ON m.id = cm.module 
# WHERE cm.course = c.id AND m.name NOT IN 
# ('book','certificate','folder','label','lightboxgallery','page','resource','tab','url') ) AS "פעילויות"

,(SELECT COUNT(*) FROM prefix_course_modules cm WHERE cm.course = c.id AND cm.module IN (4,5,14,22,24,29,32,38,39) ) AS "משאבים"

,(SELECT COUNT(*) FROM prefix_log WHERE course = c.id) AS Hits

,(SELECT COUNT( ra.userid ) AS Users
FROM prefix_role_assignments AS ra
JOIN prefix_context AS ctx ON ra.contextid = ctx.id 
WHERE ra.roleid = 5 AND ctx.instanceid = c.id AND ctx.contextlevel = 50 ) AS Students

,(SELECT COUNT(*) 
FROM prefix_log AS l
JOIN prefix_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
JOIN prefix_role_assignments AS ra ON ra.contextid = context.id AND l.userid = ra.userid AND ra.roleid = 5
WHERE l.course = c.id) As StudentHits

,(SELECT COUNT(DISTINCT l.userid) 
FROM prefix_log AS l
JOIN prefix_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
JOIN prefix_role_assignments AS ra ON ra.contextid = context.id AND l.userid = ra.userid AND ra.roleid = 5
WHERE l.course = c.id ) As uniqueStudentHits

FROM prefix_course AS c
#HAVING Activities > 5 OR Resources > 5
%%FILTER_SEARCHTEXT:Teacher%%
