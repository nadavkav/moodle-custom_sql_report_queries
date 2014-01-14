All teachers in course ###
All teachers in course ###

,(SELECT GROUP_CONCAT( CONCAT( u.firstname,  " ", u.lastname ) ) 
FROM prefix_course ic
JOIN prefix_context con ON con.instanceid = ic.id
JOIN prefix_role_assignments ra ON con.id = ra.contextid AND con.contextlevel = 50
JOIN prefix_role r ON ra.roleid = r.id
JOIN prefix_user u ON u.id = ra.userid
WHERE r.id = 3 AND ic.id = c.id
GROUP BY ic.id
) AS TeacherNames

