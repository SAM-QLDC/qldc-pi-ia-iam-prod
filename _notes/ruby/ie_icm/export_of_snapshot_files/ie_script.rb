$dbase = '//10.0.29.43:40000/wastewater ongoing/system_performance'
$dest = 'C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_icm\\export_of_snapshot_files\\exports\\'
$network = 'Model Network'  #could also be sim

array = [260,6,633,768,978,1075,1170,1533,1557,1885,1972,1999,2559]
name = [
	'MoaPt SPA_Aug2023',
	'WCC WW Johnsonville SPA',
	'Porirua SPA',
	'SVW Strategic SPA',
	'WWL Wainuiomata LTSE_Cmtd_SP',
	'HCC Hutt Valley SP Latest 2019 use this one!',
	'UHC Upper Hutt MCA 2015',
	'WTP Porirua Simplified',
	'WCC Evans Bay MCA 2018',
	'WCC Karori Performance',
	'Island Bay MCA_Existing',
	'WWH System Performance',
	'WCC Central Business District MCA 2015'
	]
order = [0,1,2,3,4,5,6,7,8,9,10,11,12]
index = 0

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

	on.snapshot_export_ex($dest + "\\" + db_name + ".isfm",exp)
	
	# Loop
	index += 1
end