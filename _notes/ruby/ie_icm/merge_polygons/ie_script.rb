# EXPORT MODEL NETWORK AS SHAPE FILES

#require 'date'
#require 'fileutils'

# ===========================================================================================
# parameters
$working_dir = "C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_icm\\merge_polygons"
$dbase="//10.0.29.43:40000/wastewater FY2324/20230712 PCC Titahi Bay Flow Survey and Calibration"

array = [13]
name = ["titahi_bay"]
index = 0

WSApplication.use_arcgis_desktop_licence

db=WSApplication.open($dbase,false)

until index == array.length

	# pick out network
	nw = db.model_object_from_type_and_id("Model Network",array[index])
	
	# Set up options for exports
	options=Hash.new
	#options['ExportFlags'] = false
	
	# Convert to string
	#string = index.to_s
	db_name = name[index]
	
	# make directory if it doesn't exists
	#path = $working_dir + "\\exports\\" + db_name
	#FileUtils.mkdir_p(path) unless File.exists?(path)
	
	# Export
		
	nw.odec_export_ex("MIF", 
		$working_dir + "\\icm_config.cfg", options, 
		"Subcatchment", $working_dir + "\\exports\\" + db_name + "\\subcatchment.MIF")

	# Loop
	index += 1
end