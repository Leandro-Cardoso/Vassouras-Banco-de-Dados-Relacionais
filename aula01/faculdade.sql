-- CRIANDO TABELAS:

CREATE TABLE aluno (
	id INT PRIMARY KEY,
	nome VARCHAR(30),
	curso VARCHAR(30)
);

CREATE TABLE professor (
	id INT PRIMARY KEY,
	nome VARCHAR(30),
	curso VARCHAR(30)
);

CREATE TABLE campus (
	id INT PRIMARY KEY,
	nome VARCHAR(30),
	endereco VARCHAR(30)
);

CREATE TABLE sala (
	id INT PRIMARY KEY,
	sala CHAR(5),
	campus VARCHAR(30)
);

CREATE TABLE disciplina (
	id INT PRIMARY KEY,
	nome VARCHAR(30),
	curso VARCHAR(30)
);

-- VISUALIZACAO:
SELECT * FROM sala;

SELECT COUNT(sala) FROM sala;
