# water supply_odic.rb
# ==============================================================

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia'

## user interface
net=WSApplication.current_network

# Define a useful class
class ImportTable
	attr_accessor :tbl_format, :in_table, :cfg_file, :csv_file, :cb_class

	def initialize(tbl_format, in_table, cfg_file, csv_file, cb_class)
		@tbl_format = tbl_format
		@in_table = in_table
		@cfg_file = cfg_file
		@csv_file = csv_file
		@cb_class = cb_class
	end
end
puts 'class defined to help with the import parameters for each table'

## Attribute Conversion from InfoAsset CSV Files into InfoWorks ICM
# Callback Classes

class ImporterClassValve
	def ImporterClassValve.onEndRecordValve(obj)

		# load fields
		inValveID = obj['COMPKEY']
		inValveType = obj['ASSETTYPE']
		inValveDesc = obj['DESCR']
		inValveServ = obj['SERVSTAT']
		inValveOwn = obj['OWN']
		inValveLevel = obj['ZCOORD']
		inValveInvert = obj['INVERTELEV']
		inValveValveStatus = obj['VALVESTAT']
		inValveZ = obj['VALVESZ']
		inValveSerial = obj['SERNO']
		inValveModel = obj['MODELNO']
		inValveManufacturer = obj['MANUFCT']
		inValveInstallDate = obj['INSTDATE']
		inValveAsBuilt = obj['ASBUILT']
		inValveScheme = obj['SCHEME']
		inValveDateScr = obj['DATA_SRC']
		inValveComments = obj['COMMENTS']
		inValveDatetimeAdd = obj['ADDDTTM']
		inValveDatetimeMod = obj['MODDTTM']
		inValveConfidence = obj['CONFIDENCE']
		inValveCriticality = obj['CRITICALITY']
		inValveAllocate = obj['ALLOCATE']
		inValveDatetimeCreated = obj['created_date']
		inValveDatetimeEdited = obj['last_edited_date']
		
		# import fields
		## owner field
		if inValveOwn != nil
			iamValveOwn = inValveOwn
			iamValveOwnFlag = '#A'
		else
			iamValveOwn = 'QLDC'
			iamValveOwnFlag = 'XX'	
		end
		obj['owner'] = iamValveOwn
		obj['owner_flag'] = iamValveOwnFlag
		
		## area code
		if inValveScheme != nil
			iamValveScheme = inValveScheme
			iamValveSchemeFlag = '#A'
		else
			iamValveScheme = ''
			iamValveSchemeFlag = 'XX'
		end
		obj['area_code'] = iamValveScheme
		obj['area_code_flag'] = iamValveSchemeFlag

		## operational_status
		if inValveServ != nil
			iamValveServ = inValveServ 
			iamValveServFlag = '#A'
		else
			iamValveServ = ''
			iamValveServFlag = 'XX'
		end
		obj['operational_status'] = iamValveServ
		obj['operational_status_flag'] = iamValveServFlag
		
		## date_installed
		if inValveInstallDate != nil
			iamValveInstallDate = inValveInstallDate
			iamValveInstallDateFlag = '#A'
		else
			iamValveInstallDate = ''
			iamValveInstallDateFlag = 'XX'
		end
		obj['date_installed'] = iamValveInstallDate
		obj['date_installed_flag'] = iamValveInstallDateFlag
		
	end
end

