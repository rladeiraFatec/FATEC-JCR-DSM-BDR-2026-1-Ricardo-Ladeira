-- ===================
-- INÍCIO ATIVIDADE 13
-- ===================

-- ========================================
-- Exercício 1 – Criar uma VIEW que liste:
	--título do livro
	--número de páginas
-- ========================================
CREATE VIEW vw_listar_titulo_num_paginas AS
SELECT
	titulo,
	num_paginas
FROM
	livro;
-- ========================================
-- TESTE
-- ========================================
SELECT
	*
FROM
	vw_listar_titulo_num_paginas;

-- ========================================
-- Exercício 2 - Criar uma VIEW com:
-- autores que possuem mais de 1 livro 
-- (Dica: usar HAVING)
-- ========================================
CREATE VIEW vw_autores_com_livros AS
SELECT
	a.nome
FROM
	autor a
JOIN 
    livro l ON
	l.id_autor = a.id_autor
GROUP BY
	a.id_autor,
	a.nome
HAVING
	COUNT(l.id_livro) > 1;

-- ========================================
-- TESTE
-- ========================================
SELECT
	*
FROM
	vw_autores_com_livros;

-- ========================================
-- Exercício 3 - Criar uma VIEW com:
-- livros acima da média de páginas
-- ========================================
CREATE VIEW vw_livros_acima_media AS
SELECT
	titulo,
	num_paginas
FROM
	livro
WHERE
	num_paginas > (
	SELECT
		AVG(num_paginas)
	FROM
		livro);

-- ========================================
-- TESTE
-- ========================================
SELECT
	*
FROM
	vw_livros_acima_media;

-- ========================================
-- Exercício 4 - Criar uma VIEW que mostre:
-- autor
-- título do livro
-- ano de publicação
-- ========================================
CREATE VIEW vw_autor_titulo_publicacao AS
SELECT
	a.nome,
	l.titulo,
	l.ano_publicacao
FROM
	autor a
JOIN 
    livro l ON
	l.id_autor = a.id_autor
GROUP BY
	a.nome,
	l.titulo,
	l.ano_publicacao;

-- ========================================
-- TESTE
-- ========================================
SELECT
	*
FROM
	vw_autor_titulo_publicacao;

-- ========================================
-- Exercício 5 - Criar uma VIEW com:
-- autor
-- total de livros
-- maior número de páginas
-- ========================================
CREATE VIEW vw_autor_total_livros_maior_num_paginas AS
SELECT
	a.nome AS autor,
	COUNT(l.id_livro) AS total_livros,
	MAX(l.num_paginas) AS maior_numero_paginas
FROM
	autor a
JOIN 
    livro l ON
	a.id_autor = l.id_autor
GROUP BY
	a.nome;

-- ========================================
-- TESTE
-- ========================================
SELECT
	*
FROM
	vw_autor_total_livros_maior_num_paginas;

-- ===================
-- TÉRMINO ATIVIDADE 13
-- ===================

