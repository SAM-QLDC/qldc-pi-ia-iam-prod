## IEXCHANGE CONFIG

$dbase = '//10.106.2.52:40000/InfoNet_Pims'
$type = 'GDB'
$dest = 'C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_ia\\export_latest_infoasset data\\exports\\'

## END OF IEXCHANGE CONFIG

array = [4815, 4986, 8, 4944, 4914]
name = ['PCC', 'UHC', 'WCC', 'SWD', 'HCC']
order = [0, 1, 2, 3, 4]
index = 0

WSApplication.use_arcgis_desktop_licence
db = WSApplication.open($dbase, false)

until index == array.length
	nw = db.model_object_from_type_and_id('Collection Network',array[index])
	
	options=Hash.new
	
	# Boolean | Default = FALSE
	options['ExportFlags'] = false
	options['SkipEmptyTables'] = false
	
	# Convert to string
	string = index.to_s
	subfolder = name[index]
	
	# Export
	nw.GIS_export($type, options, $dest + subfolder + "\\data.gdb")    #to geodatabase file
	
	# Loop
	index += 1
end