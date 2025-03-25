-- SELECIONA UMA LISTA DE PESSOAS PELAS COLUNAS NOME E SOBRENOME EM ORDEM DECRESCENTE:
SELECT first_name AS nome, last_name AS sobrenome FROM actor ORDER BY nome DESC;

-- SELECIONA UMA PESSOA COM UM NOME E SOBRENOME ESPECIFICO:
SELECT first_name, last_name FROM actor WHERE first_name = 'FRED' AND last_name = 'COSTNER';

-- | PARTE 2 |:

-- CRIANDO OUTRAS TABELAS:
CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL, -- NAO PODE SER NULO
	email VARCHAR(100) NOT NULL UNIQUE, -- NAO PODE SER NULO E PRECISA SER UNICO
	nascimento DATE NOT NULL
);

CREATE TABLE pedidos (
	id SERIAL PRIMARY KEY,
	cliente INT REFERENCES clientes(id),
	produto VARCHAR(100) NOT NULL,
	dataPedido DATE DEFAULT CURRENT_TIMESTAMP
);

-- INSERCOES:
INSERT INTO clientes (nome, email, nascimento) VALUES
	('Leandro', 'abc@gmail.com', '1988-10-25'),
	('Joao', 'cba@gmail.com', '1970-03-10'),
	('Maria', 'asd@gmail.com', '1995-08-20');

INSERT INTO pedidos (cliente, produto) VALUES
	((SELECT id FROM clientes WHERE nome = 'Leandro'), 'computador'),
	((SELECT id FROM clientes WHERE nome = 'Joao'), 'notebook'),
	((SELECT id FROM clientes WHERE nome = 'Maria'), 'celular');

-- SELECIONAR QUEM NASCEU ANTES DE 1990 E DEPOIS DE 1979:
SELECT nome FROM clientes WHERE nascimento < '1990-01-01' AND nascimento > '1980-01-01';

-- SELECAO COMPLETA:
SELECT
	pedidos.id,
	clientes.nome as nome,
	produto,
	dataPedido as dia
FROM
	pedidos
INNER JOIN
	clientes ON pedidos.id = pedidos.id;
