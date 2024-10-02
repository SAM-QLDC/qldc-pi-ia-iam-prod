# INTERFACE SCRIPT
# Export snapshot file from network

# Network variables and WSOpenNetwork conversion to WSModelObject
net = WSApplication.current_network
mo = net.model_object

# Set the path and txt files that contain the imported and/or exported snapshot file
path = 'C:/Users/HLewis/Downloads/ruby_infonet/0004_snapshot_export/'
imported_file = 'imported.isfm'
exported_file = 'exported.isfm'

# Select mode (1) Export or (2) Import
mode = 1

# Example 1: Export snapshot from current network
if mode == 1
	filename = 'C:/Users/HLewis/Downloads/ruby_infonet/0004_snapshot_export/exported.isfm'
	net.snapshot_export(filename)
end