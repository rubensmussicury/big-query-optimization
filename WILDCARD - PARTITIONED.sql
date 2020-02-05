# VSCode - Copyright © Rubens Mussi Cury 2020 All Rights Reserved

/*
---------------------------------------------------------------
CÓDIGO NÃO OTIMIZADO
---------------------------------------------------------------
*/
# Utilizando UNION ALL e data desagrupada.
SELECT
    max, ROUND((max-32)*5/9,1) celsius, mo, da, year
FROM
   (SELECT * FROM `bpd.noaa_gsod.gsod1930` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1931` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1932` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1933` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1934` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1935` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1936` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1937` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1938` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1939` UNION ALL
    SELECT * FROM `bpd.noaa_gsod.gsod1940`)
WHERE
    da = "18" AND
    mo = "11" AND
    year = "1940" AND
    max <> 9999.9
ORDER BY
    max DESC

/*
---------------------------------------------------------------
CÓDIGO OTIMIZADO
---------------------------------------------------------------
*/
# Utilizando procedimento de UNION através 
# da técnica WILDCARD e PARTITIONED.
SELECT
    max, ROUND((max-32)*5/9,1) celsius, mo, da, year
FROM
    `bpd.noaa_gsod.gsod19*`
WHERE
    # Ao invés de 3 colunas de dia, mês e ano, 
    # criar uma de data e particionar a tabela.
    _PARTITIONDATE = "1940-11-18" AND
    # Note que o _TABLE_SUFFIX 
    # entrega valores em STRING 
    _TABLE_SUFFIX BETWEEN "30" AND "40" AND
    max <> 9999.9
ORDER BY
    max DESC



