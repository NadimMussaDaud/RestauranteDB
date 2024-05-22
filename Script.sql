
CREATE TABLE Restaurantes (
    NumeroCadeia INT PRIMARY KEY,
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

CREATE TABLE Funcionarios (
    CC VARCHAR(20),
    funcao VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Fornecedores (
    CC VARCHAR(20),
    NumeroConta VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Direcao (
    CC VARCHAR(20),
    bonus DECIMAL(10, 2),
    funcao VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (funcao) REFERENCES Funcionarios(funcao)
);

CREATE TABLE Chef (
    CC VARCHAR(20),
    Estrelas INT,
    funcao VARCHAR(50),
    PRIMARY KEY (CC),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (funcao) REFERENCES Funcionarios(funcao)
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
    NumeroCadeia INT,
    CC VARCHAR(20),
    FOREIGN KEY (CP) REFERENCES Restaurantes(CP),
    FOREIGN KEY (NumeroCadeia) REFERENCES Restaurantes(NumeroCadeia),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC)
);

CREATE TABLE Cardapio (
    Epoca VARCHAR(50) PRIMARY KEY,
    NomeCardapio VARCHAR(100)
);

CREATE TABLE Ingredientes (
    CodigoIngredientes INT PRIMARY KEY,
    Nome VARCHAR(100),
    Proveniencia VARCHAR(100),
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
    NumeroCadeia INT,
    Quantidade INT,
    PRIMARY KEY (CodigoIngredientes, NumeroCadeia),
    FOREIGN KEY (CodigoIngredientes) REFERENCES Ingredientes(CodigoIngredientes),
    FOREIGN KEY (NumeroCadeia) REFERENCES Restaurantes(NumeroCadeia)
);

CREATE TABLE Inventario (
    NumeroCadeia INT,
    codigoBens INT,
    QuantidadeInventario INT,
    PRIMARY KEY (NumeroCadeia, codigoBens),
    FOREIGN KEY (NumeroCadeia) REFERENCES Restaurantes(NumeroCadeia),
    FOREIGN KEY (codigoBens) REFERENCES Bens(codigoBens)
);

CREATE TABLE Frequentam (
    CC VARCHAR(20),
    NumeroCadeia INT,
    PRIMARY KEY (CC, NumeroCadeia),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (NumeroCadeia) REFERENCES Restaurantes(NumeroCadeia)
);

CREATE TABLE Cartas (
    Epoca VARCHAR(50),
    NumeroCadeia INT,
    NomeItem VARCHAR(100),
    PRIMARY KEY (Epoca, NumeroCadeia, NomeItem),
    FOREIGN KEY (NumeroCadeia) REFERENCES Restaurantes(NumeroCadeia),
    FOREIGN KEY (Epoca) REFERENCES Cardapio(Epoca),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Gere (
    CC VARCHAR(20),
    NumeroCadeia INT,
    Direcao_CC VARCHAR(20),
    PRIMARY KEY (CC, NumeroCadeia),
    FOREIGN KEY (CC) REFERENCES Pessoas(CC),
    FOREIGN KEY (NumeroCadeia) REFERENCES Restaurantes(NumeroCadeia),
    FOREIGN KEY (Direcao_CC) REFERENCES Funcionarios(CC)
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

CREATE TABLE Constituicao (
    CodigoIngrediente INT,
    NomeItem VARCHAR(100),
    QuantidadeConst INT,
    PRIMARY KEY (CodigoIngrediente, NomeItem),
    FOREIGN KEY (CodigoIngrediente) REFERENCES Ingredientes(CodigoIngredientes),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem)
);

CREATE TABLE Menu (
    Preco DECIMAL(10, 2),
    Descricao VARCHAR(255),
    NomeItem VARCHAR(100),
    Epoca VARCHAR(50),
    PRIMARY KEY (NomeItem, Epoca),
    FOREIGN KEY (NomeItem) REFERENCES Item(NomeItem),
    FOREIGN KEY (Epoca) REFERENCES Cardapio(Epoca)
);
