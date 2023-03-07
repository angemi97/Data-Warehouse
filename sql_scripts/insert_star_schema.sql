INSERT INTO driver_type
SELECT DISTINCT driver_class_id, sex_of_driver,	age_of_driver
FROM accdata;

INSERT INTO vehicle_type
SELECT DISTINCT vehicle_type_id, vehicle_type
FROM accdata;

INSERT INTO severity_type
SELECT DISTINCT severity_id, severity
FROM accdata;

INSERT INTO road_type
SELECT DISTINCT road_surface_conditions_id, road_surface_conditions
FROM accdata;

SET DATEFIRST 1;
INSERT INTO timeinfo
SELECT DISTINCT accident_date, datepart(year, accident_date), datepart(month, accident_date), datepart(day, accident_date)
FROM accdata;

INSERT INTO accidents
SELECT 	accident_id, severity_id, road_surface_conditions_id, accident_date, vehicle_type_id, driver_class_id,
        sum(number_of_vehicles), count(sex_of_casualty)
FROM accdata
GROUP BY accident_id, severity_id, road_surface_conditions_id, accident_date, vehicle_type_id, driver_class_id;