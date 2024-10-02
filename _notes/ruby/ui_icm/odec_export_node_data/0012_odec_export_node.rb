#require date

# Sets the current directory to a user defined location

Dir.chdir 'C:/Users/HLewis/Downloads/ruby_odec_export'
cfg_file = './0012_odec_export_node.cfg'
#export_date = DateTime.now.strftime("%Y%d%m%H%S")
export_date = "202307131017"

# Network variables and WSOpenNetwork conversion to WSModelObject
net = WSApplication.current_network
mo = net.model_object

# ODEC method options
options=Hash.new
options['Error File'] = './0012_odec_export_node_errors.txt'
#options['Export Selection'] = true

# Export (with timer)
outputs = Array.new
outputs << 'CSV'
outputs << 'MIF'

tables = Array.new
tables << 'Conduit'
tables << 'Subcatchment'
tables << 'Polygon'

outputs.each do |output|
    tables.each do |table|
        puts "#{table} - #{output} export commenced: #{export_date}"
        file_name = "#{export_date} #{mo.name} - #{table}"
        net.odec_export_ex(output, cfg_file, options, table, file_name + ('.csv' if output == 'CSV').to_s)
        puts "=> Exported file: \"#{Dir.getwd}/#{file_name}\""
        puts "#{table} - #{output} export complete: #{export_date}"
        puts ''
    end
end