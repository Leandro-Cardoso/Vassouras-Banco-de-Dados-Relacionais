-- 1) Crie o banco de dados:
CREATE TABLE estoque (
	id_estoque SERIAL PRIMARY KEY,
	produto VARCHAR(100) NOT NULL,
	quantidade INT NOT NULL,
	VALOR NUMERIC(10, 2) NOT NULL
);

CREATE TABLE venda (
	id_venda SERIAL PRIMARY KEY,
	id_estoque INT NOT NULL,
	quantidade INT NOT NULL,
	valor_produto NUMERIC(10, 2) NOT NULL,
	valor_venda NUMERIC(10, 2) NOT NULL,
	FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque)
);

CREATE TABLE funcionario (
	id_funcionario SERIAL PRIMARY KEY,
	endereco TEXT NOT NULL,
	nome VARCHAR(100) NOT NULL
);

CREATE TABLE loja (
	id_loja SERIAL PRIMARY KEY,
	endereco TEXT NOT NULL,
	nome VARCHAR(100) NOT NULL
);

CREATE TABLE log_venda (
	id_log SERIAL PRIMARY KEY,
	data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	id_estoque INT NOT NULL,
	id_loja INT NOT NULL,
	id_venda INT NOT NULL,
	FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque),
	FOREIGN KEY (id_loja) REFERENCES loja(id_loja),
	FOREIGN KEY (id_venda) REFERENCES venda(id_venda)
);

-- 2) Realize a Trigger:
CREATE OR REPLACE VIEW vendas_realizadas AS
SELECT
	venda.id_venda,
	estoque.produto,
	venda.quantidade,
	estoque.valor AS valor_produto,
	venda.valor_venda
FROM
	venda
JOIN
	estoque ON estoque.id_estoque = venda.id_venda;

-- 3) Trigger de log_venda:
CREATE OR REPLACE FUNCTION registrar_log_venda()
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO log_venda (id_estoque, id_loja, id_venda)
	VALUES (NEW.id_estoque, NEW.id_loja, NEW.id_venda);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_venda
AFTER INSERT ON log_venda
FOR EACH ROW
EXECUTE FUNCTION registrar_log_venda();

-- 4) Crie um usuário e de prioridade de edição para ele e mostre o processo:
CREATE USER teste WITH PASSWORD 'teste';
GRANT CONNECT ON DATABASE postgres TO teste;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO teste;
--GRANT USAGE ON SCHEMA public TO teste;
--GRANT SELECT, INSERT, UPDATE, DELETE ON minha_tabela TO teste;

INSERT INTO funcionario (endereco, nome) VALUES ('Saquarema', 'Lucas');

UPDATE funcionario SET nome = 'Alastor' WHERE nome = 'Lucas';

DELETE FROM funcionario WHERE name = 'Alastor';

SELECT * FROM funcionario;

-- 5) Tkinter para criação do serviço:
-- No main.py
