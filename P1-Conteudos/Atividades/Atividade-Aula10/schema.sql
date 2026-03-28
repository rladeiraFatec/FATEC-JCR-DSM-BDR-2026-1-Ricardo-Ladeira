-- ===================
-- INÍCIO ATIVIDADE 10
-- ===================

-- EXERCÍCIO 1
-- **Acrescentei uma editora sem livros** --
INSERT INTO editora (nome, cidade)
	VALUES ('Sextante', 'Rio de Janeiro');
-- Liste todas as editoras, mesmo aquelas que não possuem livros cadastrados.
SELECT
	e.nome AS Editoras
FROM
	editora e;
-- Produz o mesmo que:
SELECT
	e.nome AS Editoras
FROM
    editora e
LEFT JOIN livro l ON l.id_editora = e.id_editora
GROUP BY e.nome;
-- EXERCÍCIO 2
-- Liste todas as editoras e a quantidade de livros, incluindo editoras com zero livros.
SELECT
	e.nome AS Editoras,
    COUNT(l.id_livro) AS Quantidade_de_livros
FROM
    editora e
LEFT JOIN livro l ON l.id_editora = e.id_editora
GROUP BY
	e.nome
ORDER BY
	Quantidade_de_livros DESC;
-- EXERCÍCIO 3
-- Liste cada autor e a quantidade de livros publicados por editora.
SELECT
    a.nome AS Autor,
    e.nome AS Editora,
    COUNT(l.id_livro) AS Quantidade_de_livros
FROM
    autor a
LEFT JOIN
    livro l ON a.id_autor = l.id_autor
LEFT JOIN
    editora e ON l.id_editora = e.id_editora
GROUP BY
    a.nome,
    e.nome
ORDER BY
    a.nome;
-- EXERCÍCIO 4
-- Liste as editoras que possuem mais de 1 livro cadastrado.
SELECT
    e.nome AS Editoras,
    COUNT(l.id_livro) AS Quantidade_de_livros_publicados
FROM
    livro l
    INNER JOIN editora e ON e.id_editora = l.id_editora
GROUP BY
	Editoras
HAVING COUNT(l.id_livro) >1;
-- EXERCÍCIO 5
-- RELATÓRIO COMPLEXO (nível avançado)
-- A biblioteca deseja um relatório com:
-- nome da editora
-- total de livros publicados
-- quantidade de empréstimos desses livros
SELECT
    e.nome AS Editora,
    COUNT(DISTINCT l.id_livro ) AS Total_livros_publicados,
    COUNT (emp.id_emprestimo) AS Quantidade_de_livros_emprestados
FROM
    livro l
    LEFT JOIN editora e ON e.id_editora = l.id_editora
    LEFT JOIN emprestimo_livro emp_l ON emp_l.id_livro = l.id_livro
	LEFT JOIN emprestimo emp ON emp.id_emprestimo = emp_l.id_emprestimo
GROUP BY
    e.nome;
-- CREIO QUE NÃO PRECISEMOS UTILIZAR A TABELA EMPRÉSTIMO POIS A TABELA EMPRESTIMO_LIVRO JÁ
-- TEM AS INFORMAÇÕES NECESSÁRIAS SENDO REDUNDANTE O USO DESSA TABELA.

-- ====================
-- TÉRMINO ATIVIDADE 10
-- ====================

