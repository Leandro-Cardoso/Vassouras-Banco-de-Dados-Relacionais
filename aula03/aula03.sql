-- CRIAR TABELAS:

CREATE TABLE clientes (
	clienteId SERIAL PRIMARY KEY,
	clienteNome VARCHAR(255),
	clienteTelefone VARCHAR(20)
);

CREATE TABLE produtos (
	produtoId SERIAL PRIMARY KEY,
	produtoNome VARCHAR(255),
	produtoPreco DECIMAL(10, 2)
);

CREATE TABLE pedidos (
	pedidoId SERIAL PRIMARY KEY,
	clienteId INT REFERENCES clientes(clienteId),
	produtoId INT REFERENCES produtos(produtoId),
	produtoQuantidade INT
);

-- INSERÇÕES:

INSERT INTO clientes (clienteNome, clienteTelefone) VALUES
	('Zé das Coves', '123456789'),
	('Zé das Manga', '987654321');

INSERT INTO produtos (produtoNome, produtoPreco) VALUES
	('Notebook', 3000),
	('Smartfone', 2000),
	('Impressora', 800);

INSERT INTO pedidos (clienteId, produtoId, produtoQuantidade) VALUES
	((SELECT clienteId FROM clientes WHERE clienteNome = 'Zé das Coves'),
	(SELECT produtoId FROM produtos WHERE produtoNome = 'Notebook'), 5),
	((SELECT clienteId FROM clientes WHERE clienteNome = 'Zé das Manga'),
	(SELECT produtoId FROM produtos WHERE produtoNome = 'Smartfone'), 6),
	((SELECT clienteId FROM clientes WHERE clienteNome = 'Zé das Coves'),
	(SELECT produtoId FROM produtos WHERE produtoNome = 'Impressora'), 4);

-- VISUALIZAÇÃO:

SELECT
	clientes.clienteNome,
	produtos.produtoNome,
	produtoQuantidade,
	produtos.produtoPreco,
	produtoQuantidade * produtos.produtoPreco AS total
FROM
	pedidos
JOIN
	clientes ON pedidos.clienteId = clientes.clienteId
JOIN
	produtos ON pedidos.produtoId = produtos.produtoId
ORDER BY
	pedidos.pedidoId;
