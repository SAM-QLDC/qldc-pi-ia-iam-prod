@echo off
set version=2021.8
set bit=32
set script=ie_script.rb
if %bit%==32 (set "path=C:\Program Files (x86)")
if %bit%==64 (set "path=C:\Program Files")
"%path%\Innovyze Workgroup Client %version%\IExchange" "%~dp0%script%" IA