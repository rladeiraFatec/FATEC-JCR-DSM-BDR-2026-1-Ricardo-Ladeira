-- Exercício 1
-- Criar BD
-- Database: sistema_bancario
-- DROP DATABASE IF EXISTS sistema_bancario;
-- CREATE DATABASE sistema_bancario
-- WITH
--     OWNER = postgres ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.UTF-8' LC_CTYPE = 'pt_BR.UTF-8' LOCALE_PROVIDER = 'libc' TABLESPACE = pg_default CONNECTION
-- LIMIT
--     = -1;
-- Exercício 2
-- Criar Tabela Clientes
CREATE TABLE
    clientes (
        id_cliente SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        cpf VARCHAR(11) UNIQUE NOT NULL,
        endereco TEXT,
        telefone VARCHAR(15)
    );

-- Exercício 3
-- Inserir Clientes
INSERT INTO
    clientes (nome, cpf, endereco, telefone)
VALUES
    (
        'João Silva',
        '12345678900',
        'Rua A, 123',
        '11999990000'
    ),
    (
        'Maria Oliveira',
        '98765432100',
        'Rua B, 456',
        '11988887777'
    );

-- Exercício 4
-- Criar Tabela Contas
CREATE TABLE
    contas (
        id_conta SERIAL PRIMARY KEY,
        numero_conta VARCHAR(10) UNIQUE NOT NULL,
        saldo DECIMAL(10, 2) DEFAULT 0,
        id_cliente INT REFERENCES clientes (id_cliente) ON DELETE CASCADE
    );

-- Exercício 5
-- Inserir Contas
INSERT INTO
    contas (numero_conta, saldo, id_cliente)
VALUES
    ('000123', 1500.00, 1),
    ('000456', 2300.00, 2);

-- Exercício 6
-- Criar Tabela Transações
CREATE TABLE
    transacoes (
        id_transacao SERIAL PRIMARY KEY,
        id_conta INT REFERENCES contas (id_conta) ON DELETE CASCADE,
        tipo VARCHAR(15) CHECK (tipo IN ('Depósito', 'Saque', 'Transferência')),
        valor DECIMAL(10, 2) NOT NULL CHECK (valor > 0),
        data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        destino_transferencia INT REFERENCES contas (id_conta)
    );

-- Exercício 7
-- Inserir Transações
INSERT INTO
    transacoes (id_conta, tipo, valor)
VALUES
    (1, 'Depósito', 500.00),
    (2, 'Saque', 200.00),
    (1, 'Transferência', 300.00);

-- EXERCÍCIO 8
-- Listar todos os clientes cadastrados.
SELECT
    *
FROM
    clientes;

-- EXERCÍCIO 9
-- Listar todas as contas e seus respectivos clientes.
SELECT
    clientes.nome,
    contas.numero_conta
FROM
    clientes
    LEFT JOIN contas ON clientes.id_cliente = contas.id_cliente;

-- EXERCÍCIO 10
-- Insira um novo cliente no sistema.
INSERT INTO
    clientes (nome, cpf, endereco, telefone)
VALUES
    (
        'José Carlos',
        '15935745655',
        'Rua C, 438',
        '12999733213'
    );

--     EXERCÍCIO 11
-- Crie uma conta para esse novo cliente.
INSERT INTO
    contas (numero_conta, saldo, id_cliente)
VALUES
    (
        '000789',
        0.00,
        (
            SELECT
                id_cliente
            FROM
                clientes
            WHERE
                nome = 'José Carlos'
        )
    );

-- EXERCÍCIO 12
-- Realize uma transferência de R$ 100,00 da conta 000123 para a conta 000789.
BEGIN;

-- 1. Debita da conta de origem
UPDATE contas
SET
    saldo = saldo - 100.00
WHERE
    numero_conta = '000123';

-- 2. Credita na conta de destino
UPDATE contas
SET
    saldo = saldo + 100.00
WHERE
    numero_conta = '000789';

-- 3. Registra a transação na tabela transacoes
INSERT INTO
    transacoes (id_conta, tipo, valor, destino_transferencia)
VALUES
    (
        (
            SELECT
                id_conta
            FROM
                contas
            WHERE
                numero_conta = '000123'
        ),
        'Transferência',
        100.00,
        (
            SELECT
                id_conta
            FROM
                contas
            WHERE
                numero_conta = '000789'
        )
    );

COMMIT;

-- EXERCÍCIO 13
-- Liste todas as contas do banco, mostrando os saldos atualizados.
SELECT
    clientes.nome,
    contas.numero_conta,
	contas.saldo
FROM
    clientes
    LEFT JOIN contas ON clientes.id_cliente = contas.id_cliente;