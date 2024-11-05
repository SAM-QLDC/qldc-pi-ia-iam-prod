# stormwater_odic.rb
# ==============================================================

## Import the 'date' library
#require 'date'
#WSApplication.use_arcgis_desktop_licence

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod'
data = '\fme\exports\stormwater'

# reserve network so no-one else can use it
#net.reserve

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
# Node - from InfoAsset manhole

class ImporterClassNode
	def ImporterClassNode.onEndRecordNode(obj)

		# load fields
		inNodeX = obj['x'].to_f							#yes
		inNodeY = obj['y'].to_f							#yes
		inNodeZ = obj['ZCOORD'].to_f					#yes
		inNodeI = obj['INVERTELEV'].to_f
		
		inNodeDiam1 = obj['BARLDIAM'].to_i				#yes
		inNodeDiam2 = obj['BARLDIM2'].to_i				#yes
		inNodeCoverDiam = obj['CVRDIAM'].to_i	
		inNodeCrit = obj['CRITICALITY'].to_i			#yes
		
		inNodeInstallDate = obj['INSTDATE']				#yes
		inNodeAddDate = obj['ADDDTTM']					#yes
		inNodeModDate = obj['MODDTTM']					#yes
		inNodeCreatedDate = obj['created_date']			#yes
		inNodeLastEditdate = obj['last_edited_date']	#yes

		inNodeType = obj['ASSETTYPE']					#yes
		inNodeDesc = obj['DESCR']						#yes
		inNodeServ = obj['SERVSTAT']					#yes
		inNodeOwn = obj['OWN']							#yes
		#inNode = obj['BARLSHAPE']
		#inNodeChmbMaterial = obj['CHAMATL']
		#inNodeCoverType = obj['CVRTYPE']
		#inNodeAsBuilt = obj['ASBUILT']
		inNodeScheme = obj['SCHEME']					#yes
		#inNodeDataScr = obj['DATA_SRC']
		inNodeComments = obj['COMMENTS']				#yes
		#inNodeAddBy = obj['ADDDBY']
		#inNodeModBy = obj['MODBY']
		#inNodeConfidence = obj['CONFIDENCE']
		#inNodeAllocate = obj['ALLOCATE']
		#inNodeCreatedUser = obj['created_user']
		#inNodeLastEditUser = obj['last_edited_user']
		inNodeFeature = obj['FEATURE']
		
		@nodeTypeLookup = {	
			'AIR' => 'AV',
			'AIR VALVE' => 'AV',
			'BEND' => 'G',
			'BOUND' => 'U',
			'CHAMBER' => 'M',
			'COMM' => 'U',
			'END' => 'HSE',
			'FLOW' => 'M',
			'JUNCTION' => 'J',
			'LAMPHOLE' => 'L',
			'MANHOLE' => 'M',
			'MISC' => 'U',
			'NON RETURN' => 'NRV',
			'NORETURN' => 'NRV',
			'OTHER' => 'U',
			'PRESSURE' => 'Z',
			'SEWERPUMP' => 'P',
			'SEWERTREAT' => 'W',
			'STDMH' => 'M',
			'STOPV' => 'SV',
			'VALVE' => 'V'
		}	
		
		# change some fields to upper case (if necessary)
		if !inNodeType.nil?
			inNodeType = inNodeType
		end
		
		# if else list to set status
		if @nodeTypeLookup.has_key? inNodeType
			iamNodeNodeType = @nodeTypeLookup[inNodeType]
			iamNodeNodeTypeFlag = '#A'
		else
			iamNodeNodeType = 'U'
			iamNodeNodeTypeFlag = 'XX'
		end
		
		# manhole status
		if inNodeServ == 'ABANDON'
			iamNodeServ = 'AB'
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'A'
			iamNodeSystemTypeFlag = '#A'
		elsif inNodeServ == 'REMOVED'
			iamNodeServ = 'RE'
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'A'
			iamNodeSystemTypeFlag = '#A'
		elsif inNodeServ == 'INACTIVE'
			iamNodeServ = 'IA'
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'A'
			iamNodeSystemTypeFlag = '#A'
		elsif inNodeServ == 'ACTIVE'
			iamNodeServ = 'PU'
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'F'
			iamNodeSystemTypeFlag = '#A'
		elsif inNodeServ == 'REDRAWN'
			iamNodeServ = 'PU'
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'F'
			iamNodeSystemTypeFlag = '#A'
		elsif inNodeServ == 'EXIST'
			iamNodeServ = 'PU'	
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'F'
			iamNodeSystemTypeFlag = '#A'			
		elsif inNodeServ == 'PROPOSED'
			iamNodeServ = 'TC'
			iamNodeServFlag = '#A'
			iamNodeSystemType = 'A'
			iamNodeSystemTypeFlag = '#A'
		else
			iamNodeServ  = 'U'
			iamNodeServFlag = 'XX'
			iamNodeSystemType = 'U'
			iamNodeSystemTypeFlag = 'XX'
		end
		
		# loop CVRDIAM
		if inNodeCoverDiam > 0
			iamNodeCoverDiam = inNodeCoverDiam
			iamNodeCoverDiamFlag = '#A'
		else
			iamNodeCoverDiam = ''
			iamNodeCoverDiamFlag = 'XX'
		end
		
		# loop inNodeZ
		if inNodeZ > 0
			iamNodeZ = inNodeZ
			iamNodeZFlag = '#A'
		else
			iamNodeZ = ''
			iamNodeZFlag = 'XX'
		end
		
		# loop inNodeDiam1
		if inNodeDiam1 > 0
			iamNodeDiam1 = inNodeDiam1
			iamNodeDiam1Flag = '#A'
		else
			iamNodeDiam1 = ''
			iamNodeDiam1Flag = 'XX'
		end		
			
		# loop inNodeDiam2
		if inNodeDiam2 > 0
			iamNodeDiam2 = inNodeDiam2
			iamNodeDiam2Flag = '#A'
		else
			iamNodeDiam2 = ''
			iamNodeDiam2Flag = 'XX'
		end	

		# chamber floor depth
		if inNodeZ > 0 && inNodeI > 0
			iamNodeCfd = (inNodeZ - inNodeI)*1000
			iamNodeCfdFlag = '#A'		
		else
			iamNodeCfd = ''
			iamNodeCfdFlag = '#D'
		end
		
		# flag install year field
		if inNodeInstallDate != nil
			iamNodeInstallDate = inNodeInstallDate
			iamNodeInstallDateFlag = '#A'
		else
			iamNodeInstallDate = ''
			iamNodeInstallDateFlag = 'XX'		
		end
		
		# flag owner field
		if inNodeOwn != nil
			iamNodeOwn = inNodeOwn
			iamNodeOwnFlag = '#A'
		else
			iamNodeOwn = 'QLDC'
			iamNodeOwnFlag = 'XX'	
		end
		
		# flag criticality field
		if inNodeCrit > 0
			iamNodeCrit = inNodeCrit
			iamNodeCritFlag = '#A'
		else
			iamNodeCrit = ''
			iamNodeCritFlag = 'XX'
		end
		
		# update various fields
		obj['node_type'] = inNodeType
		#obj['node_type_flag'] = iamNodeNodeTypeFlag
		obj['cover_dim'] = iamNodeCoverDiam
		obj['cover_dim_flag'] = iamNodeCoverDiamFlag
		obj['status'] = inNodeServ
		#obj['status_flag'] = iamNodeServFlag
		obj['cover_level'] = iamNodeZ
		obj['cover_level_flag'] = iamNodeZFlag
		obj['shaft_dim'] = iamNodeDiam1
		obj['shaft_dim_flag'] = iamNodeDiam1Flag
		obj['shaft_dim_2'] = iamNodeDiam2
		obj['shaft_dim_2_flag'] = iamNodeDiam2Flag
		obj['chamber_floor_depth'] = iamNodeCfd
		obj['chamber_floor_depth_flag'] = iamNodeCfdFlag
		obj['system_type'] = iamNodeSystemType
		obj['system_type_flag'] = iamNodeSystemTypeFlag
		obj['x'] = inNodeX
		obj['y'] = inNodeY
		obj['year_laid'] = iamNodeInstallDate
		obj['year_laid_flag'] = iamNodeInstallDateFlag
		obj['owner'] = iamNodeOwn
		obj['owner_flag'] = iamNodeOwnFlag
		obj['critical'] = iamNodeCrit
		obj['critical_flag'] = iamNodeCritFlag
		obj['user_date_1'] = inNodeAddDate
		obj['user_date_2'] = inNodeModDate
		obj['user_date_3'] = inNodeCreatedDate
		obj['user_date_4'] = inNodeLastEditdate
		obj['drainage_area'] = inNodeScheme
		obj['notes'] = inNodeDesc
		obj['special_instructions'] = inNodeComments
		obj['user_text_1'] = inNodeFeature

	end
