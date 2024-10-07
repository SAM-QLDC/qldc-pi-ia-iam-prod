# water supply_odic.rb
# ==============================================================

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod'
data = '\fme\exports\water supply'

# Run batch file
#system(folder + '/water supply_agol.bat')

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
		inValveZ = obj['VALVESZ'].to_i
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
		
		## elevation
		if inValveLevel != nil
			iamValveLevel = inValveLevel
			iamValveLevelFlag = '#A'
		else
			iamValveLevel = ''
			iamValveLevelFlag = 'XX'
		end
		obj['elevation'] = iamValveLevel
		obj['elevation_flag'] = iamValveLevelFlag
		
		## manufacturer
		if inValveManufacturer != nil
			iamValveManufacturer = inValveManufacturer
			iamValveManufacturerFlag = '#A'
		else
			iamValveManufacturer = ''
			iamValveManufacturerFlag = 'XX'
		end
		obj['manufacturer'] = iamValveManufacturer
		obj['manufacturer_flag'] = iamValveManufacturerFlag
		
		## status
		if inValveValveStatus != nil
			iamValveValveStatus = inValveValveStatus.capitalize
			iamValveValveStatusFlag = '#A'
		else
			iamValveValveStatus = 'Unknown'
			iamValveValveStatusFlag = 'XX'
		end
		obj['status'] = iamValveValveStatus
		obj['status_flag'] = iamValveValveStatusFlag

		## diameter
		if inValveZ > 0
			iamValveZ = inValveZ
			iamValveZFlag = '#A'
		else
			iamValveZ = ''
			iamValveZFlag = 'XX'
		end
		obj['diameter'] = iamValveZ
		obj['diameter_flag'] = iamValveZFlag
		obj['criticality'] = inValveCriticality
		
		obj['user_date_1'] = inValveDatetimeAdd
		obj['user_date_2'] = inValveDatetimeMod
		#obj['user_date_3'] = inValveDatetimeCreated
		#obj['user_date_4'] = inValveDatetimeEdited
		
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
		
		## elevation
		if inHydrantLevel != nil
			iamHydrantLevel = inHydrantLevel
			iamHydrantLevelFlag = '#A'
		else
			iamHydrantLevel = ''
			iamHydrantLevelFlag = 'XX'
		end
		obj['elevation'] = iamHydrantLevel
		obj['elevation_flag'] = iamHydrantLevelFlag
		
		## manufacturer
		if inHydrantManufacturer != nil
			iamHydrantManufacturer = inHydrantManufacturer
			iamHydrantManufacturerFlag = '#A'
		else
			iamHydrantManufacturer = ''
			iamHydrantManufacturerFlag = 'XX'
		end
		obj['manufacturer'] = iamHydrantManufacturer
		obj['manufacturer_flag'] = iamHydrantManufacturerFlag
		obj['criticality'] = inHydrantCriticality	
		
		obj['user_date_1'] = inHydrantDatetimeAdd
		obj['user_date_2'] = inHydrantDatetimeMod
		#obj['user_date_3'] = inHydrantDatetimeCreated
		#obj['user_date_4'] = inHydrantDatetimeEdited

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
		inMeterZ = obj['METERSZ'].to_i
		inMeterSerial = obj['SERNO']
		inMeterModel = obj['MODELNO']
		inMeterManufacturer = obj['MANUFCT']
		inMeterInstallDate = obj['INSTDATE']
		inMeterAsBuilt = obj['ASBUILT']
		inMeterScheme = obj['SCHEME']
		inMeterDataScr = obj['DATA_SRC']
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
		
		## elevation
		if inMeterLevel != nil
			iamMeterLevel = inMeterLevel
			iamMeterLevelFlag = '#A'
		else
			iamMeterLevel = ''
			iamMeterLevelFlag = 'XX'
		end
		obj['elevation'] = iamMeterLevel
		obj['elevation_flag'] = iamMeterLevelFlag
		
		## manufacturer
		if inMeterManufacturer != nil
			iamMeterManufacturer = inMeterManufacturer
			iamMeterManufacturerFlag = '#A'
		else
			iamMeterManufacturer = ''
			iamMeterManufacturerFlag = 'XX'
		end
	
		obj['manufacturer'] = iamMeterManufacturer
		obj['manufacturer_flag'] = iamMeterManufacturerFlag
		
		## diameter
		if inMeterZ > 0
			iamMeterZ = inMeterZ
			iamMeterZFlag = '#A'
		else
			iamMeterZ = ''
			iamMeterZFlag = 'XX'
		end
		obj['diameter'] = iamMeterZ
		obj['diameter_flag'] = iamMeterZFlag
		
		## serial_number
		if inMeterSerial != nil
			iamMeterSerial = inMeterSerial
			iamMeterSerialFlag = '#A'
		else
			iamMeterSerial = ''
			iamMeterSerialFlag = 'XX'
		end
		obj['serial_number'] = iamMeterSerial
		obj['serial_number_flag'] = iamMeterSerialFlag
		obj['criticality'] = inMeterCriticality	
		
		obj['user_date_1'] = inMeterDatetimeAdd
		obj['user_date_2'] = inMeterDatetimeMod
		#obj['user_date_3'] = inMeterDatetimeCreated
		#obj['user_date_4'] = inMeterDatetimeEdited

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
		
		## elevation
		if inFittingLevel != nil
			iamFittingLevel = inFittingLevel
			iamFittingLevelFlag = '#A'
		else
			iamFittingLevel = ''
			iamFittingLevelFlag = 'XX'
		end
		obj['elevation'] = iamFittingLevel
		obj['elevation_flag'] = iamFittingLevelFlag
		obj['criticality'] = inFittingCritcality
		
		obj['user_date_1'] = inFittingDatetimeAdd
		obj['user_date_2'] = inFittingDatetimeMod
		#obj['user_date_3'] = inFittingDatetimeCreated
		#obj['user_date_4'] = inFittingDatetimeEdited

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
		inPipeDiameterNominal = obj['NOMDIAM'].to_i
		inPipeDiameterInternal = obj['INTDIAM'].to_i
		inPipeDiameterExternal = obj['OUTDIAM'].to_i
		inPipeDepth = obj['DPTH'].to_f
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
		inPipeXstart = obj['x_start'].to_f
		inPipeYstart = obj['y_start'].to_f
		inPipeXend = obj['x_end'].to_f
		inPipeYend = obj['y_end'].to_f
	
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
		
		## material
		if inPipeMaterial != nil
			iamPipeMaterial = inPipeMaterial
			iamPipeMaterialFlag = '#A'
		else
			iamPipeMaterial = ''
			iamPipeMaterialFlag = 'XX'
		end
		obj['material'] = iamPipeMaterial
		obj['material_flag'] = iamPipeMaterialFlag
		
		# internal_diameter
		if inPipeDiameterInternal > 0
			iamPipeDiameterInternal = inPipeDiameterInternal
			iamPipeDiameterInternalFlag = '#A'
		else
			iamPipeDiameterInternal = ''
			iamPipeDiameterInternalFlag = 'XX'
		end
		obj['internal_diameter'] = iamPipeDiameterInternal
		obj['internal_diameter_flag'] = iamPipeDiameterInternalFlag
		
		# external_diameter
		if inPipeDiameterExternal > 0
			iamPipeDiameterExternal = inPipeDiameterExternal
			iamPipeDiameterExternalFlag = '#A'
		else
			iamPipeDiameterExternal = ''
			iamPipeDiameterExternalFlag = 'XX'
		end
		obj['external_diameter'] = iamPipeDiameterExternal
		obj['external_diameter_flag'] = iamPipeDiameterExternalFlag
		
		# nominal_diameter
		if inPipeDiameterNominal > 0
			iamPipeDiameterNominal = inPipeDiameterNominal
			iamPipeDiameterNominalFlag = '#A'
		else
			iamPipeDiameterNominal = ''
			iamPipeDiameterNominalFlag = 'XX'
		end
		obj['nominal_diameter'] = iamPipeDiameterNominal
		obj['nominal_diameter_flag'] = iamPipeDiameterNominalFlag
		
		## depth_of_cover = inPipeDepth
		if inPipeDepth > 0
			iamPipeDepth = inPipeDepth
			iamPipeDepthFlag = '#A'
		else
			iamPipeDepth = ''
			iamPipeDepthFlag = 'XX'
		end
		obj['depth_of_cover'] = iamPipeDepth
		obj['depth_of_cover_flag'] = iamPipeDepthFlag
		
		## date_lined = inPipeLiningDate
		if inPipeLiningDate  != nil
			iamPipeLiningDate = inPipeLiningDate
			iamPipeLiningDateFlag = '#A'
		else
			iamPipeLiningDate = ''
			iamPipeLiningDateFlag = 'XX'
		end
		obj['date_lined'] = iamPipeLiningDate
		obj['date_lined_flag'] = iamPipeLiningDateFlag
		
		## lining_type = inPipeLiningMethod
		if inPipeLiningMethod != nil
			iamPipeLiningMethod = inPipeLiningMethod
			iamPipeLiningMethodFlag = '#A'
		else
			iamPipeLiningMethod = ''
			iamPipeLiningMethodFlag = 'XX'
		end
		obj['lining_type'] = iamPipeLiningMethod
		obj['lining_type_flag'] = iamPipeLiningMethodFlag
		
		## construction_method = inPipeInstallMethod
		if inPipeInstallMethod != nil
			iamPipeInstallMethod = inPipeInstallMethod
			iamPipeInstallMethodFlag = '#A'
		else
			iamPipeInstallMethod = ''
			iamPipeInstallMethodFlag = 'XX'
		end
		obj['construction_method'] = iamPipeInstallMethod
		obj['construction_method_flag'] = iamPipeInstallMethodFlag

		## lining_material = inPipeLiningMaterial
		if inPipeLiningMaterial != nil
			iamPipeLiningMaterial = inPipeLiningMaterial
			iamPipeLiningMaterialFlag = '#A'
		else
			iamPipeLiningMaterial = ''
			iamPipeLiningMaterialFlag = 'XX'
		end
		obj['lining_material'] = iamPipeLiningMaterial
		obj['lining_material_flag'] = iamPipeLiningMaterialFlag
		
		## class = inPipeClass
		if inPipeClass != nil
			iamPipeClass = inPipeClass
			iamPipeClassFlag = '#A'
		else
			iamPipeClass = ''
			iamPipeClassFlag = 'XX'
		end
		obj['pipe_class'] = iamPipeClass
		obj['pipe_class_flag'] = iamPipeClassFlag
		
		## type = inPipeType
		if inPipeType != nil
			iamPipeType = inPipeType
			iamPipeTypeFlag = '#A'
		else
			iamPipeType = ''
			iamPipeTypeFlag = 'XX'
		end
		obj['user_text_5'] = iamPipeType
		obj['user_text_5_flag'] = iamPipeTypeFlag
		
		## joint_type = inPipeJunctionType
		if inPipeJunctionType != nil
			iamPipeJunctionType = inPipeJunctionType
			iamPipeJunctionTypeFlag = '#A'
		else
			iamPipeJunctionType = ''
			iamPipeJunctionTypeFlag = 'XX'
		end
		obj['joint_type'] = iamPipeJunctionType
		obj['joint_type_flag'] = iamPipeJunctionTypeFlag
		
		## manufacturer = inPipeManufacturer
		if inPipeManufacturer != nil
			iamPipeManufacturer = inPipeManufacturer
			iamPipeManufacturerFlag = '#A'
		else
			iamPipeManufacturer = ''
			iamPipeManufacturerFlag = 'XX'
		end
		obj['manufacturer'] = iamPipeManufacturer
		obj['manufacturer_flag'] = iamPipeManufacturerFlag

		## obj['us_node_id'] = inPipeUSnode
		if inPipeUSnode != nil
			iamPipeUSnode = inPipeUSnode
			iamPipeUSnodeFlag = '#A'
		else
			iamPipeUSnode = ''
			iamPipeUSnodeFlag = 'XX'
		end
		obj['us_node_id'] = iamPipeUSnode
		obj['us_node_id_flag'] = iamPipeUSnodeFlag
		
		##obj['ds_node_id'] = inPipeDSnode
		if inPipeDSnode != nil
			iamPipeDSnode = inPipeDSnode
			iamPipeDSnodeFlag = '#A'
		else
			iamPipeDSnode = ''
			iamPipeDSnodeFlag = 'XX'
		end
		obj['ds_node_id'] = iamPipeDSnode
		obj['ds_node_id_flag'] = iamPipeDSnodeFlag			
		
		## may be usefull for automation
		obj['user_date_1'] = inPipeDatetimeAdd
		obj['user_date_2'] = inPipeDatetimeMod
		#obj['user_date_3'] = inPipeDatetimeCreated
		#obj['user_date_4'] = inPipeDatetimeEdited
		obj['criticality'] = inPipeCriticality
		
		## useful if you want to create nodes either end of link
		obj['user_number_1'] = inPipeXstart
		obj['user_number_2'] = inPipeYstart
		obj['user_number_3'] = inPipeXend
		obj['user_number_4'] = inPipeYend

	end
