/*
DISCLAIMER : UTILIZAÇÃO DE IA

Foi utilizada IA em algum dos triggers, uma vez que a sua estrutura era muit similar. Ex: Impor restrições de ISA's
Foi utilizada IA para a realização das inserções
Na realização de algumas funções

*/

-- TODO: 
/* 
- Criar asserções para os ISA para disjoint e ISA totais #DONE
- Efetuar pedido se houver espaço no restaurante. Acrescentar atributo numero_clientes em pedido TRIGGER #DONE
- Um prato ou bebida tem que fazer parte de um item #DONE
- Efetuar ITEMS com Ingredientes que estejam dentro do prazo TRIGGER #DONE
- Subtrair em stock uma vez efetuado um pedido #DONE
- Para encomendar ITEM Ingredientes todos tem que ter stock no local da encomenda TRIGGER #DONE
- Certificar que todos empregados trabalham em algum lugar e todo restaurante tenha algum empregado #DONE
- Empregados podem nao ter algum gerente. #DONE
- Um item pode ser um ingrediente. Certificar que o Item se é prato não é mais nada #DONE
- A cada momento apenas pode existir um menu de uma epoca em um restaurante.
- Implementar UPDATE ON CASCADE #DONE
- Implementar DELETE ON CASCADE #DONE
- 1 consulta com JOIN #DONE
- 1 consulta com AGREGAÇÕES #DONE
- 1 consulta com OPERAÇÕES DE CONJUNTOS #DONE
*/

DROP TABLE RESTAURANTES CASCADE CONSTRAINTS;
DROP TABLE MORADA CASCADE CONSTRAINTS;
DROP TABLE MOBILIA_MATERIAIS CASCADE CONSTRAINTS;
DROP TABLE PESSOAS CASCADE CONSTRAINTS;
DROP TABLE FUNCIONARIOS CASCADE CONSTRAINTS;
DROP TABLE FORNECEDORES CASCADE CONSTRAINTS;
DROP TABLE DIRECAO CASCADE CONSTRAINTS;
DROP TABLE CHEF CASCADE CONSTRAINTS;
DROP TABLE CONTACTOS CASCADE CONSTRAINTS;
DROP TABLE PEDIDOS CASCADE CONSTRAINTS;
DROP TABLE CARDAPIO CASCADE CONSTRAINTS;
DROP TABLE INGREDIENTES CASCADE CONSTRAINTS;
DROP TABLE ITEM CASCADE CONSTRAINTS;
DROP TABLE PRATO CASCADE CONSTRAINTS;
DROP TABLE BEBIDA CASCADE CONSTRAINTS;
DROP TABLE STOCK CASCADE CONSTRAINTS;
DROP TABLE INVENTARIO CASCADE CONSTRAINTS;
DROP TABLE ENCOMENDA CASCADE CONSTRAINTS;
DROP TABLE FREQUENTAM CASCADE CONSTRAINTS;
DROP TABLE CARTAS CASCADE CONSTRAINTS;
DROP TABLE GERE CASCADE CONSTRAINTS;
DROP TABLE FORNECE CASCADE CONSTRAINTS;
DROP TABLE CONSTITUICAO CASCADE CONSTRAINTS;
DROP SEQUENCE codigo_bens;
DROP SEQUENCE codigo_ingredientes;
DROP SEQUENCE numero_pedido;


CREATE TABLE MORADA (
    CP INT PRIMARY KEY,
    LOCALIDADE VARCHAR(100)
);

CREATE TABLE RESTAURANTES (
    NUMEROCADEIA INT CHECK(NUMEROCADEIA > 0),
    NOMERESTAURANTE VARCHAR(100) UNIQUE NOT NULL,
    HORAABERTURA TIMESTAMP NOT NULL ,
    HORAFECHO TIMESTAMP NOT NULL ,
    LUGARES INT CHECK(LUGARES > 40) NOT NULL,
    CP INT,
    PRIMARY KEY (NUMEROCADEIA, CP),
    FOREIGN KEY (CP) REFERENCES MORADA(CP) ON DELETE CASCADE,
    CONSTRAINT check_opening_time CHECK(HORAFECHO > HORAABERTURA)
);


