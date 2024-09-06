/*  
object type: node
cover_level: updated from gps_survey
ground_level: updated from ground model
*/

SELECT uid, node_id, 
	x, y, 
	ground_level,
	ground_level_flag,
	cover_level,
	cover_level_flag,
	NOW()
WHERE ground_level>0
OR cover_level>0