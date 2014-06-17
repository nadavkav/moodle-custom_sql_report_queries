SQL snippets ###
Filters and variables ###

%%COURSEID%% and %%USERID%% and %%FILTER_VAR%%
%%DEBUG%% - Display the SQL query

And Special filters (if available!):
%%FILTER_SEARCHTEXT:table.field:('=', '<', '>', '<=', '>=', '~')%%
%%FILTER_SEMESTER:table.field%%
%%FILTER_YEARNUMERIC:table.field%%
%%FILTER_YEARHEBREW:table.field%% 
%%FILTER_COURSES:table.field%% - courseid
%%FILTER_MYCOURSE:table.field%% - courseid
%%FILTER_CATEGORIES:table.field%% - categoryid
%%FILTER_SUBCATEGORIES:mdl_course_categories.path%% - categoryid
%%FILTER_ROLE:table.field%% - roleid
%%FILTER_STARTTIME:l.time:>%% %%FILTER_ENDTIME:l.time:<%% ('<', '>', '<=', '>=', '~')
%%FILTER_COURSEMODULEID%% , %%FILTER_COURSEMODULEFIELDS%% , %%FILTER_COURSEMODULE%%
%%FILTER_USERS:table.field%% - Custom profile fields
%%FILTER_SYSTEMUSER:table.field%% - userid
%%FILTER_COURSEUSER:table.field%% - userid

Samples:
FROM mdl_course AS c
JOIN mdl_course_categories AS cc ON cc.id = c.category
WHERE 1=1
%%FILTER_SUBCATEGORIES:cc.path%%

Link to user's edit profile
CONCAT('<a target="_new" href="%%WWWROOT%%/user/editadvanced.php?id=', 
	   u.id, '">', u.firstname, ' ', u.lastname, '</a>') AS Fullname
	   
Link to course
CONCAT('<a target="_new" href="%%WWWROOT%%/course/view.php?id=', 
    c.id, '">', c.fullname,'</a>') AS Course

