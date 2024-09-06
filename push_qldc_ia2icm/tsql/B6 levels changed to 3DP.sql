/*  
object type: node
reduce the number of decimal places in ground
level data and any other RLs
*/

/* saved fields to memory */
UPDATE [All Nodes] SET $gl = ground_level, $gl_flag = ground_level_flag;
UPDATE [All Nodes] SET $cl = cover_level, $cl_flag = cover_level_flag;
UPDATE [All Links] SET $usdfc = us_depth_from_cover,$usdfc_flag = us_depth_from_cover_flag;
UPDATE [All Links] SET $dsdfc = ds_depth_from_cover, $dsdfc_flag = ds_depth_from_cover_flag;

/* updates to all nodes */
UPDATE [All Nodes] SET ground_level = FIXED($gl,3), ground_level_flag = $gl_flag;
UPDATE [All Nodes] SET cover_level = FIXED($cl,3), cover_level_flag = $cl_flag;
	
/* updates to all links */
UPDATE [All Links] SET us_depth_from_cover = FIXED($usdfc,3),us_depth_from_cover_flag = $usdfc_flag;
UPDATE [All Links] SET ds_depth_from_cover = FIXED($dsdfc,3),ds_depth_from_cover_flag = $dsdfc_flag;