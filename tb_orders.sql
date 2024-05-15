-- Examinando as primeiras linhas da tabela de pedidos 
SELECT *
FROM olist_orders_dataset 
LIMIT 5 

-- Resumo das colunas da tabela pedidos 
SELECT  
	COUNT(*) AS número_linhas, 
	COUNT(DISTINCT customer_id) AS número_clientes, 
	COUNT(*) - COUNT(order_status) AS total_missing_status, 
	COUNT(*) - COUNT(order_purchase_timestamp) AS total_missing_data_compra, 
	COUNT(*) - COUNT(order_approved_at) AS total_missing_data_pagamento, 
	COUNT(*) - COUNT(order_delivered_carrier_date) AS total_missing_data_parlogistica, 
	COUNT(*) - COUNT(order_delivered_customer_date) AS total_missing_data_entrega, 
	COUNT(*) - COUNT(order_estimated_delivery_date) AS total_missing_data_estimada 
FROM olist_orders_dataset 



-- Qual o tempo médio de entrega?
SELECT 
    CAST(AVG(JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_delivered_carrier_date)) AS INTEGER) AS tempo_medio_entrega_dias   
FROM olist_orders_dataset   

-- Tempo médio de postagem em dias
SELECT 
    CAST(AVG(JULIANDAY(order_delivered_carrier_date) - JULIANDAY(order_approved_at)) AS INTEGER) AS tempo_medio_postagem_dias
FROM olist_orders_dataset

 
-- Taxa de acuracia de entrega 
 SELECT 
    COUNT(*) AS total_pedidos,
    SUM(CASE WHEN JULIANDAY(order_delivered_customer_date) <= JULIANDAY(order_estimated_delivery_date) THEN 1 ELSE 0 END) AS pedidos_dentro_do_prazo,
    100 * SUM(CASE WHEN JULIANDAY(order_delivered_customer_date) <= JULIANDAY(order_estimated_delivery_date) THEN 1 ELSE 0 END) / COUNT(*) AS taxa_acuracia
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL 

-- Status do pedido   
WITH status AS(
	SELECT DISTINCT order_status, COUNT(order_status) AS contagem_status
	FROM olist_orders_dataset  
	GROUP BY order_status   
) 
SELECT order_status, contagem_status, 
ROUND(CAST(contagem_status AS FLOAT)/SUM(contagem_status) OVER() * 100, 3) AS proporção_status
FROM status  
ORDER BY contagem_status DESC  


-- Quais os dias da semana em que ocorrem mais e menos entregas? 
SELECT 
	CASE 
		WHEN CAST(STRFTIME('%w',order_delivered_customer_date) AS INTEGER) = 0 THEN 'domingo' 
		WHEN CAST(STRFTIME('%w',order_delivered_customer_date) AS INTEGER) = 1 THEN 'segunda-feira' 
		WHEN CAST(STRFTIME('%w',order_delivered_customer_date) AS INTEGER) = 2 THEN 'terça-feira' 
		WHEN CAST(STRFTIME('%w',order_delivered_customer_date) AS INTEGER) = 3 THEN 'quarta-feira' 
		WHEN CAST(STRFTIME('%w',order_delivered_customer_date) AS INTEGER) = 4 THEN 'quinta-feira' 
		WHEN CAST(STRFTIME('%w',order_delivered_customer_date) AS INTEGER) = 5 THEN 'sexta-feira' 
		ELSE 'sabado'
	END AS dia_da_semana, 
	COUNT(order_id) AS total_entrega
FROM olist_orders_dataset 	
GROUP BY dia_da_semana 
ORDER BY total_entrega DESC

-- Quais os dias da semana em que ocorrem mais e menos compras? 
SELECT 
	CASE 
		WHEN CAST(STRFTIME('%w',order_purchase_timestamp) AS INTEGER) = 0 THEN 'domingo' 
		WHEN CAST(STRFTIME('%w',order_purchase_timestamp) AS INTEGER) = 1 THEN 'segunda-feira' 
		WHEN CAST(STRFTIME('%w',order_purchase_timestamp) AS INTEGER) = 2 THEN 'terça-feira' 
		WHEN CAST(STRFTIME('%w',order_purchase_timestamp) AS INTEGER) = 3 THEN 'quarta-feira' 
		WHEN CAST(STRFTIME('%w',order_purchase_timestamp) AS INTEGER) = 4 THEN 'quinta-feira' 
		WHEN CAST(STRFTIME('%w',order_purchase_timestamp) AS INTEGER) = 5 THEN 'sexta-feira' 
		ELSE 'sabado'
	END AS dia_da_semana, 
	COUNT(order_id) AS contagem_pedido
FROM olist_orders_dataset 	
GROUP BY dia_da_semana 
ORDER BY contagem_pedido DESC


