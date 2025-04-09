-- QUESTAO 1:
CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	cpf VARCHAR(30) NOT NULL,
	email VARCHAR(100) NOT NULL
);

CREATE TABLE produtos (
	id SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE pedidos (
	id SERIAL PRIMARY KEY,
	data DATE DEFAULT CURRENT_TIMESTAMP,
	cliente INT REFERENCES clientes(id)
);

CREATE TABLE carrinho (
	id SERIAL PRIMARY KEY,
	produto INT REFERENCES produtos(id),
	quantidade INT NOT NULL,
	pedido INT REFERENCES pedidos(id)
);

-- QUESTAO 2:
INSERT INTO clientes (nome, cpf, email) VALUES
	('João Silva', '12345678901', 'joao@email.com'),
	('José da Silva', '12345678910', 'jose@email.com'),
	('Maria Souza', '98765432109', 'maria@email.com'),
	('Leandro Lima Cardoso', '00000000001', 'leandro@email.com'),
	('Luna Costa', '00000000002', 'luna@email.com');

INSERT INTO produtos (descricao, preco) VALUES
	('Notebook Dell', 5200.00),
	('Mouse Wireless', 120.00),
	('Teclado Mecânico', 250.00),
	('Notebook Lenovo', 3500.00),
	('Mouse Wireless G2', 135.00),
	('Teclado Mecânico G2', 265.00);

INSERT INTO pedidos (cliente) VALUES
	((SELECT id FROM clientes WHERE nome = 'João Silva')),
	((SELECT id FROM clientes WHERE nome = 'José da Silva')),
	((SELECT id FROM clientes WHERE nome = 'Maria Souza'));

INSERT INTO carrinho (produto, quantidade, pedido) VALUES
	((SELECT id FROM produtos WHERE descricao = 'Notebook Dell'), 2, (SELECT id FROM pedidos WHERE cliente = (SELECT id FROM clientes WHERE nome = 'João Silva'))),
	((SELECT id FROM produtos WHERE descricao = 'Notebook Lenovo'), 1, (SELECT id FROM pedidos WHERE cliente = (SELECT id FROM clientes WHERE nome = 'João Silva'))),
	((SELECT id FROM produtos WHERE descricao = 'Mouse Wireless'), 1, (SELECT id FROM pedidos WHERE cliente = (SELECT id FROM clientes WHERE nome = 'José da Silva'))),
	((SELECT id FROM produtos WHERE descricao = 'Mouse Wireless G2'), 3, (SELECT id FROM pedidos WHERE cliente = (SELECT id FROM clientes WHERE nome = 'José da Silva'))),
	((SELECT id FROM produtos WHERE descricao = 'Teclado Mecânico'), 3, (SELECT id FROM pedidos WHERE cliente = (SELECT id FROM clientes WHERE nome = 'Maria Souza'))),
	((SELECT id FROM produtos WHERE descricao = 'Teclado Mecânico G2'), 2, (SELECT id FROM pedidos WHERE cliente = (SELECT id FROM clientes WHERE nome = 'Maria Souza')));

-- QUESTAO 3:
UPDATE clientes SET email = 'leandrocardoso@email.com' WHERE nome = 'Leandro Lima Cardoso';
UPDATE produtos SET descricao = 'Teclado Mecânico G2 Pro' WHERE descricao = 'Teclado Mecânico G2';
UPDATE pedidos SET cliente = (SELECT id FROM clientes WHERE nome = 'Leandro Lima Cardoso') WHERE cliente = (SELECT id FROM clientes WHERE nome = 'Maria Souza');
UPDATE carrinho SET quantidade = 2 WHERE produto = (SELECT id FROM produtos WHERE descricao = 'Teclado Mecânico');

DELETE FROM clientes WHERE nome = 'Luna Costa';

-- QUESTAO 4:
-- Nao lembro...

-- QUESTAO 5:
SELECT
	clientes.id AS id_cliente,
	clientes.nome AS nome_cliente,
	clientes.cpf AS cpf_cliente,
	clientes.email AS email_cliente,
	produtos.id AS id_produto,
	pedidos.data AS data_pedido,
	produtos.descricao AS descricao_produto,
	produtos.preco AS preco_produto,
	carrinho.quantidade AS quantidade
FROM
	clientes
JOIN
	produtos ON produtos.id = produtos.id
JOIN
	pedidos ON pedidos.id = clientes.id
JOIN
	carrinho ON carrinho.id = pedidos.id