CREATE TABLE MOBILIA_MATERIAIS (
    CODIGOBENS INT PRIMARY KEY,
    NOMEBENS VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE PESSOAS (
    NOMEPESSOA VARCHAR(100) UNIQUE NOT NULL,
    NIF VARCHAR(20) UNIQUE,
    CC VARCHAR(20) PRIMARY KEY,
    EMAIL VARCHAR(100) UNIQUE
);

CREATE TABLE FUNCIONARIOS (
    CC VARCHAR(20),
    SALARIO DECIMAL(6,2),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE
);

CREATE TABLE FORNECEDORES (
    CC VARCHAR(20),
    NUMEROCONTA VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE
);

CREATE TABLE DIRECAO (
    CC VARCHAR(20),
    BONUS DECIMAL(10, 2) NOT NULL CHECK(BONUS >= 0),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE
);

CREATE TABLE CHEF (
    CC VARCHAR(20) ,
    ESTRELAS INT CHECK(ESTRELAS >= 0),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE
);

CREATE TABLE CONTACTOS (
    CC VARCHAR(20),
    NUMEROTELEFONE VARCHAR(15) UNIQUE, --Duas pessoas não podem ter o mesmo número
    PRIMARY KEY (CC, NUMEROTELEFONE),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE
);

CREATE TABLE PEDIDOS (
    NUMEROPEDIDO INT PRIMARY KEY,
    HORA TIMESTAMP, -- Redundante??? --
    TEMPO_TERMINO TIMESTAMP NOT NULL,
    NUMEROCLIENTES INT NOT NULL,
    CP INT,
    NUMEROCADEIA INT,
    CC VARCHAR(20),
    FOREIGN KEY (CP) REFERENCES MORADA ON DELETE CASCADE,
    FOREIGN KEY (NUMEROCADEIA, CP) REFERENCES RESTAURANTES ON DELETE CASCADE,
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE
);

CREATE TABLE CARDAPIO (
    EPOCA VARCHAR(10) PRIMARY KEY  CHECK (EPOCA IN ('Verão', 'Inverno', 'Primavera', 'Outono')),
    NOMECARDAPIO VARCHAR(100) -- Pode não ter nome o cardápio --
);


CREATE TABLE INGREDIENTES (
    CODIGOINGREDIENTES INT PRIMARY KEY,
    NOME VARCHAR(100) UNIQUE NOT NULL,
    PROVENIENCIA VARCHAR(100),
    DATAVALIDADE DATE NOT NULL,
    PRECO DECIMAL(10, 2) CHECK (PRECO > 0)
);


CREATE TABLE ITEM (
    NOMEITEM VARCHAR(100) PRIMARY KEY,
    EPOCA VARCHAR(10) CHECK (EPOCA IN ('Verão', 'Inverno', 'Primavera', 'Outono')),
    DESCRICAO VARCHAR(255) NOT NULL,
    PRECO DECIMAL(10, 2) CHECK (PRECO > 0.0),
    FOREIGN KEY (EPOCA) REFERENCES CARDAPIO(EPOCA) ON DELETE CASCADE
);


CREATE TABLE PRATO (
    NOMEITEM VARCHAR(100),
    TIPO VARCHAR(50) CHECK (TIPO IN ('Principal', 'Entrada', 'Sobremesa')),
    FOREIGN KEY (NOMEITEM)  REFERENCES ITEM(NOMEITEM) ON DELETE CASCADE
);

CREATE TABLE BEBIDA (
    NOMEITEM VARCHAR(100),
    TEORALCOOL DECIMAL(5, 2) CHECK (TEORALCOOL >= 0), 
    FOREIGN KEY (NOMEITEM) REFERENCES ITEM(NOMEITEM) ON DELETE CASCADE
);

CREATE TABLE STOCK (
    CODIGOINGREDIENTES INT,
    NUMEROCADEIA INT,
    CP INT,
    QUANTIDADE_STOCK INT CHECK (QUANTIDADE_STOCK >= 0),
    PRIMARY KEY (CODIGOINGREDIENTES, NUMEROCADEIA, CP),
    FOREIGN KEY (CODIGOINGREDIENTES) REFERENCES INGREDIENTES(CODIGOINGREDIENTES) ON DELETE CASCADE,
    FOREIGN KEY (NUMEROCADEIA,CP) REFERENCES RESTAURANTES(NUMEROCADEIA,CP) ON DELETE CASCADE
);

CREATE TABLE INVENTARIO (
    NUMEROCADEIA INT,
    CP INT,
    CODIGOBENS INT,
    QUANTIDADE_INVENTARIO INT CHECK( QUANTIDADE_INVENTARIO >= 0),
    PRIMARY KEY (NUMEROCADEIA, CP, CODIGOBENS),
    FOREIGN KEY (NUMEROCADEIA, CP) REFERENCES RESTAURANTES(NUMEROCADEIA, CP) ON DELETE CASCADE,
    FOREIGN KEY (CODIGOBENS) REFERENCES MOBILIA_MATERIAIS(CODIGOBENS) ON DELETE CASCADE
);

CREATE TABLE FREQUENTAM (
    CC VARCHAR(20),
    NUMEROCADEIA INT,
    CP INT,
    PRIMARY KEY (CC, NUMEROCADEIA, CP),
    FOREIGN KEY (CP) REFERENCES MORADA(CP),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE,
    FOREIGN KEY (NUMEROCADEIA,CP) REFERENCES RESTAURANTES(NUMEROCADEIA, CP) ON DELETE CASCADE
);

CREATE TABLE CARTAS (
    EPOCA VARCHAR(50),
    NUMEROCADEIA INT,
    CP INT,
    PRIMARY KEY (EPOCA, NUMEROCADEIA, CP),
    FOREIGN KEY (NUMEROCADEIA, CP) REFERENCES RESTAURANTES(NUMEROCADEIA, CP) ON DELETE CASCADE,
    FOREIGN KEY (EPOCA) REFERENCES CARDAPIO(EPOCA) ON DELETE CASCADE
);

CREATE TABLE GERE (
    CC VARCHAR(20),
    DIRECAO_CC VARCHAR(20),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE,
    FOREIGN KEY (DIRECAO_CC) REFERENCES PESSOAS(CC) ON DELETE CASCADE

);

CREATE TABLE FORNECE (
    CC VARCHAR(20),
    CODIGOINGREDIENTES INT,
    PRIMARY KEY (CC, CODIGOINGREDIENTES),
    FOREIGN KEY (CC) REFERENCES FORNECEDORES(CC) ON DELETE CASCADE, --certificar que só podemos ter fornecedores
    FOREIGN KEY (CODIGOINGREDIENTES) REFERENCES INGREDIENTES(CODIGOINGREDIENTES) ON DELETE CASCADE
);

CREATE TABLE ENCOMENDA (
    NUMEROPEDIDO INT,
    NOMEITEM VARCHAR(100),
    QUANTIDADEENCOMENDA INT CHECK (QUANTIDADEENCOMENDA >= 0) NOT NULL,
    PRIMARY KEY (NUMEROPEDIDO, NOMEITEM),
    FOREIGN KEY (NUMEROPEDIDO) REFERENCES PEDIDOS(NUMEROPEDIDO) ON DELETE CASCADE,
    FOREIGN KEY (NOMEITEM) REFERENCES ITEM(NOMEITEM) ON DELETE CASCADE
);

CREATE TABLE CONSTITUICAO (
    CODIGOINGREDIENTES INT,
    NOMEITEM VARCHAR(100),
    QUANTIDADECONST INT CHECK (QUANTIDADECONST > 0),
    PRIMARY KEY (CODIGOINGREDIENTES, NOMEITEM),
    FOREIGN KEY (CODIGOINGREDIENTES) REFERENCES INGREDIENTES(CODIGOINGREDIENTES) ON DELETE CASCADE,
    FOREIGN KEY (NOMEITEM) REFERENCES ITEM(NOMEITEM) ON DELETE CASCADE
);

CREATE SEQUENCE codigo_bens START WITH 10000 INCREMENT BY 1;
CREATE SEQUENCE codigo_ingredientes START WITH 10000 INCREMENT BY 1;
CREATE SEQUENCE numero_pedido START WITH 1 INCREMENT BY 1;

/*
--TODO: NÃO POR QUERIES dentro dos checks
ALTER TABLE RESTAURANTES
ADD CONSTRAINT check_rest_has_emp
CHECK (EXISTS (
    SELECT 1
    FROM FUNCIONARIOS f
    JOIN PESSOAS p ON f.CC = p.CC
    JOIN FREQUENTAM fr ON p.CC = fr.CC
    WHERE fr.NUMEROCADEIA = RESTAURANTES.NUMEROCADEIA
    AND fr.CP = RESTAURANTES.CP
)) DEFERRABLE INITIALLY DEFERRED;


ALTER TABLE FUNCIONARIOS
ADD CONSTRAINT check_emp_has_rest
CHECK (EXISTS (
    SELECT 1
    FROM FREQUENTAM fr
    WHERE fr.CC = FUNCIONARIOS.CC
)) DEFERRABLE INITIALLY DEFERRED;
*/

--VIEW DE FUNCIONARIOS NAO DESTACADOS

CREATE OR REPLACE TRIGGER check_funcionarios_in_restaurant
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    funcionarios_total INT;
BEGIN
    SELECT COUNT(*) INTO funcionarios_total
    FROM FREQUENTAM fr JOIN FUNCIONARIOS f ON fr.CC = f.CC
    WHERE fr.NUMEROCADEIA = :NEW.NUMEROCADEIA AND fr.CP = :NEW.CP;

    IF funcionarios_total = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Neste Restaurante não há funcionários');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_funcionarios_allocated
AFTER INSERT ON FREQUENTAM
FOR EACH ROW
DECLARE
    not_allocated INT;
BEGIN
    SELECT COUNT(*)
    INTO not_allocated
    FROM FUNCIONARIOS f
    WHERE NOT EXISTS (
        SELECT 1
        FROM FREQUENTAM fr
        WHERE fr.CC = f.CC
    );

    IF not_allocated > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Existem funcionários não colocados');
    END IF;
END;
/

--Ignora pedidos que já passaram
CREATE OR REPLACE FUNCTION get_restaurant_capacity(
    num_cadeia IN PEDIDOS.NUMEROCADEIA%TYPE,
    c_postal IN PEDIDOS.CP%TYPE
) RETURN INT IS
    capacity_left INT;
    total_capacity INT;
    total_clients INT;
BEGIN
    SELECT COALESCE(SUM(p.NUMEROCLIENTES),0) -- COALESCE certifica que seja 0 se for null a consulta
    INTO total_clients
    FROM PEDIDOS p
    WHERE p.NUMEROCADEIA = num_cadeia AND p.CP = c_postal AND p.TEMPO_TERMINO > SYSDATE;

    SELECT r.LUGARES
    INTO total_capacity
    FROM RESTAURANTES r
    WHERE r.NUMEROCADEIA = num_cadeia AND r.CP = c_postal;
    
    capacity_left := total_capacity - total_clients;

    RETURN capacity_left;

END;
/

CREATE OR REPLACE TRIGGER check_capacity
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    capacity INT;
BEGIN
    capacity := get_restaurant_capacity(:NEW.NUMEROCADEIA, :NEW.CP);
    IF :NEW.NUMEROCLIENTES > capacity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Não ha mais lugares no restaurante.');
    END IF;
END;
/

CREATE OR REPLACE FUNCTION check_expiration_date_over(
    enc_nomeItem IN ENCOMENDA.NOMEITEM%TYPE
) RETURN BOOLEAN IS
    v_count INT;
BEGIN 
    SELECT COUNT(*)
    INTO v_count
    FROM CONSTITUICAO c 
    JOIN INGREDIENTES i on i.CODIGOINGREDIENTES = c.CODIGOINGREDIENTES
    WHERE c.NOMEITEM = enc_nomeItem AND i.DATAVALIDADE < SYSDATE;

    IF v_count > 0 THEN
        RETURN FALSE;
    ELSE 
        RETURN TRUE;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER validate_item_order
BEFORE INSERT ON ENCOMENDA
FOR EACH ROW
DECLARE
    is_valid BOOLEAN;
BEGIN
    is_valid := check_expiration_date_over(:NEW.NOMEITEM);

    IF NOT is_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Item não possível.Ingredientes estão fora do prazo.');
    END IF;
END;
/




-- Verifica se está dentro do periodo de operação do restaurante --
CREATE OR REPLACE FUNCTION check_order_time(
    p_numeroCadeia IN PEDIDOS.NUMEROCADEIA%TYPE,
    p_hora        IN PEDIDOS.HORA%TYPE
) RETURN BOOLEAN IS
    v_horaAbertura RESTAURANTES.HORAABERTURA%TYPE;
    v_horaFecho    RESTAURANTES.HORAFECHO%TYPE;
BEGIN
    SELECT HORAABERTURA, HORAFECHO INTO v_horaAbertura, v_horaFecho
    FROM RESTAURANTES
    WHERE NUMEROCADEIA = p_numeroCadeia;

    IF p_hora < v_horaAbertura OR p_hora > v_horaFecho THEN
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
/



CREATE OR REPLACE TRIGGER trg_check_order_time
BEFORE INSERT OR UPDATE ON PEDIDOS
FOR EACH ROW
DECLARE
    v_is_valid BOOLEAN;
BEGIN
    v_is_valid := check_order_time(:NEW.NUMEROCADEIA, :NEW.HORA);
    IF NOT v_is_valid THEN
        RAISE_APPLICATION_ERROR(-20001, 'Hora do pedido está fora do intervalo de operação do restaurante.');
    END IF;
END;
/


CREATE OR REPLACE FUNCTION calcular_custo_prato(p_nomeitem IN PRATO.NOMEITEM%TYPE)
RETURN NUMBER
IS
    v_custo_total NUMBER := 0;
BEGIN
    SELECT SUM(i.PRECO * c.QUANTIDADECONST)
    INTO v_custo_total
    FROM CONSTITUICAO c
    JOIN INGREDIENTES i ON c.CODIGOINGREDIENTES = i.CODIGOINGREDIENTES
    WHERE c.NOMEITEM = p_nomeitem;
    
    RETURN v_custo_total;
END;
/


CREATE OR REPLACE FUNCTION ingredientes_em_falta(p_numerocadeia IN RESTAURANTES.NUMEROCADEIA%TYPE, p_cp IN RESTAURANTES.CP%TYPE)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT i.NOME
        FROM INGREDIENTES i
        LEFT JOIN STOCK s ON i.CODIGOINGREDIENTES = s.CODIGOINGREDIENTES AND s.NUMEROCADEIA = p_numerocadeia AND s.CP = p_cp
        WHERE s.CODIGOINGREDIENTES IS NULL OR s.QUANTIDADE_STOCK = 0;
    
    RETURN v_cursor;
END;
/

CREATE OR REPLACE FUNCTION mesas_disponiveis(p_numerocadeia IN RESTAURANTES.NUMEROCADEIA%TYPE, p_cp IN RESTAURANTES.CP%TYPE)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
    v_lugares_ocupados NUMBER;
    v_lugares_totais NUMBER;
BEGIN
    SELECT COUNT(DISTINCT cc) INTO v_lugares_ocupados
    FROM FREQUENTAM
    WHERE NUMEROCADEIA = p_numerocadeia AND CP = p_cp;
    
    SELECT LUGARES INTO v_lugares_totais
    FROM RESTAURANTES
    WHERE NUMEROCADEIA = p_numerocadeia AND CP = p_cp;
    
    OPEN v_cursor FOR
        SELECT v_lugares_totais - v_lugares_ocupados AS mesas_disponiveis FROM DUAL;
    
    RETURN v_cursor;
END;
/

CREATE OR REPLACE FUNCTION calcular_valor_encomenda(p_numeropedido IN ENCOMENDA.NUMEROPEDIDO%TYPE)
RETURN NUMBER
IS
    v_valor_total NUMBER := 0;
BEGIN
    SELECT SUM(i.PRECO * e.QUANTIDADEENCOMENDA)
    INTO v_valor_total
    FROM ENCOMENDA e
    JOIN ITEM i ON e.NOMEITEM = i.NOMEITEM
    WHERE e.NUMEROPEDIDO = p_numeropedido
    GROUP BY e.NUMEROPEDIDO;
    
    RETURN v_valor_total;
END;
/


CREATE OR REPLACE TRIGGER verify_stock_before_order
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    v_quantidade_necessaria INT;
BEGIN
    FOR encomenda IN (
        SELECT e.NOMEITEM, e.QUANTIDADEENCOMENDA, c.CODIGOINGREDIENTES, c.QUANTIDADECONST, s.QUANTIDADE_STOCK
        FROM ENCOMENDA e
        JOIN CONSTITUICAO c ON e.NOMEITEM = c.NOMEITEM
        JOIN STOCK s ON c.CODIGOINGREDIENTES = s.CODIGOINGREDIENTES
        AND s.NUMEROCADEIA = :NEW.NUMEROCADEIA
        AND s.CP = :NEW.CP 
        WHERE e.NUMEROPEDIDO = :NEW.NUMEROPEDIDO
    ) LOOP
        v_quantidade_necessaria := encomenda.QUANTIDADEENCOMENDA * encomenda.QUANTIDADECONST;


        IF encomenda.QUANTIDADE_STOCK < v_quantidade_necessaria THEN
            RAISE_APPLICATION_ERROR(-20001, 'Stock insuficiente para o ingrediente: ' || encomenda.CODIGOINGREDIENTES);
        END IF;
    END LOOP;
END;
/



CREATE OR REPLACE TRIGGER update_stock_after_order
AFTER INSERT ON PEDIDOS
FOR EACH ROW
BEGIN
    FOR encomenda IN (
        SELECT e.NOMEITEM, e.QUANTIDADEENCOMENDA, c.CODIGOINGREDIENTES, c.QUANTIDADECONST
        FROM ENCOMENDA e
        JOIN CONSTITUICAO c ON e.NOMEITEM = c.NOMEITEM
        WHERE e.NUMEROPEDIDO = :NEW.NUMEROPEDIDO
    ) LOOP
        UPDATE STOCK s
        SET s.QUANTIDADE_STOCK = s.QUANTIDADE_STOCK - (encomenda.QUANTIDADECONST * encomenda.QUANTIDADEENCOMENDA)
        WHERE s.CODIGOINGREDIENTES = encomenda.CODIGOINGREDIENTES
            AND s.NUMEROCADEIA = :NEW.NUMEROCADEIA
            AND s.CP = :NEW.CP;
    END LOOP;
END;
/ 


CREATE OR REPLACE TRIGGER check_key_in_funcionarios
BEFORE INSERT OR UPDATE ON FORNECEDORES
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM FUNCIONARIOS f
    WHERE f.CC = :NEW.CC;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Chave duplicada encontrada em Funcionários.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_key_in_fornecedores
BEFORE INSERT OR UPDATE ON FUNCIONARIOS
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM FORNECEDORES f
    WHERE f.CC = :NEW.CC;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Chave duplicada encontrada em Fornecedores.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_key_in_prato
BEFORE INSERT OR UPDATE ON BEBIDA
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM PRATO p
    WHERE p.NOMEITEM = :NEW.NOMEITEM;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Chave duplicada encontrada em Prato.');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER check_key_in_bebidas
BEFORE INSERT OR UPDATE ON PRATO
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM BEBIDA b
    WHERE b.NOMEITEM = :NEW.NOMEITEM;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Chave duplicada encontrada em Bebida.');
    END IF;
END;
/



CREATE OR REPLACE TRIGGER ensure_item_is_prato_ou_bebida
BEFORE INSERT OR UPDATE ON ITEM
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    -- Verificar se a chave existe em Prato ou Bebida
    SELECT COUNT(*)
    INTO v_count
    FROM PRATO p
    WHERE  p.NOMEITEM = :NEW.NOMEITEM;

    IF v_count = 0 THEN
        SELECT COUNT(*)
        INTO v_count
        FROM BEBIDA b
        WHERE  b.NOMEITEM = :NEW.NOMEITEM;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'A chave deve ser um Prato ou Bebida.');
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER check_key_in_chef
BEFORE INSERT OR UPDATE ON DIRECAO
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM CHEF c
    WHERE c.CC = :NEW.CC;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Chave duplicada encontrada em Chef.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_key_in_direcao