class ImporterClassHydrant
	def ImporterClassHydrant.onEndRecordHydrant(obj)	

		# load fields
		inHydrantID = obj['COMPKEY']
		inHydrantType = obj['ASSETTYPE']
		inHydrantDesc = obj['DESCR']
		inHydrantServ = obj['SERVSTAT']
		inHydrantOwn = obj['OWN']
		inHydrantLevel = obj['ZCOORD']
		inHydrantInvert = obj['INVERTELEV']
		inHydrantModel = obj['MODELNO']
		inHydrantManufacturer = obj['MANUFCT']
		inHydrantInstallDate = obj['INSTDATE']
		inHydrantAsBuilt = obj['ASBUILT']
		inHydrantScheme = obj['SCHEME']
		inHydrantDataScr = obj['DATA_SRC']
		inHydrantComments = obj['COMMENTS']
		inHydrantDatetimeAdd = obj['ADDDTTM']
		inHydrantDatetimeMod = obj['MODDTTM']
		inHydrantConfidence = obj['CONFIDENCE']
		inHydrantCriticality = obj['CRITICALITY']
		inHydrantAllocate = obj['ALLOCATE']
		inHydrantDatetimeCreated = obj['created_date']
		inHydrantDatetimeEdited = obj['last_edited_date']
		
		# import fields
		## owner field
		if inHydrantOwn != nil
			iamHydrantOwn = inHydrantOwn
			iamHydrantOwnFlag = '#A'
		else
			iamHydrantOwn = 'QLDC'
			iamHydrantOwnFlag = 'XX'	
		end
		obj['owner'] = iamHydrantOwn
		obj['owner_flag'] = iamHydrantOwnFlag
		
		## area code
		if inHydrantScheme != nil
			iamHydrantScheme = inHydrantScheme
			iamHydrantSchemeFlag = '#A'
		else
			iamHydrantScheme = ''
			iamHydrantSchemeFlag = 'XX'
		end
		obj['area_code'] = iamHydrantScheme
		obj['area_code_flag'] = iamHydrantSchemeFlag
		
		## operational_status
		if inHydrantServ != nil
			iamHydrantServ = inHydrantServ 
			iamHydrantServFlag = '#A'
		else
			iamHydrantServ = ''
			iamHydrantServFlag = 'XX'
		end
		obj['operational_status'] = iamHydrantServ
		obj['operational_status_flag'] = iamHydrantServFlag
		
		## date_installed
		if inHydrantInstallDate != nil
			iamHydrantInstallDate = inHydrantInstallDate
			iamHydrantInstallDateFlag = '#A'
		else
			iamHydrantInstallDate = ''
			iamHydrantInstallDateFlag = 'XX'
		end
		obj['date_installed'] = iamHydrantInstallDate
		obj['date_installed_flag'] = iamHydrantInstallDateFlag

	end
end

class ImporterClassMeter
	def ImporterClassMeter.onEndRecordMeter(obj)	

		# load fields
		inMeterID = obj['COMPKEY']
		inMeterType = obj['ASSETTYPE']
		inMeterDesc = obj['DESCR']
		inMeterServ = obj['SERVSTAT']
		inMeterOwn = obj['OWN']
		inMeterLevel = obj['ZCOORD']
		inMeterInvert = obj['INVERTELEV']
		inMeterZ = obj['METERSZ']
		inMeterSerial = obj['SERNO']
		inMeterModel = obj['MODELNO']
		inMeterManufacturer = obj['MANUFCT']
		inMeterInstallDate = obj['INSTDATE']
		inMeterAsBuilt = obj['ASBUILT']
		inMeterScheme = obj['SCHEME']
		inMeterFDataScr = obj['DATA_SRC']
		inMeterComments = obj['COMMENTS']
		inMeterDatetimeAdd = obj['ADDDTTM']
		inMeterDatetimeMod = obj['MODDTTM']
		inMeterConfidence = obj['CONFIDENCE']
		inMeterCriticality = obj['CRITICALITY']
		inMeterAllocate = obj['ALLOCATE']
		inMeterDatetimeCreated = obj['created_date']
		inMeterDatetimeEdited = obj['last_edited_date']
		
		# import fields
		## owner field
		if inMeterOwn != nil
			iamMeterOwn = inMeterOwn
			iamMeterOwnFlag = '#A'
		else
			iamMeterOwn = 'QLDC'
			iamMeterOwnFlag = 'XX'	
		end
		obj['owner'] = iamMeterOwn
		obj['owner_flag'] = iamMeterOwnFlag
		
		## area code
		if inMeterScheme != nil
			iamMeterScheme = inMeterScheme
			iamMeterSchemeFlag = '#A'
		else
			iamMeterScheme = ''
			iamMeterSchemeFlag = 'XX'
		end
		obj['area_code'] = iamMeterScheme
		obj['area_code_flag'] = iamMeterSchemeFlag
		
		## operational_status
		if inMeterServ != nil
			iamMeterServ = inMeterServ 
			iamMeterServFlag = '#A'
		else
			iamMeterServ = ''
			iamMeterServFlag = 'XX'
		end
		obj['operational_status'] = iamMeterServ
		obj['operational_status_flag'] = iamMeterServFlag
		
		## date_installed
		if inMeterInstallDate != nil
			iamMeterInstallDate = inMeterInstallDate
			iamMeterInstallDateFlag = '#A'
		else
			iamMeterInstallDate = ''
			iamMeterInstallDateFlag = 'XX'
		end
		obj['date_installed'] = iamMeterInstallDate
		obj['date_installed_flag'] = iamMeterInstallDateFlag

	end
