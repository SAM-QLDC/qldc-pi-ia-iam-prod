# update fields within current geoplan network with estimated condition grades

# notes: this ruby script is to be run on the eser interface ie the geoplan it will generate exepected lifetimes and and estimate based on Vaughan simplified condition rating table

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

	### water supply lifetimes from old IAM networks
	if ro.pipe_material == 'AC'
		lifetime = 60
	elsif ro.pipe_material == 'ALK' || ro.pipe_material == 'ALKATHENE'
		lifetime = 70
	elsif ro.pipe_material == 'CI'
		lifetime = 60
	elsif ro.pipe_material == 'CLDI'
		lifetime = 80
	elsif ro.pipe_material == 'CLSTEEL'
		lifetime = 80	
	elsif ro.pipe_material == 'CONC'
		lifetime = 60
	elsif ro.pipe_material == 'COP'
		lifetime = 80
	elsif ro.pipe_material == 'DI'
		lifetime = 80
	elsif ro.pipe_material == 'EPOXYPE'
		lifetime = 50
	elsif ro.pipe_material == 'GI'
		lifetime = 80
	elsif ro.pipe_material == 'HDPE'
		lifetime = 70
	elsif ro.pipe_material == 'MDPE' || ro.pipe_material == 'MDPE PN9'
		lifetime = 80
	elsif ro.pipe_material == 'MPVC'
		lifetime = 80
	elsif ro.pipe_material == 'NOVA'
		lifetime = 80
	elsif ro.pipe_material == 'PE' || ro.pipe_material == 'PE100' || ro.pipe_material == 'PE80' || ro.pipe_material == 'PE80B'
		lifetime = 80	
	elsif ro.pipe_material == 'PP'
		lifetime = 70
	elsif ro.pipe_material == 'PVC' || ro.pipe_material == 'PVCo'
		lifetime = 80
	elsif ro.pipe_material == 'SSTEEL'
		lifetime = 80
	elsif ro.pipe_material == 'STEEL'
		lifetime = 60
	elsif ro.pipe_material == 'UPVC'
		lifetime = 80
	else
		lifetime = 70
	end

	if ro.year_laid == nil
		age = ((curyear + 1) - 2020).to_i
	else
		age = (curyear + 1) - ro.year_laid.strftime('%Y').to_i
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
	
ro.write

end

## final commit
net.transaction_commit

puts ".... network committed and data saved"