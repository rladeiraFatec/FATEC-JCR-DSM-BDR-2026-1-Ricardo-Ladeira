-- ===================
-- INÍCIO ATIVIDADE 16
-- ===================

-- ===================
-- PREPARATIVOS
-- ===================
-- Cria uma coluna na tabela livro para armazenar a quantidade de livros
ALTER TABLE livro
ADD COLUMN quantidade INTEGER DEFAULT 5;

-- Cria tabela de log
CREATE TABLE log_livro (
	id_log SERIAL PRIMARY KEY,
	titulo VARCHAR(100),
	quantidade_antiga INTEGER,
	quantidade_nova INTEGER,
	data_log TIMESTAMP
);

-- Cria tabela de log de exclusao
CREATE TABLE log_exclusao_livro (
	id_log SERIAL PRIMARY KEY,
	titulo VARCHAR(100),
	data_log TIMESTAMP,
	mensagem VARCHAR(100)
);

-- =============================================================================
-- Exercício 1 – Trigger para Bloqueio de Exclusão
-- =============================================================================
-- A coordenação deseja impedir que livros sejam removidos do sistema caso 
-- ainda existam exemplares disponíveis.
-- Desenvolva:
-- a)
-- Uma FUNCTION chamada:
-- bloquear_exclusao()
-- que:
--  - impeça DELETE quando:
-- 		quantidade > 0
-- 	- utilize:
-- 		RAISE EXCEPTION
-- para exibir mensagem apropriada.
-- b)
-- Uma TRIGGER chamada:
-- 	- trg_bloquear_exclusao
-- executada BEFORE DELETE na tabela:
-- 		livro
-- =============================================================================
CREATE OR REPLACE
FUNCTION
bloquear_exclusao()
RETURNS TRIGGER
AS $$
BEGIN
	IF OLD.quantidade >0 THEN
	RAISE EXCEPTION 'Não podemos excluir registros enquanto há livros 
					existentes!';
END IF;

RETURN OLD;
END;

$$ LANGUAGE plpgsql;
-- ====================
-- Trigger
-- ==================== 
CREATE TRIGGER trg_bloquear_exclusao 
BEFORE
DELETE
	ON
	livro
FOR EACH ROW
EXECUTE FUNCTION bloquear_exclusao();
-- ===================
-- TESTE
-- ===================
DELETE FROM livro WHERE id_livro = 1; -- temos 5 livros
INSERT  INTO livro VALUES (7,'O Alienista',1882,2,2,112,0); -- quantidade 0
DELETE FROM livro WHERE id_livro = 7; -- deve apagar o livro "O Alienista"

-- =============================================================================
-- Exercício 2 – Registro Automático de Exclusões
-- =============================================================================
-- A biblioteca deseja manter histórico de livros removidos do sistema.
-- Desenvolva:
-- a)Uma FUNCTION chamada:
-- 	log_exclusao_livro()
-- que registre:
-- 	-título do livro removido;
-- 	-data e hora da exclusão;
-- 	-mensagem informativa no log.
-- b)Uma TRIGGER chamada:
-- 	trg_log_exclusao
-- executada AFTER DELETE na tabela:
-- 	livro
-- =============================================================================
CREATE OR REPLACE
FUNCTION
log_exclusao_livro()
RETURNS TRIGGER
AS $$
BEGIN 
	INSERT
	INTO
	log_exclusao_livro(
	titulo,
	data_log,
	mensagem)
VALUES(
	OLD.titulo,
	CURRENT_TIMESTAMP,
	'Registro removido.');

RETURN OLD;
END
$$ LANGUAGE plpgsql;
-- ====================
-- Trigger
-- ====================
CREATE TRIGGER trg_log_exclusao_livro
AFTER
DELETE
	ON
	livro
FOR EACH ROW
EXECUTE FUNCTION log_exclusao_livro();
-- ===================
-- TESTE
-- ===================
DELETE FROM livro WHERE id_livro = 1; -- temos 5 livros
INSERT  INTO livro VALUES (8,'O Alienista',1882,2,2,112,0); -- quantidade 0
DELETE FROM livro WHERE id_livro = 8;-- deve apagar o livro e registrar no log

-- =============================================================================
-- Exercício 3 – Controle de Aumento Excessivo de Estoque
-- =============================================================================
-- Durante auditorias, foi identificado que alguns operadores cadastraram quan-
-- tidades irreais de livros.
-- Crie:
-- a) Uma FUNCTION chamada:
-- 	validar_limite_estoque() que:
-- 		-impeça UPDATE quando:
-- 			-quantidade > 100
-- 		-apresente mensagem de erro usando:
-- 			RAISE EXCEPTION
-- b)Uma TRIGGER chamada:
-- 	trg_validar_limite
-- 		executada BEFORE UPDATE na tabela livro
-- =============================================================================
CREATE OR REPLACE
FUNCTION
validar_limite_estoque()
RETURNS TRIGGER
AS $$
BEGIN
	IF NEW.quantidade >100 THEN
	RAISE EXCEPTION 'Solicite autorização para inserir mais de 100 
	quantidades.';
END IF;

RETURN NEW;
END;

$$ LANGUAGE plpgsql;
-- ====================
-- Trigger
-- ==================== 
CREATE TRIGGER trg_validar_limite_estoque
BEFORE
UPDATE
	ON
	livro
