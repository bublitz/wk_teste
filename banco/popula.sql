-- POPULAÇÃO DE TABELAS

USE wkteste;

-- LIMPA DADOS EXISTENTES (OPCIONAL)
DELETE FROM pedidos_produtos;
DELETE FROM pedidos;
DELETE FROM clientes;
DELETE FROM produtos;

-- CLIENTES
INSERT INTO clientes (codigo, nome, cidade, uf) VALUES
(1,  'Comercial São João',        'São Paulo',        'SP'),
(2,  'Supermercado Bom Preço',    'Rio de Janeiro',   'RJ'),
(3,  'Loja Central',              'Belo Horizonte',   'MG'),
(4,  'Mercado União',             'Curitiba',         'PR'),
(5,  'Atacado Paulista',          'Campinas',         'SP'),
(6,  'Distribuidora Alpha',       'Santos',           'SP'),
(7,  'Comercial Beta',            'Sorocaba',         'SP'),
(8,  'Loja do Povo',              'Porto Alegre',     'RS'),
(9,  'Superlar',                  'Florianópolis',    'SC'),
(10, 'Mercado Econômico',         'Joinville',        'SC'),
(11, 'Rede Vitória',              'Vitória',          'ES'),
(12, 'Comercial Minas',           'Contagem',         'MG'),
(13, 'Super Rio',                 'Niterói',          'RJ'),
(14, 'Comercial Sul',             'Caxias do Sul',    'RS'),
(15, 'Atacado Brasil',            'Brasília',         'DF'),
(16, 'Loja Popular',              'Goiânia',          'GO'),
(17, 'Centro Comercial',          'Manaus',           'AM'),
(18, 'Mercado Tropical',          'Belém',            'PA'),
(19, 'Rede Nordeste',             'Recife',           'PE'),
(20, 'Super Bahia',               'Salvador',         'BA');

-- PRODUTOS
INSERT INTO produtos (codigo, descricao, preco_venda) VALUES
(1,  'Arroz Tipo 1 5kg',               25.90),
(2,  'Feijão Carioca 1kg',             8.50),
(3,  'Açúcar Refinado 1kg',            4.20),
(4,  'Café Torrado e Moído 500g',      12.90),
(5,  'Macarrão Espaguete 500g',        3.80),
(6,  'Óleo de Soja 900ml',             7.10),
(7,  'Leite Integral 1L',              5.30),
(8,  'Manteiga 200g',                  9.90),
(9,  'Biscoito Cream Cracker 400g',    6.40),
(10, 'Detergente Líquido 500ml',       2.50),
(11, 'Sabão em Pó 1kg',                11.90),
(12, 'Amaciante de Roupas 2L',         14.50),
(13, 'Sabonete 90g',                   2.10),
(14, 'Shampoo 350ml',                  15.90),
(15, 'Condicionador 350ml',            16.90),
(16, 'Papel Higiênico 12 rolos',       18.50),
(17, 'Água Mineral 1,5L',              3.20),
(18, 'Refrigerante Cola 2L',           8.90),
(19, 'Suco de Laranja 1L',             6.80),
(20, 'Chocolate Barra 100g',           5.70);
