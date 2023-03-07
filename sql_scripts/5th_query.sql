SELECT  timeinfo.t_year, datepart(quarter, timeinfo.accident_date) as 'Quarter', timeinfo.t_month, count(accidents.accident_id) as NumOfAccidents, sum(accidents.number_of_vehicles) as NumOfVehicles,
	   sum(accidents.casualties) as NumOfCasualties
FROM accidents, timeinfo
WHERE accidents.accident_date = timeinfo.accident_date
GROUP BY timeinfo.t_year, datepart(quarter, timeinfo.accident_date), timeinfo.t_month WITH ROLLUP;