FOR EACH ROW
EXECUTE FUNCTION validar_limite_estoque();
-- ===================
-- TESTE
-- ===================
UPDATE livro SET quantidade = 100 WHERE id_livro = 1; --aumenta de 5 para 100!
UPDATE livro SET quantidade = 101 WHERE id_livro = 1; --impede a atualização.

-- =============================================================================
-- Exercício 4 – Análise de Trigger BEFORE e AFTER
-- =============================================================================
-- Observe o cenário:
-- A equipe criou uma trigger:
-- 	BEFORE UPDATE
-- para validar estoque e outra:
-- 	AFTER UPDATE
-- para registrar logs.
-- Explique detalhadamente:
-- a) A diferença entre triggers BEFORE e AFTER.
-- b) Qual delas deve ser usada para validação.
-- c) Qual delas deve ser usada para auditoria.
-- d) Por que a ordem de execução é importante em bancos de dados reais.
-- =============================================================================

-- ====================
-- RESPOSTAS
-- ==================== 
-- a) BEFORE executa a ação antes da transação ocorrer; AFTER executa a ação 
-- após sua conclusão.
-- b) Para validação, deve ser usada BEFORE.
-- c) Para auditoria, deve ser usada AFTER, já que o fato já ocorreu.
-- d) Pois a ordem importa na manutenção da integridade dos dados lá existentes.
-- Além da integridade, a ordem é crucial para a performance e o controle de 
-- erros. Se tivermos várias triggers do mesmo tipo (todas `BEFORE`, por 
-- exemplo), a ordem em que elas são criadas define a ordem de execução. Supondo
-- que uma trigger de validação de estoque falhar, ela impede que todas as 
-- triggers subsequentes sejam executadas, o que evita criar falsos logs.

-- =============================================================================
-- Exercício 5 – Reflexão sobre Integridade e Automação
-- =============================================================================
-- Uma empresa decidiu remover todas as triggers do banco e deixar as 
-- validações apenas na aplicação.
-- Analise criticamente:
-- a) Quais riscos essa decisão pode gerar.
-- b) Quais vantagens existem em manter regras diretamente no banco.
-- c) Explique como triggers ajudam na integridade e consistência dos dados.
-- d) Cite um exemplo real de uso de triggers em sistemas corporativos.
-- =============================================================================

-- ====================
-- RESPOSTAS
-- ==================== 
-- a)A remoção total das triggers e a dependência exclusiva da aplicação para 
-- validações trazem riscos críticos:
-- -Perda de regras em acessos diretos: Se um administrador ou desenvolvedor 
-- executar um comando SQL manualmente direto no banco, as regras de negó-
-- cio da aplicação não serão aplicadas, o que pode corromper os dados.
-- -Vulnerabilidade a falhas na aplicação: Se o frontend falhar ou o backend 
-- apresentar um bug na persistência, as regras críticas deixam de existir, 
-- pois não há uma última defesa no banco de dados.
-- -Inconsistência entre múltiplos sistemas: Caso a empresa utilize diferentes 
-- sistemas (ex: um app mobile e um sistema web) acessando o mesmo banco, a 
-- lógica de validação teria que ser duplicada em todos eles, aumentando o 
-- risco de discrepâncias.

-- b)Manter certas regras no banco de dados oferece benefícios estratégicos:
-- -Centralização: A regra fica em um único lugar, garantindo que qualquer 
-- sistema que acesse o banco siga o mesmo padrão.
-- -Segurança e Integridade: O banco protege a si mesmo contra dados inválidos, 
-- independentemente de onde venha a requisição.
-- -Auditoria Automática: É possível gerar históricos de alterações (logs) de 
-- forma nativa e automática, sem depender da lógica da aplicação.
-- -Padronização: Garante que tarefas manuais e repetitivas sejam automatiza-
-- das, eliminando o erro humano no processo de atualização de dados 
-- relacionados.

-- c)Como triggers ajudam na integridade e consistência
-- -As triggers funcionam como sensores automáticos que reagem a eventos 
-- (INSERT, UPDATE, DELETE) para garantir que o estado do banco permaneça 
-- consistente:
-- -Validação Preventiva (BEFORE): Podem bloquear a inserção de dados inváli-
-- dos,como impedir que um livro seja cadastrado com número de páginas negativo.
-- -Sincronização Automática (AFTER): Garantem que, ao realizar uma ação 
-- (como um empréstimo), outras tabelas sejam atualizadas instantaneamente 
-- (como a redução do estoque), mantendo o equilíbrio dos dados.
-- -Garantia de Consistência: Elas operam dentro do conceito de transações, 
-- assegurando que, se a trigger falhar, a operação principal também falhe, 
-- evitando dados quebrados ou incompletos.

-- d)Exemplo real de uso em sistemas corporativos
-- -E-commerce: Atualização automática de estoque sempre que um pedido é fatu-
-- rado.
-- -Setor Bancário: Registro de toda e qualquer movimentação financeira em ta-
-- belas de log para fins de auditoria e segurança.
-- -RH: Registro de histórico de alterações salariais, armazenando o valor an-
-- tigo e o novo, além de quem fez a alteração e quando.

-- Conclusão: Embora o excesso de triggers possa dificultar o debug e impactar 
-- a performance, removê-las completamente é perigoso. As boas práticas sugerem 
-- que regras críticas de integridade devem permanecer no banco de dados, en-
-- quanto lógicas de negócio complexas e regras visuais devem ficar na apli-
-- cação.

-- ====================
-- TÉRMINO ATIVIDADE 16
-- ====================
