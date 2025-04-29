-- MODELO DO TRIGGER:
-- Trata o dado das tabelas, automatiza acoes, cria um controle de acesso, auditoria e verifica a integridade dos dados.

-- CREATE TRIGGER triggerTest {BEFORE \ AFTER} {INSERT \ UPDATE \ DELETE}
-- ON tabela
-- FOR EACH ROW
-- EXECUTE FUNCTION funcao();

-- TABELAS:
CREATE TABLE vendedores (
	id_vendedor SERIAL PRIMARY KEY,
	nome_vendedor VARCHAR(100) NOT NULL
);

CREATE TABLE produtos (
	id_produto SERIAL PRIMARY KEY,
	nome_produto VARCHAR(100) NOT NULL,
	valor_produto DECIMAL(10, 2) NOT NULL
);

CREATE TABLE vendas (
	id_venda SERIAL PRIMARY KEY,
	id_vendedor INT REFERENCES vendedores(id_vendedor),
	id_produto INT REFERENCES produtos(id_produto),
	quantidade INT NOT NULL
);

CREATE TABLE log_vendas (
	id SERIAL PRIMARY KEY,
	id_venda INT REFERENCES vendas(id_venda),
	id_vendedor INT REFERENCES vendedores(id_vendedor),
	id_produto INT REFERENCES produtos(id_produto),
	quantidade INT NOT NULL,
	data_log DATE DEFAULT CURRENT_TIMESTAMP
);

-- FUNCOES:
CREATE OR REPLACE FUNCTION log_venda()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'INSERT' THEN
		INSERT INTO log_vendas (id_venda, id_vendedor, id_produto, quantidade, data_log)
		VALUES (NEW.id_venda, NEW.id_vendedor, NEW.id_produto, NEW.quantidade, CURRENT_TIMESTAMP);

	ELSIF TG_OP = 'DELETE' THEN
		INSERT INTO log_vendas (id_venda, id_vendedor, id_produto, quantidade, data_log)
		VALUES (OLD.id_venda, OLD.id_vendedor, OLD.id_produto, OLD.quantidade, CURRENT_TIMESTAMP);

 	ELSIF TG_OP = 'UPDATE' THEN
		INSERT INTO log_vendas (id_venda, id_vendedor, id_produto, quantidade, data_log)
		VALUES (NEW.id_venda, NEW.id_vendedor, NEW.id_produto, NEW.quantidade, CURRENT_TIMESTAMP);

	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGERS:
CREATE TRIGGER trigger_log_vendas
AFTER INSERT ON vendas
FOR EACH ROW
EXECUTE FUNCTION log_venda();

-- INSERCOES:
INSERT INTO vendedores (nome_vendedor) VALUES
	('Leandro'),
	('Luna'),
	('Joao');

INSERT INTO produtos (nome_produto, valor_produto) VALUES
	('Celular', 2000.00),
	('Assistente', 500.00),
	('Computador', 5400.00);

INSERT INTO vendas (id_vendedor, id_produto, quantidade) VALUES
	(1, 3, 2),
	(2, 2, 5),
	(3, 1, 3);

-- VIEW:
SELECT * FROM log_vendas;
