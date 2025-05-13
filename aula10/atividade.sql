-- COM O SUPERUSUARIO:

-- Criar Usuario:
CREATE USER joao WITH PASSWORD 'joao';

-- Conceder Permissoes de leitura e escrita:
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO joao;

-- Revogar Permissoes:
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM joao;
