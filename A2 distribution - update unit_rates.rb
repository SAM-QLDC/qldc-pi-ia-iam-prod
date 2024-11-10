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
valyear = 2024
unityear = 2022
curyear = Time.now.strftime('%Y').to_i

### cost index changes
cgi_year = [
	1800,1914,1915,1916,1917,1918,1919,
	1920,1921,1922,1923,1924,1925,1926,1927,1928,1929,
	1930,1931,1932,1933,1934,1935,1936,1937,1938,1939,
	1940,1941,1942,1943,1944,1945,1946,1947,1948,1949,
	1950,1951,1952,1953,1954,1955,1956,1957,1958,1959,
	1960,1961,1962,1963,1964,1965,1966,1967,1968,1969,
	1970,1971,1972,1973,1974,1975,1976,1977,1978,1979,
	1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,
	1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,
	2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,
	2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,
	2020,2021,2022,2023,2024]

cgi_index = [
	1,8,8,8.6,9.4,10.5,11.6,
	13.1,13.2,11.9,11.7,11.9,12,12.1,12,12,12,
	11.8,10.9,10,9.5,9.6,10,10.3,11,11.3,11.8,
	12.3,12.8,13.2,13.5,13.7,13.9,14,14.5,15.6,
	15.9,16.8,18.7,20.1,21,22,22.6,23.4,23.9,25,
	26,26.2,26.7,27.4,27.9,28.9,29.9,30.7,32.6,
	34,35.7,38,41.9,44.8,48.5,53.9,61.8,72.2,
	82.6,92.5,105.2,123.2,142.1,165.1,177.2,
	188.1,217.1,245.8,284.5,302.6,319.9,339.4,
	361.3,361,359,367.8,377.6,381.8,382.8,389.8,
	396.5,415.6,436.8,446.8,456.3,481.7,534,558.2,
	576.4,612.3,658.5,679.9,712.1,726.2,643.9,
	675.9,697.6,699.8,704.2,767.9,784.5,800.8,
	850.8,966.7,1026.8,1049]
	
### uplift factors
index_unityear = cgi_year.index{ |x| x >= unityear}
ci_unityear = cgi_index[index_unityear]
index_valyear = cgi_year.index{ |x| x >= valyear}
ci_valyear = cgi_index[index_valyear]

on_cost_valuation_year = (ci_valyear.to_f/ci_unityear.to_f)
on_cost_network = 1.262
on_cost_facilities = 1.259

flag_calc = 'VAL'
flag_unsure = 'XX'

### depth factor increases
#depth_m = [0.5,1,2,10000]
#depth_cost_factor = [1,1,1,1]

### latest unit rates
serv_size = [20,50,63,100,10000]
serv_cost = [207.77,213.99,257.54,277.44,518.81]
serv_cost_road = [207.77,213.99,257.54,277.44,518.81]

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
main_cost_road = [
	298.91,230.55,282.83,298.91,558.97,
	562.98,562.98,722.49,664.86,667.54,
	768.08,857.88,1032.14,1238.57
	]

# unit costs for non-pipe assets
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

# lifetimes for various point assets
hydrant_lifetime = 70
meter_lifetime = 20
valve_lifetime = 20
backflow_lifetime = 30    #guessed
fitting_lifetime = 40

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

	if ro.date_installed == nil || ro.date_installed.strftime('%Y').to_i < 1910
		year_installed = 2000
	else
		year_installed = ro.date_installed.strftime('%Y').to_i
	end

	if ro.date_installed == nil
		age = ((curyear + 1) - 2020).to_i
	else
		age = (curyear + 1) - year_installed
	end
	
	percRUL = (age.to_f / lifetime.to_f) * 100
	
	if percRUL <= 57
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = flag_calc
		ro['likelihood_score'] = 1
		ro['likelihood_score_flag'] = flag_calc
	elsif percRUL <= 66
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = flag_calc
		ro['likelihood_score'] = 2
		ro['likelihood_score_flag'] = flag_calc
	elsif percRUL <= 75
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = flag_calc
		ro['likelihood_score'] = 3
		ro['likelihood_score_flag'] = flag_calc
	elsif percRUL <= 93
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = flag_calc
		ro['likelihood_score'] = 4	
		ro['likelihood_score_flag'] = flag_calc
	else
		ro['lifetime'] = lifetime
		ro['lifetime_flag'] = flag_calc
		ro['likelihood_score'] = 5
		ro['likelihood_score_flag'] = flag_calc
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
	
	### pick out CPI figures for the install year and the current year
	index_year_installed = cgi_year.index{ |x| x >= year_installed}
	index_year_now = cgi_year.index{ |x| x >= valyear}
	ci_year_installed = cgi_index[index_year_installed]
	ci_year_now = cgi_index[index_year_now]
	
	replace_cost = length.to_f * rate.to_f * on_cost_network.to_f * on_cost_valuation_year.to_f
	installation_cost = (ci_year_installed.to_f/ci_year_now.to_f) * replace_cost.to_f
	current_value = (1-(age.to_f/lifetime.to_f)) * installation_cost.to_f
	
	if current_value < 0
		current_value_positive = 0
		current_value_positive_flag = flag_unsure
	else
		current_value_positive = current_value.to_i
		current_value_positive_flag = flag_calc
	end
	
	#### 
	ro['install_cost'] = installation_cost
	ro['current_value'] = current_value_positive
	ro['replace_cost'] = replace_cost
	ro['type'] = type
	ro['use'] = use
	# check on ci indexes
	#ro['user_number_7'] = on_cost_valuation_year
	
	ro['install_cost_flag'] = flag_calc
	ro['current_value_flag'] = current_value_positive_flag
	ro['replace_cost_flag'] = flag_calc
	ro['type_flag'] = type_flag
	ro['use_flag'] = use_flag
	
