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
├── .env                  # Environment variables for local dev
├── .env.docker           # Environment variables for docker environment
├── .env.production       # Environment variables for production
├── Dockerfile            # Docker image definition
├── docker-compose.yml    # Docker compose configuration
├── pyproject.toml        # Poetry project definition
└── README.md             # Project documentation
```

## Ambientes de Execução

A API suporta quatro ambientes de execução diferentes, com detecção automática:

1. **Local** - Execução da API diretamente na máquina local, conectando-se ao PostgreSQL que roda no Docker
2. **Dev** - Execução da API diretamente na máquina local, usando configurações de desenvolvimento
3. **Docker** - Execução completa em contêineres Docker
4. **Production** - Ambiente de produção em contêineres Docker

### Detecção Automática de Ambiente

A API detecta automaticamente o ambiente onde está sendo executada e aplica as configurações corretas:

- Se a variável de ambiente `ENVIRONMENT` estiver definida, ela será usada
- Se a aplicação estiver rodando dentro de um contêiner Docker, usa o ambiente Docker
- Caso contrário, usa o ambiente Local

### Arquivos de Configuração por Ambiente

Cada ambiente tem seu próprio arquivo de configuração:

- `.env.local` - Configurações para desenvolvimento local (API local, BD no Docker)
- `.env` - Configurações para desenvolvimento (API local, BD no Docker)
- `.env.docker` - Configurações para o ambiente Docker (API e BD no Docker)
- `.env.production` - Configurações para o ambiente de produção

Você também pode forçar o uso de um arquivo específico definindo a variável `ENV_FILE`:

```bash
ENV_FILE=.env.local poetry run uvicorn app.main:app --reload
```

## Quick Start with Make

The project includes a Makefile with common commands for development:

```bash
# Start development environment (local Python with Docker database)
make dev

# Start development environment (all components in Docker)
make dev-docker

# Start Docker environment
make docker

# Start production environment
make prod

# Run database migrations
make migrate-dev
make migrate-docker
make migrate-prod

# Generate a new migration
make generate-migration

# Reset databases (use with caution!)
make reset-dev
make reset-docker
make reset-prod

# Code quality
make lint
make format

# Run tests
make test

# Generate PlantUML diagrams
make diagrams

# Check if PlantUML is installed
make check-plantuml

# Para execução local (API local, banco no Docker)
make local

# Para execução em desenvolvimento (API local, banco no Docker)
make dev
```

## Setup and Running the API

### Prerequisites

- Docker and Docker Compose
- Python 3.8 or higher (for local development without Docker)
- Poetry (for local development without Docker)

### Development Environment

There are three environments available:

1. **Development (dev)**: For local development with a PostgreSQL container
2. **Docker (compiled)**: Running the API in a Docker container
3. **Production**: Production-ready environment

### Running the Development Environment

To start the development database:

```bash
cd pulse-flow-api
docker-compose up -p pulse-flow-api db_dev
```

For local development (outside Docker):

1. Install dependencies with Poetry:
```bash
cd pulse-flow-api
poetry install
```

2. Run the application:
```bash
poetry run uvicorn app.main:app --reload
```

Or use the Docker development environment:

```bash
docker-compose -p pulse-flow-api up api_dev
```

### Running the Docker Environment (Compiled)

This runs the API in a Docker container with its own database:

```bash
docker-compose -p pulse-flow-api up api_docker db_docker
```

### Running the Production Environment

This runs the production-ready version in Docker:

```bash
docker-compose -p pulse-flow-api up api_production db_production
```

## Database Migrations

Database migrations are managed with Alembic. Here are the most common commands:

### Initialize the Database

```bash
# Generate initial migration
poetry run alembic revision --autogenerate -m "Initial migration"

# Apply migrations
poetry run alembic upgrade head
```

### Making Changes to the Database

1. Modify the SQLAlchemy models in `app/models/`
2. Generate a new migration:
```bash
poetry run alembic revision --autogenerate -m "Description of the changes"
```
3. Apply the migration:
```bash
poetry run alembic upgrade head
```

### Rolling Back Migrations

To roll back to a previous migration:
```bash
# Roll back one step
poetry run alembic downgrade -1

# Roll back to a specific revision
poetry run alembic downgrade <revision_id>

# Roll back to the beginning (before any migrations)
poetry run alembic downgrade base
```

## PlantUML Diagrams

The project uses PlantUML for creating documentation diagrams. The diagrams are located in the `docs/diagrams/` directory.

### Prerequisites

To render the diagrams, you need:

1. Java Runtime Environment (JRE)
2. GraphViz
3. PlantUML

Install on macOS:

```bash
brew install --cask temurin
brew install graphviz
brew install plantuml
```

Install on Linux:

```bash
sudo apt-get install default-jre graphviz plantuml
```

### Generating Diagrams

You can generate all diagrams at once:

```bash
make diagrams
```

Or use the script directly:

```bash
./scripts/generate_diagrams.sh
```

### Available Diagrams

- `architecture.puml` - System architecture diagram
- `data_flow.puml` - Data flow sequence diagram

For more details about PlantUML usage in this project, see the dedicated documentation in `docs/diagrams/README.md`.

## API Endpoints

### User Management

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/users` | Create a new user |
| GET | `/api/v1/users/{user_id}` | Get user by ID |
| PUT | `/api/v1/users/{user_id}` | Update user |
| POST | `/api/v1/users/search` | Search for users by ID, name, or email |
| PATCH | `/api/v1/users/{user_id}/activate` | Activate a user |
| PATCH | `/api/v1/users/{user_id}/deactivate` | Deactivate a user |

## Development

### Adding New Models

1. Create a new model in `app/models/`
2. Add the model to `app/db/base.py`
3. Create corresponding Pydantic schemas in `app/schemas/`
4. Create a repository in `app/repositories/`
5. Create a service in `app/services/`
6. Create API endpoints in `app/api/v1/endpoints/`
7. Register the API router in `app/api/v1/__init__.py`

## API Documentation

Once the API is running, you can access the auto-generated documentation:

- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Environment Variables

The following environment variables can be set:

- `PROJECT_NAME`: API project name
- `API_V1_STR`: API version 1 prefix
- `POSTGRES_SERVER`: PostgreSQL server host
- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_PORT`: PostgreSQL port

## Troubleshooting

### Common Issues

#### ModuleNotFoundError: No module named 'pydantic_settings'

If you encounter this error, it means the pydantic-settings package is missing. Make sure you're using the latest version of the code which includes this dependency in pyproject.toml. Run:

```bash
poetry install
```

#### Database Connection Issues

If you have problems connecting to the database, check:

1. Database is running and accessible
2. Environment variables are correctly set in the appropriate .env file
3. Network connectivity between containers if using Docker

#### Migrations Failing

If database migrations fail:

1. Check database connection settings
2. Ensure the database exists and is accessible
3. Check that alembic is properly installed:
   ```bash
   poetry add alembic
   ```
4. Run migrations manually:
   ```bash
   poetry run alembic upgrade head
   ```
