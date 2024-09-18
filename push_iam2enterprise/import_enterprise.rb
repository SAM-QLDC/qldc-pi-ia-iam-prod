# wastewater_export.rb
# ==============================================================

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod\push_iam2enterprise'

## user interface
net=WSApplication.current_network

## subset of tables to export
export_tables = ['cams_pipe','cams_cctv_survey']

# Export GIS files
gis_options=Hash.new
gis_options['Tables'] = export_tables
net.GIS_export('MIF', gis_options, folder + "/exports/MIF/")

# Export CSV files for full network
csv_options=Hash.new
csv_options['Use Display Precision'] = false
csv_options['Flag Fields '] = false
csv_options['Multiple Files'] = true
csv_options['Selection Only'] = false
csv_options['Coordinate Arrays Format'] = 'Packed'
csv_options['Other Arrays Format'] = 'Separate'
csv_options['WGS84'] = false
net.csv_export(folder + "/exports/CSV/network.csv", csv_options)

# Export GDB files for full network

# Run the second batch file
system(folder + '/import_enterprise_network.bat')
system(folder + '/import_enterprise_defects.bat')