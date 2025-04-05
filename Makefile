.PHONY: dev local docker prod migrate-dev migrate-docker migrate-prod migrate-local reset-dev reset-docker reset-prod reset-local lint format test diagrams

# Development environment (only db in Docker)
local:
	docker-compose -p pulse-flow-api up db_dev -d
	@echo "Starting local development server..."
	ENV_FILE=.env.local poetry run uvicorn app.main:app --reload --port 8001

# Development environment (all in Docker)
dev:
	docker-compose -p pulse-flow-api up db_dev -d
	@echo "Starting development server..."
	ENV_FILE=.env poetry run uvicorn app.main:app --reload --port 8002

dev-docker:
	docker-compose -p pulse-flow-api up api_dev

# Docker environment
docker:
	docker-compose -p pulse-flow-api up api_docker db_docker

# Production environment
prod:
	docker-compose -p pulse-flow-api up api_production db_production

# Database migrations
migrate-local:
	ENV_FILE=.env.local poetry run alembic upgrade head

migrate-dev:
	ENV_FILE=.env poetry run alembic upgrade head

migrate-docker:
	ENV_FILE=.env.docker poetry run alembic upgrade head

migrate-prod:
	ENV_FILE=.env.production poetry run alembic upgrade head

# Generate migrations
generate-migration:
	@read -p "Enter migration message: " message; \
	poetry run alembic revision --autogenerate -m "$$message"

# Reset databases (use with caution!)
reset-local:
	@echo "WARNING: This will reset the local development database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.local poetry run alembic downgrade base; \
		ENV_FILE=.env.local poetry run alembic upgrade head; \
		echo "Local database reset complete."; \
	else \
		echo "Operation cancelled."; \
	fi

reset-dev:
	@echo "WARNING: This will reset the development database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env poetry run alembic downgrade base; \
		ENV_FILE=.env poetry run alembic upgrade head; \
		echo "Development database reset complete."; \
	else \
		echo "Operation cancelled."; \
	fi

reset-docker:
	@echo "WARNING: This will reset the docker database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.docker poetry run alembic downgrade base; \
		ENV_FILE=.env.docker poetry run alembic upgrade head; \
		echo "Docker database reset complete."; \
	else \
		echo "Operation cancelled."; \
	fi

reset-prod:
	@echo "WARNING: This will reset the production database. All data will be lost!"
	@read -p "Are you sure? (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		ENV_FILE=.env.production poetry run alembic downgrade base; \
		ENV_FILE=.env.production poetry run alembic upgrade head; \
		echo "Production database reset complete."; \
	else \
		echo "Operation cancelled."; \
	fi

# Code quality
lint:
	poetry run flake8 app tests
	poetry run mypy app tests

format:
	poetry run black app tests
	poetry run isort app tests

# Tests
test:
	poetry run pytest -v tests 

# Diagrams
diagrams:
	@echo "Generating PlantUML diagrams..."
	./scripts/generate_diagrams.sh

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