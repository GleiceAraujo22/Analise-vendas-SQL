-- Conhecendo a tabela order_items 
SELECT *
FROM olist_order_items_dataset  

-- Qual é receita total de vendas e total de frete
SELECT  
SUM(price) AS receita_total
FROM olist_order_items_dataset  


-- Qual é receita de Vendas por Ano 
SELECT 
	strftime('%Y', o.order_purchase_timestamp) AS ano, 
	SUM(oi.price) AS receita_total
FROM  
	olist_order_items_dataset oi 
JOIN 
	olist_orders_dataset o ON oi.order_id = o.order_id  
GROUP BY strftime('%Y', O.order_purchase_timestamp) 
ORDER BY ano 

-- Qual é a receita por ano e mês
SELECT 
    strftime('%Y-%m', o.order_purchase_timestamp) AS ano_mes, 
    ROUND(SUM(oi.price), 2) AS receita_total
FROM  
    olist_order_items_dataset oi 
JOIN 
    olist_orders_dataset o ON oi.order_id = o.order_id  
GROUP BY strftime('%Y-%m', o.order_purchase_timestamp) 
ORDER BY ano_mes 

-- Ticket médio de vendas 
WITH ReceitaTotal AS (  
	SELECT SUM(price) AS receita_total
	FROM olist_order_items_dataset 
), 
TotalPedidos AS (  
	SELECT COUNT(*) AS total_pedidos 
	FROM olist_orders_dataset 
) 
SELECT 
	ROUND( receita_total / total_pedidos, 2) AS ticket_medio 
FROM ReceitaTotal, TotalPedidos 


-- Ticket Médio para cada seller_id, receita total e total de pedidos, ordenado pelo total de receita
SELECT  
	seller_id, 
	SUM(price) AS total_receita_vendedor,
	COUNT(order_id) AS total_pedidos,
	ROUND(SUM(price) / COUNT(order_id), 2) AS ticket_medio
FROM olist_order_items_dataset  
GROUP BY seller_id  
ORDER BY total_receita_vendedor DESC 


