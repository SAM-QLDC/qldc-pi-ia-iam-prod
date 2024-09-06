# Export to Snapshot File via snapshot_export_ex method

# do a check here for network type
# ie check if is a distribution network

exportloc = WSApplication.file_dialog(
	false,
	'isfd',
	'Distribution Network Snapshot File',
	'snapshot',
	false,
	false)
	
if exportloc==nil
	WSApplication.message_box('Export location required','OK','!',nil)
else

nw=WSApplication.current_network

# Create an array for the tables to be exported
export_tables = []

# Create a hash for the export options override the defaults
exp_options=Hash.new
exp_options['IncludeImageFiles'] = true
exp_options['Tables'] = export_tables

# Export
nw.snapshot_export_ex(exportloc, exp_options)

end