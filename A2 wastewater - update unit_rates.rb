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

## main parameters
source = 'OAS 2024-020 DR - QLDC - Final 3W Valuation.pdf'
curyear = Time.now.strftime('%Y').to_i	# not used however could be substited for valyear
valyear = 2024							# valuation year
unityear = 2022							# unit rates year
typyear = 2000							# typical year assets are installed
on_cost_network = 1.262					# general uplift for below ground assets
on_cost_facilities = 1.259				# general uplift for above ground assets
flag_calc = 'VAL'						# data flag used to show where the data has come from
flag_unsure = 'XX'						# data flag to show where iimprovements can be made

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
	
### valuation uplift factor
index_unityear = cgi_year.index{ |x| x >= unityear}
ci_unityear = cgi_index[index_unityear]
index_valyear = cgi_year.index{ |x| x >= valyear}
ci_valyear = cgi_index[index_valyear]
on_cost_valuation_year = (ci_valyear.to_f/ci_unityear.to_f)

### depth factor increases
#depth_m = [0.5,1,2,10000]
#depth_cost_factor = [1,1,1,1]

### latest unit rates
serv_size = [40,50,100,125,10000]
serv_cost = [214,210,273,452,467]

main_size = [40,50,60,106,110,150,200,250,300,375,10000]
main_cost = [214,210,259,272,451,466,557,698,776,918,7035]

# unit costs for non-pipe assets
ww_manhole_mh = 7000
ww_manhole_lh = 7000
ww_manhole_st = 7000
ww_valve = 8364

# lifetimes for various point assets
manhole_lifetime = 80
valve_lifetime = 20

# set up array for CGI values
# this will enable old unit rates to be used for newer assessments
# and back calcs for installation costs where none are available

## looping and updating each asset
ro = net.row_objects('cams_pipe').each do |ro|

	### wastewater lifetimes from old IAM network
	if 
		ro.pipe_material == 'ALK' ||
		ro.pipe_material == 'CI' ||
		ro.pipe_material == 'HDPE' ||
		ro.pipe_material == 'MDPE' ||
		ro.pipe_material == 'MPVC' ||
		ro.pipe_material == 'PE' ||
		ro.pipe_material == 'PE100' ||
		ro.pipe_material == 'POLYETHYLENE (PE100)' ||
		ro.pipe_material == 'POLYVINYL CHLORIDE' ||
		ro.pipe_material == 'PP' ||
		ro.pipe_material == 'PVC' ||
		ro.pipe_material == 'PVCO' ||
		ro.pipe_material == 'UPVC' ||
		ro.pipe_material == 'UPVCLINE' ||
		ro.pipe_material == 'STRUCTURAL LINER UPVC' ||
		ro.pipe_material == 'U - POLYVINYL CHLORIDE' ||
		ro.pipe_material == 'SSTEEL' ||
		ro.pipe_material == 'STAINLESS STEEL' ||
		ro.pipe_material == 'STEEL' ||
		ro.pipe_material == 'NOVA'
			lifetime = 80
	elsif 
		ro.pipe_material == 'EW'
			lifetime = 70
	elsif 
		ro.pipe_material == 'GI' ||
		ro.pipe_material == 'DI' ||
		ro.pipe_material == 'NOVA'
			lifetime = 60
	elsif 
		ro.pipe_material == 'AC' ||
		ro.pipe_material == 'FIBGLASS' ||
		ro.pipe_material == 'CLSTEEL' ||
		ro.pipe_material == 'CONC'
			lifetime = 50
	else
		lifetime = 80
	end

	if ro.year_laid == nil
		year_installed = typyear
	else
		year_installed = ro.year_laid.strftime('%Y').to_i
	end

	if ro.year_laid == nil
		age = ((curyear + 1) - typyear).to_i
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

	### unit rates
	size = ro.width.to_i
	length = ro.length.to_f
	pipe_type = ro.pipe_type
	pipe_owner = ro.owner
	
	if size > 0
		size_nd = size
	elsif pipe_type = 'TRUNK'
		size_nd = 300
	elsif pipe_type = 'RISING' && pipe_owner = 'QLDC'
		size_nd = 200
	elsif pipe_type = 'RISING'
		size_nd = 200
	elsif pipe_type = 'LATGRAV'
		size_nd = 50
	elsif pipe_type = 'SEWER' && pipe_owner = 'QLDC'
		size_nd = 125
	elsif pipe_type = 'SEWER'
		size_nd = 50
	else
		size_nd = 125
	end
	
	if pipe_type == 'LATGRAV' || pipe_type == 'LATPRES'
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
	
	rehab_cost = replace_cost - current_value_positive
	
	#### 
	ro['install_cost'] = installation_cost
	ro['current_value'] = current_value_positive
	ro['replace_cost'] = replace_cost
	ro['rehab_cost'] = rehab_cost
	
	ro['install_cost_flag'] = flag_calc
	ro['current_value_flag'] = current_value_positive_flag
	ro['replace_cost_flag'] = flag_calc
	ro['rehab_cost_flag'] = flag_calc
	
