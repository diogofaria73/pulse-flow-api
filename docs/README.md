# Pulse Flow API - Documentação

Esta pasta contém diagramas e documentação relacionada à arquitetura e ao design do sistema Pulse Flow API.

## Diagramas

Todos os diagramas são criados usando [PlantUML](https://plantuml.com/), uma ferramenta que permite a criação de diagramas através de código.

### Lista de Diagramas

1. **Fluxo de Dados do Sistema**
   - Arquivo: `diagrams/data_flow.puml`
   - Descrição: Mostra como os dados fluem através dos componentes do sistema.
   - ![Fluxo de Dados](images/Data%20Flow%20Diagram.png)
   - Explicação: Este diagrama ilustra o fluxo de dados desde o usuário até o banco de dados e de volta. O usuário interage com o frontend, que envia requisições HTTP para a API FastAPI. A API processa essas requisições usando a camada de serviços, que por sua vez utiliza repositórios para operações no banco de dados. Os dados então percorrem o caminho inverso até retornarem ao usuário na interface.

2. **Arquitetura de Camadas da Aplicação**
   - Arquivo: `diagrams/architecture_layers.puml`
   - Descrição: Ilustra as diferentes camadas da aplicação e suas responsabilidades.
   - ![Arquitetura de Camadas](images/Architecture%20Layers.png)
   - Explicação: Este diagrama apresenta a arquitetura em camadas do Pulse Flow API. Começando pelo Frontend com a aplicação cliente, passando pela Camada de API (FastAPI, Endpoints, Router, Middlewares), a Camada de Serviço que contém a lógica de negócio, a Camada de Repositório responsável pelo acesso aos dados, a Camada de Modelo com as entidades ORM, e finalmente o Banco de Dados PostgreSQL. As setas mostram as dependências entre os componentes.

3. **Diagramas C4**
   
   a. **Contexto**
   - Arquivo: `diagrams/c4_context.puml`
   - ![C4 Contexto](images/C4%20Context%20Diagram.png)
   - Explicação: Este diagrama de contexto C4 mostra a visão de alto nível do sistema. Apresenta o profissional de saúde como usuário principal interagindo com o Pulse Flow API (sistema de rastreamento de erros hospitalares). O sistema se conecta a sistemas externos de notificação e autenticação para funcionalidades complementares.

   b. **Contêiner**
   - Arquivo: `diagrams/c4_container.puml`
   - ![C4 Contêiner](images/C4%20Container%20Diagram.png)
   - Explicação: O diagrama de contêiner C4 detalha os principais componentes (contêineres) do sistema. Mostra que o Pulse Flow System é composto por uma aplicação web (frontend em React), uma aplicação API (backend em FastAPI) e um banco de dados PostgreSQL. Ilustra como esses componentes se comunicam entre si e com sistemas externos de notificação e autenticação.

   c. **Componente**
   - Arquivo: `diagrams/c4_component.puml`
   - ![C4 Componente](images/C4%20Component%20Diagram.png)
   - Explicação: Este diagrama de componente C4 detalha a estrutura interna da aplicação API. Mostra como o API Gateway FastAPI roteia as requisições para diferentes componentes: Usuário, Rastreamento de Erros, Relatórios, Autenticação e Notificação. Cada componente tem uma responsabilidade específica e interage com o banco de dados e/ou sistemas externos quando necessário.

## Detalhes da Arquitetura

O Pulse Flow API segue uma arquitetura em camadas com separação clara de responsabilidades:

1. **Camada de API (API Layer)**: 
   - Responsável por receber requisições HTTP, validação de entrada e roteamento.
   - Implementada com FastAPI para alta performance e tipagem de dados.
   - Inclui middlewares para CORS, autenticação e logging.

2. **Camada de Serviço (Service Layer)**:
   - Contém a lógica de negócio da aplicação.
   - Orquestra as operações entre diferentes repositórios.
   - Implementa regras de negócio e validações específicas do domínio.

3. **Camada de Repositório (Repository Layer)**:
   - Abstrai o acesso a dados e operações no banco de dados.
   - Implementa padrões de acesso a dados para cada entidade.
   - Permite a substituição fácil da fonte de dados subjacente.

4. **Camada de Modelo (Model Layer)**:
   - Define as entidades do domínio e seus relacionamentos.
   - Utiliza SQLAlchemy ORM para mapeamento objeto-relacional.
   - Inclui validações em nível de modelo.

5. **Banco de Dados**:
   - PostgreSQL para armazenamento persistente de dados.
   - Gerenciado por migrações Alembic para controle de versão do esquema.

Esta arquitetura promove separação de preocupações, facilita testes e manutenção, e permite que diferentes partes do sistema evoluam independentemente.

## Geração dos Diagramas

Os diagramas podem ser regenerados usando o script `generate_diagrams.sh` localizado na pasta raiz do projeto. Este script utiliza a CLI do PlantUML para gerar imagens a partir dos arquivos `.puml`.

```bash
./scripts/generate_diagrams.sh
```

## Requisitos

Para gerar os diagramas, você precisa ter:

1. Java Runtime Environment (JRE)
2. PlantUML JAR

Estes requisitos são verificados e, se necessário, baixados automaticamente pelo script de geração. 