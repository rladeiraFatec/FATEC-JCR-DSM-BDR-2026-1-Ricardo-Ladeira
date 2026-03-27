-- ==================
-- INÍCIO ATIVIDADE 9
-- ==================
--EXERCÍCIO 1
--Escreva uma query que retorne titulo do evento e nome do tipo_evento (INNER JOIN).
SELECT
    evento.titulo AS titulo_do_evento,
    tipoevento.nome AS nome_do_tipo_evento
FROM
    evento
    INNER JOIN tipoevento ON evento.idtipoevento = tipoevento.idtipoevento;

-- EXERCÍCIO 2
-- Escreva uma query que retorne titulo do evento, cidade e sigla_estado (INNER JOIN evento → localizacao).
SELECT
    evento.titulo AS titulo_do_evento,
    localizacao.cidade,
    localizacao.estado AS sigla_estado
FROM
    evento
    INNER JOIN localizacao ON evento.idlocalizacao = localizacao.idlocalizacao;

-- EXERCÍCIO 3
-- Escreva uma query que retorne titulo do evento, tipo_evento, cidade, incluindo eventos que
-- possam não ter localizacao (usar LEFT JOIN quando necessário). Explique por que escolheu
-- LEFT/INNER.
SELECT
    evento.titulo AS titulo_do_evento,
    tipoevento.nome AS tipo_evento,
    localizacao.cidade
FROM
    localizacao
    LEFT JOIN evento ON evento.idlocalizacao = localizacao.idlocalizacao
    LEFT JOIN tipoevento ON evento.idtipoevento = tipoevento.idtipoevento;

-- Usei o LEFT JOIN pois ele irá buscar todos os elementos existentes na tabela a esquerda (localizacao),
-- mesmo que as tabelas à direita tenham campos nulos (sem correspondências nas três tabelas)
-- EXERCÍCIO 4
-- Reescreva a Consulta B usando RIGHT JOIN (invertendo a ordem das tabelas) e verifique que o resultado 
-- é equivalente. Anote as diferenças de leitura/legibilidade.
SELECT
    evento.titulo AS titulo_do_evento,
    tipoevento.nome AS tipo_evento,
    localizacao.cidade
FROM
    evento
    RIGHT JOIN tipoevento ON evento.idtipoevento = tipoevento.idtipoevento
    RIGHT JOIN localizacao ON evento.idlocalizacao = localizacao.idlocalizacao;

-- O resultado foi o mesmo. No entanto, a legibilidade pode ser comprometida, pois começar com a tabela principal,
-- como `evento`, facilita a compreensão do propósito da consulta. Quando a tabela principal aparece após as 
-- tabelas relacionadas, exige mais esforço do leitor para entender as interligações. 
-- EXERCÍCIO 5
-- Crie uma query que mostre para cada cidade a quantidade de eventos (usar JOIN + GROUP BY),
-- este exercício já prepara a Aula 10.
SELECT
    localizacao.cidade AS cidade,
    COUNT(evento.titulo) AS quantidade_de_eventos
FROM
    localizacao
    LEFT JOIN evento ON evento.idlocalizacao = localizacao.idlocalizacao
GROUP BY
    localizacao.cidade;

-- ================
-- FIM ATIVIDADE 9
-- ================