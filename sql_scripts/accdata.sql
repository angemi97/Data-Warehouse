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