BEFORE INSERT OR UPDATE ON CHEF
FOR EACH ROW
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM DIRECAO d
    WHERE d.CC = :NEW.CC;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Chave duplicada encontrada em Direcao.');
    END IF;
END;
/

--Garante que não há dois pedidos do mesmo cliente ao mesmo tempo em restaurntes diferentes--
CREATE OR REPLACE TRIGGER prevent_concurrent_orders
BEFORE INSERT ON PEDIDOS
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM PEDIDOS p
    WHERE p.CC = :NEW.CC
      AND p.NUMEROPEDIDO <> :NEW.NUMEROPEDIDO -- Ignorar o próprio pedido
      AND p.NUMEROCADEIA <> :NEW.NUMEROCADEIA
      AND p.CP <> :NEW.CP
      AND p.TEMPO_TERMINO > SYSDATE;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cliente já tem um pedido em andamento em outro restaurante.');
    END IF;
END;
/

--UPDATE ON CASCADE --

CREATE OR REPLACE TRIGGER update_cascade_restaurante
BEFORE UPDATE ON RESTAURANTES
FOR EACH ROW
BEGIN
    UPDATE PEDIDOS
    SET NUMEROCADEIA = :NEW.NUMEROCADEIA,
        CP = :NEW.CP
    WHERE CP = :OLD.CP AND NUMEROCADEIA = :OLD.NUMEROCADEIA;

    UPDATE STOCK
    SET NUMEROCADEIA = :NEW.NUMEROCADEIA,
        CP = :NEW.CP
    WHERE CP = :OLD.CP AND NUMEROCADEIA = :OLD.NUMEROCADEIA;

    UPDATE INVENTARIO
    SET NUMEROCADEIA = :NEW.NUMEROCADEIA,
        CP = :NEW.CP
    WHERE CP = :OLD.CP AND NUMEROCADEIA = :OLD.NUMEROCADEIA;

    UPDATE FREQUENTAM
    SET NUMEROCADEIA = :NEW.NUMEROCADEIA,
        CP = :NEW.CP
    WHERE CP = :OLD.CP AND NUMEROCADEIA = :OLD.NUMEROCADEIA;

    UPDATE CARTAS
    SET NUMEROCADEIA = :NEW.NUMEROCADEIA,
        CP = :NEW.CP
    WHERE CP = :OLD.CP AND NUMEROCADEIA = :OLD.NUMEROCADEIA;

