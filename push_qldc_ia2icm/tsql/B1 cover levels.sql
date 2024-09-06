/*  
object type: node
cover_level: is updated from gps_survey
ground_level: is updated from ground model
*/

SET $gl = ground_level,
$gl_f = ground_level_flag,
$cl = cover_level,
$cl_f = cover_level_flag;

SET cover_level = $gl, cover_level_flag = $gl_f 
WHERE $cl is null;

SET ground_level = null, ground_level_flag = null;