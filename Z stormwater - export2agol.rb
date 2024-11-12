# wastewater_export.rb
# ==============================================================

## parameters
folder = 'C:\Github\qldc-pi-ia-iam-prod'
data = '\fme\imports\iam_network\wastewater'

## user interface
net=WSApplication.current_network

# Export GIS files
gis_options_mif = Hash.new
gis_options_mif['SkipEmptyTables'] = true
#net.GIS_export('MIF',gis_options_mif,folder+data+'\MIF')

# Export GDB files for full network
gis_options_gdb = Hash.new
gis_options_gdb['ExportFlags'] = true
gis_options_gdb['SkipEmptyTables'] = true
#net.GIS_export('GDB',gis_options_gdb,folder+data+'\GDB\network.gdb')

# Export CSV files for full network
csv_options = Hash.new
csv_options['Error File'] = folder + data + '\CSV\ImportErrorLog.txt'
csv_options['Flag Fields '] = true
csv_options['Multiple Files'] = true
csv_options['Coordinate Arrays Format'] = 'Packed'
csv_options['Other Arrays Format'] = 'Separate'
net.csv_export(folder+data+'\CSV\network.csv',csv_options)

# Run the second batch file
#system(folder + '/import_enterprise_network.bat')
#system(folder + '/import_enterprise_defects.bat')