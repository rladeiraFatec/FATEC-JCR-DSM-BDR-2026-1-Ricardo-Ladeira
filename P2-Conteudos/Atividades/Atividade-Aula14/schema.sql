-- ===================
-- INÍCIO ATIVIDADE 14
-- ===================
-- =============================================================================
-- Exercício 1 – Lógica e Condição
-- =============================================================================
-- Criar uma procedure que:
-- Insira um livro somente se o autor existir
-- Regras:
-- •Verificar se id_autor existe na tabela autor
-- •Se não existir: mostrar erro com RAISE EXCEPTION
-- Habilidade:
-- - IF
-- - SELECT dentro da procedure
-- - Regra de negócio
-- =============================================================================
CREATE OR REPLACE
PROCEDURE
	inserir_livro(
	p_titulo VARCHAR,
	p_ano INT,
	p_id_autor INT,
	p_id_editora INT,
	p_paginas INT
	)
LANGUAGE plpgsql
AS $$
BEGIN
	IF NOT EXISTS (
SELECT
	1
FROM
	autor
WHERE
	id_autor = p_id_autor) THEN
	RAISE EXCEPTION 'Não existe o autor indicado';
END IF;

INSERT
	INTO
	livro (titulo,
	ano_publicacao,
	id_autor,
	id_editora,
	num_paginas)
VALUES
(p_titulo,
p_ano,
p_id_autor,
p_id_editora,
p_paginas);
END;

$$;

-- ====================
-- TESTE
-- ====================

CALL inserir_livro ('a',2020,100,100,100); -- autor não existe

CALL inserir_livro ('Laços de Família',1960,3,2,136);-- autora Clarice Lispector

SELECT * FROM livro;

-- =============================================================================
-- Exercício 2 – Atualização com regra
-- =============================================================================
-- Criar uma procedure que:
-- - Atualize o número de páginas de um livro
-- - Mas só permita valores maiores que 10
-- Caso contrário:
-- 	- Exibir erro
-- Habilidade:
-- 	- Validação
-- 	- UPDATE com condição
-- =============================================================================
CREATE OR REPLACE
PROCEDURE
	atualizar_pg_livro(
	p_id_livro INT,
	p_paginas INT
	)
LANGUAGE plpgsql
AS $$
BEGIN
	IF p_paginas < 10 THEN
	RAISE EXCEPTION 'Número de páginas inferior ao permitido (10)';
END IF;

UPDATE
	livro
SET
	num_paginas = p_paginas
WHERE
	id_livro = p_id_livro;
END;

$$;

-- ====================
-- TESTE
-- ====================

CALL  atualizar_pg_livro (3,3);

CALL atualizar_pg_livro (1,1570);

SELECT * FROM LIVRO;

-- =============================================================================
-- Exercício 3 – Operação composta
-- =============================================================================
-- Criar uma procedure que:
-- - Exclua um autor
-- - Mas só permita se ele NÃO tiver livros cadastrados
-- Habilidade:
-- - Subquery dentro da procedure
-- - Controle de integridade
-- - Lógica de negócio real
-- =============================================================================
CREATE OR REPLACE
PROCEDURE
	apagar_autor(
	p_id_autor INT
	)
LANGUAGE plpgsql
AS $$
BEGIN
IF EXISTS (
SELECT
	1
FROM
	livro
WHERE
	id_autor = p_id_autor) THEN
	RAISE EXCEPTION 'O autor tem livro na biblioteca!';
END IF;

DELETE
FROM
	autor
WHERE
	id_autor = p_id_autor;
END;

$$;

-- ====================
-- TESTE
-- ====================

CALL apagar_autor (1); -- Tem livro na biblioteca - J. R. R. Tolkien

CALL apagar_autor (4); -- Não tem livro na biblioteca - J.K. Rowling

SELECT * FROM autor;

