Log configuration changes ###
Log configuration changes ###

SELECT 
 CONCAT(u.firstname, ' ', u.lastname) As Username
,DATE_FORMAT(FROM_UNIXTIME(cl.`timemodified`),'%Y-%m-%d %k:%m') AS tModified
,cl.plugin
,cl.name
,cl.value
,cl.oldvalue


FROM `mdl_config_log` AS cl
JOIN mdl_user AS u ON u.id = cl.userid

WHERE 1=1
%%FILTER_STARTTIME:cl.timemodified:>%% %%FILTER_ENDTIME:cl.timemodified:<%%
%%FILTER_SEARCHTEXT:cl.name:~%%
