Single teacher ###
Main / Single / First teacher in course role list ###

,( SELECT DISTINCT CONCAT(u.firstname,' ',u.lastname)
  FROM prefix_role_assignments AS ra
  JOIN prefix_user AS u ON ra.userid = u.id
  JOIN prefix_context AS ctx ON ctx.id = ra.contextid
  WHERE ra.roleid = 3 AND ctx.instanceid = c.id AND ctx.contextlevel = 50 LIMIT 1) AS Teacher
