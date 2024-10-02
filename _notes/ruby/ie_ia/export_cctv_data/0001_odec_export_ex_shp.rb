# INTERFACE SCRIPT
# Export Nodes and Pipes to SHP File via odec_export_ex method

nw=WSApplication.current_network

# Config File name - within same director of this script
config = File.dirname(WSApplication.script_file)+'/0001_odec_export_ex_shp.cfg'

# Change this to a different folder for the export location if required
#exportloc = File.dirname(WSApplication.script_file)
exportloc = 'C:/Users/HLewis/Downloads/ruby_infonet/0001_odec_export_ex_shp/'

options=Hash.new

# Default = nil
#options['Callback Class'] = nil
options['Callback Class'] = Exporter
#options['Error File'] = File.dirname(WSApplication.script_file)+'ErrorLog.txt'
#options['Error File'] = 'C:/Users/HLewis/Downloads/ruby_infonet/0001_odec_export_ex_shp_errorlog.txt'
#options['Image Folder'] = nil

# Native or User  Default = Native
#options['Units Behaviour'] = 'Native'

# Boolean, True to export in 'report mode'  Default = FALSE
#options['Report Mode'] = false

# Boolean, True to enable 'Append to existing data'  Default = FALSE
#options['Append'] = false

# Boolean, True to export the selected objects only  Default = FALSE
#options['Export Selection'] = false		

# Integer, Previous version, if not zero differences are exportedy Default = 0
#options['Previous Version'] = false

# Boolean  Default = FALSE
#options['WGS84'] = true					
#options['Don’t Update Geometry'] = true

nw.odec_export_ex(
	'SHP',                      # Export data format = SHP File
	config,         			# Field mapping config file
	options,                   	# Specified options override the default options
	'node',                     # InfoAsset table to export
	exportloc+'node.SHP',		# Export destination file
)

nw.odec_export_ex(
	'SHP',
	config,
	options,
	'pipe',
	exportloc+'pipe.SHP',
)

nw.odec_export_ex(
	'SHP',
	config,
	options,
	'cctvsurvey',
	exportloc+'cctvsurvey.SHP',
)
