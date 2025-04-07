.PHONY: dev staging prod migrate-dev migrate-staging migrate-prod reset-dev reset-staging reset-prod lint format test diagrams infra-dev infra-staging infra-prod local

# Development environment
dev:
	docker-compose -p pulse-flow-api up db_dev api_dev

# Staging environment
staging:
	docker-compose -p pulse-flow-api up db_staging api_staging

# Production environment
prod:
	docker-compose -p pulse-flow-api up db_production api_production

# Local development (API local + DB in Docker)
local:
	docker-compose -p pulse-flow-api up -d db_dev
	@echo "Starting local development server..."
	ENV_FILE=.env.dev poetry run uvicorn app.main:app --reload --port 8000

# Infrastructure only (database)
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
migrate-dev:
	ENV_FILE=.env.dev poetry run alembic upgrade head

migrate-staging:
	ENV_FILE=.env.staging poetry run alembic upgrade head

migrate-prod:
	ENV_FILE=.env.production poetry run alembic upgrade head

# Generate migrations
generate-migration:
	@read -p "Enter migration message: " message; \
	poetry run alembic revision --autogenerate -m "$$message"

# Reset databases (use with caution!)
reset-dev:
	@echo "WARNING: This will reset the development database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.dev poetry run alembic downgrade base; \
		ENV_FILE=.env.dev poetry run alembic upgrade head; \
	fi

reset-staging:
	@echo "WARNING: This will reset the staging database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.staging poetry run alembic downgrade base; \
		ENV_FILE=.env.staging poetry run alembic upgrade head; \
	fi

reset-prod:
	@echo "WARNING: This will reset the production database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.production poetry run alembic downgrade base; \
		ENV_FILE=.env.production poetry run alembic upgrade head; \
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