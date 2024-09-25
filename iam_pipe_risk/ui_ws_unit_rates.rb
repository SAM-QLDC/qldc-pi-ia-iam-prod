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
source = 'OAS 2024-020 DR - QLDC - Final 3W Valuation.pdf'
flag_calc = 'AS'
flag_unsure = 'XX'

### latest unit rates
valyear = 2023
curyear = Time.now.strftime('%Y').to_i
cgi_uplift = 1.000
on_cost = 1.262
serv_size = [20,50,63,100,10000]
serv_cost = [207.77,213.99,257.54,277.44,518.81]
main_size = [
	50,75,100,125,140,
	150,200,225,250,289,
	366,407,456,10000
	]
main_cost = [
	298.91,230.55,282.83,298.91,558.97,
	562.98,562.98,722.49,664.86,667.54,
	768.08,857.88,1032.14,1238.57
	]
backflow_nrv = 13273.05
backflow_2xcv = 13273.05
hydrant_fire = 3845.73 
hydrant_na = 3845.73 
meter_na = 837.78 
meter_tbd = 837.78
meter_bulk = 837.78
valve_tbd = 927.59
valve_toby = 927.59
valve_line = 927.59
meter_dom = 837.78

# set up array for CGI values
# this will enable old unit rates to be used for newer assessments
# and back calcs for installation costs where none are available

## looping and updating each asset
ro = net.row_objects('wams_pipe').each do |ro|

	### water supply lifetimes from old IAM networks
	if ro.material == 'AC'
		lifetime = 60
	elsif 
		ro.material == 'ALK' || 
		ro.material == 'ALKATHENE'
			lifetime = 70
	elsif ro.material == 'CI'
		lifetime = 60
	elsif ro.material == 'CLDI'
		lifetime = 80
	elsif ro.material == 'CLSTEEL'
		lifetime = 80	
	elsif ro.material == 'CONC'
		lifetime = 60
	elsif ro.material == 'COP'
		lifetime = 80
	elsif ro.material == 'DI'
		lifetime = 80
	elsif ro.material == 'EPOXYPE'
		lifetime = 50
	elsif ro.material == 'GI'
		lifetime = 80
	elsif ro.material == 'HDPE'
		lifetime = 70
	elsif 
		ro.material == 'MDPE' || 
		ro.material == 'MDPE PN9'
			lifetime = 80
	elsif ro.material == 'MPVC'
		lifetime = 80
	elsif ro.material == 'NOVA'
		lifetime = 80
	elsif 
		ro.material == 'PE' || 
		ro.material == 'PE100' || 
		ro.material == 'PE80' || 
		ro.material == 'PE80B' || 
		ro.material == 'POLYETHYLE'
			lifetime = 80	
	elsif ro.material == 'PP'
		lifetime = 70
	elsif 
		ro.material == 'PVC' || 
		ro.material == 'PVCo' || 
		ro.material == 'PVCO'
			lifetime = 80
	elsif ro.material == 'SSTEEL'
		lifetime = 80
	elsif ro.material == 'STEEL'
		lifetime = 60
	elsif 
		ro.material == 'UPVC' || 
		ro.material == 'UPVCLINE'
			lifetime = 80
	else
		lifetime = 70
	end

	if ro.date_installed == nil
		age = ((curyear + 1) - 2020).to_i
	else
		age = (curyear + 1) - ro.date_installed.strftime('%Y').to_i
	end
	
	percRUL = (age.to_f / lifetime.to_f) * 100
	
	if percRUL <= 57
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = 'AS'
		ro['likelihood_score'] = 1
		ro['likelihood_score_flag'] = 'AS'
	elsif percRUL <= 66
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = 'AS'
		ro['likelihood_score'] = 2
		ro['likelihood_score_flag'] = 'AS'
	elsif percRUL <= 75
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = 'AS'
		ro['likelihood_score'] = 3
		ro['likelihood_score_flag'] = 'AS'
	elsif percRUL <= 93
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = 'AS'
		ro['likelihood_score'] = 4	
		ro['likelihood_score_flag'] = 'AS'
	else
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = 'AS'
		ro['likelihood_score'] = 5
		ro['likelihood_score_flag'] = 'AS'
	end
	
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
		ro.user_text_5 == 'wsLaterial' ||
		ro.user_text_5 == 'RIDER'
			use = 'SERV'
			use_flag = flag_calc
	elsif 
		ro.user_text_5 == 'Irrigation supply' || 
		ro.user_text_5 == 'Irrigation' || 
		ro.user_text_5 == 'Irrigation Lateral'
			use = 'SERV'
			use_flag = flag_unsure	
	elsif 
		ro.user_text_5 == 'Air Line'
			use = 'SCOUR'
			use_flag = flag_calc	
	elsif 
		ro.user_text_5 == 'Pump Station Supply' ||
		ro.user_text_5 == 'RACE' ||
		ro.user_text_5 == 'Sewer Pump Station' ||
		ro.user_text_5 == 'Spray Water Supply' ||
		ro.user_text_5 == 'SUPPLY' ||
		ro.user_text_5 == 'Supply to Hydrants' ||
		ro.user_text_5 == 'Hydrant Supply'
			use = 'SUPPLY'
			use_flag = flag_calc
	elsif 
		ro.user_text_5 == 'RISEFALL' ||
		ro.user_text_5 == 'RISING' ||
		ro.user_text_5 == 'Water' ||
		ro.user_text_5 == 'WATER LINE' ||
		ro.user_text_5 == 'Water Pipe' ||
		ro.user_text_5 == 'MAIN' ||
		ro.user_text_5 == 'FALL'
			use = 'DIST'
			use_flag = flag_calc
	elsif 
		ro.user_text_5 == 'TRUNK'
			use = 'TRUNK'
			use_flag = flag_calc
	else
		use = 'Unknown' 
		use_flag = flag_unsure
	end
	
	ro['use'] = use
	ro['use_flag'] = use_flag

	### water supply pipe types
	### options include: AQUA (aquaduct), GRAV (gravity), PUMP (pumped), 
	### PUMPGRAV (pumped and gravity), RIS (rising), TUNNEL (tunnel) and Unknown

	if ro.user_text_5 == 'RISEFALL'
		type = 'PUMPGRAV'
		type_flag = flag_calc
	elsif ro.user_text_5 == 'RISING'
		type = 'RIS'
		type_flag = flag_calc
	elsif ro.user_text_5 == 'FALL'
		type = 'GRAV'
		type_flag = flag_calc
	else
		type = 'PUMP'
		type_flag = flag_calc
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
	
	if use == 'SERV'
		index = serv_size.index{ |x| x >= size_nd}
		rate = serv_cost[index]
	else
		index = main_size.index{ |x| x >= size_nd}	
		rate = main_cost[index]
	end
	
	ro['replace_cost'] = rate * length
	ro['replace_cost_flag'] = flag_calc

ro.write

end

## final commit
net.transaction_commit

puts ".... network committed and data saved"