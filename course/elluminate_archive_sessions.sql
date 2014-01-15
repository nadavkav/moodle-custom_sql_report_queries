Elluminate archived sessions ###
List all course related archived elluminate (Blackboard Live) session ###

SELECT 

CONCAT('<a target="_new" href="%%WWWROOT%%/mod/elluminate/loadrecording.php?id=',er.id,'">צפיה ב "',e.name,'"</a>') AS "Elluminate Sessions"
,DATE_FORMAT( FROM_UNIXTIME( er.created ) , '%d-%m-%Y  %H:%k' ) AS Created
,CONCAT(u.firstname, ' ', u.lastname) AS Teacher
,DATE_FORMAT( FROM_UNIXTIME( e.timestart ) , '%d-%m-%Y  %H:%k' ) AS "Time Start"
,DATE_FORMAT( FROM_UNIXTIME( e.timeend ) , '%d-%m-%Y  %H:%k' ) AS "Time End"


FROM `mdl_elluminate_recordings` AS er
JOIN `mdl_elluminate` AS e ON e.meetingid = er.meetingid
JOIN mdl_user AS u ON u.id = e.creator
WHERE e.course = %%COURSEID%%
