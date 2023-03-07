SELECT severity_type.severity, timeinfo.t_year, count(accident_id) as NumOfAccidents
FROM accidents, severity_type, timeinfo
WHERE accidents.accident_date = timeinfo.accident_date and 
	  accidents.severity_id = severity_type.severity_id
GROUP BY severity_type.severity, timeinfo.t_year
ORDER BY timeinfo.t_year DESC;