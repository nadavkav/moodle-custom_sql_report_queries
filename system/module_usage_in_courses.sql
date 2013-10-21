Modules usage in courses ###
How much modules (resources and activities) Teachers used in their courses, system wide ###

SELECT COUNT( cm.id ) AS counter, m.name
FROM prefix_course_modules AS cm
JOIN prefix_modules AS m ON cm.module = m.id
GROUP BY cm.module
ORDER BY counter DESC