END;
/

CREATE OR REPLACE TRIGGER update_cascade_pessoas
BEFORE UPDATE ON PESSOAS
FOR EACH ROW
BEGIN
    UPDATE FORNECEDORES
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE FUNCIONARIOS
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE CONTACTOS
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE PEDIDOS
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE FREQUENTAM
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE GERE
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE FORNECE
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

END;
/

CREATE OR REPLACE TRIGGER update_cascade_funcionarios
BEFORE UPDATE ON FUNCIONARIOS
FOR EACH ROW
BEGIN
    UPDATE CHEF
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;

    UPDATE DIRECAO
    SET CC = :NEW.CC
    WHERE CC = :OLD.CC;


END;
/

CREATE OR REPLACE TRIGGER update_cascade_cardapio
BEFORE UPDATE ON CARDAPIO
FOR EACH ROW
BEGIN
    UPDATE ITEM
    SET EPOCA = :NEW.EPOCA
    WHERE EPOCA = :OLD.EPOCA;

    UPDATE CARTAS
    SET EPOCA = :NEW.EPOCA
    WHERE EPOCA = :OLD.EPOCA;

END;
/

CREATE OR REPLACE TRIGGER update_cascade_item
BEFORE UPDATE ON ITEM
FOR EACH ROW
BEGIN
    UPDATE PRATO
    SET NOMEITEM = :NEW.NOMEITEM
    WHERE NOMEITEM = :OLD.NOMEITEM;

    UPDATE BEBIDA
    SET NOMEITEM = :NEW.NOMEITEM
    WHERE NOMEITEM = :OLD.NOMEITEM;

    UPDATE ENCOMENDA
    SET NOMEITEM = :NEW.NOMEITEM
    WHERE NOMEITEM = :OLD.NOMEITEM;

    UPDATE CONSTITUICAO
    SET NOMEITEM = :NEW.NOMEITEM
    WHERE NOMEITEM = :OLD.NOMEITEM;

