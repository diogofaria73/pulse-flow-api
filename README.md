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

The API supports three distinct execution environments:

1. **Development** - For local development and testing
   - API runs on port 8000
   - Database runs on port 5432
   - Automatic code reloading enabled
   - Debug mode enabled

2. **Staging** - For pre-production testing
   - API runs on port 8001
   - Database runs on port 5433
   - Debug mode disabled
   - Production-like settings

3. **Production** - For live deployment
   - API runs on port 8002
   - Database runs on port 5434
   - Debug mode disabled
   - Optimized for performance

### Environment Detection

The API automatically detects the environment where it's running and applies the correct settings based on the `ENVIRONMENT` variable in the respective `.env` file.

## Getting Started

### Prerequisites

- Python 3.9+
- Poetry
- Docker and Docker Compose
- PostgreSQL (for local development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/pulse-flow-api.git
cd pulse-flow-api
```

2. Install dependencies:
```bash
poetry install
```

3. Copy the environment template:
```bash
cp .env.example .env.dev  # For development
cp .env.example .env.staging  # For staging
cp .env.example .env.production  # For production
```

4. Update the environment variables in each `.env` file as needed.

### Running the Application

#### Full Environment (API + Database)

```bash
make dev      # For development
make staging  # For staging
make prod     # For production
```

#### Infrastructure Only (Database)

If you only need the database infrastructure:

```bash
make infra-dev      # Start development database
make infra-staging  # Start staging database
make infra-prod     # Start production database
```

The databases will be available on the following ports:
- Development: 5432
- Staging: 5433
- Production: 5434

### Database Migrations

To run migrations in each environment:

```bash
make migrate-dev      # For development
make migrate-staging  # For staging
make migrate-prod     # For production
```

To generate a new migration:
```bash
make generate-migration
```

### Development Tools

- Run tests: `make test`
- Format code: `make format`
- Run linter: `make lint`
- Generate diagrams: `make diagrams`

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