end

class ImporterClassFitting
	def ImporterClassFitting.onEndRecordFitting(obj)	

		# load fields
		inFittingID = obj['COMPKEY']
		inFittingType = obj['ASSETTYPE']
		inFittingDesc = obj['DESCR']
		inFittingServ = obj['SERVSTAT']
		inFittingOwn = obj['OWN']
		inFittingLevel = obj['ZCOORD']
		inFittingInvert = obj['INVERTELEV']
		inFittingInstallDate = obj['INSTDATE']
		inFittingAsBuillt = obj['ASBUILT']
		inFittingScheme = obj['SCHEME']
		inFittingDataScr = obj['DATA_SRC']
		inFittingComments = obj['COMMENTS']
		inFittingDatetimeAdd = obj['ADDDTTM']
		inFittingDatetimeMod = obj['MODDTTM']
		inFittingConfidence = obj['CONFIDENCE']
		inFittingCritcality = obj['CRITICALITY']
		inFittingAllocate = obj['ALLOCATE']
		inFittingDatetimeCreated = obj['created_date']
		inFittingDatetimeEdited = obj['last_edited_date']	

		# import fields
		## owner field
		if inFittingOwn != nil
			iamFittingOwn = inFittingOwn
			iamFittingOwnFlag = '#A'
		else
			iamFittingOwn = 'QLDC'
			iamFittingOwnFlag = 'XX'	
		end
		obj['owner'] = iamFittingOwn
		obj['owner_flag'] = iamFittingOwnFlag
		
		## area code
		if inFittingScheme != nil
			iamFittingScheme = inFittingScheme
			iamFittingSchemeFlag = '#A'
		else
			iamFittingScheme = ''
			iamFittingSchemeFlag = 'XX'
		end
		obj['area_code'] = iamFittingScheme
		obj['area_code_flag'] = iamFittingSchemeFlag
		
		## operational_status
		if inFittingServ != nil
			iamFittingServ = inFittingServ 
			iamFittingServFlag = '#A'
		else
			iamFittingServ = ''
			iamFittingServFlag = 'XX'
		end
		obj['operational_status'] = iamFittingServ
		obj['operational_status_flag'] = iamFittingServFlag
		
		## date_installed
		if inFittingInstallDate != nil
			iamFittingInstallDate = inFittingInstallDate
			iamFittingInstallDateFlag = '#A'
		else
			iamFittingInstallDate = ''
			iamFittingInstallDateFlag = 'XX'
		end
		obj['date_installed'] = iamFittingInstallDate
		obj['date_installed_flag'] = iamFittingInstallDateFlag

	end
end

