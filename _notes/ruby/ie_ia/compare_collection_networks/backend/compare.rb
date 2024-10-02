## IEXCHANGE CONFIG

$dbase = '//10.0.29.43:40000/wastewater FY2324.d/20230712 PCC Titahi Bay Flow Survey and Calibration'
$dest = 'C:\\Users\\HLewis\\Downloads\\export_icm_results\\export\\changes.csv'

## END OF IEXCHANGE CONFIG

## Open database
db=WSApplication.open($dbase)

## Network to use
net=db.model_object_from_type_and_id('Model Network',13)

## nno.csv_changes(commit_id1, commit_id2, filename)
net.csv_changes(70,80,$dest )