ro.write

end

## looping and updating each asset
cp = net.row_objects('cams_connection_pipe').each do |cp|

	### wastewater lifetimes from old IAM network
	if 
		cp.pipe_material == 'ALK' ||
		cp.pipe_material == 'CI' ||
		cp.pipe_material == 'HDPE' ||
		cp.pipe_material == 'MDPE' ||
		cp.pipe_material == 'MPVC' ||
		cp.pipe_material == 'PE' ||
		cp.pipe_material == 'PE100' ||
		cp.pipe_material == 'POLYETHYLENE (PE100)' ||
		cp.pipe_material == 'POLYVINYL CHLORIDE' ||
		cp.pipe_material == 'PP' ||
		cp.pipe_material == 'PVC' ||
		cp.pipe_material == 'PVCO' ||
		cp.pipe_material == 'UPVC' ||
		cp.pipe_material == 'UPVCLINE' ||
		cp.pipe_material == 'STRUCTURAL LINER UPVC' ||
		cp.pipe_material == 'U - POLYVINYL CHLORIDE' ||
		cp.pipe_material == 'SSTEEL' ||
		cp.pipe_material == 'STAINLESS STEEL' ||
		cp.pipe_material == 'STEEL' ||
		cp.pipe_material == 'NOVA'
			lifetime = 80
	elsif 
		cp.pipe_material == 'EW'
			lifetime = 70
	elsif 
		cp.pipe_material == 'GI' ||
		cp.pipe_material == 'DI' ||
		cp.pipe_material == 'NOVA'
			lifetime = 60
	elsif 
		cp.pipe_material == 'AC' ||
		cp.pipe_material == 'FIBGLASS' ||
		cp.pipe_material == 'CLSTEEL' ||
		cp.pipe_material == 'CONC'
			lifetime = 50
	else
		lifetime = 80
	end

	if cp.year_laid == nil
		year_installed = typyear
	else
		year_installed = cp.year_laid.strftime('%Y').to_i
	end

	if cp.year_laid == nil
		age = ((curyear + 1) - typyear).to_i
	else
		age = (curyear + 1) - year_installed
	end
	
	percRUL = (age.to_f / lifetime.to_f) * 100
	
	if percRUL <= 57
		cp['lifetime'] = lifetime
		cp['lifetime_flag'] = flag_calc
	elsif percRUL <= 66
		cp['lifetime'] = lifetime
		cp['lifetime_flag'] = flag_calc
	elsif percRUL <= 75
		cp['lifetime'] = lifetime
		cp['lifetime_flag'] = flag_calc
	elsif percRUL <= 93
		cp['lifetime'] = lifetime
		cp['lifetime_flag'] = flag_calc
	else
		cp['lifetime'] = lifetime
		cp['lifetime_flag'] = flag_calc
	end

	diameter = cp.diameter.to_i
	pipe_length = cp.length.to_f

	### unit rates
	if diameter > 0
		size = cp.diameter.to_i
	else
		size = 100
	end
	
	if pipe_length > 0
		length = cp.length.to_f
	else
		length = 5
	end

	index = serv_size.index{ |x| x >= size}
	rate = serv_cost[index]

	### pick out CPI figures for the install year and the current year
	index_year_installed = cgi_year.index{ |x| x >= year_installed}
	index_year_now = cgi_year.index{ |x| x >= valyear}
	ci_year_installed = cgi_index[index_year_installed]
	ci_year_now = cgi_index[index_year_now]
	
	replace_cost = length.to_f * rate.to_f * on_cost_network.to_f * on_cost_valuation_year.to_f
	installation_cost = (ci_year_installed.to_f/ci_year_now.to_f) * replace_cost.to_f
	current_value = (1-(age.to_f/lifetime.to_f)) * installation_cost.to_f
	
	if current_value > 0
		current_value_positive = current_value
		current_value_positive_flag = flag_calc	
	else
		current_value_positive = 0
		current_value_positive_flag = flag_unsure
	end
	
	rehab_cost = replace_cost - current_value_positive
	
	#### 
	cp['replace_cost'] = replace_cost
	cp['install_cost'] = installation_cost
	cp['current_value'] = current_value_positive
	cp['rehab_cost'] = rehab_cost
	
	cp['replace_cost_flag'] = flag_calc
	cp['install_cost_flag'] = flag_calc
	cp['current_value_flag'] = current_value_positive_flag
	cp['rehab_cost_flag'] = flag_calc
	
