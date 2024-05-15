-- Tabela "customers" primeiras linhas 
SELECT *
FROM olist_customers_dataset  
LIMIT 5 

-- Contagem do número de vendedores,cidades e Estados da tabela de clientes
    SELECT  
    	COUNT(*) AS n_linhas, 
    	COUNT(DISTINCT customer_id) AS n_customer_id, 
    	COUNT(DISTINCT customer_unique_id ) AS n_unique_id, 
    	COUNT(DISTINCT customer_city) AS n_cidades,  
    	COUNT(DISTINCT customer_state) AS n_Estados
    FROM olist_customers_dataset  
    
  -- Contagem de clientes por cidade 
  
    SELECT customer_city, COUNT(customer_unique_id) AS total_clientes
    FROM olist_customers_dataset 
    GROUP BY customer_city  
    ORDER BY total_clientes DESC 
    
    -- Contagem de clientes por Estado 
    
    SELECT customer_state, COUNT(customer_unique_id) AS total_clientes
    FROM olist_customers_dataset   
    GROUP BY customer_state  
    ORDER BY total_clientes DESC 
    
  -- Clientes por Estado % 
    WITH por_clientes AS (
	    SELECT customer_state, COUNT(customer_unique_id) AS total_clientes 
	    FROM olist_customers_dataset  
	    GROUP BY customer_state 
	    ORDER BY total_clientes DESC
) 
  SELECT customer_state, 
  total_clientes, 
  ROUND(CAST(total_clientes AS FLOAT)/SUM(total_clientes) OVER() * 100, 2) AS porcentagem_clientes
  FROM por_clientes
  ORDER BY total_clientes DESC 
  
    