# export 

dbase = '//10.0.29.43:40000/wastewater FY2324/20240212 WCC Miramar Live Sewer Modelling Trial'
db=WSApplication.open dbase,false

mo=db.model_object_from_type_and_id 'Rainfall Event',65
mo.export 'C:\\Users\\HLewis\\Downloads\\innovyze_ruby_scripts\\ie_icm\\odec_icm\\export_rainfall\\Rainfall.csv','csv'