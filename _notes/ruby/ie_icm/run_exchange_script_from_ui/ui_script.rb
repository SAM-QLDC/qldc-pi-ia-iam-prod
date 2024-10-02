$version = "2021.7"
$exchange_path = "C:/Program Files/Innovyze Workgroup Client #{$version}/IExchange.exe"

$param1 = "This is a string"
$param2 = WSApplication.current_network.model_object.name
$script_path = "C:/Users/HLewis/Downloads/innovyze_ruby_scripts/ui_icm_run exchange script from ui/ex_script.rb"

system("\"#{$exchange_path}\" \"#{$script_path}\" ICM \"#{$param1}\" \"#{$param2}\" & pause")