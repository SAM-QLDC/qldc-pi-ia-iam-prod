SET $min_level = MIN(ds_links.us_invert);
SET $max_diameter = MAX(ds_links.height)/1000;

//SELECT node_id, $min_level, $max_diameter;

SELECT node_id, MIN(ds_links.us_invert)+(MAX(ds_links.height)/1000)+0.1 AS sealed_level