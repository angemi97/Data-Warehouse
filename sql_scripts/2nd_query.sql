SELECT driver_type.sex_of_driver, driver_type.age_of_driver, count(severity_type.severity) as NumOfFatalAccidents, sum(accidents.casualties) as NumOfCasualties
FROM accidents, severity_type, driver_type
WHERE accidents.severity_id = severity_type.severity_id and 
	  accidents.driver_class_id = driver_type.driver_class_id and 
	  severity_type.severity = 'Fatal'
GROUP BY driver_type.sex_of_driver, driver_type.age_of_driver
ORDER BY driver_type.sex_of_driver, driver_type.age_of_driver;