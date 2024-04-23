CREATE DATABASE loja_fisica;

USE loja_fisica;

-- Tabela "Produtos" para armazenar informações sobre os produtos
CREATE TABLE produtos (
    produto_id INT PRIMARY KEY, --int, pois será acrescentado a mão.
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(25),
    pontos INT NOT NULL -- Pontos que o cliente ganhará ao comprar o produto
);

-- Tabela "Clientes" para armazenar informações sobre os clientes
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY, -- serial, pois será autoincrementável
    nome VARCHAR(255) NOT NULL,
    endereco TEXT, -- text, pois pode acabar tendo mais de 255 caracteres
    email VARCHAR(255) UNIQUE,
    cpf VARCHAR(11) UNIQUE, -- campo CPF
    RG_RNE VARCHAR(255) UNIQUE,
    telefone VARCHAR(20)
    pontos INT NOT NULL DEFAULT 0 -- Pontos acumulados pelo cliente
);

-- Tabela "Vendedores" para armazenar informações sobre os vendedores
CREATE TABLE vendedores (
    vendedor_id INT PRIMARY KEY, -- int, pois será inserido manualmente, de acordo com a matricula do funcionario
    nome VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    coordenador VARCHAR(255) NOT NULL
);

-- Tabela "Estoque" para armazenar informações sobre o estoque
CREATE TABLE estoque (
    produto_id INT PRIMARY KEY,
    quantidade_estoque INT NOT NULL,
    data_entrada TIMESTAMP NOT NULL,
    FOREIGN KEY (produto_id) REFERENCES produtos (produto_id)

);

-- Tabela "Vendas" para armazenar informações sobre as vendas
CREATE TABLE vendas (
    venda_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    vendedor_id INT NOT NULL,
    forma_de_pagamento VARCHAR(50),
    valor_venda DECIMAL(10, 2) NOT NULL,
    data_venda TIMESTAMP NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes (cliente_id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedores (vendedor_id)

);

-- Tabela "Vendas_produtos" para armazenar informações sobre os produtos vendidos
CREATE TABLE vendas_produtos (
    venda_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade_vendida INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(25),
    vendedor_id INT NOT NULL;
    FOREIGN KEY (vendedor_id) REFERENCES vendedores (vendedor_id)
    FOREIGN KEY (venda_id) REFERENCES vendas (venda_id),
    FOREIGN KEY (produto_id) REFERENCES produtos (produto_id)
);

-- adição de restrições evitando que existam vendas sem clientes e/ou sem vendedores
-- feita em separado para melhor organização do código
ALTER TABLE vendas
ADD CONSTRAINT fk_vendas_clientes
    FOREIGN KEY (cliente_id)
    REFERENCES clientes (cliente_id)
    MATCH SIMPLE;

ALTER TABLE vendas
ADD CONSTRAINT fk_vendas_vendedores
    FOREIGN KEY (vendedor_id)
    REFERENCES vendedores (vendedor_id)
    MATCH SIMPLE;