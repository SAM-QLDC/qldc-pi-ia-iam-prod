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
		inNodeX = obj['x'].to_f
		inNodeY = obj['y'].to_f
		inNodeType = obj['node_type']
	
		# update various fields
		obj['x'] = inNodeX
		obj['y'] = inNodeY
		obj['node_type'] = inNodeType

	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('csv', 'node', 
	folder + data + '\stormwater_config.cfg', 
	folder + data + '\swNodes.csv', 
	ImporterClassNode)
	
puts 'Import tables and config file setup'

# Set up params
csv_options = Hash.new
csv_options['Use Display Precision'] = false
csv_options['Update Based On Asset ID'] = true
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
csv_options['Error File'] = folder + data + '\errors_csv.txt'

puts 'specific import options defined'

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	csv_options['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		csv_options,			# specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import'