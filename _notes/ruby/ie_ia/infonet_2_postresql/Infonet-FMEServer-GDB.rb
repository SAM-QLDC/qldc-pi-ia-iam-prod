puts 'Hello World'
fmeservergdbfile = "\\\\10.0.27.147\\resources\\data\\infonet\\gdb\\All_InfoNet_Export.gdb"
gisservergdbfile = "\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export.gdb"
db = WSApplication.open('10.106.2.52:40000/Infonet_PIMS',false)

# Required to tell IExchange to use the desktop licence and not ArcServer licence
WSApplication.use_arcgis_desktop_licence

# Create an array of the networks you want to connect to and a label for them.

read_file = open("\\\\10.0.27.147\\resources\\data\\Auto-Scripting-Infonet-ArcGIS\\network\\distnw.txt","r") #Read all the networks text file specified seperated by commas
lines = read_file.read().split(',')
moc=db.model_object_collection(lines[0]) #first string in networks file which is collection network
moc1=db.model_object_collection(lines[1]) #second string in networks file which is distribution network
networks = {
            'pcc_pw' => db.model_object_from_type_and_id('Distribution Network',4819),
            'pcc_ww' => db.model_object_from_type_and_id('Collection Network',4815),
            'pcc_sw' => db.model_object_from_type_and_id('Collection Network',4709),
            'wcc_pw' => db.model_object_from_type_and_id('Distribution Network',1667),
            'wcc_ww' => db.model_object_from_type_and_id('Collection Network',8),
            'wcc_sw' => db.model_object_from_type_and_id('Collection Network',9),
            'hcc_pw' => db.model_object_from_type_and_id('Distribution Network',4820),
            'hcc_ww' => db.model_object_from_type_and_id('Collection Network',4914),
            'hcc_sw' => db.model_object_from_type_and_id('Collection Network',5061),
            'uhcc_pw' => db.model_object_from_type_and_id('Distribution Network',5024),
            'uhcc_ww' => db.model_object_from_type_and_id('Collection Network',4986),
            'uhcc_sw' => db.model_object_from_type_and_id('Collection Network',4987),
            'gwrc_pw' => db.model_object_from_type_and_id('Distribution Network',5132),
			'swdc_pw' => db.model_object_from_type_and_id('Distribution Network',4595),
            'swdc_ww' => db.model_object_from_type_and_id('Collection Network',4944),
            'swdc_sw' => db.model_object_from_type_and_id('Collection Network',5181),
            }
			
# Creates a list of all the tables in the potable water and drainage networks
# Creates a list of all the tables in the potable water and drainage networks
	drainage_tables = [
					'node',
					'pipe',
					'acousticsurvey',
					'alllinks', #was not active
					'allnodes', #was not active
					#'approvallevel', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'blockageincident',
					'cctvsurvey',
					'channel',
					'collapseincident',
					'connectionnode',
					'connectionpipe',
					#'connectionpipenamegroup', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'crosssectionsurvey',
					'customercomplaint',
					'datalogger',
					'defencearea',
					'defencestructure',
					'draintest',
					'dyetest',
					'flooddefencesurvey',
					'floodingincident',
					'flume',
					'foginspection',
					'generalasset',
					'generalincident',
					'generalline',
					'generalmaintenance',
					'generalsurvey',
					'generalsurveyline',
					'generator',
					'gpssurvey',
					'manholerepair',
					'manholesurvey',
					#'material', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'monitoringsurvey',
					#'nodenamegroup', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'odorincident',
					#'order', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'orifice',
					'outlet',
					'pipeclean', #was not active
					#'pipenamegroup', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'piperepair',
					'pollutionincident',
					'property',
					'pump',
					'pumpstation',
					'pumpstationelectricalmaintenance',
					'pumpstationmechanicalmaintenance',
					'pumpstationsurvey',
					#'resource', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'screen',
					'siphon',
					'sluice',
					'smokedefectobservation',
					'smoketest',
					'storagearea', #was not active
					'treatmentworks',
					'userancillary',
					'valve',
					'vortex',
					'waterqualitysurvey',
					'weir',
					'workpackage',
					'zone',
					]
	potable_tables = [
					'alllinks', #Was not active
					'allnodes', #Was not active
					#'approvallevel', #Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
					'borehole',
					'burstincident',
					'customercomplaint',
					'datalogger',
					'fitting',
					'generalasset',
					'generalincident',
					'generalline',
					'generalmaintenance',
					'generalsurvey',
					'generalsurveyline',
					'generator',
					'gpssurvey',
					'hydrant',
					'hydrantmaintenance',
					'hydranttest',
					'leakdetection',
					'manhole',
					'manholerepair',
					'manholesurvey',
					#'material', #Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
					'meter',
					'metermaintenance',
					'metertest',
					'monitoringsurvey',
					#'nodenamegroup', #Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
					#'order', #Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
					'pipe',
					#'pipenamegroup', #Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
					'piperepair',
					'pipesample',
					'property',
					'pump',
					'pumpstation',
					'pumpstationelectricalmaintenance',
					'pumpstationmechanicalmaintenance',
					'pumpstationsurvey',
					#'resource', #Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
					'surfacesource',
					'tank',
					'treatmentworks',
					'valve',
					'valvemaintenance',
					'valveshutoff',
					'waterqualityincident',
					'waterqualitysurvey',
					'workpackage',
					'zone',
					]

            



