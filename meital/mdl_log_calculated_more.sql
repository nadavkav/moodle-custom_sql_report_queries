# use report 50 to fill table mdl_log_calculated_more with results

CREATE TABLE IF NOT EXISTS `mdl_log_calculated_more` (
`id` bigint(10) NOT NULL,
`course` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
`studentcount` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
`teachercount` bigint(10) NOT NULL,
`teacheracount` bigint(10) NOT NULL,
`totalhits` bigint(10) NOT NULL,
`totalteacherhit` bigint(10) NOT NULL,
`totalstudenthit` bigint(10) NOT NULL,
`uniquestudents` bigint(10) NOT NULL,
`studantviews` bigint(10) NOT NULL,
`studantviewsunique` bigint(10) NOT NULL,
`teachernews` bigint(10) NOT NULL,
`teacheranews` bigint(10) NOT NULL,
`teachers` varchar(255) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
