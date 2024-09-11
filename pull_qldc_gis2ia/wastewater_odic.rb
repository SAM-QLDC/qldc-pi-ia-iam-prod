# wastewater_odic.rb
# ===========================================================================================
#

folder = 'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia'

net=WSApplication.current_network

puts 'Start import'

# Set up params
csv_options=Hash.new
csv_options['Use Display Precision'] = false
csv_options['Flag Fields '] = false
csv_options['Multiple Files'] = true
csv_options['Selection Only'] = false
csv_options['Coordinate Arrays Format'] = 'Packed'
csv_options['Other Arrays Format'] = 'Separate'
csv_options['WGS84'] = false
csv_options['Duplication Behaviour'] = 'Overwrite'
csv_options['Delete Missing Objects'] = true
csv_options['Update Links From Points'] = false
csv_options['Default Value Flag'] = '#S'
csv_options['Set Value Flag'] = '#A'

## Action the Import using odic_import_ex
net.odic_import_ex('CSV',
	folder + '\wastewater_config.cfg',
	csv_options, 'node',
	folder + '\exports\wwManhole.csv'
	)
puts 'wwManhole import completed'

# clear selection
net.clear_selection