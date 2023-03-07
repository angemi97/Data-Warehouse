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