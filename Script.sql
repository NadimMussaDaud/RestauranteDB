DROP DATABASE IF EXISTS restaurante_db;

-- Criar a base de dados
CREATE DATABASE restaurante_db;

-- Utilizar a base de dados restaurante_db
USE restaurante_db;

-- Criar as tabelas
CREATE TABLE Restaurantes (
    NúmeroCadeia INT PRIMARY KEY,
    NomeRestaurante VARCHAR(100),
    HoraAbertura TIME,
    HoraFecho TIME,
    Lugares INT,
    CP INT,
    FOREIGN KEY (CP) REFERENCES Morada(CP)
);

CREATE TABLE Morada (
    CP INT PRIMARY KEY,
    Localidade VARCHAR(100)
);

CREATE TABLE Bens (
    codigoBens INT PRIMARY KEY,
    nomeBens VARCHAR(100)
);

CREATE TABLE Pessoas (
    NomePessoa VARCHAR(100),
    NIF VARCHAR(20),
    CC VARCHAR(20) PRIMARY KEY,
    email VARCHAR(100)
);

CREATE TABLE Funcionários (
    CC VARCHAR(20),
    função VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Fornecedores (
    CC VARCHAR(20),
    NumeroConta VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Direção (
    CC VARCHAR(20),
    bónus DECIMAL(10, 2),
    função VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (função) REFERENCES Funcionários(função)
);

CREATE TABLE Chef (
    CC VARCHAR(20),
    Estrelas INT,
    função VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (função) REFERENCES Funcionários(função)
);

CREATE TABLE Contactos (
    CC VARCHAR(20),
    NumeroTelefone VARCHAR(15),
    PRIMARY KEY (CC, NumeroTelefone),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Pedidos (
    NumeroPedido INT PRIMARY KEY,
    Hora TIME,
    Data DATE,
    CP INT,
    NúmeroCadeia INT,
    CC VARCHAR(20),
    FOREIGN KEY (CP) REFERENCES Restaurantes(CP),
    FOREIGN KEY (NúmeroCadeia) REFERENCES Restaurantes(NúmeroCadeia),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Cardápio (
    Época VARCHAR(50) PRIMARY KEY,
    NomeCardapio VARCHAR(100)
);

CREATE TABLE Ingredientes (
    CodigoIngredientes INT PRIMARY KEY,
    Nome VARCHAR(100),
    Proveniência VARCHAR(100),
    DataValidade DATE,
    Custo DECIMAL(10, 2)
);

CREATE TABLE Item (
    NomeItem VARCHAR(100) PRIMARY KEY,
    Tipo VARCHAR(50) CHECK (Tipo IN ('Prato', 'Bebida'))
);

CREATE TABLE Prato (
    NomeItem VARCHAR(100) PRIMARY KEY,
    Tipo VARCHAR(50),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Bebida (
    NomeItem VARCHAR(100) PRIMARY KEY,
    TeorAlcool DECIMAL(5, 2),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Stock (
    CodigoIngredientes INT,
    NúmeroCadeia INT,
    Quantidade INT,
    PRIMARY KEY (CodigoIngredientes, NúmeroCadeia),
    FOREIGN KEY (CodigoIngredientes) REFERENCES Ingredientes(CodigoIngredientes),
    FOREIGN KEY (NúmeroCadeia) REFERENCES Restaurantes(NúmeroCadeia)
);

CREATE TABLE Inventário (
    NúmeroCadeia INT,
    codigoBens INT,
    QuantidadeInventário INT,
    PRIMARY KEY (NúmeroCadeia, codigoBens),
    FOREIGN KEY (NúmeroCadeia) REFERENCES Restaurantes(NúmeroCadeia),
    FOREIGN KEY (codigoBens) REFERENCES Bens(codigoBens)
);

CREATE TABLE Frequentam (
    CC VARCHAR(20),
    NúmeroCadeia INT,
    PRIMARY KEY (CC, NúmeroCadeia),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (NúmeroCadeia) REFERENCES Restaurantes(NúmeroCadeia)
);

CREATE TABLE Cartas (
    Época VARCHAR(50),
    NúmeroCadeia INT,
    NomeItem VARCHAR(100),
    PRIMARY KEY (Época, NúmeroCadeia, NomeItem),
    FOREIGN KEY (NúmeroCadeia) REFERENCES Restaurantes(NúmeroCadeia),
    FOREIGN KEY (Época) REFERENCES Cardápio(Época),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Gere (
    CC VARCHAR(20),
    NúmeroCadeia INT,
    Direção_CC VARCHAR(20),
    PRIMARY KEY (CC, NúmeroCadeia),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (NúmeroCadeia) REFERENCES Restaurantes(NúmeroCadeia),
    FOREIGN KEY (Direção_CC) REFERENCES Funcionários(CC)
);

CREATE TABLE Fornece (
    CC VARCHAR(20),
    CodigoIngrediente INT,
    PRIMARY KEY (CC, CodigoIngrediente),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (CodigoIngrediente) REFERENCES Ingredientes(CodigoIngredientes)
);

CREATE TABLE Encomenda (
    NumeroPedido INT,
    NomeItem VARCHAR(100),
    QuantidadeEncomenda INT,
    PRIMARY KEY (NumeroPedido, NomeItem),
    FOREIGN KEY (NumeroPedido) REFERENCES Pedidos(NumeroPedido),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Constituição (
    CodigoIngrediente INT,
    NomeItem VARCHAR(100),
    QuantidadeConst INT,
    PRIMARY KEY (CodigoIngrediente, NomeItem),
    FOREIGN KEY (CodigoIngrediente) REFERENCES Ingredientes(CodigoIngredientes),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Menu (
    Preço DECIMAL(10, 2),
    Descrição VARCHAR(255),
    NomeItem VARCHAR(100),
    Época VARCHAR(50),
    PRIMARY KEY (NomeItem, Época),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem),
    FOREIGN KEY (Época) REFERENCES Cardápio(Época)
);
