-- 1) Aplique as três regras de normalização considerando a tabela disponibilizada:
CREATE TABLE responsaveis (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	telefone VARCHAR(30) NOT NULL
);

CREATE TABLE alunos (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	idade INT NOT NULL,
	responsavel INT REFERENCES responsaveis(id),
	periodo INT NOT NULL
);

CREATE TABLE presencas (
	id SERIAL PRIMARY KEY,
	aluno INT REFERENCES alunos(id),
	faltas INT NOT NULL,
	materia VARCHAR(30) NOT NULL
);

CREATE TABLE avaliacoes (
	id SERIAL PRIMARY KEY,
	aluno INT REFERENCES alunos(id),
	nota DECIMAL(3, 1) NOT NULL,
	status VARCHAR(30) NOT NULL,
	materia VARCHAR(30) NOT NULL
);

-- 2) Realize o insert into de cada registro:
INSERT INTO responsaveis (nome, telefone) VALUES
	('Ze da Horta', '2212345-1234'),
	('Ze da Mangueira', '2254321-4321');

INSERT INTO alunos (nome, idade, responsavel, periodo) VALUES
	('Ze das Couves', 35, (SELECT id FROM responsaveis WHERE nome = 'Ze da Horta'), 1),
	('Ze da Manga', 46, (SELECT id FROM responsaveis WHERE nome = 'Ze da Mangueira'), 2),
	('Zelia das Couves', 30, (SELECT id FROM responsaveis WHERE nome = 'Ze da Horta'), 1);

INSERT INTO presencas (aluno, faltas, materia) VALUES
	((SELECT id FROM alunos WHERE nome = 'Ze das Couves'), 15, 'Portugues'),
	((SELECT id FROM alunos WHERE nome = 'Ze das Couves'), 25, 'Matematica'),
	((SELECT id FROM alunos WHERE nome = 'Ze da Manga'), 12, 'Portugues'),
	((SELECT id FROM alunos WHERE nome = 'Ze da Manga'), 13, 'Matematica'),
	((SELECT id FROM alunos WHERE nome = 'Zelia das Couves'), 10, 'Portugues'),
	((SELECT id FROM alunos WHERE nome = 'Zelia das Couves'), 9, 'Matematica');

INSERT INTO avaliacoes (aluno, nota, status, materia) VALUES
	((SELECT id FROM alunos WHERE nome = 'Ze das Couves'), 5.6, 'Reprovado', 'Portugues'),
	((SELECT id FROM alunos WHERE nome = 'Ze das Couves'), 6.5, 'Reprovado', 'Matematica'),
	((SELECT id FROM alunos WHERE nome = 'Ze da Manga'), 4.2, 'Reprovado', 'Portugues'),
	((SELECT id FROM alunos WHERE nome = 'Ze da Manga'), 3.4, 'Reprovado', 'Matematica'),
	((SELECT id FROM alunos WHERE nome = 'Zelia das Couves'), 6.5, 'Reprovado', 'Portugues'),
	((SELECT id FROM alunos WHERE nome = 'Zelia das Couves'), 7, 'Aprovado', 'Matematica');

INSERT INTO responsaveis (nome, telefone) VALUES
	('Ze Deletinho', '22 98765-4321');

-- 3) Faca o update em dois registros:
UPDATE responsaveis SET telefone = '22 11111-2222' WHERE nome = 'Ze da Horta';

UPDATE responsaveis SET telefone = '22 22222-1111' WHERE nome = 'Ze da Mangueira';

-- 4) Faca o delete de um registro:
DELETE FROM responsaveis WHERE nome = 'Ze Deletinho';

-- 5) Realizar JOIN entre as tabelas para demonstrar a mesma tabela, porem, com as correlacoes baseada na normalizacao:
SELECT
	alunos.nome,
	alunos.idade,
	presencas.faltas,
	avaliacoes.nota,
	avaliacoes.status,
	responsaveis.nome,
	alunos.periodo
FROM
	alunos
LEFT JOIN
	responsaveis ON responsaveis.id = responsaveis.id
LEFT JOIN
	avaliacoes ON avaliacoes.id = alunos.id
LEFT JOIN
	presencas ON presencas.id = alunos.id;
