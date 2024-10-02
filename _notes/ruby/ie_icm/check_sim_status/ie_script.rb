dbase = '//10.0.29.43:40000/wastewater FY2324/20240212 WCC Miramar Live Sewer Modelling Trial'

db = WSApplication.open dbase,false
sim1 = db.model_object_from_type_and_id 'Sim',46
status1 = sim1.status
success1 = sim1.success_substatus
puts status1
puts success1