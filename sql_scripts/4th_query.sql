SELECT timeinfo.t_year, vehicle_type.vehicle_type, count(accidents.accident_id) as NumOfAccidents, sum(accidents.casualties) as TotalCasualties
FROM accidents, timeinfo, vehicle_type
WHERE accidents.vehicle_type_id = vehicle_type.vehicle_type_id and
	  accidents.accident_date = timeinfo.accident_date and
	  accidents.number_of_vehicles > 2
GROUP BY timeinfo.t_year, vehicle_type.vehicle_type
ORDER BY timeinfo.t_year;