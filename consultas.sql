-- Listar todos os produtos com nome, descrição e preço em ordem alfabética crescente:
SELECT nome, descricao, preco FROM produtos ORDER BY nome ASC;

-- Listar todas as categorias com nome e número de produtos associados em ordem alfabética crescente:
SELECT c.nome, COUNT(pc.produto_id) as quantidade_produtos 
FROM categorias c 
LEFT JOIN produtos_categorias pc ON c.id = pc.categoria_id 
GROUP BY c.nome 
ORDER BY c.nome ASC;

-- Listar todos os pedidos com data, endereço de entrega e total do pedido (soma dos preços dos itens), em ordem decrescente de data:
SELECT data_pedido, local_entrega, preco_total 
FROM pedidos 
ORDER BY data_pedido DESC;

-- Listar todos os produtos que já foram vendidos em pelo menos um pedido, com nome, descrição, preço e quantidade total vendida, em ordem decrescente de quantidade total vendida:
SELECT p.nome, p.descricao, p.preco, SUM(pp.quantidade) as quantidade_total_vendida 
FROM produtos p 
JOIN produtos_pedidos pp ON p.id = pp.produto_id 
GROUP BY p.id 
ORDER BY quantidade_total_vendida DESC;

-- Listar todos os pedidos feitos por um cliente, filtrando-os por um determinado período, em ordem alfabética crescente do nome do cliente e ordem crescente da data do pedido:
SELECT c.nome, p.data_pedido, p.local_entrega, p.preco_total 
FROM pedidos p 
JOIN clientes c ON c.id = p.cliente_id 
WHERE p.data_pedido BETWEEN '2022-01-01' AND '2022-12-31' 
ORDER BY c.nome ASC, p.data_pedido ASC;

-- Listar possíveis produtos com nome replicado e a quantidade de replicações, em ordem decrescente de quantidade de replicações:
SELECT nome, COUNT(*) as quantidade_replicacoes 
FROM produtos 
GROUP BY nome 
HAVING COUNT(*) > 1 
ORDER BY quantidade_replicacoes DESC;
