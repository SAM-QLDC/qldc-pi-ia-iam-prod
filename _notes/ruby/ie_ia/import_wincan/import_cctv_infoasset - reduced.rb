begin

nw=WSApplication.current_network
options=Hash.new
options['Error File'] = 'V:\\Digitisation VHCA\\Wincan\\CCTV_import_Log.txt'
options['Set Value Flag'] = 'CCTV'
options['Default Value Flag'] = ''
options['Image Folder'] = ''
options['Duplication Behaviour'] = 'Overwrite'
options['Units Behaviour'] = 'Native'
options['Allow Multiple Asset Ids'] = false

#********************************
# Survey Header Import

nw.odic_import_ex('CSV'
	, 'V:\Digitisation VHCA\Wincan\Wincan import.cfg'
	, options
	, 'cctvsurvey'
	, 'V:\Digitisation VHCA\Wincan\OUTPUTS FME CSV FILE IMPORT\CCTV Headers.csv'
)
puts " CCTV Headers - DONE"

#********************************
# Survey Details Import

nw.odic_import_ex('CSV'
	, 'V:\Digitisation VHCA\Wincan\Wincan import.cfg'
	, options
	, 'cctvsurveydetails'
	, 'V:\Digitisation VHCA\Wincan\OUTPUTS FME CSV FILE IMPORT\CCTV Details.csv'
)
puts " Details - DONE"
end