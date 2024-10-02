$dbase = '//10.106.2.52:40000/InfoNet_Pims'
$dest = 'C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_ia\\export_of_snapshot_files\\exports\\'
$network = 'Collection Network'

array = [4914,4815,4986,8,4944]
name = ['HCC_Wastewater','PCC_Wastewater','UHCC_Wastewater','WCC_Wastewater','SWDC_Wastewater']
order = [0,1,2,3,4]
index = 0

WSApplication.use_arcgis_desktop_licence
db = WSApplication.open($dbase, false)

until index == array.length

	nw = db.model_object_from_type_and_id($network,array[index])
	nw.update
	on = nw.open
	
	exp=Hash.new
	
	# Boolean | Default = FALSE
	exp['SelectedOnly'] = false
	exp['IncludeImageFiles'] = 	false
	exp['IncludeGeoPlanPropertiesAndThemes'] = 	false
	
	# Convert to string
	string = index.to_s
	db_name = name[index]

	on.snapshot_export_ex($dest + "\\" + db_name + ".isfc",exp)
	
	# Loop
	index += 1
end