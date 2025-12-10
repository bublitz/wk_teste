# Teste Técnico Delphi - WK Technology

Este projeto implementa uma **tela de pedidos de venda** utilizando **Delphi 12.3**, **FireDAC** e **MySQL**, seguindo os requisitos do teste técnico da WK Technology.

---

## Tecnologias Utilizadas

- Delphi 12.3 (VCL)
- FireDAC (acesso a dados)
- MySQL
- POO, separação em camadas (Model, DAO, UI)
- Grid em memória com `TFDMemTable` para itens do pedido

---

## Estrutura do Projeto

- `uDM.pas`  
  DataModule responsável pela conexão com o banco via FireDAC.  
  Lê as configurações de conexão a partir do arquivo `config.ini`.

- `uModelos.pas`  
  Contém as classes de modelo:

  - `TCliente`
  - `TProduto`
  - `TPedido`
  - `TPedidoItem`

- `uPedidoDAO.pas`  
  Classe responsável pelo acesso a dados de pedidos:

  - Obter próximo número de pedido (sequencial)
  - Gravar pedido (cabeçalho e itens) com transação
  - Carregar pedido
  - Cancelar pedido

- `untMain.pas`  
  Tela principal de pedidos de venda:
  - Seleção de cliente (código)
  - Inclusão / edição / exclusão de itens em um grid (memória)
  - Navegação no grid com setas
  - Edição com ENTER e exclusão com DEL
  - Cálculo automático do valor total do pedido
  - Gravação, carregamento e cancelamento de pedidos

---

## Banco de Dados

### 1. Criação do Banco

Crie o banco no MySQL (ajuste o nome se desejar):

```sql
CREATE DATABASE wkteste
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;
```

Selecione o banco:

```sql
USE wkteste;
```

### 2. Criação das Tabelas

O projeto utiliza quatro tabelas principais:

- `clientes`
- `produtos`
- `pedidos`
- `pedidos_produtos`

Exemplo de criação (modelo sugerido):

```sql
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
```

### 3. Índices

Índices adicionais para melhorar desempenho:

```sql
CREATE INDEX idx_pedidos_codigo_cliente
  ON pedidos (codigo_cliente);

CREATE INDEX idx_pedprod_numero_pedido
  ON pedidos_produtos (numero_pedido);

CREATE INDEX idx_pedprod_codigo_produto
  ON pedidos_produtos (codigo_produto);
```

### 4. População de Clientes e Produtos

No diretório `banco/` do projeto há o script:

- `popula.sql`

Exemplo do conteúdo (resumo):

```sql
USE wkteste;

DELETE FROM pedidos_produtos;
DELETE FROM pedidos;
DELETE FROM clientes;
DELETE FROM produtos;

INSERT INTO clientes (codigo, nome, cidade, uf) VALUES
(1,  'Comercial São João',        'São Paulo',        'SP'),
(2,  'Supermercado Bom Preço',    'Rio de Janeiro',   'RJ'),
...
(20, 'Super Bahia',               'Salvador',         'BA');

INSERT INTO produtos (codigo, descricao, preco_venda) VALUES
(1,  'Arroz Tipo 1 5kg',               25.90),
(2,  'Feijão Carioca 1kg',             8.50),
...
(20, 'Chocolate Barra 100g',           5.70);
```

Para executar:

```sql
SOURCE banco/popula_banco.sql;
```

---

## Configuração de Conexão (`config.ini`)

O projeto lê os parâmetros de conexão a partir de um arquivo `config.ini` localizado na mesma pasta do executável.

Exemplo:

```ini
[Database]
Server=localhost
Port=3306
Database=wkteste
Username=root
Password=senha_aqui
DriverDll=libmysql.dll
```

- `Server`: endereço do servidor MySQL
- `Port`: porta do MySQL (padrão 3306)
- `Database`: nome do banco (ex.: `wkteste`)
- `Username`: usuário do MySQL
- `Password`: senha do MySQL
- `DriverDll`: caminho/nome da DLL do MySQL distribuída com a aplicação (ex.: `libmysql.dll` na mesma pasta do EXE)

O `TDM` lê esse arquivo no método `ConfigurarConexao` e configura o `TFDConnection`.

---

## Funcionalidades Implementadas

### Cliente

- Campo para informar o **código do cliente**.
- Ao sair do campo, o sistema busca os dados na tabela `clientes`:
  - Nome
  - Cidade
  - UF