-- =============================================================================
-- Exercício 4 – Procedure com cálculo
-- =============================================================================
-- Criar uma procedure que:
-- - Receba id_autor
-- -Retorne (via SELECT dentro da procedure):
-- 	- Nome do autor
-- 	- Média de páginas dos livros
-- Habilidade:
-- - Agregação
-- - SELECT dentro da procedure
-- - Integração com conteúdo anterior (subquery / AVG)
-- =============================================================================
CREATE OR REPLACE
PROCEDURE info_autor (p_id_autor INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_nome TEXT;
	v_media NUMERIC;
BEGIN
-- Busca os dados e armazena nas variáveis declaradas acima
    SELECT
	a.nome,
	AVG(l.num_paginas)
    INTO
	v_nome,
	v_media
FROM
	autor a
JOIN livro l ON
	a.id_autor = l.id_autor
WHERE
	a.id_autor = p_id_autor
GROUP BY
	a.nome;
-- Exibe o resultado no console
    RAISE NOTICE 'Autor: %, Média de Páginas: %',
v_nome,
v_media;
END;
$$;
-- =============================================================================
-- Usando uma função - mais adequada ao caso
-- =============================================================================

CREATE OR REPLACE
FUNCTION media_paginas_autor(p_id_autor INT)
RETURNS TABLE (nome_autor VARCHAR(100),
media_paginas NUMERIC) 
LANGUAGE plpgsql
AS $$
-- Alterado de TEXT para VARCHAR(100)
BEGIN
    RETURN QUERY
    SELECT
	a.nome,
	AVG(l.num_paginas)::NUMERIC(10, 2)
FROM
	autor a
JOIN 
        livro l ON
	a.id_autor = l.id_autor
WHERE
	a.id_autor = p_id_autor
GROUP BY
	a.nome;
END;

$$;


-- ====================
-- TESTE
-- ====================

CALL info_autor(2); -- Tem um livro com 208 páginas
SELECT * FROM media_paginas_autor(2); -- Tem um livro com 208 páginas

SELECT * FROM livro;

-- =============================================================================
-- Exercício 5 – DESAFIO
-- =============================================================================
-- Criar uma procedure que:
-- - Insira um livro
-- - Aplique TODAS as validações:
--  - páginas > 0
--  - título não pode ser vazio
--  - autor deve existir
-- - Se tudo estiver correto: insere
-- - Caso contrário: erro com mensagem clara
-- Habilidade:
-- - IF
-- - IF aninhado
-- - Regras múltiplas
-- - Pensamento lógico
-- =============================================================================
CREATE OR REPLACE
PROCEDURE
	inserir_livro_com_verificacao(
	p_titulo VARCHAR,
	p_ano INT,
	p_id_autor INT,
	p_id_editora INT,
	p_paginas INT
	)
LANGUAGE plpgsql
AS $$
BEGIN
-- verifica autor
	IF NOT EXISTS (
SELECT
	1
FROM
	autor
WHERE
	id_autor = p_id_autor) THEN
	RAISE EXCEPTION 'Não existe o autor indicado';
END IF;
-- verifica páginas > 0 
	IF p_paginas < 1 THEN
	RAISE EXCEPTION 'O número de páginas não pode ser negativo ou zero.';
END IF;
-- verifica se há título 
	IF p_titulo = '' THEN
	RAISE EXCEPTION 'O livro precisa ter um título';
END IF;

INSERT
	INTO
	livro (titulo,
	ano_publicacao,
	id_autor,
	id_editora,
	num_paginas)
VALUES
(p_titulo,
p_ano,
p_id_autor,
p_id_editora,
p_paginas);
END;

$$;

-- ====================
-- TESTE
-- ====================

CALL inserir_livro_com_verificacao ('a',2020,100,100,100); -- autor não existe

CALL inserir_livro_com_verificacao ('Laços de Família',1960,3,2,0); 
-- livro com 0 páginas

CALL inserir_livro_com_verificacao ('',1960,3,2,136); -- livro com título vazio

CALL inserir_livro_com_verificacao ('The Book of Lost Tales',1969,1,2,297); 
-- autor J. R. R. Tolkien

SELECT * FROM livro;

-- =============================================================================
-- Exercício 6 – DESAFIO
-- =============================================================================
-- Insira um livro com páginas negativas
-- - Depois mostre Procedure bloqueando isso

-- =============================================================================
CALL inserir_livro_com_verificacao ('O Alienista',1882,2,2,-112); 
-- autor Machado de Assis

-- ====================
-- TÉRMINO ATIVIDADE 14
-- ====================
