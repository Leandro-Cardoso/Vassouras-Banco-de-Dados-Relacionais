-- COM O USUARIO JOAO:

-- 2 INSERTS:
INSERT INTO users (nome, idade, email) VALUES
	('Paulo', 90, 'paulo@mail.com'),
	('Marcos', 30, 'marcos@mail.com');

-- 1 DELETE:
DELETE FROM users WHERE nome = 'Paulo';

-- 1 UPDATE:
UPDATE users SET nome = 'Michel' WHERE nome = 'Marcos';
