# Infoworks_ICM_to_Estry

This project contains a ruby script to be run in InfoWorks ICM which will export all tables to shapefile format for converting to Estry format using the TUFLOW Viewer 'Insert TUFLOW Attributes into existing GIS layers'.  The script also exports RTC to text files.

The ruby script can be run to call the Open Data Export Centre, and export all tables, using a specified config file automatically, significantly reducing the number of button clicks. 

# How to Export Data

To run the script, you’ll again need to run InfoWorks ICM with a viewer licence or greater. With the desired network in the geoplan, go to Network->Run Ruby Script. Navigate to and select the ruby script, in the below this is the ICM_Out_to_shp_AutoMap.rb available within this project.

![Run Ruby Script Dialog](/images/run_ruby_network.PNG "Run Ruby Script Dialog")

The script will then begin running and prompt the user to select a config file. Navigate and select the relevant config file.  An example is contained with the ICM_Config_Files directory although this can be edited by the user.

![Select Config File](/images/select_config.PNG "Select Config File")

The user will then be prompted where they would like to export the data too. Select an appropriate file directory. The ruby script will then cycle through the list of tables within the script and export the tables automatically. Once complete the script will return a log highlighting the location of the exported files. All network objects are exported regardless of system type. System type is exported as an additional field in the shape files to enable filtering within GIS as required.

![Ruby log message](/images/Ruby_log_message.png "Ruby log message")

The exported shape files can then be opened in GIS for further inspection and once checked can be linked together using the various TUFLOW control files. 

# Exporting Real Time Control

Operational Control is referred to as Real Time Control (RTC) in InfoWorks. The ICM_Out_to_shp_AutoMap.rb ruby script above will export the RTC as a text file called [Network_Name]_ICM_RTC.txt which can be used as the basis to generate the TUFLOW Operational Control file. The RTC is made up of the object that is being controlled, the defined ranges in which the structure operates and the desired operation. For example, in the below example, the sluice gate, Storm1_Chamber.1, will be set to an 'On' position of 0.2m if the height above datum at FORAST_CSO is below 32.3m AD and will be set to an 'Off' position of 0m if the water level is above 32.3m AD.

![RTC Data](/images/RTC.png "RTC Data")

This can be written using TUFLOW Operation Control rules as the following:-

![TOC File](/images/TOC.PNG "TUFLOW Operational Control File")