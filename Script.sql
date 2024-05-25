-- TODO: Criar asserções para os ISA para disjoint e ISA totais
/* 
- Efetuar pedido se houver espaço no restaurante. Acrescentar atributo numero_clientes em pedido TRIGGER
- Subtrair em stock uma vez efetuado um pedido
- Efetuar ITEMS com Ingredientes que estejam dentro do prazo TRIGGER #DONE
- Para encomendar ITEM Ingredientes todos tem que ter stock no local da encomenda TRIGGER
- Certificar que todos empregados trabalham em algum lugar e em apenas 1???
- A cada momento apenas pode existir um menu de uma epoca em um restaurante.
- Empregados precisam necessariamente de ter algum gerente.
- Um item pode ser um ingrediente. Certificar que o Item se é prato não é mais nada
-Um prato ou bebida tem que fazer parte de um item #DONE

*/


CREATE TABLE RESTAURANTES (
    NUMEROCADEIA INT CHECK(NUMEROCADEIA > 0),
    NOMERESTAURANTE VARCHAR(100) UNIQUE NOT NULL,
    HORAABERTURA TIMESTAMP NOT NULL ,
    HORAFECHO TIMESTAMP NOT NULL ,
    LUGARES INT CHECK(LUGARES > 40) NOT NULL,
    CP INT,
    PRIMARY KEY (NUMEROCADEIA, CP),
    FOREIGN KEY (CP) REFERENCES MORADA(CP),
    CONSTRAINT check_opening_time CHECK(HORAFECHO > HORAABERTURA)
);

CREATE TABLE MORADA (
    CP INT PRIMARY KEY,
    LOCALIDADE VARCHAR(100)
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
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC)
);

CREATE TABLE FORNECEDORES (
    CC VARCHAR(20),
    NUMEROCONTA VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC)
);

CREATE TABLE DIRECAO (
    CC VARCHAR(20),
    BONUS DECIMAL(10, 2) NOT NULL CHECK(BONUS >= 0),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC)
);

CREATE TABLE CHEF (
    CC VARCHAR(20) ,
    ESTRELAS INT CHECK(ESTRELAS >= 0),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC)
);

CREATE TABLE CONTACTOS (
    CC VARCHAR(20),
    NUMEROTELEFONE VARCHAR(15) UNIQUE, --Duas pessoas não podem ter o mesmo número
    PRIMARY KEY (CC, NUMEROTELEFONE),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC)
);

CREATE TABLE PEDIDOS (
    NUMEROPEDIDO INT PRIMARY KEY,
    HORA TIMESTAMP,
    TEMPO_TERMINO TIMESTAMP NOT NULL,
    NUMEROCLIENTES INT NOT NULL,
    CP INT,
    NUMEROCADEIA INT,
    CC VARCHAR(20),

    FOREIGN KEY (CP) REFERENCES MORADA,
    FOREIGN KEY (NUMEROCADEIA, CP) REFERENCES RESTAURANTES,
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC)
);

CREATE TABLE CARDAPIO (
    EPOCA VARCHAR(10) PRIMARY KEY  CHECK (EPOCA IN ('Verão', 'Inverno', 'Primavera', 'Outono')),
    NOMECARDAPIO VARCHAR(100) -- Pode não ter nome o cardápio --
);

DROP TABLE INGREDIENTES CASCADE CONSTRAINTS;

CREATE TABLE INGREDIENTES (
    CODIGOINGREDIENTES INT PRIMARY KEY,
    NOME VARCHAR(100) UNIQUE NOT NULL,
    PROVENIENCIA VARCHAR(100),
    DATAVALIDADE DATE NOT NULL,
    PRECO DECIMAL(10, 2) CHECK (PRECO > 0)
);

DROP TABLE ITEM CASCADE CONSTRAINTS;

CREATE TABLE ITEM (
    NOMEITEM VARCHAR(100) PRIMARY KEY,
    EPOCA VARCHAR(10) CHECK (EPOCA IN ('Verão', 'Inverno', 'Primavera', 'Outono')),
    DESCRICAO VARCHAR(255) NOT NULL,
    PRECO DECIMAL(10, 2) CHECK (PRECO > 0.0),
    FOREIGN KEY (EPOCA) REFERENCES CARDAPIO(EPOCA)
);

DROP TABLE PRATO CASCADE CONSTRAINTS;

CREATE TABLE PRATO (
    NOMEITEM VARCHAR(100),
    TIPO VARCHAR(50) CHECK (TIPO IN ('Principal', 'Entrada', 'Sobremesa')),
    FOREIGN KEY (NOMEITEM)  REFERENCES ITEM(NOMEITEM) 
);

CREATE TABLE BEBIDA (
    NOMEITEM VARCHAR(100),
    TEORALCOOL DECIMAL(5, 2) CHECK (TEORALCOOL >= 0), 
    FOREIGN KEY (NOMEITEM) REFERENCES ITEM(NOMEITEM)
);

CREATE TABLE STOCK (
    CODIGOINGREDIENTES INT,
    NUMEROCADEIA INT,
    CP INT,
    QUANTIDADE_STOCK INT CHECK (QUANTIDADE >= 0),
    PRIMARY KEY (CODIGOINGREDIENTES, NUMEROCADEIA, CP),
    FOREIGN KEY (CODIGOINGREDIENTES) REFERENCES INGREDIENTES(CODIGOINGREDIENTES),
    FOREIGN KEY (NUMEROCADEIA,CP) REFERENCES RESTAURANTES(NUMEROCADEIA,CP)
);

