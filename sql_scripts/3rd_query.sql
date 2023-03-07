SELECT road_type.road_surface_conditions, severity_type.severity, count(accidents.accident_id) as NumOfAccidents
FROM accidents, road_type, severity_type
WHERE accidents.road_surface_conditions_id = road_type.road_surface_conditions_id AND accidents.severity_id = severity_type.severity_id
GROUP BY road_type.road_surface_conditions, severity_type.severity;