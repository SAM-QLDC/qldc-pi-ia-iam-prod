# Introduction

Currently there is a need to import of multiple Snapshot files from VAMS into IAM at QLDC.

- .isfc - and an old .isf file) into an InfoAsset Manager Collection Network, 
- .isfd files can be imported into a Distribution network

This version of the script below is designed to be ran using the client interface, from the Network menu > Run Ruby Script.... This doesn't require an Exchange licence.
The process can also be run uising Exchange outside of the InfoAsset Manager interface, however currenytly QLDC is not licensed for IExchange.

The script will identify all files in the specified directory, and its sub-directories, with a defined file type extension to use as the import data sources.
 
## Customising the syntax
Source Data Directory
If all you are looking to do is import snapshot files (.isfc/.isf) into an InfoAsset Manager Collection Network, then all you need to amend is line 7, set the top-level source directory between the quotation marks, ending with a forward slash. Then the script is ready to be ran from the Network menu.

For example, with the below the script will go through a folder C:/Temp/Data/.

`dir = "C:/Temp/Data/"`
 

## Source Data File Format
To import into a Distribution or Model network, or if you are using a different import method and therefore a different file type, set the source file type extensions on line 10 between the quotation marks, separate different file extensions (if required) with a single comma.

Below the script will only look for files with the extensions *.isfc and *.isf.

`ext = 'isfc,isf'`
 

## Import Options
Edit the Import options between lines 15-19, these are the same options as are shown in the interface dialog. Change the work true to false or vice-versa as required. True is as if the checkbox is selected on the interface dialog.

For the below set the boolean value to true to enable deletes from a differential snapshot file, false means the deletes will not happen.

`options['AllowDeletes'] = true`

If using a different import method, see the Exchange document for details on the import parameters as/if required. For import methods which do not require an options hash, the lines 13-19 can be removed from the syntax.
 

## Import Method
To import a different data type, edit line 29 after the full stop - nw. . To use a different method follow the guidance of the Ruby Exchange document keeping fname in the location for the filename/import_file as necessary.

This is the Snapshot file import method

`nw.snapshot_import_ex(fname, options)`


The below could be used to import MSCC CCTV Survey XML Data

`nw.mscc_import_cctv_surveys(fname, 'IM', true, 2, false, 'C:\Temp\log.txt')`


## The Ruby syntax code for running in the interface
 ![](/UI-SnapshotImport.rb)

### The Output
What you might also notice in the syntax are a number of lines beginning with puts, this is the Ruby code to output someone to the screen. This means the syntax above will produce an output letting you know what has been imported into your network.


## The Ruby syntax code for running via Exchange
This syntax will action the same as above but via InfoAsset Exchange, after the import is complete the script will also commit the changes to the network (line 41).
The Master Database is defined on line 4, the network selected on line 7.
 ![](/IE-SnapshotImport.rb)


 ## Importing files with something specific in the filename
 In the instance that you need to import multiple files like above, but only files which have something specific within the filename, see the script  
 ![](/UI-SnapshotImport_Filename.rb) to only select files with a specific term within the name.