CREATE TABLE INVENTARIO (
    NUMEROCADEIA INT,
    CP INT,
    CODIGOBENS INT,
    QUANTIDADE_INVENTARIO INT CHECK( QUANTIDADE_INVENTARIO >= 0),
    PRIMARY KEY (NUMEROCADEIA, CP, CODIGOBENS),
    FOREIGN KEY (NUMEROCADEIA, CP) REFERENCES RESTAURANTES(NUMEROCADEIA, CP),
    FOREIGN KEY (CODIGOBENS) REFERENCES BENS(CODIGOBENS)
);

CREATE TABLE FREQUENTAM (
    CC VARCHAR(20),
    NUMEROCADEIA INT,
    CP INT,
    PRIMARY KEY (CC, NUMEROCADEIA, CP),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC),
    FOREIGN KEY (NUMEROCADEIA) REFERENCES RESTAURANTES(NUMEROCADEIA, CP)
);

CREATE TABLE CARTAS (
    EPOCA VARCHAR(50),
    NUMEROCADEIA INT,
    CP INT,
    PRIMARY KEY (EPOCA, NUMEROCADEIA, CP),
    FOREIGN KEY (NUMEROCADEIA, CP) REFERENCES RESTAURANTES(NUMEROCADEIA, CP),
    FOREIGN KEY (EPOCA) REFERENCES CARDAPIO(EPOCA)
);

CREATE TABLE GERE (
    CC VARCHAR(20),
    DIRECAO_CC VARCHAR(20),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC),
    FOREIGN KEY (DIRECAO_CC) REFERENCES PESSOAS(CC)

);

CREATE TABLE FORNECE (
    CC VARCHAR(20),
    CODIGOINGREDIENTE INT,
    PRIMARY KEY (CC, CODIGOINGREDIENTE),
    FOREIGN KEY (CC) REFERENCES PESSOAS(CC),
    FOREIGN KEY (CODIGOINGREDIENTE) REFERENCES INGREDIENTES(CODIGOINGREDIENTES)
);

CREATE TABLE ENCOMENDA (
    NUMEROPEDIDO INT,
    NOMEITEM VARCHAR(100),
    QUANTIDADEENCOMENDA INT CHECK (QUANTIDADEENCOMENDA >= 0) NOT NULL,
    PRIMARY KEY (NUMEROPEDIDO, NOMEITEM),
    FOREIGN KEY (NUMEROPEDIDO) REFERENCES PEDIDOS(NUMEROPEDIDO),
    FOREIGN KEY (NOMEITEM) REFERENCES ITEM(NOMEITEM)
);

CREATE TABLE CONSTITUICAO (
    CODIGOINGREDIENTE INT,
    NOMEITEM VARCHAR(100),
    QUANTIDADECONST INT CHECK (QUANTIDADECONST > 0),
    PRIMARY KEY (CODIGOINGREDIENTE, NOMEITEM),
    FOREIGN KEY (CODIGOINGREDIENTE) REFERENCES INGREDIENTES(CODIGOINGREDIENTES),
    FOREIGN KEY (NOMEITEM) REFERENCES ITEM(NOMEITEM)
);

CREATE SEQUENCE codigo_bens START WITH 10000 INCREMENT BY 1;
CREATE SEQUENCE codigo_ingredientes START WITH 10000 INCREMENT BY 1;
CREATE SEQUENCE numero_pedido START WITH 1 INCREMENT BY 1;

--Para efeitos de DEBUG
--DROP TABLE RESTAURANTES CASCADE CONSTRAINTS;

--Ignora pedidos que já passaram
CREATE OR REPLACE FUNCTION get_restaurant_capacity(
    num_cadeia IN PEDIDO.NUMEROCADEIA%TYPE,
    c_postal IN PEDIDOS.CP%TYPE
) RETURN INT IS
    capacity_left INT;
    total_capacity INT;
    total_clients INT;
BEGIN
    SELECT COALESCE(SUM(p.NUMEROCLIENTES)) -- COALESCE certifica que seja 0 se for null a consulta
    INTO total_clients
    FROM PEDIDOS p
    WHERE p.NUMEROCADEIA = num_cadeia AND p.CP = c_postal AND p.TEMPO_TERMINO > SYSDATE;

    SELECT r.CAPACIDADE_TOTAL
    INTO total_capacity
    FROM RESTAURANTES r
    WHERE r.NUMEROCADEIA = num_cadeia AND r.CP = c_postal;
    
    capacity_left := total_capacity - total_clients;

    RETURN capacity_left;

END;
/

CREATE OR REPLACE TRIGGER check_capacity
BEFORE INSERT ON PEDIDO
FOR EACH ROW
DECLARE
    capacity INT;
BEGIN
    capacity := get_restaurant_capacity(:NEW.NUMEROCADEIA,:NEW.CP);
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
    JOIN INGREDIENTES i on i.CODIGOINGREDIENTES = c.CODIGOINGREDIENTE
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
    JOIN INGREDIENTES i ON c.CODIGOINGREDIENTE = i.CODIGOINGREDIENTES
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

/*
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

