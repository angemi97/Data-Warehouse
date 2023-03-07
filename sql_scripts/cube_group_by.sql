CREATE VIEW dbo.NumOfAccidents
WITH SCHEMABINDING
AS
	SELECT severity_type.severity, road_type.road_surface_conditions, vehicle_type.vehicle_type, count(accidents.accident_id) as NumOfAccidents
	FROM dbo.accidents, dbo.road_type, dbo.vehicle_type, dbo.severity_type
	WHERE accidents.severity_id = severity_type.severity_id and
		  accidents.road_surface_conditions_id = road_type.road_surface_conditions_id and
		  accidents.vehicle_type_id = vehicle_type.vehicle_type_id
	GROUP BY severity_type.severity, road_type.road_surface_conditions, vehicle_type.vehicle_type;
GO

SELECT severity, road_surface_conditions, vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY severity, road_surface_conditions, vehicle_type
UNION
SELECT severity, road_surface_conditions, null as vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY severity, road_surface_conditions
UNION 
SELECT severity, null as road_surface_conditions, vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY severity, vehicle_type
UNION
SELECT null as severity, road_surface_conditions, vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY road_surface_conditions, vehicle_type
UNION
SELECT severity, null as road_surface_conditions,null as vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY severity
UNION
SELECT null as severity, road_surface_conditions, null as vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY road_surface_conditions
UNION
SELECT null as severity, null as road_surface_conditions, vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents
GROUP BY vehicle_type
UNION 
SELECT null as severity, null as road_surface_conditions, null as vehicle_type, sum(NumOfAccidents) as SumOfAccidents
FROM dbo.NumOfAccidents;