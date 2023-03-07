CREATE TABLE accdata (
	accident_id varchar(15) NOT NULL,
	severity_id int NOT NULL,
	severity varchar(10) NOT NULL,
	road_surface_conditions_id int NOT NULL,
	road_surface_conditions varchar(50) NOT NULL,
	accident_date date NOT NULL,
	number_of_vehicles int NOT NULL,
	vehicle_type_id int NOT NULL,
	vehicle_type varchar(50) NOT NULL,
	driver_class_id int NOT NULL,
	sex_of_driver varchar(6) NOT NULL,
	age_of_driver int NOT NULL,
	sex_of_casualty varchar(6) NOT NULL,
	age_of_casualty int NOT NULL
);    

CREATE TABLE driver_type (
	driver_class_id int PRIMARY KEY,
	sex_of_driver varchar(6),
	age_of_driver int
);

CREATE TABLE vehicle_type (
	vehicle_type_id int PRIMARY KEY,
	vehicle_type varchar(50)
);

CREATE TABLE severity_type (
	severity_id int PRIMARY KEY,
	severity varchar(10)
);

CREATE TABLE road_type (
	road_surface_conditions_id int PRIMARY KEY,
	road_surface_conditions varchar(50)
);

CREATE TABLE timeinfo (
	accident_date date PRIMARY KEY,
	t_year int,
	t_month int,
	t_dayofmonth int
); 

CREATE TABLE accidents (
	accident_id varchar(15),
	severity_id int,
	road_surface_conditions_id int,
	accident_date date,
	vehicle_type_id int,
	driver_class_id int,
	number_of_vehicles int,
	casualties int,
	PRIMARY KEY(accident_id, severity_id, road_surface_conditions_id, accident_date, vehicle_type_id, driver_class_id),
	FOREIGN KEY(severity_id) references severity_type(severity_id),
	FOREIGN KEY(road_surface_conditions_id) references road_type(road_surface_conditions_id),
	FOREIGN KEY(accident_date) references timeinfo(accident_date),
	FOREIGN KEY(vehicle_type_id) references vehicle_type(vehicle_type_id),
	FOREIGN KEY(driver_class_id) references driver_type(driver_class_id)
);


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



SELECT severity_type.severity, timeinfo.t_year, count(accident_id) as NumOfAccidents
FROM accidents, severity_type, timeinfo
WHERE accidents.accident_date = timeinfo.accident_date and 
	  accidents.severity_id = severity_type.severity_id
GROUP BY severity_type.severity, timeinfo.t_year
ORDER BY timeinfo.t_year DESC;

SELECT driver_type.sex_of_driver, driver_type.age_of_driver, count(severity_type.severity) as NumOfFatalAccidents, sum(accidents.casualties) as NumOfCasualties
FROM accidents, severity_type, driver_type
WHERE accidents.severity_id = severity_type.severity_id and 
	  accidents.driver_class_id = driver_type.driver_class_id and 
	  severity_type.severity = 'Fatal'
GROUP BY driver_type.sex_of_driver, driver_type.age_of_driver
ORDER BY driver_type.sex_of_driver, driver_type.age_of_driver;

SELECT road_type.road_surface_conditions, severity_type.severity, count(accidents.accident_id) as NumOfAccidents
FROM accidents, road_type, severity_type
WHERE accidents.road_surface_conditions_id = road_type.road_surface_conditions_id AND accidents.severity_id = severity_type.severity_id
GROUP BY road_type.road_surface_conditions, severity_type.severity;

SELECT timeinfo.t_year, vehicle_type.vehicle_type, count(accidents.accident_id) as NumOfAccidents, sum(accidents.casualties) as TotalCasualties
FROM accidents, timeinfo, vehicle_type
WHERE accidents.vehicle_type_id = vehicle_type.vehicle_type_id and
	  accidents.accident_date = timeinfo.accident_date and
	  accidents.number_of_vehicles > 2
GROUP BY timeinfo.t_year, vehicle_type.vehicle_type
ORDER BY timeinfo.t_year;

SELECT  timeinfo.t_year, datepart(quarter, timeinfo.accident_date) as 'Quarter', timeinfo.t_month, count(accidents.accident_id) as NumOfAccidents, sum(accidents.number_of_vehicles) as NumOfVehicles,
	   sum(accidents.casualties) as NumOfCasualties
FROM accidents, timeinfo
WHERE accidents.accident_date = timeinfo.accident_date
GROUP BY timeinfo.t_year, datepart(quarter, timeinfo.accident_date), timeinfo.t_month WITH ROLLUP;

SELECT severity_type.severity, road_type.road_surface_conditions, vehicle_type.vehicle_type, count(accidents.accident_id) as NumOfAccidents
FROM accidents, road_type, vehicle_type, severity_type
WHERE accidents.severity_id = severity_type.severity_id and
	  accidents.road_surface_conditions_id = road_type.road_surface_conditions_id and
	  accidents.vehicle_type_id = vehicle_type.vehicle_type_id
GROUP BY CUBE (severity_type.severity, road_type.road_surface_conditions, vehicle_type.vehicle_type);

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