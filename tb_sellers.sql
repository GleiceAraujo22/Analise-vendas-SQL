 -- Conhecendo a Tabela 'sellers' 
    SELECT *
    FROM olist_sellers_dataset  
    LIMIT 5

 -- Contagem do número de vendedores,cidades e Estados da tabela
    SELECT  
    	COUNT(*) AS n_linhas, 
    	COUNT(DISTINCT seller_id) AS n_vendedores, 
    	COUNT(DISTINCT seller_city) AS n_cidades, 
    	COUNT(DISTINCT seller_state) AS n_Estados 
    FROM olist_sellers_dataset 

 -- Contagem vendedores por cidade 
    SELECT seller_city, 
    	COUNT(seller_id) AS total_vendedores 
     FROM olist_sellers_dataset  
     GROUP BY seller_city  
     ORDER BY total_vendedores DESC  
     
 -- Contagem de vendedores por Estado 
     SELECT  
     seller_state,
     COUNT(seller_id) AS total_vendedores
     FROM olist_sellers_dataset  
     GROUP BY seller_state  
     ORDER BY total_vendedores DESC 
     
-- Percentual de vendedores por Estado 
     WITH prop_vendedores_por_estado AS (  
     SELECT
     seller_state,
     COUNT(seller_id) AS total_vendedores
     FROM olist_sellers_dataset 
     GROUP BY seller_state 
     ORDER BY total_vendedores DESC 
 ) 
 SELECT  
 seller_state,  
 total_vendedores, 
 ROUND(CAST(total_vendedores AS FLOAT)/SUM(total_vendedores) OVER() * 100, 2) AS porcentagem_vendedores
 FROM prop_vendedores_por_estado
 ORDER BY total_vendedores DESC
  LIMIT 10   