networks.each do |key, net|
	puts
	puts "Start InfoNet Export from #{key} masterdata network"

	nw = net
	nw.update

	council = key[0...-3].upcase
  
	if key == 'pcc_pw' || key == 'wcc_pw' || key == 'hcc_pw'  || key == 'uhcc_pw' || key == 'gwrc_pw' || key == 'swdc_pw'
		tables = potable_tables
		cfg = 'PW'
	else
		tables = drainage_tables
		cfg = 'DRN'
	end
	tables.each do |table|

		puts 'council='
		puts council
		puts 'table='
		puts table
	
		gdb_options = {
			'Callback Class' => nil,
			'Image Folder' => '',
			'Units Behaviour' => 'Native',
			'Report Mode' => true,
			'Export Selection' => false,
			'Previous Version' => 0,
			'Error File' => "\\\\10.0.27.147\\resources\\data\\Auto-Scripting-Infonet-ArcGIS\\Errorlogs\\#{key}_#{table}_GDB_Exporterrorlog.txt"
			}


    #This exports all the Councils into CSV. See Export Filename.
##		begin
##			print "Exporting InfoNet table '#{table}' to CSV feature class '#{key}_#{table}' in CSV"
##			nw.odec_export_ex(
##				'CSV',
##				"\\\\10.0.27.147\\resources\\data\\Auto-Scripting-Infonet-ArcGIS\\All Configuration Files\\All_#{cfg}.cfg",
##				gdb_options,
      #1- Table to export from InfoNet. Pulls from list of table names
##				table,
      #6- Export Filename (for personal and file GeoDatabases, connection name for SDE)
##				"\\\\10.0.27.147\\resources\\data\\infonet\\csv\\#{key}_#{table}_dwexport.csv"
##				)  
##		rescue
##			puts
##			puts " - EXPORTED WITH ERRORS, Check Error File"
##			puts
##		else
##			puts
##			print '- Done'
##			puts
##		end


    #This exports all the Councils into a single GDB in FME Server Folder. See Export Filename.
		begin
			print "Exporting InfoNet table '#{table}' to GDB feature class '#{key}_#{table}' in ALL GDB"
			nw.odec_export_ex(
				'GDB',
				"\\\\10.0.27.147\\resources\\data\\Auto-Scripting-Infonet-ArcGIS\\All Configuration Files\\New_GDB_#{cfg}.cfg",
				gdb_options,
      #1- Table to export from InfoNet. Pulls from list of table names
				table,
      #2- Feature class name, currently uses the same value as InfoNet table
				key + '_' + table,
      #3- Feature dataset, currently uses the 'key' in the networks array
				key,
      #4- Update – true to update, false otherwise. If true the feature class must exist.
				false,
      #5- ArcSDE configuration keyword – nil for Personal / File GeoDatabases, and ignored for updates
				nil,
      #6- Export Filename (for personal and file GeoDatabases, connection name for SDE)
				fmeservergdbfile
##				'\\\\10.0.27.147\\resources\\data\\infonet\\gdb\\All_InfoNet_Export.gdb'

				)  

		rescue
			puts
			puts " - EXPORTED WITH ERRORS, Check Error File"
			puts
		else
			puts
			print '- Done'
			puts
		end


    #This exports all the Councils into a single GDB in GIS Server. See Export Filename.
##		begin
##			print "Exporting InfoNet table '#{table}' to GDB feature class '#{key}_#{table}' in GIS Server"
##			nw.odec_export_ex(
##				'GDB',
##				"\\\\10.0.27.147\\resources\\data\\Auto-Scripting-Infonet-ArcGIS\\All Configuration Files\\All_#{cfg}.cfg",
##				gdb_options,
####				nil,
      #1- Table to export from InfoNet. Pulls from list of table names
##				table,
      #2- Feature class name, currently uses the same value as InfoNet table
##				key + '_' + table,
      #3- Feature dataset, currently uses the 'key' in the networks array
##				key,
      #4- Update – true to update, false otherwise. If true the feature class must exist.
##				false,
      #5- ArcSDE configuration keyword – nil for Personal / File GeoDatabases, and ignored for updates
##				nil,
      #6- Export Filename (for personal and file GeoDatabases, connection name for SDE)
##      '\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export.gdb'
##				)  

##		rescue
##			puts
##			puts " - EXPORTED WITH ERRORS, Check Error File"
##			puts
##		else
##			puts
##			print '- Done'
##			puts
##		end



    puts
	end
end

