DROP DATABASE IF EXISTS desafio_bridge_rafael;
CREATE DATABASE desafio_bridge_rafael;
GRANT ALL PRIVILEGES ON DATABASE desafio_bridge_rafael TO postgres;

CREATE TABLE produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco NUMERIC(8,2) NOT NULL
);

CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE produtos_categorias (
    produto_id INTEGER NOT NULL,
    categoria_id INTEGER NOT NULL,
    PRIMARY KEY (produto_id, categoria_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INTEGER NOT NULL,
    local_entrega VARCHAR(255) NOT NULL,
    data_pedido DATE NOT NULL,
    preco_total NUMERIC(8,2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE produtos_pedidos (
    pedido_id INTEGER NOT NULL,
    produto_id INTEGER NOT NULL,
    quantidade INTEGER NOT NULL,
    PRIMARY KEY (pedido_id, produto_id),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

\set num_produtos 90
\set num_categorias 75
\set num_pedidos 200
\set num_clientes 150
\set num_produtos_pedidos 60

INSERT INTO produtos (nome, descricao, preco)
SELECT 'produto' || i, 'descrição do produto' || i, (random()*100)::NUMERIC(8,2)
FROM generate_series(1, :num_produtos) AS i;

INSERT INTO categorias (nome)
SELECT 'categoria' || i
FROM generate_series(1, :num_categorias) AS i;

INSERT INTO clientes (nome)
SELECT 'cliente' || i
FROM generate_series(1, :num_clientes) AS i;

INSERT INTO pedidos (cliente_id, local_entrega, data_pedido, preco_total)
SELECT (:num_clientes % i) + 1, 'local' || i, CURRENT_DATE - (2*i), (random()*1000)::NUMERIC(8,2)
FROM generate_series(1, :num_clientes) AS i;

DELETE FROM produtos_categorias;
INSERT INTO produtos_categorias (produto_id, categoria_id)
SELECT (i % (:num_produtos*7)) + 1, (i % (:num_categorias*11)) + 1
FROM generate_series(1, :num_produtos) AS i
WHERE (i % (:num_produtos*7)) + 1 IN (SELECT id FROM produtos)
AND (i % (:num_categorias*11)) + 1 IN (SELECT id FROM categorias);

DELETE FROM produtos_pedidos;
INSERT INTO produtos_pedidos (pedido_id, produto_id, quantidade)
SELECT (i % :num_pedidos) + 1, (i % :num_produtos) + 1, i
FROM generate_series(1, :num_produtos_pedidos) AS i
WHERE (i % :num_pedidos) + 1 IN (SELECT id FROM pedidos)
AND (i % :num_produtos) + 1 IN (SELECT id FROM produtos);
