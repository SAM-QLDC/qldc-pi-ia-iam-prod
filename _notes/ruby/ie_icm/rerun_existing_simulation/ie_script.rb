$dbase = '//10.0.29.43:40000/wastewater FY2324/20240212 WCC Miramar Live Sewer Modelling Trial'
$db=WSApplication.open $dbase,false
#$group = '>MODG~sims2' # this one works as it doesnt use TSDB data
$group = '>MODG~sims' # this one doesnt work as it uses TSDB data

# Rerun all sims in the Model Group

$group=$db.model_object $group
$group.children.each do |run|
	$sims_array = Array.new
	if run.type=='Run'
		run.children.each { |sim| $sims_array << sim }
		WSApplication.connect_local_agent(1)
		WSApplication.launch_sims $sims_array,'.',false,0,0
	end
end
while $sims_array.any? { |sim| sim.status=='None' } 
	puts  'running'
	sleep 1
end