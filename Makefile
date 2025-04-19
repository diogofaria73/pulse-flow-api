.PHONY: dev staging prod migrate-dev migrate-staging migrate-prod reset-dev reset-staging reset-prod lint format test diagrams infra-dev infra-staging infra-prod local

# Cenário 1: Desenvolvimento Local (API local + DB no Docker)
local:
	docker-compose -p pulse-flow-api up -d db_dev
	@echo "Starting local development server..."
	ENV_FILE=.env.local poetry run uvicorn app.main:app --reload --port 8000

# Cenário 2: Ambiente de Staging (API + DB no Docker)
staging:
	docker-compose -p pulse-flow-api up db_staging api_staging

# Cenário 3: Ambiente de Produção (API + DB no Docker)
prod:
	docker-compose -p pulse-flow-api up db_production api_production

# Somente infraestrutura (banco de dados)
infra-dev:
	docker-compose -p pulse-flow-api up -d db_dev
	@echo "Development database is running on port 5432"

infra-staging:
	docker-compose -p pulse-flow-api up -d db_staging
	@echo "Staging database is running on port 5433"

infra-prod:
	docker-compose -p pulse-flow-api up -d db_production
	@echo "Production database is running on port 5434"

# Database migrations
migrate-local:
	ENV_FILE=.env.local poetry run alembic -c app/infrastructure/alembic.ini upgrade head

migrate-staging:
	ENV_FILE=.env.staging poetry run alembic -c app/infrastructure/alembic.ini upgrade head

migrate-prod:
	ENV_FILE=.env.production poetry run alembic -c app/infrastructure/alembic.ini upgrade head

# Generate migrations
generate-migration:
	@read -p "Enter migration message: " message; \
	poetry run alembic -c app/infrastructure/alembic.ini revision --autogenerate -m "$$message"

# Reset databases (use with caution!)
reset-local:
	@echo "WARNING: This will reset the development database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.local poetry run alembic -c app/infrastructure/alembic.ini downgrade base; \
		ENV_FILE=.env.local poetry run alembic -c app/infrastructure/alembic.ini upgrade head; \
	fi

reset-staging:
	@echo "WARNING: This will reset the staging database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.staging poetry run alembic -c app/infrastructure/alembic.ini downgrade base; \
		ENV_FILE=.env.staging poetry run alembic -c app/infrastructure/alembic.ini upgrade head; \
	fi

reset-prod:
	@echo "WARNING: This will reset the production database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.production poetry run alembic -c app/infrastructure/alembic.ini downgrade base; \
		ENV_FILE=.env.production poetry run alembic -c app/infrastructure/alembic.ini upgrade head; \
	fi

# Development tools
lint:
	poetry run flake8 app tests
	poetry run mypy app tests

format:
	poetry run black app tests
	poetry run isort app tests

test:
	poetry run pytest tests

diagrams:
	poetry run python scripts/generate_diagrams.py

check-plantuml:
	@echo "Checking if PlantUML is installed..."
	@if ! command -v plantuml &> /dev/null; then \
		echo "PlantUML not found. Please install it:"; \
		echo "  macOS: brew install plantuml"; \
		echo "  Linux: sudo apt-get install plantuml"; \
		exit 1; \
	else \
		echo "PlantUML is installed."; \
	fi

# Ensure port is an integer
port = int(port) 