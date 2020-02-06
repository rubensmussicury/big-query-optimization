# VSCode - Copyright © Rubens Mussi Cury 2020 All Rights Reserved

/*
---------------------------------------------------------------
CÓDIGO NÃO OTIMIZADO
---------------------------------------------------------------
*/
# Utilizando ORDER BY em SELECT intermediário
# sem o uso de LIMIT
WITH 
_WM_0 AS (
    SELECT SAFE.SUBSTR(series_id, 0, 3) AS code_series_id, 
    year, period, date, series_title 
    FROM `bigquery-public-data.bls.wm`
    ORDER BY series_title 
)
SELECT * FROM _WM_0

/*
Duração	
4,5 s

Bytes processados	
71,1 MB

Bytes faturados	
72 MB

Custo estimado
$0.0003
*/


/*
---------------------------------------------------------------
CÓDIGO OTIMIZADO
---------------------------------------------------------------
*/
# Utilizando ORDER BY no final combinado com LIMIT.
WITH 
_WM_0 AS (
    SELECT SAFE.SUBSTR(series_id, 0, 3) AS code_series_id, 
    year, period, date, series_title
    FROM `bigquery-public-data.bls.wm`
)
SELECT * FROM _WM_0 
ORDER BY series_title 
LIMIT 1000

/*
Duração	
0,9 s (80% mais rápida)

Bytes processados	
71,1 MB

Bytes faturados	
72 MB

Custo estimado
$0.0003
*/