ro.write

end

## looping and updating each asset
fitting_ro = net.row_objects('wams_fitting').each do |fitting_ro|

	fitting_ro['install_cost'] = 0
	fitting_ro['current_value'] = 0
	fitting_ro['replace_cost'] = 0
	fitting_ro['lifetime'] = fitting_lifetime
	
	fitting_ro['install_cost_flag'] = flag_unsure
	fitting_ro['current_value_flag'] = flag_unsure
	fitting_ro['replace_cost_flag'] = flag_unsure
	fitting_ro['lifetime_flag'] = flag_unsure

fitting_ro.write

end

## looping and updating each hydrant asset
hydrant_ro = net.row_objects('wams_hydrant').each do |hydrant_ro|

	if hydrant_ro.date_installed == nil || hydrant_ro.date_installed.strftime('%Y').to_i < 1910
		year = 2000
		age = valyear - 2000
	else
		year = hydrant_ro.date_installed.strftime('%Y').to_i
		age = valyear - year
	end
	
	index_install_year = cgi_year.index{ |x| x >= year}
	ci_year_installed = cgi_index[index_install_year]
	
	index_year_now = cgi_year.index{ |x| x >= valyear}
	ci_year_now = cgi_index[index_year_now]	
	
	replace_cost = hydrant_na.to_f * on_cost_network.to_f * on_cost_valuation_year.to_f
	installation_cost = (ci_year_installed.to_f/ci_year_now.to_f) * replace_cost.to_f
	current_value = (1-(age.to_f/hydrant_lifetime.to_f)) * installation_cost.to_f
	
	if current_value < 0
		current_value_positive = 0
		current_value_positive_flag = flag_unsure
	else
		current_value_positive = current_value.to_i
		current_value_positive_flag = flag_calc
	end

	hydrant_ro['install_cost'] = installation_cost
	hydrant_ro['current_value'] = current_value_positive
	hydrant_ro['replace_cost'] = replace_cost
	hydrant_ro['lifetime'] = hydrant_lifetime
	
	hydrant_ro['install_cost_flag'] = flag_calc
	hydrant_ro['current_value_flag'] = current_value_positive_flag
	hydrant_ro['replace_cost_flag'] = flag_calc
	hydrant_ro['lifetime_flag'] = flag_calc

hydrant_ro.write

end

## looping and updating each meter asset
meter_ro = net.row_objects('wams_meter').each do |meter_ro|

	if meter_ro.date_installed == nil || meter_ro.date_installed.strftime('%Y').to_i < 1910
		year = 2000
		age = valyear - 2000
	else
		year = meter_ro.date_installed.strftime('%Y').to_i
		age = valyear - year
	end
	
	index_install_year = cgi_year.index{ |x| x >= year}
	index_year_now = cgi_year.index{ |x| x >= valyear}	
	ci_year_installed = cgi_index[index_install_year]
	ci_year_now = cgi_index[index_year_now]	

	unit_cost = meter_tbd
	
	replace_cost = unit_cost.to_f * on_cost_network.to_f * on_cost_valuation_year.to_f 
	installation_cost = (ci_year_installed.to_f/ci_year_now.to_f) * unit_cost.to_f * on_cost_network.to_f
	current_value = (1-(age.to_f/meter_lifetime.to_f)) * installation_cost.to_f
	
	if current_value < 0
		current_value_positive = 0
		current_value_positive_flag = flag_unsure
	else
		current_value_positive = current_value.to_i
		current_value_positive_flag = flag_calc
	end
	
	meter_ro['install_cost'] = installation_cost
	meter_ro['current_value'] = current_value_positive
	meter_ro['replace_cost'] = replace_cost
	meter_ro['lifetime'] = meter_lifetime

	meter_ro['install_cost_flag'] = flag_calc
	meter_ro['current_value_flag'] = current_value_positive_flag
	meter_ro['replace_cost_flag'] = flag_calc
	meter_ro['lifetime_flag'] = flag_calc

meter_ro.write

end

## looping and updating each meter asset
valve_ro = net.row_objects('wams_valve').each do |valve_ro|

	if valve_ro.date_installed == nil || valve_ro.date_installed.strftime('%Y').to_i < 1910
		year = 2000
		age = valyear - 2000
	else
		year = valve_ro.date_installed.strftime('%Y').to_i
		age = valyear - year
	end
	
	index_install_year = cgi_year.index{ |x| x >= year}
	index_year_now = cgi_year.index{ |x| x >= valyear}	
	ci_year_installed = cgi_index[index_install_year]
	ci_year_now = cgi_index[index_year_now]	

	unit_cost = valve_tbd	
	
	replace_cost = unit_cost.to_f * on_cost_network.to_f * on_cost_valuation_year.to_f 	
	installation_cost = (ci_year_installed.to_f/ci_year_now.to_f) * unit_cost.to_f * on_cost_network.to_f
	current_value = (1-(age.to_f/valve_lifetime.to_f)) * installation_cost.to_f

	if current_value < 0
		current_value_positive = 0
		current_value_positive_flag = flag_unsure
	else
		current_value_positive = current_value.to_i
		current_value_positive_flag = flag_calc
	end

	valve_ro['install_cost'] = installation_cost
	valve_ro['current_value'] = current_value_positive
	valve_ro['replace_cost'] = replace_cost
	valve_ro['lifetime'] = valve_lifetime
	
	valve_ro['install_cost_flag'] = flag_calc
	valve_ro['current_value_flag'] = current_value_positive_flag
	valve_ro['replace_cost_flag'] = flag_calc
	valve_ro['lifetime_flag'] = flag_calc

valve_ro.write

end

## final commit
net.transaction_commit

puts ".... network committed and data saved"