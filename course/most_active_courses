Most active courses ###
Most active courses ###
SELECT COUNT(l.id) hits, l.course courseId, c.fullname coursename
FROM prefix_log l INNER JOIN prefix_course c ON l.course = c.id
GROUP BY courseId
ORDER BY hits DESC
