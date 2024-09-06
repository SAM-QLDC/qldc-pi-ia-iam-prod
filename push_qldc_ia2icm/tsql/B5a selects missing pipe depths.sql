/*  object type: node
     check chamber depths vs
     pipe depths
*/

//DESELECT ALL;
LET $threshold = 1.1;

/* saved fields to memory */
SET $cdepth = chamber_floor_depth/1000;
SET $m_ddepth = MAX(ds_links.us_depth_from_cover);
SET $m_udepth = MAX(us_links.ds_depth_from_cover);
SET $diff = $cdepth/$m_ddepth;

/* select assets which have a depth but not pipe depth */
SELECT WHERE $cdepth is not null
AND $m_ddepth is null AND $m_udepth is null;

/* update pipe depths with manhole depth
SET 
us_links.ds_depth_from_cover = $cdepth, 
us_links.ds_depth_from_cover_flag = '#A',
us_links.ds_invert_flag = '#D',
ds_links.us_depth_from_cover = $cdepth,
ds_links.us_depth_from_cover_flag = '#A',
ds_links.us_invert_flag = '#D'
WHERE $cdepth is not null
AND $m_ddepth is null 
AND $m_udepth is null;