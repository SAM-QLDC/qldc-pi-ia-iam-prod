/*
Process to identify pipes that need be ignored for the
purposes of identifying the most current condition
survey for each pipe

For instance cctv surveys carried out earlier than 
a pipes install date should not be used for 
capacity assessment
*/

/* deselect all pipes */
DESELECT ALL;

/* clean field so that the following queries can update */
SET ignore_for_updates = 0, ignore_for_updates_flag = '';

/* deseelct pipes which have been abadoned */
SET ignore_for_updates = '1', ignore_for_updates_flag = 'AS'
WHERE details.code = 'IA' 
AND surveyed_length/joined.length < 0.1
AND ignore_for_updates = 0;

/* identify surveys that have occured before it has been renewed */
SET ignore_for_updates = '1', ignore_for_updates_flag = 'XX'
WHERE joined.year_laid > when_surveyed
OR joined.year_renew > YEARPART(when_surveyed)
AND ignore_for_updates = 0;

/* identify surveys with no attached defects */
SET ignore_for_updates ='1', ignore_for_updates_flag = '#V'
WHERE COUNT(details.*)= 0 AND ignore_for_updates = 0;

/* identify surveys not matched to a pipe */
SET ignore_for_updates = '1', ignore_for_updates_flag = '#S'
WHERE joined.oid is null AND ignore_for_updates = 0;