# VSCode - Copyright © Rubens Mussi Cury 2020 All Rights Reserved

/*
---------------------------------------------------------------
CÓDIGO NÃO OTIMIZADO
---------------------------------------------------------------
*/
SELECT sf.path, COUNT(sc.commit) AS number_of_commits
FROM 
  # Tabela MENOR com 672,309 linhas.
  `bigquery-public-data.github_repos.sample_commits` as sc 
INNER JOIN 
  # Tabela MAIOR com 72,879,442 linhas.
  `bigquery-public-data.github_repos.sample_files` as sf
ON 
  sf.repo_name = sc.repo_name
WHERE sf.path LIKE '%.py'
GROUP BY sf.path
ORDER BY number_of_commits DESC


/*

Duration	
2.9 sec

Bytes processed	
5.27 GB

Bytes billed	
5.27 GB

Custo Estimado
$0.03

*/

/*
---------------------------------------------------------------
CÓDIGO OTIMIZADO
---------------------------------------------------------------
*/

SELECT sf.path, COUNT(sc.commit) AS number_of_commits
FROM 
  # Tabela MAIOR com 72,879,442 linhas.
  `bigquery-public-data.github_repos.sample_files` as sf
INNER JOIN 
  # Tabela MENOR com 672,309 linhas.
  `bigquery-public-data.github_repos.sample_commits` as sc 
ON 
  sf.repo_name = sc.repo_name
WHERE sf.path LIKE '%.py'
GROUP BY sf.path
ORDER BY number_of_commits DESC

/*
NÃO MUDOU NADA


Duration	
2.9 sec

Bytes processed	
5.27 GB

Bytes billed	
5.27 GB

Custo Estimado
$0.03

*/


