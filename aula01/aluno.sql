CREATE TABLE professor (
	id INT PRIMARY KEY,
	nome VARCHAR(30),
	cod_curso VARCHAR(5)
);

INSERT INTO aluno (id, nome, cod_curso) VALUES 
	(1, 'Leandro', 'A12BC'),
	(2, 'Joao', 'C510A');

SELECT * FROM aluno;
