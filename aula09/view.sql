-- CRIAR TABELAS:
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	idade INT CHECK (idade >= 0) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE funcionarios (
	id SERIAL PRIMARY KEY,
	cargo VARCHAR(100) NOT NULL,
	salario NUMERIC(10, 2) NOT NULL,
	user_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE log_funcionarios (
	id SERIAL PRIMARY KEY,
	operacao VARCHAR(10) NOT NULL,
	funcionario_id INT,
	cargo VARCHAR(100),
	salario NUMERIC(10, 2),
	user_id INT,
	username VARCHAR DEFAULT CURRENT_USER,
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FUNCAO:
CREATE OR REPLACE FUNCTION log_funcionario()
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		INSERT INTO log_funcionarios (operacao, funcionario_id, cargo, salario, user_id)
		VALUES ('INSERT', NEW.id, NEW.cargo, NEW.salario, NEW.user_id);
		RETURN NEW;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO log_funcionarios (operacao, funcionario_id, cargo, salario, user_id)
		VALUES ('UPDATE', NEW.id, NEW.cargo, NEW.salario, NEW.user_id);
		RETURN NEW;
	ELSIF (TG_OP = 'DELETE') THEN
		INSERT INTO log_funcionarios (operacao, funcionario_id, cargo, salario, user_id)
		VALUES ('DELETE', OLD.id, OLD.cargo, OLD.salario, OLD.user_id);
		RETURN OLD;
	END IF;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER:
CREATE TRIGGER trigger_log_funcionario
AFTER INSERT OR UPDATE OR DELETE ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION log_funcionario();

-- INSERCOES:
INSERT INTO users (nome, idade, email) VALUES
	('Leandro', 36, 'leandro@mail.com'),
	('Luna', 40, 'luna@mail.com'),
	('Joao', 26, 'joao@mail.com'),
	('Jorge', 54, 'jorge@mail.com'),
	('Paula', 23, 'paula@mail.com');

INSERT INTO funcionarios (cargo, salario, user_id) VALUES
	('Gerente', 18000.00, 1),
	('Senior', 16000.00, 2),
	('Pleno', 8000.00, 3),
	('Pleno', 8000.00, 4),
	('Estagiario', 3000.00, 5);
	
-- VIEW:
CREATE VIEW view_funcionarios AS
SELECT
	users.nome,
	funcionarios.cargo,
	funcionarios.salario
FROM
	funcionarios
JOIN
	users ON users.id = funcionarios.id;

-- VISUALIZACAO:
SELECT * FROM view_funcionarios;
