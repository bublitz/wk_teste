CREATE TABLE clientes (
    codigo      INT PRIMARY KEY,
    nome        VARCHAR(100) NOT NULL,
    cidade      VARCHAR(100),
    uf          CHAR(2)
);

CREATE TABLE produtos (
    codigo          INT PRIMARY KEY,
    descricao       VARCHAR(150) NOT NULL,
    preco_venda     DECIMAL(15,2) NOT NULL
);

CREATE TABLE pedidos (
    numero_pedido   INT NOT NULL,
    data_emissao    DATE NOT NULL,
    codigo_cliente  INT NOT NULL,
    valor_total     DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (numero_pedido),
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

CREATE TABLE pedidos_produtos (
    id              INT NOT NULL AUTO_INCREMENT,
    numero_pedido   INT NOT NULL,
    codigo_produto  INT NOT NULL,
    quantidade      DECIMAL(15,3) NOT NULL,
    valor_unitario  DECIMAL(15,2) NOT NULL,
    valor_total     DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_pedprod_pedidos
        FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
    CONSTRAINT fk_pedprod_produtos
        FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

CREATE INDEX idx_pedidos_codigo_cliente ON pedidos (codigo_cliente);
CREATE INDEX idx_pedprod_numero_pedido ON pedidos_produtos (numero_pedido);
CREATE INDEX idx_pedprod_codigo_produto ON pedidos_produtos (codigo_produto);
