# EXPORT MODEL NETWORK AS SHAPE FILES

# Import the 'date' library
require 'date'

# ===========================================================================================
# parameters
$working_dir = "C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_icm\\export_icm_sim_results"
$dbase="//10.0.29.43:40000/wastewater FY2324/20240212 WCC Miramar Live Sewer Modelling Trial"

# arrays ready for looping
#array = [100]
#name = ["sim"]
#index = 0

# get hold of arcgis licence
WSApplication.use_arcgis_desktop_licence

# set the sim to use
db = WSApplication.open($dbase,false)
net = db.model_object_from_type_and_id "Sim",113
status1 = net.status
success1 = net.success_substatus

# Ensure there's more than one timestep before proceeding
ts_size = net.list_timesteps.count
ts = net.list_timesteps
if ts.size <= 1
	puts "Not enough timesteps available!"
	return
end
	puts "Enough timesteps available!"

# Export 

# Create a hash for the export options override the defaults
param_options=Hash.new

#param_options['Tables']
#param_options['2DZoneSQL']
#param_options['AlternativeNaming']
#param_options['ExportMaxima']
#param_options['Feature Dataset']
#param_options['Threshold']
#param_options['UseArcGISCompatibility']

#param_options['Tables'] = ['_2Delements', '_links', 'hw_1d_results_point', 'hw_2d_bridge'
#'hw_2d_linear_structure', 'hw_2d_results_line', 'hw_2d_results_point'
#'hw_2d_results_polygon', 'hw_2d_sluice', 'hw_bridge', 'hw_bridge_opening', 
#'hw_node', 'hw_river_reach', 'hw_subcatchment'
#'hw_tvd_connector']
param_options['Tables'] = ['hw_node', '_links', 'hw_subcatchment']

net.results_GIS_export(
	"MIF", 							# options include: SHP, TAB. MIF and GDB
	"Max", 							# options include: nil, All, Max, Integer 'Fixnum', Array of integers 
	param_options, 					# options include: nil or hashed
	$working_dir + "\\exports")