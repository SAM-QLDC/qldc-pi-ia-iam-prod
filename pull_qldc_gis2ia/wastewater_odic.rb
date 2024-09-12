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

		# load float fields
		inNodeX = obj['x'].to_f
		inNodeY = obj['y'].to_f
	
		@nodeTypeLookup = {		
			'STDMH' => 'M',
			'LAMPHOLE' => 'L'
		}
		
		# load text fields
		inNodeType = obj['ASSETTYPE']
		
		# load integer fields
		#inNodeChmbDim2 = obj['chamber_dim_2'].to_i
		
		# change some fields to upper case (if necessary)
		if !inNodeType.nil?
			inNodeType = inNodeType
		end
		
		# loop through and change according to lookup list above
		if @nodeTypeLookup.has_key? inNodeType
			iamNodeNodeType = @nodeTypeLookup[inNodeType]
		else
			iamNodeNodeType = 'U'
		end
		
		# update various fields
		obj['node_type'] = iamNodeNodeType
		obj['x'] = inNodeX
		obj['y'] = inNodeY
		
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