end

class ImporterClassPipe
	def ImporterClassPipe.onEndRecordPipe(obj)

		# load fields
		inPipeCompkley = obj['COMPKEY']
		inPipeType = obj['ASSETTYPE']
		inPipeDescription = obj['DESC']
		inPipeStatus = obj['SERVSTAT']
		inPipeOwn = obj['Own']
		inPipeMaterial = obj['PIPEMATL']
		inPipeLength = obj['PIPELEN'].to_f
		inPipeDiamNom = obj['NOMDIAM'].to_i
		inPipeDiamInt = obj['INTDIAM'].to_i
		inPipeDiamExt = obj['OUTDIAM'].to_i
		inPipeUsNodeId = obj['UPNODE']
		inPipeUsInvert = obj['UPSELEV'].to_f
		inPipeDsNodeId = obj['DWNNODE']
		inPipeDsInvert = obj['DWNELEV'].to_f
		inPipePipeClass = obj['CLASS']
		inPipeYearLaid = obj['INSTDATE']
		inPipeJunctionType = obj['JTTYPE']
		inPipeManufacturer = obj['MANUFCT']
		inPipeInstallationMethod = obj['INSTMTHD']
		inPipeLiningMaterial = obj['LINEMATL']
		inPipeLiningMethod = obj['LINEMTHD']
		inPipeLiningDate = obj['LINEDATE']
		inPipeAsBuilt = obj['ASBUILT']
		inPipeScheme = obj['SCHEME']
		inPipeDataScr = obj['DATA_SRC']
		inPipeComments = obj['COMMENTS']
		inPipeAddBy = obj['ADDDBY']
		inPipeAddTtm = obj['ADDDTTM']
		inPipeModBy = obj['MODBY']
		inPipeModTtm = obj['MODDTTM']
		inPipeConfidence = obj['CONFIDENCE']
		inPipeCriticality = obj['CRITICALITY'].to_i
		inPipeAllocate = obj['ALLOCATE']
		inPipeOldGuid = obj['OLDGUID']
		inPipeGlobalID = obj['GlobalID']
		inPipeCreatedUser = obj['created_user']
		inPipeCreatedDate = obj['created_date']
		inPipeLastEditedUser = obj['last_edited_user']
		inPipeLastEditedDate = obj['last_edited_date']
		inPipeStartX = obj['x_start']
		inPipeStartY = obj['y_start']
		inPipeEndX = obj['x_end']
		inPipeEndY = obj['y_end']
		
		# asset type
		if inPipeType == 'PERFORATED PIPE'
			iamPipeType = 'PERFORTD'
			iamPipeTypeFlag = 'AS'
		elsif 
			inPipeType == 'MUDTANK LEAD' || 
			inPipeType == 'MUDTANK LATERAL' ||
			inPipeType == 'MUDTANK LEAD' ||
			inPipeType == 'Raingarden Lead' 
				iamPipeType = 'LATERAL_M'
				iamPipeTypeFlag = 'AS'												
		else
			iamPipeType  = inPipeType
			iamPipeTypeFlag = '#A'
		end
		
		# pipe status
		if inPipeStatus == 'ABANDON'
			iamPipeStatus = 'AB'
			iamPipeStatusFlag = '#A'
			iamSystemType = 'A'
			iamSystemTypeFlag = '#A'
		elsif inPipeStatus == 'ACTIVE'
			iamPipeStatus = 'INUSE'
			iamPipeStatusFlag = '#A'
			iamSystemType = 'F'
			iamSystemTypeFlag = '#A'
		elsif inPipeStatus == 'HOST'
			iamPipeStatus = 'HO'
			iamPipeStatusFlag = 'XX'
			iamSystemType = 'F'
			iamSystemTypeFlag = 'XX'
		elsif inPipeStatus == 'REMOVED'
			iamPipeStatus = 'RE'
			iamPipeStatusFlag = '#A'
			iamSystemType = 'A'
			iamSystemTypeFlag = '#A'
		elsif inPipeStatus == 'INACTIVE'
			iamPipeStatus = 'Standby'
			iamPipeStatusFlag = '#A'
			iamSystemType = 'A'
			iamSystemTypeFlag = '#A'
		elsif inPipeStatus == 'EXIST'
			iamPipeStatus = 'INUSE'
			iamPipeStatusFlag = 'AS'
			iamSystemType = 'F'
			iamSystemTypeFlag = '#A'
		else
			iamPipeStatus  = 'U'
			iamPipeStatusFlag = 'XX'
			iamSystemType = 'U'
			iamSystemTypeFlag = 'XX'
		end
		
		# pipe materials
		if inPipeMaterial == 'POLYETHYLENE (PE100)'
			iamPipeMaterial = 'PE100'	
			iamPipeMaterialFlag = 'AS'				
		elsif inPipeMaterial == 'POLYVINYL CHLORIDE'
			iamPipeMaterial = 'PVC'	
			iamPipeMaterialFlag = 'AS'							
		elsif inPipeMaterial == 'STAINLESS STEEL'
			iamPipeMaterial = 'SS'	
			iamPipeMaterialFlag = 'AS'							
		elsif inPipeMaterial == 'STRUCTURAL LINER UPVC'
			iamPipeMaterial = 'UPVCS'	
			iamPipeMaterialFlag = 'AS'				
		elsif inPipeMaterial == 'U - POLYVINYL CHLORIDE'
			iamPipeMaterial = 'UPVC'
			iamPipeMaterialFlag = 'AS'				
		elsif inPipeMaterial == 'UPVCLINE'
			iamPipeMaterial = 'UPVCL'
			iamPipeMaterialFlag = 'AS'			
		else
			iamPipeMaterial = inPipeMaterial
			iamPipeMaterialFlag = '#A'
		end
		
		# loop us inverts
		if inPipeUsInvert > 0
			iamPipeUsInvert = inPipeUsInvert
			iamPipeUsInvertFlag = '#A'
		else
			iamPipeUsInvert = ''
			iamPipeUsInvertFlag = 'XX'
		end
		
		# loop ds inverts
		if inPipeDsInvert > 0
			iamPipeDsInvert = inPipeDsInvert
			iamPipeDsInvertFlag = '#A'
		else
			iamPipeDsInvert = ''
			iamPipeDsInvertFlag = 'XX'
		end
		
		# loop through criticality
		if inPipeCriticality >= 1
			iamPipeCriticality = inPipeCriticality.to_s
			iamPipeCriticalityFlag = '#A'
		else
			iamPipeCriticality = '0'
			iamPipeCriticalityFlag = 'XX'	
		end
		
		# loop through diameters
		# should really use internal diameters
		if inPipeDiamNom > 0
			iamPipeDiamNom = inPipeDiamNom
			iamPipeDiamNomFlag = '#A'
			iamPipeHeightNom = inPipeDiamNom
			iamPipeHeightNomFlag = 'AS'
		else
			iamPipeDiamNom = ''
			iamPipeDiamNomFlag = 'XX'
			iamPipeHeightNom = ''
			iamPipeHeightNomFlag = 'XX'
		end
	
		# update various fields
		obj['pipe_type'] = iamPipeType
		obj['pipe_type_flag'] = iamPipeTypeFlag
		obj['notes'] = inPipeDescription
		obj['status'] = inPipeStatus
		obj['owner'] = inPipeOwn
		obj['system_type'] = 'S'
		obj['system_type_flag'] = 'AS'
		obj['shape'] = 'CP'
		obj['shape_flag'] = 'AS'
		obj['width'] = iamPipeDiamNom
		obj['width_flag'] = iamPipeDiamNomFlag
		obj['height'] = iamPipeHeightNom
		obj['height_flag'] = iamPipeHeightNomFlag
		obj['pipe_material'] = iamPipeMaterial
		obj['pipe_material_flag'] = iamPipeMaterialFlag
		obj['lining_type'] = inPipeLiningMethod 
		obj['lining_material'] = inPipeLiningMaterial
		obj['us_invert'] = iamPipeUsInvert
		obj['us_invert_flag'] = iamPipeUsInvertFlag
		obj['ds_invert'] = iamPipeDsInvert
		obj['ds_invert_flag'] = iamPipeDsInvertFlag
		obj['year_laid'] = inPipeYearLaid
		obj['pipe_class'] = inPipePipeClass
		obj['criticality'] = iamPipeCriticality 
		obj['criticality_flag'] = iamPipeCriticalityFlag
		obj['user_number_1'] = inPipeStartX
		obj['user_number_2'] = inPipeStartY
		obj['user_number_3'] = inPipeEndX
		obj['user_number_4'] = inPipeEndY
		obj['user_text_1'] = inPipeUsNodeId
		obj['user_text_2'] = inPipeDsNodeId
		obj['user_date_1'] = inPipeAddTtm
		obj['user_date_2'] = inPipeModTtm
		obj['user_date_3'] = inPipeCreatedDate
		obj['user_date_4'] = inPipeLastEditedDate
		obj['drainage_code'] = inPipeScheme
		obj['notes'] = inPipeDescription
		obj['special_instructions'] = inPipeComments
		
	end
