List of users in a course ###
List of enrolled users in a Moodle 2.x course ###

SELECT
user2.firstname AS Firstname,
user2.lastname AS Lastname,
user2.email AS Email,
user2.city AS City,
course.fullname AS Course
,(SELECT shortname FROM prefix_role WHERE id=en.roleid) AS ROLE
,(SELECT name FROM prefix_role WHERE id=en.roleid) AS RoleName
 
FROM prefix_course AS course 
JOIN prefix_enrol AS en ON en.courseid = course.id
JOIN prefix_user_enrolments AS ue ON ue.enrolid = en.id
JOIN prefix_user AS user2 ON ue.userid = user2.id