END;
/

CREATE OR REPLACE TRIGGER update_cascade_ingredientes
BEFORE UPDATE ON INGREDIENTES
FOR EACH ROW
BEGIN
    UPDATE STOCK
    SET CODIGOINGREDIENTES = :NEW.CODIGOINGREDIENTES
    WHERE CODIGOINGREDIENTES = :OLD.CODIGOINGREDIENTES;

     UPDATE FORNECE
    SET CODIGOINGREDIENTES = :NEW.CODIGOINGREDIENTES
    WHERE CODIGOINGREDIENTES = :OLD.CODIGOINGREDIENTES;
    
    UPDATE CONSTITUICAO
    SET CODIGOINGREDIENTES = :NEW.CODIGOINGREDIENTES
    WHERE CODIGOINGREDIENTES = :OLD.CODIGOINGREDIENTES;

END;
/

CREATE OR REPLACE TRIGGER update_cascade_bens
BEFORE UPDATE ON MOBILIA_MATERIAIS
FOR EACH ROW
BEGIN
    UPDATE INVENTARIO
    SET CODIGOBENS = :NEW.CODIGOBENS
    WHERE CODIGOBENS = :OLD.CODIGOBENS;
END;
/

CREATE OR REPLACE TRIGGER update_cascade_pedidos
BEFORE UPDATE ON PEDIDOS
FOR EACH ROW
BEGIN
    UPDATE ENCOMENDA
    SET NUMEROPEDIDO = :NEW.NUMEROPEDIDO
    WHERE NUMEROPEDIDO = :OLD.NUMEROPEDIDO;
