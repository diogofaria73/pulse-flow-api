# Pulse Flow API

API for capturing and managing errors that occur within a hospital environment.

## Technology Stack

- **FastAPI**: Modern, fast (high-performance) web framework for building APIs
- **Poetry**: Dependency management and packaging tool
- **PostgreSQL**: Relational database for storing application data
- **SQLAlchemy**: ORM (Object Relational Mapper) for database interactions
- **Docker**: Containerization for development, testing, and production

## Project Structure

```
pulse-flow-api/
├── app/
│   ├── api/              # API endpoints
│   │   └── v1/           # Version 1 API routes
│   │       └── endpoints/  # API endpoint modules
│   ├── core/             # Core application settings
│   ├── db/               # Database configuration
│   ├── models/           # SQLAlchemy models
│   ├── repositories/     # Data access objects
│   ├── schemas/          # Pydantic models for validation
│   └── services/         # Business logic
├── docs/
│   └── diagrams/         # PlantUML diagrams
├── tests/                # Unit and integration tests
├── .env.example          # Environment variables template
├── .env.dev              # Environment variables for development
├── .env.staging          # Environment variables for staging
├── .env.production       # Environment variables for production
├── Dockerfile            # Docker image definition
├── docker-compose.yml    # Docker compose configuration
├── pyproject.toml        # Poetry project definition
└── README.md             # Project documentation
```

## Execution Environments

A API suporta três cenários de execução distintos:

### Cenário 1: Desenvolvimento Local
- **API:** Executa localmente na máquina do desenvolvedor
- **Banco de Dados:** Executa no Docker
- **Arquivo de Configuração:** `.env.local`
- **Comando:** `make local`
- **Porta API:** 8000
- **Porta DB:** 5432
- **Características:** 
  - Reload automático ao editar o código
  - Modo de debug ativado
  - DB acessível em localhost:5432

### Cenário 2: Ambiente de Staging (Homologação)
- **API:** Executa no Docker
- **Banco de Dados:** Executa no Docker
- **Arquivo de Configuração:** `.env.staging`
- **Comando:** `make staging`
- **Porta API:** 8001
- **Porta DB:** 5433 (host) / 5432 (interno)
- **Características:**
  - Simula o ambiente de produção
  - Ideal para testes de integração e homologação

### Cenário 3: Ambiente de Produção
- **API:** Executa no Docker
- **Banco de Dados:** Executa no Docker
- **Arquivo de Configuração:** `.env.production`
- **Comando:** `make prod`
- **Porta API:** 8002
- **Porta DB:** 5434 (host) / 5432 (interno)
- **Características:**
  - Otimizado para desempenho
  - Modo de debug desativado

### Detecção de Ambiente

A API detecta automaticamente o ambiente de execução através da variável `ENVIRONMENT` nos arquivos `.env` e aplica as configurações apropriadas.

## Getting Started

### Prerequisites

- Python 3.9+
- Poetry
- Docker e Docker Compose
- PostgreSQL (para conexão local)

### Installation

1. Clone o repositório:
```bash
git clone https://github.com/yourusername/pulse-flow-api.git
cd pulse-flow-api
```

2. Instale as dependências:
```bash
poetry install
```

3. Copie os templates de ambiente:
```bash
cp .env.example .env.local
cp .env.example .env.staging
cp .env.example .env.production
```

4. Atualize as variáveis de ambiente em cada arquivo `.env` conforme necessário.

### Running the Application

#### Desenvolvimento Local (API Local + DB no Docker)

```bash
make local
```

#### Ambiente de Staging (API + DB no Docker)

```bash
make staging
```

#### Ambiente de Produção (API + DB no Docker)

```bash
make prod
```

#### Somente Infraestrutura (Banco de Dados)

Se você precisa apenas do banco de dados:

```bash
make infra-dev     # Inicia o banco de dados de desenvolvimento
make infra-staging # Inicia o banco de dados de staging
make infra-prod    # Inicia o banco de dados de produção
```

Os bancos de dados estarão disponíveis nas seguintes portas:
- Desenvolvimento: 5432
- Staging: 5433
- Produção: 5434

### Database Migrations

Para rodar migrações em cada ambiente:

```bash
make migrate-local    # Para desenvolvimento local
make migrate-staging  # Para ambiente de staging
make migrate-prod     # Para ambiente de produção
```

Para gerar uma nova migração:
```bash
make generate-migration
```

Para resetar o banco de dados (use com cuidado, isso apaga todos os dados):
```bash
make reset-local    # Para ambiente de desenvolvimento
make reset-staging  # Para ambiente de staging
make reset-prod     # Para ambiente de produção
```

### Development Tools

- Executar testes: `make test`
- Formatar código: `make format`
- Executar linter: `make lint`
- Gerar diagramas: `make diagrams`

## API Documentation

Once the application is running, you can access the API documentation at:
- Development: http://localhost:8000/docs
- Staging: http://localhost:8001/docs
- Production: http://localhost:8002/docs

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Migrações de Banco de Dados

As migrações de banco de dados estão centralizadas no diretório `app/infrastructure/migrations`. 

### Migração para a nova estrutura

Se você está migrando de uma instalação anterior que usava o diretório `migrations/` na raiz, execute o script de migração para atualizar:

```bash
./scripts/migrate-to-infrastructure.sh
```

Este script vai:
1. Fazer backup do schema atual
2. Transferir os arquivos de migração para a nova estrutura
3. Atualizar a tabela `alembic_version` no banco de dados

### Comandos de migração

Para executar migrações, use os comandos do Makefile:

```bash
# Gerar uma nova migração (após mudanças nos modelos)
make generate-migration

# Aplicar migrações
make migrate-dev  # para ambiente de desenvolvimento
make migrate-staging  # para ambiente de staging
make migrate-prod  # para ambiente de produção

# Resetar o banco de dados (use com cuidado!)
make reset-dev  # para ambiente de desenvolvimento
```

Todos os comandos agora apontam para o arquivo de configuração do Alembic em `app/infrastructure/alembic.ini`.
