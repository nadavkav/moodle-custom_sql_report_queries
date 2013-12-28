Course - assignments list ###
Course - assignments list, is a base report for a second report which expands on student's activity 
(Change the XX in the "viewreport.php?id=XX" of the second report with the report id that is generated 
after you save the first report ) ###

==== 1. Show user's grades in assignments (Is called by the following report) + NOTE! add the necessary filters

SELECT 

#a.course,ag.userid,

(SELECT CONCAT(MID( u.firstname, 35, LOCATE(  '</span><span lang="en"', u.firstname ) -35 ), ' ', MID( u.lastname, 35, LOCATE(  '</span><span lang="en"', u.lastname ) -35 )) FROM mdl_user AS u WHERE u.id = ag.userid ) As Username,

(SELECT u.idnumber FROM mdl_user as u WHERE u.id = ag.userid ) As IDnumber,
a.name,
ag.grade,
DATE_FORMAT(FROM_UNIXTIME(ag.timemodified), '%d-%m-%Y') AS Grading_Date 

FROM mdl_assign_grades as ag 
JOIN mdl_assign as a ON a.id = ag.assignment
WHERE 1=1
%%FILTER_SEARCHTEXT:ag.userid:=%%
%%FILTER_COURSES:a.course%%
%%FILTER_STARTTIME:ag.timecreated:>=%% %%FILTER_ENDTIME:ag.timecreated:<=%%

==== 2. Display a list of assignmnets (links to the above report) + NOTE! add the necessary filters

SELECT 
u.id

CONCAT(u.firstname, ' ', u.lastname) AS Student
#,CONCAT(MID( u.firstname, 35, LOCATE(  '</span><span lang="en"', u.firstname ) -35 ), ' ', MID( u.lastname, 35, LOCATE(  '</span><span lang="en"', u.lastname ) -35 )) AS Student

,CONCAT('<a target="_new" href="%%WWWROOT%%/blocks/configurable_reports/viewreport.php?id=XX&filter_courses=',context.instanceid,'&filter_searchtext=',u.id,'">רשימת מטלות וציונים</a>') AS "הגשות"

,CONCAT('<a target="_new" href="%%WWWROOT%%/mod/assign/index.php?id=',context.instanceid,'">רשימת מטלות</a>') AS "מטלות"

FROM mdl_role_assignments AS ra
JOIN mdl_context AS context ON ra.contextid = context.id AND context.contextlevel = 50
JOIN mdl_user AS u ON u.id = ra.userid
WHERE ra.roleid = 5 
%%FILTER_COURSES:context.instanceid%%
