//SET $largest_ds = MAX(ds_links.width)/1000;
//SET $largest_us = MAX(us_links.width)/1000;

//LET $extra = 0.762;
//SELECT node_id, ($largest + $extra) AS chamber_area;

SELECT node_id,
NVL(MAX(ds_links.width)/1000,MAX(us_links.width)/1000) + 0.762 AS chamber_plan_area_1,
(IIF((MAX(ds_links.width)/1000)=0, MAX(us_links.width)/1000, MAX(ds_links.width)/1000)) + 0.762 AS chamber_plan_area_2