END;
/

-- VIEWS --
CREATE OR REPLACE VIEW vw_fornecedores_ingredientes
AS
SELECT p.NOMEPESSOA, p.NIF, p.EMAIL, i.NOME AS INGREDIENTE
FROM PESSOAS p
JOIN FORNECEDORES f ON p.CC = f.CC
JOIN FORNECE ff ON f.CC = ff.CC
JOIN INGREDIENTES i ON ff.CODIGOINGREDIENTES = i.CODIGOINGREDIENTES;

--VIEW DE FUNCIONARIOS NAO DESTACADOS
CREATE OR REPLACE VIEW vw_funcionarios_nao_destacados
AS
SELECT p.NOMEPESSOA, p.EMAIL
FROM PESSOAS p
JOIN FUNCIONARIOS f ON p.CC = f.CC
WHERE NOT EXISTS (
    SELECT 1
    FROM FREQUENTAM fr
    WHERE fr.CC = f.CC
);

--Pedidos por restaurante e cliente
CREATE OR REPLACE VIEW vw_pedidos_restaurante_cliente
AS
SELECT p.NUMEROPEDIDO, r.NOMERESTAURANTE, pe.NOMEPESSOA, p.HORA, p.NUMEROCLIENTES
FROM PEDIDOS p
JOIN RESTAURANTES r ON p.NUMEROCADEIA = r.NUMEROCADEIA AND p.CP = r.CP
JOIN PESSOAS pe ON p.CC = pe.CC;

