##DRK (June 2021) script to export InfoWorks ICM Data into shape files.
require 'FileUtils'
db = WSApplication.current_database
net=WSApplication.current_network
my_object = net.model_object
#Determine Network Name
n_id = my_object.id
n_type = my_object.type
network_object = db.model_object_from_type_and_id n_type, n_id

#Select Config File
configfile=WSApplication.file_dialog(true,'cfg','Open Data Export Centre Config File',nil,false,false)
if configfile.nil?
	WSApplication.message_box 'No config file selected - no import will be performed',nil,nil,false
else
# Select Export Folder
	ExportFolder = WSApplication.folder_dialog('TUFLOW Files Save Location', true)
	puts 'Files exported to ' + ExportFolder

options=Hash.new

#Exports ICM Tables
	export=[['Node','Node'],['Conduit','Conduit'], ['Subcatchment','Subcatchment'], #Pipes/Manholes/Subcatchments
	['Bridge','Bridge'],['Channel','Channels'],['Culvertinlet','Culvert_Inlet'], ['Culvertoutlet','Culvert_Outlet'], #structures 
	['Flapvalve','Flap_Valves'], ['Flume','Flumes'],['Inlinebank','Inline_bank'],['Irregularweir','Irregular_weir'], #structures
	['Orifice','Orifices'], ['Pump','Pumps'],['Screen','Screens'], ['Siphon','Siphon'], ['Sluice','Sluices'], #structures 
	['Usercontrol','User_Control'], ['Weir','Weirs'], #Structures 
	['Riverreach','River_Reaches'], #River_Reaches
	['2Dzone','2d_Zone'], ['2Dpointsource','2Dpointsource'], ['2Dboundary','2dboundary'], ['2Dlinesource','2Dlinesource'],  #2D 
	['ICzone-hydraulics(2D)','ICzone-hydraulics(2D)'], ['Roughnesszone','Roughnesszone'], ['Infiltrationzone(2d)','Infiltrationzone(2d)'], ['Networkresultsline(2d)','Networkresultsline(2d)'],['Networkresultspoint(2d)','Networkresultspoint(2d)'], #2D 
	['Meshlevelzone', 'Meshlevelzone'], ['Meshzone', 'Meshzone'], ['Porouswall', 'Porouswall'], ['Baselinearstructure(2D)', 'Baselinearstructure(2D)'], ['Sluicelinearstructure(2D)', 'Sluicelinearstructure(2D)'], 
	['Bridgelinearstructure(2D)', 'Bridgelinearstructure(2D)']
	] #2D 
	errFiles=Array.new
	export.each do |f|
	errFile=ExportFolder+'\\'+f[0]+'_Errors.txt' #Create Error text Files for Each table and 
	options['Error File']=errFile
	net.odec_export_ex('SHP',configfile,options,f[0],ExportFolder+'\\'+f[1]+'_'+network_object.name+'_ICM.SHP')
		if File.exist?(errFile) #If Error.text file exist add to list to report in dialog.
			if File.size(errFile)>0
				errFiles << errFile
			else
				FileUtils.rm errFile
			end
		end
	end
	#Message box to highlight error files
	if errFiles.size>0
		msg="Errors occurred - please consult the following files:"
		errFiles.each do |f|
		msg+="\r\n"
		msg+=f
	end
	WSApplication.message_box msg,nil,nil,nil
	end
	
	#Export RTC to a text file.
	File.open(ExportFolder+'\\'+network_object.name+'_ICM_RTC.txt', 'w') do |fo|
	ro=net.row_object('hw_rtc',nil)    
		s=ro['rtc_data']
	fo.puts s
	end
end