end

class ImporterClassTank
	def ImporterClassTank.onEndRecordTank(obj)
	
		# load fields
		inTankID = obj['id']
		inTankObjID = obj['OBJECTID']
		inTankCompkey = obj['COMPKEY']
		inTankType = obj['ASSETTYPE']
		inTankDesc = obj['DESCR']
		inTankServ = obj['SERVSTAT']
		inTankOwn = obj['OWN']
		inTankZ = obj['ZCOORD']
		inTankInstallDate = obj['INSTDATE']
		inTankAsBuilt = obj['ASBUILT']
		inTankScheme = obj['SCHEME']
		inTankDataScr = obj['DATA_SRC']
		inTankDatetimeAdd = obj['ADDDTTM']
		inTankDatetimeMod = obj['MODDTTM']
		inTankConfidence = obj['CONFIDENCE']
		inTankCritcality = obj['CRITICALITY']
		inTankDatetimeCreated = obj['created_date']
		inTankDatetimeEdited = obj['last_edited_date']
		inTankGlocalID = obj['GlobalID']
		inTankX = obj['x'].to_f
		inTankY = obj['y'].to_f
		
		# load into IAM
		obj['owner'] = inTankOwn
		obj['operational_status'] = inTankServ
		obj['date_installed'] = inTankInstallDate
		obj['elevation'] = inTankZ
		obj['type'] = inTankType
		obj['special_instructions'] = inTankDesc
		obj['criticality'] = inTankCritcality
		
	end
