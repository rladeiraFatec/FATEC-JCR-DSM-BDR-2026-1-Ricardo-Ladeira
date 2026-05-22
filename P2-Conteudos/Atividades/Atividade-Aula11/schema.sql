-- ===================
-- INÍCIO ATIVIDADE 10
-- ===================
-- PREPARAÇÃO
-- Alterar tabela Livro
ALTER TABLE livro
ADD COLUMN num_paginas INT;

UPDATE livro
SET
    num_paginas = 208
WHERE
    titulo = 'Dom Casmurro';

-- Atualizar tabela Livro
UPDATE livro
SET
    num_paginas = 1568
WHERE
    titulo = 'O Senhor dos Anéis';

UPDATE livro
SET
    num_paginas = 88
WHERE
    titulo = 'A Hora da Estrela';

UPDATE livro
SET
    num_paginas = 336
WHERE
    titulo = 'O Hobbit';

-- EXERCÍCIO 1
-- **Usando subquery scalar no SELECT, listar cada autor e quantos livros publicou (COUNT) e a
-- média de páginas.** --
SELECT
    autor.nome,
    (
        SELECT
            COUNT(livro.titulo)
        FROM
            livro
        WHERE
            livro.id_autor = autor.id_autor
    ) AS total_livros,
    (
        SELECT
            AVG(livro.num_paginas)
        FROM
            livro
        WHERE
            livro.id_autor = autor.id_autor
    ) AS media_paginas
FROM
    autor;

-- **Reescrever o mesmo usando CTE e comparar legibilidade.**--
WITH
    LivroInfo AS (
        SELECT
            id_autor,
            COUNT(titulo) AS total_livros,
            AVG(num_paginas) AS media_paginas
        FROM
            livro
        GROUP BY
            id_autor
    )
SELECT
    autor.nome,
    LivroInfo.total_livros,
    LivroInfo.media_paginas
FROM
    autor
    LEFT JOIN LivroInfo ON autor.id_autor = LivroInfo.id_autor;

-- EXERCÍCIO 2
-- Listar autores cuja soma de páginas ultrapassa a média geral.
-- Primeiro calcule paginas_por_autor (CTE ou derived table).
-- Depois compare com média geral (subquery) e retorne autores acima da média. ** --
-- com derived table
SELECT
    autor.nome,
    paginas_por_autor.soma_paginas,
    media_geral.media_paginas
FROM
    autor
    JOIN (
        SELECT
            id_autor,
            SUM(num_paginas) AS soma_paginas
        FROM
            livro
        GROUP BY
            id_autor
    ) AS paginas_por_autor ON autor.id_autor = paginas_por_autor.id_autor
    CROSS JOIN (
        SELECT
            AVG(num_paginas) AS media_paginas
        FROM
            livro
    ) AS media_geral
WHERE
    paginas_por_autor.soma_paginas > media_geral.media_paginas;

-- com CTE
WITH
    paginas_por_autor AS (
        SELECT
            id_autor,
            SUM(num_paginas) AS soma_paginas
        FROM
            livro
        GROUP BY
            id_autor
    ),
    media_geral AS (
        SELECT
            AVG(num_paginas) AS media_paginas
        FROM
            livro
    )
SELECT
    autor.nome,
    paginas_por_autor.soma_paginas,
    media_geral.media_paginas
FROM
    autor
    JOIN paginas_por_autor ON autor.id_autor = paginas_por_autor.id_autor
    CROSS JOIN media_geral
WHERE
    paginas_por_autor.soma_paginas > media_geral.media_paginas;

-- EXERCÍCIO 3 - Versão A: Subconsulta Correlacionada
-- Listar livros com número de páginas acima da média do seu próprio autor
SELECT
    l.titulo,
    a.nome AS autor,
    l.num_paginas,
    (
        SELECT
            AVG(l2.num_paginas)
        FROM
            livro l2
        WHERE
            l2.id_autor = l.id_autor
    ) AS media_do_autor
FROM
    livro l
    JOIN autor a ON l.id_autor = a.id_autor
WHERE
    l.num_paginas > (
        SELECT
            AVG(l2.num_paginas)
        FROM
            livro l2
        WHERE
            l2.id_autor = l.id_autor
    )
ORDER BY
    a.nome,
    l.num_paginas DESC;

-- EXERCÍCIO 3 - Versão B: CTE Pré-agrupada
-- Listar livros com número de páginas acima da média do seu próprio autor
WITH
    media_por_autor AS (
        SELECT
            id_autor,
            AVG(num_paginas) AS media_paginas_autor
        FROM
            livro
        GROUP BY
            id_autor
    )
SELECT
    l.titulo,
    a.nome AS autor,
    l.num_paginas,
    m.media_paginas_autor
FROM
    livro l
    JOIN autor a ON l.id_autor = a.id_autor
    JOIN media_por_autor m ON l.id_autor = m.id_autor
WHERE
    l.num_paginas > m.media_paginas_autor
ORDER BY
    a.nome,
    l.num_paginas DESC;