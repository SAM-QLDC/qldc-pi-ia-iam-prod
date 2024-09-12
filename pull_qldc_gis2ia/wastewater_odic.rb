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
		inNodeI = obj['INVERTELEV'].to_f				#needs a calc
		
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
		inNodeDesc = obj['DESCR']
		inNodeServ = obj['SERVSTAT']					#yes
		inNodeOwn = obj['OWN']							#yes
		inNode = obj['BARLSHAPE']
		inNodeChmbMaterial = obj['CHAMATL']
		inNodeCoverType = obj['CVRTYPE']
		inNodeAsBuilt = obj['ASBUILT']
		inNodeScheme = obj['SCHEME']					#yes
		inNodeDataScr = obj['DATA_SRC']
		inNodeComments = obj['COMMENTS']
		inNodeAddBy = obj['ADDDBY']
		inNodeModBy = obj['MODBY']
		inNodeConfidence = obj['CONFIDENCE']
		inNodeAllocate = obj['ALLOCATE']
		inNodeCreatedUser = obj['created_user']
		inNodeLastEditUser = obj['last_edited_user']
		
		@nodeTypeLookup = {		
			'STDMH' => 'M',
			'LAMPHOLE' => 'L',
			'MANHOLE' => 'M',
			'CHAMBER' => 'M',
			'PRESSURE' => 'P',
			'MISC' => 'U',		# check
			'BOUND' => 'U',		# check
			'END' => 'E',		# add new
			'JUNCTION' => 'J'
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
		elsif inNodeServ == 'EXIST'
			iamNodeServ = 'PU'			
		elsif inNodeServ == 'PROPOSED'
			iamNodeServ = 'TC'
		else
			iamNodeServ  = 'U'
		end

		# update various fields
		obj['node_type'] = iamNodeNodeType
		obj['system_type'] = 'F'
		obj['status'] = iamNodeServ 
		obj['x'] = inNodeX
		obj['y'] = inNodeY
		obj['year_laid'] = inNodeInstallDate
		obj['owner'] = inNodeOwn
		obj['ground_level'] = inNodeZ
		obj['cover_level'] = inNodeZ
		obj['cover_dim'] = inNodeCoverDiam
		obj['chamber_dim'] = inNodeDiam1
		obj['chamber_dim_2'] = inNodeDiam2
		obj['critical'] = inNodeCrit 
		obj['user_date_1'] = inNodeAddDate
		obj['user_date_2'] = inNodeModDate
		obj['user_date_3'] = inNodeCreatedDate
		obj['user_date_4'] = inNodeLastEditdate
		obj['drainage_area'] = inNodeScheme

	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('csv', 'Node', 
	folder + '\wastewater_config.cfg', folder + '\exports\wwManhole.csv', 
	ImporterClassNode)
	
puts 'Import tables and config file setup'

puts 'Start importing'

# Set up params
csv_options=Hash.new
csv_options['Use Display Precision'] = false
csv_options['Flag Fields '] = false
csv_options['Multiple Files'] = true
csv_options['Selection Only'] = false
csv_options['Coordinate Arrays Format'] = 'Packed'
csv_options['Other Arrays Format'] = 'Separate'
csv_options['WGS84'] = false
csv_options['Duplication Behaviour'] = 'Merge'
csv_options['Delete Missing Objects'] = true
csv_options['Update Links From Points'] = false
csv_options['Default Value Flag'] = '#S'
csv_options['Set Value Flag'] = '#A'

puts 'specific import options defined'

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	csv_options['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		csv_options,				# specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import'