-- Ingredientes em falta por restaurante--
CREATE OR REPLACE VIEW vw_ingredientes_em_falta AS
SELECT r.NOMERESTAURANTE, i.NOME AS INGREDIENTE
FROM STOCK s
JOIN INGREDIENTES i ON s.CODIGOINGREDIENTES = i.CODIGOINGREDIENTES
JOIN RESTAURANTES r ON s.NUMEROCADEIA = r.NUMEROCADEIA AND s.CP = r.CP
WHERE s.QUANTIDADE_STOCK = 0;

-- funcionários e seus cargos
CREATE OR REPLACE VIEW vw_funcionarios_cargos
AS
SELECT p.NOMEPESSOA, p.NIF, p.EMAIL,
       CASE
           WHEN f.CC IS NOT NULL THEN 'Funcionário'
           WHEN d.CC IS NOT NULL THEN 'Direção'
           WHEN c.CC IS NOT NULL THEN 'Chef'
           ELSE 'Outro'
       END AS CARGO
FROM PESSOAS p
LEFT JOIN FUNCIONARIOS f ON p.CC = f.CC
LEFT JOIN DIRECAO d ON p.CC = d.CC
LEFT JOIN CHEF c ON p.CC = c.CC;

/*
-- Adiar a verificação das restrições
SET CONSTRAINTS ALL DEFERRED;

-- Inserir tuplos nas tabelas com adiamento de restrições



-- Insere alguns ingredientes
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, PRECO) VALUES
(codigo_ingredientes.NEXTVAL, 'Frango', 'Portugal', DATE '2023-06-30', 5.00);
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, PRECO) VALUES(codigo_ingredientes.NEXTVAL, 'Arroz', 'Espanha', DATE '2023-07-15', 2.50);
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, PRECO) VALUES(codigo_ingredientes.NEXTVAL, 'Cenoura', 'Portugal', DATE '2023-06-20', 1.20);
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, PRECO) VALUES
(codigo_ingredientes.NEXTVAL, 'Batata', 'França', DATE '2023-07-10', 0.80);


-- Insere um cardapio
INSERT INTO CARDAPIO(EPOCA, NOMECARDAPIO) VALUES ('Verão','Verão 2024');

-- Insere um item (prato)
INSERT INTO ITEM (NOMEITEM, EPOCA, DESCRICAO, PRECO) VALUES
('Frango com Arroz', 'Verão', 'Frango grelhado com arroz e legumes', 10.00);

INSERT INTO PRATO (NOMEITEM, TIPO) VALUES
('Frango com Arroz', 'Principal');


INSERT INTO CONSTITUICAO (CODIGOINGREDIENTE, NOMEITEM, QUANTIDADECONST) VALUES
((SELECT CODIGOINGREDIENTES FROM INGREDIENTES WHERE NOME = 'Frango'), 'Frango com Arroz', 1);
INSERT INTO CONSTITUICAO (CODIGOINGREDIENTE, NOMEITEM, QUANTIDADECONST) VALUES

((SELECT CODIGOINGREDIENTES FROM INGREDIENTES WHERE NOME = 'Arroz'), 'Frango com Arroz', 2);
INSERT INTO CONSTITUICAO (CODIGOINGREDIENTE, NOMEITEM, QUANTIDADECONST) VALUES

((SELECT CODIGOINGREDIENTES FROM INGREDIENTES WHERE NOME = 'Cenoura'), 'Frango com Arroz', 1);
INSERT INTO CONSTITUICAO (CODIGOINGREDIENTE, NOMEITEM, QUANTIDADECONST) VALUES

((SELECT CODIGOINGREDIENTES FROM INGREDIENTES WHERE NOME = 'Batata'), 'Frango com Arroz', 2);


-- Insere alguns ingredientes
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, CUSTO) VALUES
(codigo_ingredientes.NEXTVAL, 'Frango', 'Portugal', DATE '2023-06-30', 5.00);
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, CUSTO) VALUES(codigo_ingredientes.NEXTVAL, 'Arroz', 'Espanha', DATE '2023-07-15', 2.50);
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, CUSTO) VALUES(codigo_ingredientes.NEXTVAL, 'Cenoura', 'Portugal', DATE '2023-06-20', 1.20);
INSERT INTO INGREDIENTES (CODIGOINGREDIENTES, NOME, PROVENIENCIA, DATAVALIDADE, CUSTO) VALUES
(codigo_ingredientes.NEXTVAL, 'Batata', 'França', DATE '2023-07-10', 0.80);

INSERT INTO PESSOAS (NOMEPESSOA, NIF, CC, EMAIL) VALUES('João Silva', '123456789', '12345678', 'joao@email.com');
INSERT INTO PESSOAS (NOMEPESSOA, NIF, CC, EMAIL) VALUES('Maria Fernandes', '987654321', '87654321', 'maria@email.com');
INSERT INTO MORADA (CP,LOCALIDADE) VALUES (1000, 'Corroios');

INSERT INTO RESTAURANTES (NUMEROCADEIA, NOMERESTAURANTE, HORAABERTURA, HORAFECHO, LUGARES, CP) VALUES
(2, 'Restaurante A', TO_TIMESTAMP('2023-05-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-25 22:00:00', 'YYYY-MM-DD HH24:MI:SS'), 50, 1000);

INSERT INTO RESTAURANTES (NUMEROCADEIA, NOMERESTAURANTE, HORAABERTURA, HORAFECHO, LUGARES, CP) VALUES (1, 'Restaurante B', TO_TIMESTAMP('2023-05-25 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2023-05-25 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 60, 1000);

-- Insere um pedido fora do horário de operação do restaurante (dispara o gatilho)
INSERT INTO PEDIDOS (NUMEROPEDIDO, HORA, DATA, CP, NUMEROCADEIA, CC)
VALUES (numero_pedido.NEXTVAL, TO_TIMESTAMP('2023-05-25 23:00:00', 'YYYY-MM-DD HH24:MI:SS'), DATE '2023-05-25', 1000, 1, '12345678');

-- Insere outro pedido fora do horário de operação do restaurante (dispara o gatilho)
INSERT INTO PEDIDOS (NUMEROPEDIDO, HORA, DATA, CP, NUMEROCADEIA, CC)
VALUES (numero_pedido.NEXTVAL, TO_TIMESTAMP('2023-05-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), DATE '2023-05-25', 1000, 2, '87654321');

-- Insere um pedido dentro do horário de operação do restaurante
INSERT INTO PEDIDOS (NUMEROPEDIDO, HORA, DATA, CP, NUMEROCADEIA, CC)
VALUES (numero_pedido.NEXTVAL, TO_TIMESTAMP('2023-05-25 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), DATE '2023-05-25', 1000, 1, '12345678');

-- Insere outro pedido dentro do horário de operação do restaurante
INSERT INTO PEDIDOS (NUMEROPEDIDO, HORA, DATA, CP, NUMEROCADEIA, CC)
VALUES (numero_pedido.NEXTVAL, TO_TIMESTAMP('2023-05-25 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), DATE '2023-05-25', 1000, 2, '87654321');
*/

