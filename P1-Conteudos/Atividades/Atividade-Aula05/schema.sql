-- Remoção das tabelas existentes
DROP TABLE IF EXISTS Alerta      CASCADE;
DROP TABLE IF EXISTS Relato      CASCADE;
DROP TABLE IF EXISTS Evento      CASCADE;
DROP TABLE IF EXISTS TipoEvento  CASCADE;
DROP TABLE IF EXISTS Localizacao CASCADE;
DROP TABLE IF EXISTS Usuario     CASCADE;
DROP TABLE IF EXISTS CategoriaUsuario CASCADE;

-- Criação das tabelas

-- 1. CategoriaUsuario
CREATE TABLE CategoriaUsuario (
    idCategoria SERIAL PRIMARY KEY,
    nome        VARCHAR(50) NOT NULL,
    nivel_acesso INT NOT NULL,
    descricao   VARCHAR(200),
    CONSTRAINT NomeCategoria UNIQUE (nome) 
    -- Haverá apenas um nome para cada tipo de categoria (ex.administrador, operador, etc)
);

-- 2. Usuario 
CREATE TABLE Usuario (
    idUsuario SERIAL PRIMARY KEY,
    nome      VARCHAR(50),
    email     VARCHAR(50),
    senhaHash TEXT NOT NULL,
    idCategoria INT REFERENCES CategoriaUsuario(idCategoria)
);

-- 3. Localizacao 
CREATE TABLE Localizacao (
    idLocalizacao SERIAL PRIMARY KEY,
    latitude      DECIMAL(5,3),
    longitude     DECIMAL(5,3),
    cidade        VARCHAR(50),
    estado        CHAR(2)
);

-- 4. TipoEvento
CREATE TABLE TipoEvento (
    idTipoEvento SERIAL PRIMARY KEY,
    nome         VARCHAR(30),
    descricao    VARCHAR(50)
);

-- 5. Evento
CREATE TABLE Evento (
    idEvento      SERIAL PRIMARY KEY,
    titulo        VARCHAR(50),
    descricao     VARCHAR(50),
    dataHora      TIMESTAMP,
    status        VARCHAR(10),
    idTipoEvento  INT REFERENCES TipoEvento(idTipoEvento),
    idLocalizacao INT REFERENCES Localizacao(idLocalizacao)
);

-- 6. Relato 
CREATE TABLE Relato (
    idRelato  SERIAL PRIMARY KEY,
    texto     VARCHAR(50),
    dataHora  TIMESTAMP,
    idEvento  INT REFERENCES Evento(idEvento),
    idUsuario INT REFERENCES Usuario(idUsuario)
);

-- 7. Alerta 
CREATE TABLE Alerta (
    idAlerta SERIAL PRIMARY KEY,
    mensagem VARCHAR(50),
    dataHora TIMESTAMP,
    nivel    VARCHAR(30),
    idEvento INT REFERENCES Evento(idEvento)
);
-- ================================================================
-- PREENCHI 5 TABELAS COM 3 INSERÇÕES DE DADOS DIFERENTES EM CADA
-- ================================================================

-- Inserindo dados na tabela CategoriaUsuario
INSERT INTO CategoriaUsuario (nome, nivel_acesso, descricao) VALUES
('Administrador', 1, 'Acesso total ao sistema'),
('Operador', 2, 'Acesso limitado para operações'),
('Usuário Comum', 3, 'Acesso básico para visualização');

-- Inserindo dados na tabela Usuario
INSERT INTO Usuario (nome, email, senhaHash, idCategoria) VALUES
('Maria Silva', 'maria.silva@example.com', 'hash_senha_123', 1),
('João Pereira', 'joao.pereira@example.com', 'hash_senha_456', 2),
('Ana Costa', 'ana.costa@example.com', 'hash_senha_789', 3);

-- Inserindo dados na tabela Localizacao
INSERT INTO Localizacao (latitude, longitude, cidade, estado) VALUES
(-23.5505, -46.6333, 'São Paulo', 'SP'),
(-22.9083, -43.1964, 'Rio de Janeiro', 'RJ'),
(-30.0346, -51.2177, 'Porto Alegre', 'RS');

-- Inserindo dados na tabela TipoEvento
INSERT INTO TipoEvento (nome, descricao) VALUES
('Alerta de Tempestade', 'Aviso sobre tempestades intensas'),
('Alerta de Calor', 'Aviso sobre ondas de calor'),
('Alerta de Frio', 'Aviso sobre temperaturas muito baixas');

-- Inserindo dados na tabela Evento
INSERT INTO Evento (titulo, descricao, dataHora, status, idTipoEvento, idLocalizacao) VALUES
('Tempestade Forte', 'Tempestade prevista para a tarde.', '2026-03-03 15:00:00', 'Ativo', 1, 1),
('Calor Excessivo', 'Temperaturas acima de 35 graus.', '2026-03-04 10:00:00', 'Ativo', 2, 2),
('Frio Intenso', 'Temperaturas abaixo de 5 graus.', '2026-03-05 08:00:00', 'Ativo', 3, 3);

-- ================================================================
-- CONSULTA SIMPLES DE CADA TABELA
-- ================================================================

-- Consultando dados da tabela Evento
SELECT * FROM EVENTO;

-- Consultando dados da tabela TipoEvento
SELECT * FROM TIPOEVENTO;

-- Consultando dados da tabela Localizacao
SELECT * FROM LOCALIZACAO;

-- Consultando dados da tabela Usuario
SELECT * FROM USUARIO;

-- Consultando dados da tabela CategoriaUsuario
SELECT * FROM CATEGORIAUSUARIO;

-- ================================================================
-- CONSULTA FILTRADA DE CADA TABELA
-- ================================================================

-- Consultando dados da tabela Evento
SELECT TITULO, DATAHORA FROM EVENTO 
	WHERE TITULO = 'Frio Intenso';

-- Consultando dados da tabela TipoEvento
SELECT DESCRICAO FROM TIPOEVENTO
	WHERE NOME != 'Alerta de Calor';

-- Consultando dados da tabela Localizacao
SELECT LATITUDE, LONGITUDE, ESTADO FROM LOCALIZACAO
	WHERE ESTADO LIKE 'R%';

-- Consultando dados da tabela Usuario
SELECT NOME FROM USUARIO
	WHERE IDUSUARIO BETWEEN 2 AND 30;

-- Consultando dados da tabela CategoriaUsuario
SELECT DESCRICAO FROM CATEGORIAUSUARIO
	WHERE NIVEL_ACESSO < 2;
