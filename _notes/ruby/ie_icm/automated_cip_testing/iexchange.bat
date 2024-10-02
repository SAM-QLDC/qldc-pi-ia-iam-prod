@echo off
set "localpath=%~dp0"
set "icmversion=2021.8"
set "script=ie_script.rb"

echo Running IExchange script %script%
echo Running IExchange version %icmversion%
"C:\Program Files\Innovyze Workgroup Client %icmversion%\iexchange.exe" "%localpath%%script%" /ICM

PAUSE