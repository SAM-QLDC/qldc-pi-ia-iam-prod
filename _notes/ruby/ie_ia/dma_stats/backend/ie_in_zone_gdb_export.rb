## IEXCHANGE CONFIG

$dbase = '//10.106.2.52:40000/InfoNet_Pims'
$dest = 'C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_ia\\dma stats\\exports\\zone\\'

#Options: Collection Network, Distribution Network, Model Network
$network = 'Distribution Network'

#Options: SHP, TAB, MIF, GDB
$type = 'GDB'

## END OF IEXCHANGE CONFIG

array = [6794]
name = ['ZONES']
order = [0]
index = 0

WSApplication.use_arcgis_desktop_licence
db = WSApplication.open($dbase, false)

until index == array.length
	nw = db.model_object_from_type_and_id($network,array[index])
	
	export_tables = ["wams_zone"]
	
	options=Hash.new
	
	# Boolean | Default = FALSE
	options['ExportFlags'] = false
	options['SkipEmptyTables'] = false
	options['Tables'] = export_tables
	
	# Convert to string
	string = index.to_s
	db_name = name[index]
	
	# Export
	#to shape folder
	#nw.GIS_export($type, options, $dest + string + "\\")
	
	#to geodatabase file
	#nw.GIS_export($type, options, $dest + db_name + "\\data.gdb")
	nw.GIS_export($type, options, $dest + "\\" + db_name + ".gdb")
	
	# Loop
	index += 1
end