## IEXCHANGE CONFIG

$dbase = '//10.106.2.52:40000/InfoNet_Pims'
$type = 'GDB'    #Options: SHP, TAB, MIF, GDB
$dest = 'C:\\Users\\HLewis\\Downloads\\cctv_surveys_h3\\exports\\cctv_shp\\'

## END OF IEXCHANGE CONFIG

array = [4914, 5061, 4709, 4815, 4986, 4987, 8, 9, 4944, 5181]
name = ['WWHCC', 'SWHCC', 'SWPCC', 'WWPCC', 'WWUHC', 'SWUHC', 'WWWCC', 'SWWCC', 'WWSWD', 'SWSWD']
order = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
index = 0

WSApplication.use_arcgis_desktop_licence
db = WSApplication.open($dbase, false)

until index == array.length
	nw = db.model_object_from_type_and_id('Collection Network',array[index])
	
	export_tables = ["cams_cctv_survey","cams_pipe"]
	
	options=Hash.new
	
	# Boolean | Default = FALSE
	options['ExportFlags'] = false
	options['SkipEmptyTables'] = false
	options['Tables'] = export_tables
	
	# Convert to string
	string = index.to_s
	subfolder = name[index]
	
	# Export
	#nw.GIS_export($type, options, $dest + string + "\\")    #to shape folder
	nw.GIS_export($type, options, $dest + subfolder + "\\data.gdb")    #to geodatabase file
	
	# Loop
	index += 1
end