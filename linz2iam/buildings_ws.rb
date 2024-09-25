# linz buildings.rb
# ==============================================================

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod\linz2iam'

# Run batch file
#system(folder + '/.bat')

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

class ImporterClassProperty
	def ImporterClassProperty.onEndRecordProperty(obj)

		# load fields
		inPropertyID = obj['id']
		inPropertyName = obj['name']
		inPropertyUse = obj['use']
		inPropertySuburb = obj['suburb']
		inPropertyTA = obj['ta_area']
		inPropertyDatetimeOrigin = obj['origin_utc']

		# import into iam
		obj['property_type'] = inPropertyUse
		obj['property_name'] = inPropertyName
		obj['property_town'] = inPropertySuburb
		obj['property_district'] = inPropertyTA
		obj['user_date_1'] = inPropertyDatetimeOrigin

	end
end

# Set up the config files and table names
import_tables = Array.new

import_tables.push ImportTable.new('shp', 'property', 
	folder + '\exports\buildings_ws.cfg', 
	folder + '\exports\buildings.shp', 
	ImporterClassProperty)
	
puts 'Import tables and config file setup'

# Set up params
options=Hash.new
options['Use Display Precision'] = false
#options['Update Based On Asset ID'] = true
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

puts 'specific import options defined'

## import tables into IAM
# Loop over table configs
import_tables.each{|table_info|
	options['Callback Class'] = table_info.cb_class
	
	# Do the import
	net.odic_import_ex(
		table_info.tbl_format,	# input table format
		table_info.cfg_file,	# field mapping config file
		options,			    # specified options override the default options
		table_info.in_table,	# import to IAM table name
		table_info.csv_file		# import from table name
	)
}
puts 'End import'