Courses - student activity ###
Courses - student activity ###

SELECT c.id, c.fullname AS Course,

(SELECT COUNT( * ) 
FROM mdl_role_assignments AS ra
JOIN mdl_context AS context ON ra.contextid = context.id AND context.contextlevel =50
WHERE ra.roleid =5 AND context.instanceid = c.id) as Number_of_Students,

(SELECT COUNT(*) FROM mdl_log WHERE course = c.id) AS TotalHits,

(SELECT COUNT(*) 
FROM mdl_log AS l
JOIN mdl_context AS context ON context.instanceid = l.course AND context.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.contextid = context.id AND l.userid = ra.userid AND ra.roleid = 5
WHERE l.course = c.id) As StudentHits,

(SELECT COUNT(*) 
FROM mdl_log AS l
JOIN mdl_context AS ctx ON ctx.instanceid = l.course AND ctx.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.contextid = ctx.id AND ra.userid = l.userid AND ra.roleid = 5
WHERE course = c.id AND action like '%view%') AS activity_view_StudentHits,

(SELECT COUNT(DISTINCT l.userid) 
FROM mdl_log AS l
JOIN mdl_context AS ctx ON ctx.instanceid = l.course AND ctx.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.contextid = ctx.id AND ra.userid = l.userid AND ra.roleid = 5
WHERE course = c.id AND action like '%view%') AS activity_view_uniqueStudentHits,

(SELECT COUNT(DISTINCT l.userid) 
FROM mdl_log AS l
JOIN mdl_context AS context ON context.instanceid = l.course 
AND context.contextlevel = 50
JOIN mdl_role_assignments AS ra ON ra.contextid = context.id AND l.userid = ra.userid 
AND ra.roleid = 5
WHERE l.course = c.id ) As uniqueStudentHits,

(SELECT COUNT(*)
FROM mdl_forum_discussions as fd
JOIN mdl_forum as f ON f.id = fd.forum AND f.type = 'news'
JOIN mdl_context as context ON context.instanceid = f.course AND context.contextlevel = 50
JOIN mdl_role_assignments as ra ON ra.userid = fd.userid AND ra.roleid = 3
WHERE f.course=c.id ) AS Counter_TeacherPosts,

(SELECT COUNT(*)
FROM mdl_forum_discussions as fd
JOIN mdl_forum as f ON f.id = fd.forum AND f.type = 'news'
JOIN mdl_context as context ON context.instanceid = f.course AND context.contextlevel = 50
JOIN mdl_role_assignments as ra ON ra.userid = fd.userid AND ra.roleid = 4
WHERE f.course=c.id ) AS Counter_AssistentTeacherPosts,

(SELECT COUNT(*)
FROM mdl_groups WHERE courseid= c.id) AS groupsincourse,

(SELECT COUNT(*) FROM mdl_course_modules WHERE course = c.id) AS ModuleCount,

(SELECT COUNT(*)
FROM mdl_context AS ctx 
JOIN mdl_files AS f ON f.contextid = ctx.id AND ctx.contextlevel = 70
 WHERE ctx.path LIKE concat('%/',context.id,'/%')  
 AND f.source IS NOT NULL
) module_count_files,

(SELECT SUM(f.filesize)
FROM mdl_context AS ctx 
JOIN mdl_files AS f ON f.contextid = ctx.id AND ctx.contextlevel = 70
 WHERE ctx.path LIKE concat('%/',context.id,'/%') 
 AND f.source IS NOT NULL
) module_sum_filesize,


(SELECT ROUND(AVG(sum_user_time)) 
 	FROM (
	SELECT l.course, l.userid,
       @prevtime := (SELECT time FROM mdl_log WHERE id=l.id-1) as prev_time,
       IF (time - @prevtime < 7200, 
	       @delta := @delta + (time-@prevtime),@delta) AS sum_user_time
       FROM mdl_log as l , (SELECT @delta := 0) AS s_init 
       
       GROUP BY l.course, l.userid
    ) as sum_table
 	WHERE course = c.id
 ) As AVGtime


FROM mdl_course AS c
JOIN mdl_context as context ON context.instanceid = c.id AND context.contextlevel = 50

# You sould add a "courses" filter for the following lines to work properly
WHERE 1=1
%%FILTER_COURSES:c.id%%

# A specific course id
#WHERE c.id = 3123

# Current course
#WHERE c.id = %%COURSEID%%
