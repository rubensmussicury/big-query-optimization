# VSCode - Copyright © Rubens Mussi Cury 2020 All Rights Reserved

/*
---------------------------------------------------------------
CÓDIGO NÃO OTIMIZADO
---------------------------------------------------------------
*/

# Cria um campo calculado.
WITH _WM_0 AS (
    SELECT SAFE.SUBSTR(series_id, 0, 3) AS code_series_id, 
    year, period, series_title 
    FROM `bigquery-public-data.bls.wm`
),
# Consome o campo calculado e adiciona uma condição.
_WM_1 AS (
    SELECT code_series_id, year, period, series_title
    FROM _WM_0
    WHERE code_series_id = "WMU"
),
# Adiciona outra condição para year.
_WM_2 AS (
    SELECT code_series_id, year, period, series_title
    FROM _WM_1
    WHERE year = 2018
    LIMIT 1000
),
# Adiciona outra condição para series_title.
_WM_3 AS (
    SELECT code_series_id, year, period, series_title
    FROM _WM_2
    WHERE _WM_2.series_title LIKE "%healthcare%"
)

# Retorna o resultado final. Neste caso usar "*"
# está ok uma vez que em certeza do resultado
SELECT * FROM _WM_3

/*
Duração	
0,8 s

Bytes processados	
67,53 MB

Bytes faturados	
68 MB

Estimated cost is 
$0.0003
*/


/*
---------------------------------------------------------------
CÓDIGO OTIMIZADO
---------------------------------------------------------------
*/

# Cria tabela temporária utilizando EXPIRATION_TIMESTAMP.
# CREATE OR REPLACE TEMP TABLE é apenas para Script.
CREATE OR REPLACE TABLE `bigquery-public-data.bls.temp_wm`
  OPTIONS(EXPIRATION_TIMESTAMP=TIMESTAMP_ADD(CURRENT_TIMESTAMP(), INTERVAL 1 DAY)) 
AS
(
    # Aplica todas as regras possíveis de uma vez só e cria a tabela.
    SELECT 
    SAFE.SUBSTR(series_id, 0, 3) AS code_series_id, 
    year, 
    period, 
    series_title 
    FROM 
        `bigquery-public-data.bls.wm`
    WHERE 
        series_title LIKE "%healthcare%" AND
        year = 2018
);

# Retorna o resultado final filtrando o campo calculado.
SELECT * 
FROM `bigquery-public-data.bls.temp_wm` 
WHERE code_series_id = "WMU"
LIMIT 1000

/*
Duração	
0,6 s (25% mais rápida)

Bytes processados	
67,53 MB

Bytes faturados	
68 MB

Estimated cost is 
$0.0003
*/