# VSCode - Copyright © Rubens Mussi Cury 2020 All Rights Reserved

/*
---------------------------------------------------------------
CÓDIGO NÃO OTIMIZADO
---------------------------------------------------------------
*/
# Uso de HAVING e LOWER()
SELECT 
    value,
    year,
    SAFE_COUNT(1) AS qtde
FROM 
    `bigquery-public-data.bls.wm`
GROUP BY 
    value, year, period
HAVING 
    LOWER(period) LIKE "%a%" AND
    value BETWEEN 10 AND 20

/*
---------------------------------------------------------------
CÓDIGO OTIMIZADO
---------------------------------------------------------------
*/
# Uso de WHERE e REGEXP_CONTAINS()
SELECT 
    value,
    year,
    COUNT(1) AS qtde
FROM 
    `bigquery-public-data.bls.wm`
WHERE 
    SAFE.REGEXP_CONTAINS(period, "(?i)(a)") AND
    value BETWEEN 10 AND 20
GROUP BY 
    value, year, period