end

class ImporterClassPumpStation
	def ImporterClassPumpStation.onEndRecordPumpStation(obj)
		# load fields
		inPSID = obj['id']
		inPSObjectID = obj['OBJECTID']
		inPSCompkey = obj['COMPKEY']
		inPSType = obj['ASSETTYPE']
		inPSDesc = obj['DESCR']
		inPSServ = obj['SERVSTAT']
		inPSOwn = obj['OWN']
		inPSZ = obj['ZCOORD']
		inPSInstallDate = obj['INSTDATE']
		inPSAsBuilt = obj['ASBUILT']
		inPSScheme = obj['SCHEME']
		inPSDataScr = obj['DATA_SRC']
		inPSConfidence = obj['CONFIDENCE']
		inPSCriticality = obj['CRITICALITY']
	
		# load into IAM
		obj['owner'] = inPSOwn
		obj['operational_status'] = inPSServ 
		obj['date_installed'] = inPSInstallDate
		obj['type'] = inPSType
		obj['criticality'] = inPSCriticality
		
	end
end

class ImporterClassWtw
	def ImporterClassWtw.onEndRecordWtw(obj)
		# load fields
		inWtwID = obj['id']
		inWtwObjectID = obj['OBJECTID']
		inWtwCompkey = obj['COMPKEY']
		inWtwType = obj['ASSETTYPE']
		inWtwDesc = obj['DESCR']
		inWtwServ = obj['SERVSTAT']
		inWtwOwn = obj['OWN']
		inWtwZ = obj['ZCOORD']
		inWtwInstallDate = obj['INSTDATE']
		inWtwAsBuilt = obj['ASBUILT']
		inWtwScheme = obj['SCHEME']
		inWtwDataScr = obj['DATA_SRC']
		inWtwConfidence = obj['CONFIDENCE']
		inWtwCriticality = obj['CRITICALITY']

		# load into IAM
		obj['owner'] = inWtwOwn
		obj['operational_status'] = inWtwServ
		obj['date_installed'] = inWtwInstallDate
		obj['type'] = inWtwType
		obj['criticality'] = inWtwCriticality
		
	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('csv', 'valve', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsValve.csv', 
	ImporterClassValve)
	
