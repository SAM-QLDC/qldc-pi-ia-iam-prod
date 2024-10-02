# Script to export/import all network features from the masterdata networks to the validation networks
#require 'date'
#
#class Importer
#	def Importer.OnEndRecordCCTVSurvey(obj)
#		obj['user_date_1'] = Date.today
#	end
#end
begin
#********************************
# Database and network settings
#
#db = WSApplication.open('10.106.2.52:40000/InfoNet_Pims',true)		# open an InfoNet database
# Target Networks
nw=WSApplication.current_network	# get the network from the object type and id // >Non-core Networks>NET>Projects>Criticality assessments>VHCACA - Wastewater>VHCACA Wastewater VHCACA Wastwater network 
#ns = db.model_object_from_type_and_id('Collection Network',9)		# get the network from the object type and id
# Set Options
options=Hash.new
options['Error File'] = 'V:\\Digitisation VHCA\\Wincan\\CCTV_import_Log.txt'
#options['Callback Class'] = Importer
options['Set Value Flag'] = 'CCTV'
options['Default Value Flag'] = ''
options['Image Folder'] = ''
options['Duplication Behaviour'] = 'Overwrite'
options['Units Behaviour'] = 'Native'
#options['Update Based On Asset ID'] = false
#options['Update Only'] = false
#options['Delete Missing Objects'] = false
options['Allow Multiple Asset Ids'] = false
#options['Update Links From Points'] = false
#options['Blob Merge'] = false
#options['Use Network Naming Conventions'] = false
#options['Import Images'] = false
#********************************
# Survey Header Import
nw.odic_import_ex(
'CSV',									# import data format => comma separated values
'V:\Digitisation VHCA\Wincan\Wincan import.cfg',					# field mapping config file
options,								# specified options override the default options
# table group
'cctvsurvey',								# InfoNet table to import to
'V:\Digitisation VHCA\Wincan\OUTPUTS FME CSV FILE IMPORT\CCTV Headers.csv'				# source filepath and filename
)
puts " CCTV Headers - DONE"
#********************************
# Survey Details Import
nw.odic_import_ex(
'CSV',									# import data format => comma separated values
'V:\Digitisation VHCA\Wincan\Wincan import.cfg',							# field mapping config file
options,								# specified options override the default options

# table group
'cctvsurveydetails',							# InfoNet table to import to
'V:\Digitisation VHCA\Wincan\OUTPUTS FME CSV FILE IMPORT\CCTV Details.csv'						# source filepath and filename
)
puts " Details - DONE"
end