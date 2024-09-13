# wastewater_odic.rb
# ==============================================================

## Import the 'date' library
#require 'date'
#WSApplication.use_arcgis_desktop_licence

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia'
#database = '//10.0.29.43:40000/wastewater ongoing/system_performance'
#network = 'Model Network'
#network_id = 4765

## iexchange
#db=WSApplication.open(database,false)
#net=db.model_object_from_type_and_id(network,network_id)

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
		
		@nodeTypeLookup = {	
			'AIR' => 'AV',
			'AIR VALVE' => 'AV',
			'BEND' => 'G',
			'BOUND' => 'U',
			'CHAMBER' => 'M',
			'COMM' => 'U',
			'END' => 'E',
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
		else
			iamNodeNodeType = 'U'
		end
		
		# manhole status
		if inNodeServ == 'ABANDON'
			iamNodeServ = 'AB'
		elsif inNodeServ == 'REMOVED'
			iamNodeServ = 'RE'
		elsif inNodeServ == 'INACTIVE'
			iamNodeServ = 'IA'
		elsif inNodeServ == 'ACTIVE'
			iamNodeServ = 'PU'
		elsif inNodeServ == 'REDRAWN'
			iamNodeServ = 'PU'
		elsif inNodeServ == 'EXIST'
			iamNodeServ = 'PU'			
		elsif inNodeServ == 'PROPOSED'
			iamNodeServ = 'TC'
		else
			iamNodeServ  = 'U'
		end
		
		# loop CVRDIAM
		if inNodeCoverDiam > 0
			iamNodeCoverDiam = inNodeCoverDiam
		else
			iamNodeCoverDiam = ''
		end
		
		# loop inNodeZ
		if inNodeZ > 0
			iamNodeZ = inNodeZ
		else
			iamNodeZ = ''
		end
		
		# loop inNodeDiam1
		if inNodeDiam1 > 0
			iamNodeDiam1 = inNodeDiam1
		else
			iamNodeDiam1 = ''
		end		
			
		# loop inNodeDiam2
		if inNodeDiam2 > 0
			iamNodeDiam2 = inNodeDiam2
		else
			iamNodeDiam2 = ''
		end	

		# chamber floor depth
		if inNodeZ > 0 && inNodeI > 0
			iamNodeCfd = (inNodeZ - inNodeI)*1000
		else
			iamNodeCfd = ''
		end

		# update various fields
		obj['node_type'] = iamNodeNodeType
		obj['cover_dim'] = iamNodeCoverDiam
		obj['status'] = iamNodeServ
		obj['ground_level'] = iamNodeZ
		obj['cover_level'] = iamNodeZ
		obj['shaft_dim'] = iamNodeDiam1
		obj['shaft_dim_2'] = iamNodeDiam2
		obj['chamber_floor_depth'] = iamNodeCfd
		
		obj['system_type'] = 'F'
		
		obj['x'] = inNodeX
		obj['y'] = inNodeY
		obj['year_laid'] = inNodeInstallDate
		obj['owner'] = inNodeOwn

		obj['critical'] = inNodeCrit 
		obj['user_date_1'] = inNodeAddDate
		obj['user_date_2'] = inNodeModDate
		obj['user_date_3'] = inNodeCreatedDate
		obj['user_date_4'] = inNodeLastEditdate
		obj['drainage_area'] = inNodeScheme
		obj['notes'] = inNodeDesc
		obj['special_instructions'] = inNodeComments

	end
end

# Pipe - from InfoAsset manhole

class ImporterClassPipe
	def ImporterClassPipe.onEndRecordPipe(obj)

		# load fields
		#inPipeCompkley = obj['COMPKEY']				#in config file
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
		#inPipePointArray = obj['point_array']			#in config file
		
		# asset type
		if inPipeType == 'SEWER'
			iamPipeType = 'A'
			iamPipeTypeFlag = '#A'				
		elsif inPipeType == 'TRUNK'
			iamPipeType = 'A'
			iamPipeTypeFlag = '#A'				
		elsif inPipeType == 'RISING'
			iamPipeType = 'B'
			iamPipeTypeFlag = '#A'				
		elsif inPipeType == 'VENT'
			iamPipeType = 'A'
			iamPipeTypeFlag = '#A'				
		elsif inPipeType == 'OUTFALL'
			iamPipeType = 'A'
			iamPipeTypeFlag = '#A'				
		elsif inPipeType == 'LATGRAV'
			iamPipeType = 'A'
			iamPipeTypeFlag = '#A'			
		elsif inPipeType == 'MH'
			iamPipeType = 'U'
			iamPipeTypeFlag = 'XX'			
		else
			iamPipeType  = 'U'
			iamPipeTypeFlag = 'XX'
		end
		
		# pipe status
		if inPipeStatus == 'ABANDON'
			iamPipeStatus = 'AB'
			iamPipeStatusFlag = '#A'
		elsif inPipeStatus == 'ACTIVE'
			iamPipeStatus = 'INUSE'
			iamPipeStatusFlag = '#A'
		elsif inPipeStatus == 'HOST'
			iamPipeStatus = 'HO'
			iamPipeStatusFlag = 'AS'
		elsif inPipeStatus == 'REMOVED'
			iamPipeStatus = 'RE'
			iamPipeStatusFlag = '#A'
		elsif inPipeStatus == 'INACTIVE'
			iamPipeStatus = 'Standby'
			iamPipeStatusFlag = '#A'
		elsif inPipeStatus == 'EXIST'
			iamPipeStatus = 'INUSE'
			iamPipeStatusFlag = 'AS'
		else
			iamPipeStatus  = 'U'
			iamPipeStatusFlag = 'XX'
		end

		# lining method
		if inPipeLiningMethod == 'CIPP'
			iamPipeLiningMethod = 'CIP'
			iamPipeLiningMethodFlag = '#A'
		elsif inPipeLiningMethod == 'SPIRRAL'
			iamPipeLiningMethod = 'SW'
			iamPipeLiningMethodFlag = '#A'
		elsif inPipeLiningMethod == 'Spiral Wound'
			iamPipeLiningMethod = 'SW'
			iamPipeLiningMethodFlag = '#A'
		elsif inPipeLiningMethod == 'SLIP'
			iamPipeLiningMethod = 'CP'
			iamPipeLiningMethodFlag = 'AS'
		else
			iamPipeLiningMethod  = ''
			iamPipeLiningMethodFlag = 'XX'
		end
		
		# lining method
		if inPipeLiningMaterial == 'PVC'
			iamPipeLiningMaterial = 'PVC'
			iamPipeLiningMaterialFlag = '#A'
		elsif inPipeLiningMaterial == 'EPOXY'
			iamPipeLiningMaterial = 'EP'
			iamPipeLiningMaterialFlag = '#A'
		elsif inPipeLiningMaterial == 'uPVC'
			iamPipeLiningMaterial = 'UPVC'
			iamPipeLiningMaterialFlag = '#A'
		elsif inPipeLiningMaterial == 'CONCRETE'
			iamPipeLiningMaterial = 'CO'
			iamPipeLiningMaterialFlag = '#A'
		else
			iamPipeLiningMaterial  = ''
			iamPipeLiningMaterialFlag = 'XX'
		end
		
		# pipe materials
		if inPipeMaterial == 'AC'
			iamPipeMaterial = 'AC'
			iamPipeMaterialFlag = '#A'	
		elsif inPipeMaterial == 'ALK'
			iamPipeMaterial = 'ALK'
			iamPipeMaterialFlag = '#A'	
		elsif inPipeMaterial == 'CI'
			iamPipeMaterial = 'CI'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'CLSTEEL'
			iamPipeMaterial = 'CLS'
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'CONC'
			iamPipeMaterial = 'CP'
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'DI'
			iamPipeMaterial = 'DI'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'EW'
			iamPipeMaterial = 'VC'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'FIBGLASS'
			iamPipeMaterial = 'FB'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'HDPE'
			iamPipeMaterial = 'HDPE'
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'MDPE'
			iamPipeMaterial = 'MDPE'
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'MPVC'
			iamPipeMaterial = 'MPVC'
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'PE'
			iamPipeMaterial = 'PE'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'PE100'
			iamPipeMaterial = 'PE'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'POLYETHYLENE (PE100)'
			iamPipeMaterial = 'PE'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'POLYVINYL CHLORIDE'
			iamPipeMaterial = 'PVC'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'PP'
			iamPipeMaterial = 'PP'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'PVC'
			iamPipeMaterial = 'PVC'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'SSTEEL'
			iamPipeMaterial = 'SS'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'STAINLESS STEEL'
			iamPipeMaterial = 'SS'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'STEEL'
			iamPipeMaterial = 'SS'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'STRUCTURAL LINER UPVC'
			iamPipeMaterial = 'UPVC'	
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'U - POLYVINYL CHLORIDE'
			iamPipeMaterial = 'UPVC'
			iamPipeMaterialFlag = '#A'				
		elsif inPipeMaterial == 'UNK'
			iamPipeMaterial = 'XXX'
			iamPipeMaterialFlag = 'XX'	
		elsif inPipeMaterial == 'UPVC'
			iamPipeMaterial = 'UPVC'
			iamPipeMaterialFlag = '#A'	
		elsif inPipeMaterial == 'UPVCLINE'
			iamPipeMaterial = 'UPVC'
			iamPipeMaterialFlag = '#A'			
		else
			iamPipeMaterial = 'XXX'
			iamPipeMaterialFlag = 'XX'
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
		if inPipeCriticality > 0
			iamPipeCriticality = inPipeCriticality
			iamPipeCriticalityFlag = '#A'
		else
			iamPipeCriticality = ''
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
		obj['us_node_id'] = inPipeUsNodeId
		obj['ds_node_id'] = inPipeDsNodeId
		obj['notes'] = inPipeDescription
		obj['status'] = iamPipeStatus
		obj['status_flag'] = iamPipeStatusFlag
		obj['owner'] = inPipeOwn
		obj['system_type'] = 'F'
		obj['shape'] = 'CP'
		obj['shape_flag'] = 'AS'
		obj['width'] = iamPipeDiamNom
		obj['width_flag'] = iamPipeDiamNomFlag
		obj['height'] = iamPipeHeightNom
		obj['height_flag'] = iamPipeHeightNomFlag		
		obj['pipe_material'] = iamPipeMaterial
		obj['pipe_material_flag'] = iamPipeMaterialFlag
		obj['lining_type'] =  iamPipeLiningMethod
		obj['lining_type_flag'] =  iamPipeLiningMethodFlag
		obj['lining_material'] = iamPipeLiningMaterial
		obj['lining_material_flag'] = iamPipeLiningMaterialFlag
		obj['us_invert'] = iamPipeUsInvert
		obj['us_invert_flag'] = iamPipeUsInvertFlag
		obj['ds_invert'] = iamPipeDsInvert
		obj['ds_invert_flag'] = iamPipeDsInvertFlag
		obj['year_laid'] = inPipeYearLaid
		obj['pipe_class'] = inPipePipeClass
		obj['criticality'] = iamPipeCriticality 
		obj['criticality_flag'] = iamPipeCriticalityFlag
		obj['user_text_1'] = inPipeUsNodeId
		obj['user_text_2'] = inPipeDsNodeId
		obj['user_date_1'] = inPipeAddTtm
		obj['user_date_2'] = inPipeModTtm
		obj['user_date_3'] = inPipeCreatedDate
		obj['user_date_4'] = inPipeLastEditedDate
		obj['drainage_area'] = inPipeScheme
		obj['notes'] = inPipeDescription
		obj['special_instructions'] = inPipeComments
		
	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('csv', 'Node', 
	folder + '\wastewater_config.cfg', folder + '\exports\wwNodes.csv', 
	ImporterClassNode)
	
import_tables.push ImportTable.new('csv', 'Pipe', 
	folder + '\wastewater_config.cfg', folder + '\exports\wwMain.csv', 
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