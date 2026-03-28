-- Tabela Autor
CREATE TABLE
    autor (
        id_autor SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL
    );

-- Tabela Livro
CREATE TABLE
    livro (
        id_livro SERIAL PRIMARY KEY,
        titulo VARCHAR(150) NOT NULL,
        ano_publicacao INT,
        id_autor INT REFERENCES autor (id_autor)
    );

-- Tabela Aluno
CREATE TABLE
    aluno (
        id_aluno SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        curso VARCHAR(100) NOT NULL
    );

-- Tabela Emprestimo
CREATE TABLE
    emprestimo (
        id_emprestimo SERIAL PRIMARY KEY,
        data_emprestimo DATE NOT NULL,
        id_aluno INT REFERENCES aluno (id_aluno)
    );

-- Tabela associativa EmprestimoLivro
CREATE TABLE
    emprestimo_livro (
        id_emprestimo INT REFERENCES emprestimo (id_emprestimo),
        id_livro INT REFERENCES livro (id_livro),
        PRIMARY KEY (id_emprestimo, id_livro)
    );

-- Autores
INSERT INTO
    autor (nome)
VALUES
    ('J. R. R. Tolkien'),
    ('Machado de Assis'),
    ('Clarice Lispector'),
    ('J.K. Rowling');

-- Livros
INSERT INTO
    livro (titulo, ano_publicacao, id_autor)
VALUES
    ('O Senhor dos Anéis', 1954, 1),
    ('Dom Casmurro', 1899, 2),
    ('A Hora da Estrela', 1977, 3),
    ('O Hobbit', 1937, 1);

-- Alunos
INSERT INTO
    aluno (nome, curso)
VALUES
    ('Ana Souza', 'Sistemas de Informação'),
    ('Bruno Silva', 'Engenharia de Software');

-- Empréstimos
INSERT INTO
    emprestimo (data_emprestimo, id_aluno)
VALUES
    ('2025-08-20', 1),
    ('2025-08-21', 2);

-- EmprestimoLivro (associativa)
INSERT INTO
    emprestimo_livro (id_emprestimo, id_livro)
VALUES
    (1, 1), -- Ana Souza pegou O Senhor dos Anéis
    (1, 2), -- Ana Souza pegou Dom Casmurro
    (2, 3); -- Bruno Silva pegou A Hora da Estrela
-- Contar quantos empréstimos foram feitos
SELECT
    COUNT(*) AS total_emprestimos
FROM
    emprestimo;

-- Autores
SELECT
    *
FROM
    autor;

-- Livros
SELECT
    *
FROM
    livro;

-- Alunos
SELECT
    *
FROM
    aluno;

-- Empréstimos
SELECT
    *
FROM
    emprestimo;

-- EmprestimoLivro (associativa)
SELECT
    *
FROM
    emprestimo_livro;

-- Editora
CREATE TABLE
    editora (
        id_editora SERIAL PRIMARY KEY,
        nome VARCHAR(100) NOT NULL,
        cidade VARCHAR(100)
    );

-- Alterar tabela Livro
ALTER TABLE livro
ADD COLUMN id_editora INT;

ALTER TABLE livro ADD CONSTRAINT fk_livro_editora FOREIGN KEY (id_editora) REFERENCES editora (id_editora);

-- Editora
INSERT INTO
    editora (nome, cidade)
VALUES
    ('Companhia das Letras', 'São Paulo'),
    ('Saraiva', 'São Paulo'),
    ('Atlas', 'Rio de Janeiro');

-- Livros
SELECT
    *
FROM
    livro;

-- Atualizar os livros
UPDATE livro
SET
    id_editora = 1
WHERE
    titulo = 'O Senhor dos Anéis';

UPDATE livro
SET
    id_editora = 2
WHERE
    titulo = 'Dom Casmurro';

UPDATE livro
SET
    id_editora = 3
WHERE
    titulo = 'A Hora da Estrela';

UPDATE livro
SET
    id_editora = 1
WHERE
    titulo = 'O Hobbit';

-- Listar os livros com as respectivas editoras
--JOIN simples:
SELECT
    l.titulo,
    e.nome
FROM
    livro l
    JOIN editora e ON l.id_editora = e.id_editora;

-- Listar o nome do livro, o autor e a editora
-- JOIN múltiplo (3 tabelas):
SELECT
    l.titulo,
    a.nome AS autor,
    e.nome AS editora
FROM
    livro l
    JOIN autor a ON l.id_autor = a.id_autor
    JOIN editora e ON l.id_editora = e.id_editora;

-- Quantidade de livros por editora
--GROUP BY:
SELECT
    e.nome,
    COUNT(*) AS total_livros
FROM
    livro l
    JOIN editora e ON l.id_editora = e.id_editora
GROUP BY
    e.nome;

-- Quantos livros cada autor publicou em cada editora. Isso ajuda a identificar se um
-- autor concentra suas publicações em uma única editora ou diversifica.GROUP BY em consultas com múltiplas tabelas Banco de Dados Relacional - Prof.ª Lucineide Pimenta
SELECT
    a.nome AS autor,
    e.nome AS editora,
    COUNT(l.id_livro) AS total_livros
FROM
    autor a
    INNER JOIN livro l ON a.id_autor = l.id_autor
    INNER JOIN editora e ON l.id_editora = e.id_editora
GROUP BY
    a.nome,
    e.nome
ORDER BY
    total_livros DESC;

-- Mostrar apenas editoras que publicaram mais de 5 livros
SELECT
    e.nome AS editora,
    COUNT(l.id_livro) AS total_livros
FROM
    editora e
    INNER JOIN livro l ON e.id_editora = l.id_editora
GROUP BY
    e.nome
HAVING
    COUNT(l.id_livro) > 1;