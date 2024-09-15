# update fields within current geoplan network with estimated condition grades

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

## looping and updating each asset
ro = net.row_objects('cams_pipe').each do |ro|

	if ro.pipe_material == 'UPVC'
		lifetime = 100
	elsif ro.pipe_material == 'PVC'
		lifetime = 100
	elsif ro.pipe_material == 'VC'
		lifetime = 120
	elsif ro.pipe_material == 'AC'
		lifetime = 65
	elsif ro.pipe_material == 'CP'
		lifetime = 90
	elsif ro.pipe_material == 'MPVC'
		lifetime = 100	
	elsif ro.pipe_material == 'CLS'
		lifetime = 90		
	elsif ro.pipe_material == 'HDPE'
		lifetime = 100	
	elsif ro.pipe_material == 'MDPE'
		lifetime = 100	
	elsif ro.pipe_material == 'SS'
		lifetime = 80	
	elsif ro.pipe_material == 'XXX'
		lifetime = 70
	elsif ro.pipe_material == 'CI'
		lifetime = 80
	elsif ro.pipe_material == 'FB'
		lifetime = 65
	elsif ro.pipe_material == 'ALK'
		lifetime = 70
	elsif ro.pipe_material == 'PE'
		lifetime = 100
	elsif ro.pipe_material == 'PP'
		lifetime = 100
	elsif ro.pipe_material == 'DI'
		lifetime = 100
	else
		lifetime = 80
	end

	if ro.year_laid == nil
		age = ((curyear + 1) - 2020).to_i
	else
		age = (curyear + 1) - ro.year_laid.strftime('%Y').to_i
	end
	
	percRUL = (age.to_f / lifetime.to_f) * 100
	
	if percRUL <= 57
		ro['likelihood_score'] = 1
		ro['likelihood_score_flag'] = 'AS'
	elsif percRUL <= 66
		ro['likelihood_score'] = 2
		ro['likelihood_score_flag'] = 'AS'
	elsif percRUL <= 75
		ro['likelihood_score'] = 3
		ro['likelihood_score_flag'] = 'AS'
	elsif percRUL <= 93
		ro['likelihood_score'] = 4	
		ro['likelihood_score_flag'] = 'AS'
	else
		ro['likelihood_score'] = 5
		ro['likelihood_score_flag'] = 'AS'
	end
	
ro.write

end

## final commit
net.transaction_commit

puts ".... network committed and data saved"