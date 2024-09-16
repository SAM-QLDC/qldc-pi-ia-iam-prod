db = WSApplication.open('10.249.30.6:40000/Infonet_PIMS',false)

# Required to tell IExchange to use the desktop licence and not ArcServer licence
WSApplication.use_arcgis_desktop_licence

# Create an array of the networks you want to connect to and a label for them.
read_file = open("G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\network\\distnw.txt","r") #Read all the networks text file specified seperated by commas
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
            'hcc_sw' => db.model_object_from_type_and_id('Collection Network',4902),
            'uhcc_pw' => db.model_object_from_type_and_id('Distribution Network',5024),
            'uhcc_ww' => db.model_object_from_type_and_id('Collection Network',4986),
            'uhcc_sw' => db.model_object_from_type_and_id('Collection Network',4987),
            'gwrc_pw' => db.model_object_from_type_and_id('Distribution Network',5132),
            'swdc_ww' => db.model_object_from_type_and_id('Collection Network',4944),
            'swdc_pw' => db.model_object_from_type_and_id('Distribution Network',4595),
            }
            
            
# Creates a list of all the tables in the potable water and drainage networks
drainage_tables = [
                  'node',
                  'pipe',
                  'connectionnode',
                  'outlet',
                  'connectionpipe',
                  'pumpstation',
                  'generator',
                  'pump',
                  'weir',
                  'screen',
                  'valve',
                  'orifice',
                  'sluice',
                  'flume',
                  'siphon',
                  'vortex',
                  'userancillary',
                  'generalasset',
                  'datalogger',
                  'channel',
                  'defencearea',
                  'defencestructure',
                  'treatmentworks',
                  'acousticsurvey',
                  'blockageincident',
                  'cctvsurvey',
                  'collapseincident',
                  'crosssectionsurvey',
                  'customercomplaint',
                  'draintest',
                  'dyetest',
                  'flooddefencesurvey',
                  'floodingincident',
                  'foginspection',
                  'generalincident',
                  'generalline',
                  'generalmaintenance',
                  'generalsurvey',
                  'generalsurveyline',
                  'gpssurvey',
                  'manholerepair',
                  'manholesurvey',
                  'monitoringsurvey',
                  'odorincident',
                  'piperepair',
                  'pollutionincident',
                  'property',
                  'pumpstationelectricalmaintenance',
                  'pumpstationmechanicalmaintenance',
                  'pumpstationsurvey',
                  'smokedefectobservation',
                  'smoketest',
                  'waterqualitysurvey',
                  'workpackage',
                  'zone',
                  #'approvallevel', 
                  #'connectionpipenamegroup', 
                  #'material', 
                  #'nodenamegroup', 
                  #'pipenamegroup', 
                  #'order', 
                  #'pipeclean',
                  #'resource', 
                  ]
	potable_tables = [
                  'fitting',
                  'pipe',
                  'meter',
                  'valve',
                  'pump',
                  'tank',
                  'hydrant',
                  'borehole',
                  'surfacesource',
                  'pumpstation',
                  'treatmentworks',
                  'generator',
                  'manhole',
                  'datalogger',
                  'generalasset',
                  'burstincident',
                  'customercomplaint',
                  'generalincident',
                  'generalline',
                  'generalmaintenance',
                  'generalsurvey',
                  'generalsurveyline',
                  'gpssurvey',
                  'hydrantmaintenance',
                  'hydranttest',
                  'leakdetection',
                  'manholerepair', # unrecognized field names manhole.id, etc... APH deleted the offending fields from the configuration file and export now works. Removal of fields is OK since it is just a duplication of the data from the manhole table.
                  'manholesurvey', # unrecognized field names manhole.id, etc... APH deleted the offending fields from the configuration file and export now works. Removal of fields is OK since it is just a duplication of the data from the manhole table.
                  'metermaintenance', # unrecognized field names meter.node_id, etc... APH deleted the offending fields from the configuration file and export now works. Removal of fields is OK since it is just a duplication of the data from the meter table.
                  'metertest', # unrecognized field names meter.node_id, etc... APH deleted the offending fields from the configuration file and export now works. Removal of fields is OK since it is just a duplication of the data from the meter table.
                  'monitoringsurvey',
                  'piperepair',
                  'pipesample',
                  'property',
                  'pumpstationelectricalmaintenance',
                  'pumpstationmechanicalmaintenance',
                  'pumpstationsurvey',
                  'valvemaintenance',
                  'valveshutoff',
                  'waterqualityincident',
                  'waterqualitysurvey',
                  'workpackage',
                  'zone',
                  # 'approvallevel', Map Data Importer Error (No spatial reference exists. Source = Esri GeoDatabase. HRESULT = -2147467259.)
                  # 'material',  Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
                  # 'nodenamegroup',  Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
                  # 'order',  Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
                  # 'pipenamegroup',  Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
                  # 'resource', Map Data Importer Error (The specified product or version does not exist on this machine. Source = ArcGISVersion.Version. HRESULT = -2147467259.)
                  ]
	
 
  networks.each do |key, net|
  puts
  puts "Start InfoNet Export from #{key} masterdata network"
  puts

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

    gdb_options = {
    'Callback Class' => nil,
    'Image Folder' => '',
    'Units Behaviour' => 'Native',
    'Report Mode' => true,
    'Export Selection' => false,
    'Previous Version' => 0,
    'Error File' => "G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Errorlogs\\#{council}_#{key}_#{table}_Exporterrorlog.txt"
    }

    #This exports all the Councils into a single GDB. See Export Filename.
   begin
    print "Exporting InfoNet table '#{table}' to GDB feature class '#{key}_#{table}' in ALL GDB"
    nw.odec_export_ex(
      'GDB',
      "G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\All Configuration Files\\All_#{cfg}.cfg",
      gdb_options,
      # Table to export from InfoNet. Pulls from list of table names
      table,
      # Feature class name, currently uses the same value as InfoNet table
      key + '_' + table,
      # Feature dataset, currently uses the 'key' in the networks array
      key,
      #4- Update – true to update, false otherwise. If true the feature class must exist.
      false,
      #5- ArcSDE configuration keyword – nil for Personal / File GeoDatabases, and ignored for updates
      nil,
      #6- Export Filename (for personal and file GeoDatabases, connection name for SDE)
      '\\\gisfs01p.prod.arcgis.wellingtonwater.cloud\\Content\\Staging\\All_InfoNet_Export1.gdb'#'G:\\Information Directorate\\InfoNet Scripting\\InfoNet Exports for GIS FME Transform\\Auto-Scripting-Infonet-ArcGIS\\Output\\All_InfoNet_Export.gdb'
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
    puts
	end
    end



### Uncomment this to skip over errors    
   #rescue
  #   puts
 #     puts " - error"
#      puts
    #w
     # puts
    #  print '- Done'
   #   puts
  #  end
 #  puts
#  end  

#end