class ImporterClassPipe
	def ImporterClassPipe.onEndRecordPipe(obj)	

		# load fields
		inPipeID = obj['COMPKEY']
		inPipeType = obj['ASSETTYPE']
		inPipeDesc = obj['DESCR']
		inPipeServ = obj['SERVSTAT']
		inPipeOwn = obj['OWN']
		inPipeMaterial = obj['PIPEMATL']
		inPipeLength = obj['PIPELEN']
		inPipeDiameterNominal = obj['NOMDIAM']
		inPipeDiameterInternal = obj['INTDIAM']
		inPipeDiameterOutside = obj['OUTDIAM']
		inPipeDepth = obj['DPTH']
		inPipeUSnode = obj['UPNODE']
		inPipeDSnode = obj['DWNNODE']
		inPipeClass = obj['CLASS']
		inPipeJunctionType = obj['JTTYPE']
		inPipeManufacturer = obj['MANUFCT']
		inPipeInstallMethod = obj['INSTMTHD']
		inPipeLiningMaterial = obj['LINEMATL']
		inPipeLiningMethod = obj['LINEMTHD']
		inPipeLiningDate = obj['LINEDATE']
		inPipeInstallDate = obj['INSTDATE']
		inPipeAsBuilt = obj['ASBUILT']
		inPipeScheme = obj['SCHEME']
		inPipeDataScr = obj['DATA_SRC']
		inPipeComments = obj['COMMENTS']
		inPipeDatetimeAdd = obj['ADDDTTM']
		inPipeDatetimeMod = obj['MODDTTM']
		inPipeConfidence = obj['CONFIDENCE']
		inPipeCriticality = obj['CRITICALITY']
		inPipeAllocate = obj['ALLOCATE']
		inPipeDatetimeCreated = obj['created_date']
		inPipeDatetimeEdited = obj['last_edited_date']
		inPipeServiceType = obj['SRVTYPE']
		inPipeXstart = obj['x_start']
		inPipeYstart = obj['y_start']
		inPipeXend = obj['x_end']
		inPipeYend = obj['y_end']
	
		# import fields
		## owner field
		if inPipeOwn != nil
			iamPipeOwn = inPipeOwn
			iamPipeOwnFlag = '#A'
		else
			iamPipeOwn = 'QLDC'
			iamPipeOwnFlag = 'XX'	
		end
		obj['owner'] = iamPipeOwn
		obj['owner_flag'] = iamPipeOwnFlag
		
		## area code
		if inPipeScheme != nil
			iamPipeScheme = inPipeScheme
			iamPipeSchemeFlag = '#A'
		else
			iamPipeScheme = ''
			iamPipeSchemeFlag = 'XX'
		end
		obj['area_code'] = iamPipeScheme
		obj['area_code_flag'] = iamPipeSchemeFlag
		
		## operational_status
		if inPipeServ != nil
			iamPipeServ = inPipeServ 
			iamPipeServFlag = '#A'
		else
			iamPipeServ = ''
			iamPipeServFlag = 'XX'
		end
		obj['operational_status'] = iamPipeServ
		obj['operational_status_flag'] = iamPipeServFlag
		
		## date_installed
		if inPipeInstallDate != nil
			iamPipeInstallDate = inPipeInstallDate
			iamPipeInstallDateFlag = '#A'
		else
			iamPipeInstallDate = ''
			iamPipeInstallDateFlag = 'XX'
		end
		obj['date_installed'] = iamPipeInstallDate
		obj['date_installed_flag'] = iamPipeInstallDateFlag

	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('csv', 'valve', 
	folder + '\water supply_config.cfg', folder + '\exports\wsValve.csv', 
	ImporterClassValve)
	
import_tables.push ImportTable.new('csv', 'hydrant', 
	folder + '\water supply_config.cfg', folder + '\exports\wsHydrant.csv', 
	ImporterClassHydrant)
	
import_tables.push ImportTable.new('csv', 'meter', 
	folder + '\water supply_config.cfg', folder + '\exports\wsMeter.csv', 
	ImporterClassMeter)	
	
import_tables.push ImportTable.new('csv', 'fitting', 
	folder + '\water supply_config.cfg', folder + '\exports\wsNode.csv', 
	ImporterClassFitting)	
	
import_tables.push ImportTable.new('csv', 'pipe', 
	folder + '\water supply_config.cfg', folder + '\exports\wsPipes.csv', 
	ImporterClassPipe)
	
puts 'Import tables and config file setup'

# Set up params
node_options=Hash.new
node_options['Use Display Precision'] = false
node_options['Update Based On Asset ID'] = true
node_options['Flag Fields '] = false
node_options['Multiple Files'] = true
node_options['Selection Only'] = false
node_options['Coordinate Arrays Format'] = 'Packed'
node_options['Other Arrays Format'] = 'Separate'
node_options['WGS84'] = false
node_options['Duplication Behaviour'] = 'Merge'
node_options['Delete Missing Objects'] = true
node_options['Update Links From Points'] = false
node_options['Default Value Flag'] = '#S'
node_options['Set Value Flag'] = '#A'

puts 'specific import options defined'

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	node_options['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		node_options,			# specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import'