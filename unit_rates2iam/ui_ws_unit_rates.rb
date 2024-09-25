# update fields within current geoplan network with unit rate estimates

# notes: 

## libraries
require 'date'

## connection
db=WSApplication.current_database 
net=WSApplication.current_network

puts ".... connection established"

## open up network for writing
net.clear_selection
net.transaction_begin

## parameters
curyear = Time.now.strftime('%Y').to_i
valyear = 2023
source = 'OAS 2024-020 DR - QLDC - Final 3W Valuation.pdf'
flag = 'AS'

# set up array for CGI values
# this will enable old unit rates to be used for newer assessments
# and back calcs for installation costs where none are available

## looping and updating each asset
ro = net.row_objects('wams_pipe').each do |ro|

	### water supply use types
	if 
		ro.user_text_5 == '13 Lateral' ||
		ro.user_text_5 == 'feed for 508' || 
		ro.user_text_5 == 'Fountain Lateral 2' ||
		ro.user_text_5 == 'Fountain Lateral' ||
		ro.user_text_5 == 'Galv lateral' ||
		ro.user_text_5 == 'LATERAL' ||
		ro.user_text_5 == 'lateral for plot 40' ||
		ro.user_text_5 == 'lateral to #7' ||
		ro.user_text_5 == 'LATGRAV' ||
		ro.user_text_5 == 'LOT CONN,' ||
		ro.user_text_5 == 'PRIVATE' ||
		ro.user_text_5 == 'Private mains' ||	
		ro.user_text_5 == 'SERVICE' ||
		ro.user_text_5 == 'Service Lateral' ||
		ro.user_text_5 == 'SERVICE TAIL' ||
		ro.user_text_5 == 'SPRINKLER LATERAL' ||
		ro.user_text_5 == 'Water Lateral' ||
		ro.user_text_5 == 'Watersupply Lateral' ||
		ro.user_text_5 == 'WLAT #8' ||
		ro.user_text_5 == 'wsLateral' ||
		ro.user_text_5 == 'wsLaterial'
			use = 'SERV'
			use_flag = 'AS'
	elsif 
		ro.user_text_5 == 'Irrigation supply' || 
		ro.user_text_5 == 'Irrigation' || 
		ro.user_text_5 == 'Irrigation Lateral'
			use = 'SERV'
			use_flag = 'XX'	
	elsif 
		ro.user_text_5 == 'Air Line'
			use = 'SCOUR'
			use_flag = 'AS'	
	elsif 
		ro.user_text_5 == 'Pump Station Supply' ||
		ro.user_text_5 == 'RACE' ||
		ro.user_text_5 == 'Sewer Pump Station' ||
		ro.user_text_5 == 'Spray Water Supply' ||
		ro.user_text_5 == 'SUPPLY' ||
		ro.user_text_5 == 'Supply to Hydrants' ||
		ro.user_text_5 == 'Hydrant Supply'
			use = 'SUPPLY'
			use_flag = 'AS'
	elsif 
		ro.user_text_5 == 'RISEFALL' ||
		ro.user_text_5 == 'RISING' ||
		ro.user_text_5 == 'Water' ||
		ro.user_text_5 == 'WATER LINE' ||
		ro.user_text_5 == 'Water Pipe' ||
		ro.user_text_5 == 'MAIN' ||
		ro.user_text_5 == 'FALL'
			use = 'DIST'
			use_flag = 'AS'
	elsif 
		ro.user_text_5 == 'RIDER'
			use = 'DIST'
			use_flag = 'XX'	
	elsif 
		ro.user_text_5 == 'TRUNK'
			use = 'TRUNK'
			use_flag = 'AS'
	else
		use = 'Unknown' 
		use_flag = 'XX'
	end
	
	ro['use'] = use
	ro['use_flag'] = use_flag

	### water supply pipe types
	### options include: AQUA (aquaduct), GRAV (gravity), PUMP (pumped), 
	### PUMPGRAV (pumped and gravity), RIS (rising), TUNNEL (tunnel) and Unknown

	if ro.user_text_5 == 'RISEFALL'
		type = 'PUMPGRAV'
		type_flag = 'AS'
	elsif ro.user_text_5 == 'RISING'
		type = 'RIS'
		type_flag = 'AS'
	elsif ro.user_text_5 == 'FALL'
		type = 'GRAV'
		type_flag = 'AS'
	else
		type = 'PUMP'
		type_flag = 'AS'
	end

	ro['type'] = type
	ro['type_flag'] = type_flag

	### unit rates for water supply laterals (or service pipes)
	
	size = ro.nominal_diameter.to_i
	length = ro.length.to_f
	
	if size > 0
		size_nd = size
	elsif use = 'SERV'
		size_nd = 20
	else
		size_nd = 50
	end
	
	serv_size = [20, 50, 63, 100, 10000]
	serv_cost = [207.77, 213.99, 257.54, 277.44, 518.81]
	main_size = [50,75,100,125,140,150,200,225,250,289,366,407,456,10000]
	main_cost = [298.91,230.55,282.83,298.91,558.97,562.98,562.98,722.49,664.86,667.54,768.08,857.88,1032.14,1238.57]
	
	if use == 'SERV'
		index = serv_size.index{ |x| x >= size_nd}
		rate = serv_cost[index]
	else
		index = main_size.index{ |x| x >= size_nd}	
		rate = main_cost[index]
	end
	
	ro['replace_cost'] = rate * length
	ro['replace_cost_flag'] = 'AS'

ro.write

end

## final commit
net.transaction_commit

puts ".... network committed and data saved"