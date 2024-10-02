# EXPORT MODEL NETWORK AS SHAPE FILES

#require date

# ===========================================================================================
# parameters
$working_dir = "C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_icm\\odec_export_node_data"
$dbase="//10.0.29.43:40000/wastewater ongoing/design flows"

array = [5,357,358,360,362,363,364]
name = ["western","seaview","wellington","porirua","featherston","greytown","martinborough"]
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
	
	# Export
	nw.odec_export_ex("MIF", 
		$working_dir + "\\icm_config.cfg", options, 
		"Conduit", $working_dir + "\\exports\\" + db_name + "\\conduit.MIF")
		
	nw.odec_export_ex("MIF", 
		$working_dir + "\\icm_config.cfg", options, 
		"Subcatchment", $working_dir + "\\exports\\" + db_name + "\\subcatchment.MIF")
		
	nw.odec_export_ex("MIF", 
		$working_dir + "\\icm_config.cfg", options, 
		"Node", $working_dir + "\\exports\\" + db_name + "\\node.MIF")
		
	nw.odec_export_ex("MIF", 
		$working_dir + "\\icm_config.cfg", options, 
		"Polygon", $working_dir + "\\exports\\" + db_name + "\\polygon.MIF")

	# Loop
	index += 1
end