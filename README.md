# Documentação do Esquema do Banco de Dados

 *<span style="color:yellow">Banco de dados básico criado como Projeto Prático de Bootcamp - Projeto de Banco de Dados para uma loja física que vende produtos de Perfumaria e Cosméticos e possui um sistema de pontos para os clientes.*

#### Constam apenas os pontos relevantes de cada tabela no presente documento. Não há necessidade de explicar cada e toda coluna/campo.
## Tabela "Produtos"

- **produto_id**: Chave primária que indica um relacionamento um-para-um com os produtos. Cada produto tem um ID exclusivo.
- **pontos**: Aqui consta quantos pontos cada produto vale e o cliente receberá pela compra deste produto

## Tabela "Clientes"

- **cliente_id**: Chave primária do tipo **SERIAL**, estabelecendo um relacionamento um-para-muitos entre clientes e vendas. Cada cliente pode estar associado a várias vendas.
- **cpf**: É uma chave única, o que significa que cada CPF está associado a apenas um cliente. Isso também é um relacionamento um-para-um.
- **telefone**: Não há restrições específicas de cardinalidade para o campo telefone.
- **Pontos**: Pontos que o cliente possui por ter realizado compras. Possui o "default 0", para que sempre que um for criado, inicie com zero pontos.

## Tabela "Vendedores"

- **vendedor_id**: Chave primária indicando um relacionamento um-para-um com os vendedores. Cada vendedor tem um ID exclusivo. - Será o seu número de matrícula da empresa

## Tabela "Estoque"

- **produto_id**: Chave primária indicando um relacionamento um-para-um com os produtos. Cada entrada no estoque está associada a um produto específico.

## Tabela "Vendas"

**Conceito**: A presente tabela visa apenas ter o registro de quando um cliente efetuou uma compra, quanto gastou, como pagou e qual vendedor lhe atendeu.
- **venda_id**: Chave primária do tipo **SERIAL**, estabelecendo um relacionamento um-para-muitos com os produtos vendidos. Cada venda pode ter vários produtos associados.
- **cliente_id**: Chave estrangeira relacionada à tabela "Clientes". Isso estabelece um relacionamento muitos-para-um entre vendas e clientes. Muitas vendas podem estar associadas a um único cliente.
- **vendedor_id**: Também é uma chave estrangeira relacionada à tabela "Vendedores". Isso estabelece outro relacionamento muitos-para-um entre vendas e vendedores.
- **valor_total**: Não há restrições específicas de cardinalidade para o campo valor_total.

## Tabela "Vendas_produtos"

**Conceito**: Tabela feita para ser uma intermediária entre as tabelas vendas, produtos e vendedores.  Assim, torna-se possível saber quais foram os produtos vendidos sem poluir a tabela vendas, a qual possui registros mais resumidos para totais.
- **venda_id** e **produto_id**: São chaves estrangeiras relacionadas às tabelas "Vendas" e "Produtos", respectivamente. Isso estabelece um relacionamento muitos-para-muitos entre vendas e produtos.


## Restrições de Chave Estrangeira na Tabela Vendas

**Conceito**: Neste trecho de código, estamos adicionando restrições de chave estrangeira à tabela `vendas`. As restrições de chave estrangeira são usadas para manter a integridade referencial entre as tabelas.

### Restrição fk_vendas_clientes

**Conceito**: De maneira semelhante, estamos adicionando uma restrição de chave estrangeira à coluna vendedor_id na tabela vendas. A restrição garante que qualquer valor que inserirmos para vendedor_id na tabela vendas deve existir na tabela vendedores. Isso evita a inserção de vendas por vendedores que não existem no banco de dados.

A cláusula MATCH SIMPLE tem o mesmo significado explicado acima.

## Atualização dos Produtos em Estoque:
- Idealmente, tal atualização deveria ser feita através de outro sistema que possua gatilhos/triggers, que ao lançarem a venda, diminuam a quantidade total em estoque, evitando assim que uma ação de rotina de vendas seja feita diretamente na base de dados.  
Todavia, caso seja necessário, é possível criar um trigger/gatilho. Segue exemplo, o qual deverá ser especificado para cada caso e, <span style="color:red"> **como já mencionado, não é o ideal para manutenção das quantidades do estoque:**

*<span style="color:green">CREATE TRIGGER atualizar_estoque
AFTER INSERT ON vendas_produtos
FOR EACH ROW
BEGIN
    UPDATE estoque
    SET quantidade_estoque = quantidade_estoque - NEW.quantidade_vendida
    WHERE produto_id = NEW.produto_id;
END;*


## Registro de pontos ao cliente por cada compra:
- Isto pode ser feito de diversas maneiras, caso exista um sistema em que a compra seja lançada, este deverá ter uma forma de "gatilho", que faça a o update da tabela clientes, no cliente que efetuou a compra e seus respectivos pontos.

Também seria possível fazer por trigger, como a gestão de estoque.

Caso a entrada seja feita de forma manual no Bando de Dados (não recomendado), seria algo como a query abaixo:

*<span style="color:green">UPDATE clientes
SET pontos = pontos + (SELECT pontos FROM produtos WHERE produto_id = :produto_id)
WHERE cliente_id = :cliente_id;''*
#### *<span style="color:red"> Lembrando que isto é um exemplo, logo :produto_id e cliente_id deverão ser substituídos pelos valores reais no momento do UPDATE*