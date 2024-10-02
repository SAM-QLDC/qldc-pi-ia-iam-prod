## Export Choice List values from the database/network

##call on the Ruby library CSV function
require 'csv'											

##open the CSV file and iterate through it
#CSV.open("c:\\temp\\choices.csv", "wb") do |csv|
CSV.open("C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_ia_export choice lists from infoasset\\choices.csv", "wb") do |csv|

	##use the current open network
	nw = WSApplication.current_network					
		##select the Field Choice ‘text’ codes for: CCTV Survey – Category Code
		fc = nw.field_choices('cams_cctv_survey','category_code')
		##select the Field Choice descriptions codes for: CCTV Survey – Category Code
		fd = nw.field_choice_descriptions('cams_cctv_survey','category_code')
		##this starts a counter, needed to iterate through all the values
		i=0
		##sets a table name variable for the export
		tbl='cams_cctv_survey'
		##sets a field name variable for the export
		col='category_code'
		
		##runs both fc & fd together
		if fc and fd then
			##runs through each fc to retrieve all values
			fc.each do | value|
			##where the output should go: to screen (“puts”) and what the output should be
			puts("""#{tbl}"",""#{col}"",""#{value}"",""#{fd[i]}""")
			##where the output should go: csv (“<<” inserts as an additional line) and what the output should be
			csv << ["#{tbl}", "#{col}", "#{value}", "#{fd[i]}"]
			##add 1 to the interaction counter
			i=i+1														
			end
		end
end