- Esses campos são apenas leitura na tela.

### Produto e Itens do Pedido

- Informar:
  - Código do produto
  - Quantidade
  - Valor unitário
- Descrição do produto e valor unitário padrão são carregados a partir da tabela `produtos`.
- Ao clicar em **Inserir Item**:
  - O item é acrescentado a um `TFDMemTable` (`mtItens`)
  - É calculado `Valor Total = Quantidade * Valor Unitário`
  - O grid de itens é atualizado
  - O total do pedido é recalculado

### Grid de Itens

- Exibe:
  - Código do produto
  - Descrição
  - Quantidade
  - Valor unitário
  - Valor total
- Permite:
  - Navegação com as setas ↑ e ↓
  - **ENTER** para editar o item selecionado:
    - Carrega os dados do item para os campos de produto/quantidade/valor unitário
    - O mesmo botão “Inserir Item” é utilizado para confirmar a atualização
  - **DEL** para excluir o item selecionado (com confirmação)
- **Produtos repetidos** são permitidos (não há bloqueio de duplicidade).

### Total do Pedido

- O valor total do pedido é exibido no rodapé da tela.
- Sempre que um item é incluído, editado ou excluído, o total é recalculado a partir do `TFDMemTable`.

### Gravação do Pedido

- Botão **Gravar Pedido**:

  - Valida se existe cliente informado e ao menos um item.
  - Obtém o próximo número de pedido via SQL:

    ```sql
    SELECT COALESCE(MAX(numero_pedido), 0) + 1 AS prox FROM pedidos;
    ```

  - Preenche o objeto `TPedido` com:
    - Número do pedido
    - Data de emissão (data atual)
    - Código do cliente
    - Itens (convertidos a partir do `TFDMemTable`)
  - Chama `TPedidoDAO.GravarPedido`:
    - Abre transação
    - Insere cabeçalho em `pedidos`
    - Insere itens em `pedidos_produtos`
    - Executa `COMMIT` em caso de sucesso, `ROLLBACK` em caso de erro

### Carregar Pedido

- Botão **Carregar Pedido**:
  - Visível apenas quando o campo de código do cliente está em branco.
  - Solicita ao usuário o número do pedido.
  - Carrega o cabeçalho (`pedidos`) e os itens (`pedidos_produtos`) via `TPedidoDAO`.
  - Preenche:
    - Código do cliente + dados do cliente (nome, cidade, UF)
    - Grid de itens em memória (`mtItens`)
    - Total do pedido

### Cancelar Pedido

- Botão **Cancelar Pedido**:
  - Visível apenas quando o campo de código do cliente está em branco.
  - Solicita o número do pedido.
  - Pergunta se o usuário realmente deseja cancelar.
  - Exclui registros em:
    - `pedidos_produtos` (itens)
    - `pedidos` (cabeçalho)
  - Utiliza transação (commit/rollback) através de `TPedidoDAO.CancelarPedido`.

---

## Execução do Projeto

1. **Configurar o banco MySQL**:

   - Criar o banco (`wkteste` ou outro nome)
   - Executar o script `banco/cria.sql` para criação das tabelas
   - Executar o script `banco/popula.sql` para popular clientes e produtos

2. **Configurar o `config.ini`**:

   - Copiar o arquivo de exemplo (pasta `/banco`) para a pasta do executável
   - Ajustar `Server`, `Database`, `Username`, `Password` e `DriverDll` conforme seu ambiente

3. **Configurar o Delphi 12**:

   - Abrir o projeto no Delphi
   - Garantir que o DataModule `uDM` está marcado como **Auto-Create** em _Project > Options > Application > Forms_
   - Certificar-se de que a DLL do MySQL (`banco/libmysql.dll`) está acessível (na mesma pasta do EXE)

4. **Compilar e executar**:
   - Execute a aplicação
   - Informe o código de um cliente já cadastrado
   - Lance produtos e grave o pedido
   - Teste as funções de carregar e cancelar pedido

---

## Observações

- Apenas componentes nativos do Delphi/FireDAC são utilizados (sem componentes de terceiros).
- As operações de banco priorizam o uso de **SQL** explícito (SELECT, INSERT, DELETE).
- A lógica de negócio segue conceitos de POO e separação em camadas (modelo, DAO, UI).
