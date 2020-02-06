# VSCode - Copyright © Rubens Mussi Cury 2020 All Rights Reserved

# Transformando a tabela com Nested Fields.
CREATE OR REPLACE TABLE `prj.dataset.epa` AS
SELECT
    state_code,
    county_code,
    site_num,
    parameter_code,
    poc,
    MIN(latitude) as latitude,
    MIN(longitude) as longitude,
    MIN(datum) as datum,
    MIN(parameter_name) as parameter_name,
    date_local,
    ARRAY_AGG(STRUCT(time_local, 
    date_gmt, 
    sample_measurement, 
    uncertainty, 
    qualifier, 
    date_of_last_change) ORDER BY time_local ASC) AS obs,
    STRUCT(MIN(units_of_measure) as units_of_measure,
           MIN(mdl) as mdl,
           MIN(method_type) as method_type,
           MIN(method_code) as method_code,
           MIN(method_name) as method_name) AS method,
    MIN(state_name) as state_name,
    MIN(county_name) as county_name,
FROM `bigquery-public-data.epa_historical_air_quality.pm10_hourly_summary`
GROUP BY state_code, county_code, site_num, parameter_code, poc, date_local

/*

Duração	
1 min 7 sec

Bytes processados	
8.76 GB

Bytes faturados
8.76 GB

Custo estimado
$0.04
*/


# Consulta realizada na tabela SEM Nested Fields.
SELECT
 pm10.county_name,
 COUNT(DISTINCT pm10.site_num) AS num_instruments
FROM 
  `bigquery-public-data.epa_historical_air_quality.pm10_hourly_summary` as pm10
WHERE 
  EXTRACT(YEAR from pm10.date_local) = 2017 AND
  pm10.state_name = 'Ohio'
GROUP BY pm10.county_name

/*
Duração	
1.2 sec

Bytes processados	
1.28 GB

Bytes faturado
1.28 GB

Custo estimado
$0.006

6 vezes para equivaler ao custo da transformação NESTED
*/


# Consulta realizada na tabela COM Nested Fields.
SELECT
 pm10.county_name,
 COUNT(DISTINCT pm10.site_num) AS num_instruments
FROM 
  `prj.dataset.epa` as pm10
WHERE 
  EXTRACT(YEAR from pm10.date_local) = 2017 AND
  pm10.state_name = 'Ohio'
GROUP BY pm10.county_name

/*
Duração	
0.5 sec

Bytes processados	
55.78 MB

Bytes faturados	
56 MB

Custo estimado
$0.0003
*/