cp.write

end

## looping and updating each manhole asset
manhole_ro = net.row_objects('cams_manhole').each do |manhole_ro|

	if manhole_ro.year_laid == nil
		year = typyear
		age = valyear - typyear
	else
		year = manhole_ro.year_laid.strftime('%Y').to_i
		age = valyear - year
	end
	
	index_install_year = cgi_year.index{ |x| x >= year}
	index_year_now = cgi_year.index{ |x| x >= valyear}	
	ci_year_installed = cgi_index[index_install_year]
	ci_year_now = cgi_index[index_year_now]
	
	node_type = manhole_ro.node_type
	
	if node_type == 'STOPV' || node_type == 'VALVE'
		unit_cost = ww_valve
		node_lifetime = valve_lifetime
	else
		unit_cost = ww_manhole_mh
		node_lifetime = manhole_lifetime
	end
	
	replace_cost = unit_cost.to_f * on_cost_network.to_f * on_cost_valuation_year.to_f 
	installation_cost = (ci_year_installed.to_f/ci_year_now.to_f) * unit_cost.to_f * on_cost_network.to_f
	current_value = (1-(age.to_f/node_lifetime.to_f)) * installation_cost.to_f
	
	if current_value < 0
		current_value_positive = 0
		current_value_positive_flag = flag_unsure
	else
		current_value_positive = current_value.to_i
		current_value_positive_flag = flag_calc
	end
	
	rehab_cost = replace_cost - current_value_positive
	
	manhole_ro['install_cost'] = installation_cost
	manhole_ro['current_value'] = current_value_positive
	manhole_ro['replace_cost'] = replace_cost
	manhole_ro['rehab_cost'] = rehab_cost
	manhole_ro['lifetime'] = node_lifetime

	manhole_ro['install_cost_flag'] = flag_calc
	manhole_ro['current_value_flag'] = current_value_positive_flag
	manhole_ro['replace_cost_flag'] = flag_calc
	manhole_ro['rehab_cost_flag'] = flag_calc
	manhole_ro['lifetime_flag'] = flag_calc

manhole_ro.write

end

## final commit
net.transaction_commit

puts ".... network committed and data saved"