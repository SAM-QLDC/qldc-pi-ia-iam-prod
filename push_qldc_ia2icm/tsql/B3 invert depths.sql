/*  
object type: node
pipe depths: are brought in using manhole surveys
pipe inverts: will be used for modelling and also
pipe full capacity calculations
*/

/* saved fields to memory */
SET 
$usi = us_invert, $usi_f = us_invert_flag,
$dsi = ds_invert, $dsi_f = ds_invert_flag,
$usd = us_depth_from_cover, $usd_f = us_depth_from_cover_flag,
$dsd = ds_depth_from_cover, $dsd_f = ds_depth_from_cover_flag,
$uscl = us_node.cover_level, $uscl_f = us_node.cover_level_flag,
$dscl = ds_node.cover_level, $dscl_f = ds_node.cover_level_flag,
$usgl = us_node.ground_level, $usgl_f = us_node.ground_level_flag,
$dsgl = ds_node.ground_level, $dsgl_f = ds_node.ground_level_flag;

/* us and ds depth from cover level */
SET $usdcl = $uscl - $usi;
SET $dsdcl = $dscl - $dsi;

/* check above results in a table
SELECT $usi, $dsi, $usd, $dsd, $uscl, $dscl, $usgl, $dsgl, $usdcl, $dsdcl;

/* update depths where there is 
good cover and invert level data */

SET us_depth_from_cover = $uscl - $usi,
	us_depth_from_cover_flag = $usi_f,
	us_invert_flag = '#D'
WHERE us_depth_from_cover is null AND 
	$uscl is not null AND 
	$uscl_f <> 'GM' AND 
	$usi is not null;

SET ds_depth_from_cover = $dscl - $dsi,
	ds_depth_from_cover_flag = $dsi_f,
	ds_invert_flag = '#D'
WHERE ds_depth_from_cover is null AND 
	$dscl is not null AND 
	$dscl_f <> 'GM' AND 
	$dsi is not null;
	
/* update depths where there are inverts
and no cover level data */

SET us_depth_from_cover = $uscl - $usi,
	us_depth_from_cover_flag = 'GM',
	us_invert_flag = '#D'
WHERE us_depth_from_cover is null AND 
	$uscl is not null AND 
	$uscl_f = 'GM' AND 
	$usi is not null;
	
SET ds_depth_from_cover = $dscl - $dsi,
	ds_depth_from_cover_flag = 'GM',
	ds_invert_flag = '#D'
WHERE ds_depth_from_cover is null AND 
	$dscl is not null AND 
	$dscl_f = 'GM' AND 
	$dsi is not null;
	
/* update us and ds inverts to default 
where they are not #D and there is us and ds depths */

SET us_invert_flag = '#D'
WHERE $usd is not null AND
	$usi is not null AND 
	$usi_f <> '#D';
	
SET ds_invert_flag = '#D'
WHERE $dsd is not null AND
	$dsi is not null AND 
	$dsi_f <> '#D';