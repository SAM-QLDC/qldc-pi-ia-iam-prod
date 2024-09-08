begin

def print_names(folder = 'c:\github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia')
  puts folder
end

nw=WSApplication.current_network

## Set options for import
options=Hash.new													## Type | Default | Notes
#options['Error File'] = folder + '\temp\wastewater_error_log.txt'	## String | blank | Path of error file
#options['Callback Class'] = ImporterClass							## String | blank | Class used for Ruby callback methods (ICM & InfoAsset only)
#options['Set Value Flag'] = 'GDB'									## String | blank | Flag used for fields set from data
#options['Default Value Flag'] = 'GDB'								## String | blank | Flag used for fields set from the default value column
#options['Image Folder'] = 'C:\Temp\'								## String | blank | Folder to import images from (Asset networks only)
#options['Duplication Behaviour'] = 'Merge'							## String | Merge | One of Duplication Behaviour:'Overwrite','Merge','Ignore'
#options['Units Behaviour'] = 'Native'								## String | Native | One of 'Native','User','Custom'
#options['Update Based On Asset ID'] = false						## Boolean | false
#options['Update Only'] = false										## Boolean | false
#options['Delete Missing Objects'] = false							## Boolean | false
#options['Allow Multiple Asset IDs'] = false						## Boolean | false
#options['Update Links From Points'] = false						## Boolean | false
#options['Blob Merge'] = false										## Boolean | false
#options['Use Network Naming Conventions'] = false					## Boolean | false
#options['Import images'] = false									## Boolean | false | Asset networks only
#options['Group Type'] = false										## Boolean | false | Asset networks only
#options['Group Name'] = false										## Boolean | false | Asset networks only

## Action the Import using odic_import_ex
nw.odic_import_ex('GDB',
'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia\wastewater_config.cfg',
options,'node','NodeClass',
'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia\wastewater.gdb')

nw.odic_import_ex('GDB',
'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia\wastewater_config.cfg',
options,'pipe','PipeClass',
'C:\Github\qldc-pi-ia-iam-prod\pull_qldc_gis2ia\wastewater.gdb')

puts 'Import from GDB completed'