import_tables.push ImportTable.new('csv', 'hydrant', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsHydrant.csv', 
	ImporterClassHydrant)
	
import_tables.push ImportTable.new('csv', 'meter', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsMeter.csv', 
	ImporterClassMeter)	
	
import_tables.push ImportTable.new('csv', 'fitting', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsNode.csv', 
	ImporterClassFitting)
	
import_tables.push ImportTable.new('csv', 'tank', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsReservoir.csv', 
	ImporterClassTank)
	
import_tables.push ImportTable.new('csv', 'pipe', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsPipes.csv', 
	ImporterClassPipe)

import_tables.push ImportTable.new('csv', 'pumpstation', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsPumpStation.csv', 
	ImporterClassPumpStation)
	
import_tables.push ImportTable.new('csv', 'treatmentworks', 
	folder + data + '\water supply_config.cfg', 
	folder + data + '\wsTreatmentPlant.csv', 
	ImporterClassWtw)
	
puts 'Import tables and config file setup'

# Set up params
csv=Hash.new
csv['Use Display Precision'] = false
csv['Update Based On Asset ID'] = true
csv['Flag Fields '] = false
csv['Multiple Files'] = true
csv['Selection Only'] = false
csv['Coordinate Arrays Format'] = 'Packed'
csv['Other Arrays Format'] = 'Separate'
csv['WGS84'] = false
csv['Duplication Behaviour'] = 'Merge'
csv['Delete Missing Objects'] = true
csv['Update Links From Points'] = false
csv['Default Value Flag'] = '#S'
csv['Set Value Flag'] = '#A'
csv['Error File'] = folder + data + '\errors_csv.txt'

puts 'specific import options defined'

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	csv['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		csv,			    	# specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import CSV Files'

puts 'Import tables and config file setup for SHP files'

# Set up params
shp=Hash.new
shp['Duplication Behaviour'] = 'Merge'
shp['Default Value Flag'] = '#S'
shp['Set Value Flag'] = '#A'
shp['Error File'] = folder + data + '\errors_shp.txt'

puts 'specific import shp options defined'
	
# Do the import of water supply pressure zones
net.odic_import_ex('shp',
	folder + data + '\water supply_config.cfg',
	shp, 'zone',
	folder + data + '\wsPressureZone.shp')

# Do the import of water supply pressure zones
net.odic_import_ex('shp',
	folder + data + '\water supply_config.cfg',
	shp, 'workpackage',
	folder + data + '\wsSchemes.shp')

puts 'End import SHP Files'