end

class ImporterClassChannel
	def ImporterClassChannel.onEndRecordchannel(obj)
		# load fields
		# update various fields
	end
end

class ImporterClassLateral
	def ImporterClassLateral.onEndRecordLateral(obj)
		# load fields
		# update various fields
	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('csv', 'node', 
	folder + data + '\stormwater_config.cfg', 
	folder + data + '\swNodes.csv', 
	ImporterClassNode)
	
import_tables.push ImportTable.new('csv', 'pipe', 
	folder + data + '\stormwater_config.cfg', 
	folder + data + '\swMain.csv', 
	ImporterClassPipe)
	
import_tables.push ImportTable.new('csv', 'connectionpipe', 
	folder + data + '\stormwater_config.cfg', 
	folder + data + '\swLateral.csv', 
	ImporterClassLateral)
	
puts 'Import tables and config file setup - asset_id matching'

# Set up params
options = Hash.new
options['Use Display Precision'] = false
options['Update Based On Asset ID'] = true
options['Flag Fields '] = false
options['Multiple Files'] = true
options['Selection Only'] = false
options['Coordinate Arrays Format'] = 'Packed'
options['Other Arrays Format'] = 'Separate'
options['WGS84'] = false
options['Duplication Behaviour'] = 'Merge'
options['Delete Missing Objects'] = true
options['Update Links From Points'] = false
options['Default Value Flag'] = '#S'
options['Set Value Flag'] = '#A'
options['Error File'] = folder + data + '\errors_csv.txt'

puts 'specific import options defined'

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	options['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		options,				# specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import for tables matching asset_id'

# Set up the config files and table names
import_tables = Array.new
	
import_tables.push ImportTable.new('csv', 'channel', 
	folder + data + '\stormwater_config.cfg', 
	folder + data + '\swChannel.csv', 
	ImporterClassChannel)
	
puts 'Import tables and config file setup - asset_id matching'

# Set up params
options = Hash.new
options['Update Based On Asset ID'] = false

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	options['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		options,				# specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import for tables matching id'

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
	folder + data + '\stormwater_config.cfg',
	shp, 'workpackage',
	folder + data + '\swSchemes.shp')

puts 'End import SHP Files'