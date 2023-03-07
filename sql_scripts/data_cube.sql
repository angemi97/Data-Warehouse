SELECT severity_type.severity, road_type.road_surface_conditions, vehicle_type.vehicle_type, count(accidents.accident_id) as NumOfAccidents
FROM accidents, road_type, vehicle_type, severity_type
WHERE accidents.severity_id = severity_type.severity_id and
	  accidents.road_surface_conditions_id = road_type.road_surface_conditions_id and
	  accidents.vehicle_type_id = vehicle_type.vehicle_type_id
GROUP BY CUBE (severity_type.severity, road_type.road_surface_conditions, vehicle_type.vehicle_type);