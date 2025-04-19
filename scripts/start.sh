#!/bin/bash
set -e

# Função para verificar se estamos executando no Docker
is_docker() {
  [ -f /.dockerenv ] || grep -q docker /proc/1/cgroup
}

# Detectar ambiente de execução
detect_environment() {
  if [ -n "$ENVIRONMENT" ]; then
    echo "$ENVIRONMENT"
  elif is_docker; then
    echo "docker"
  else
    echo "local"
  fi
}

ENV=$(detect_environment)
echo "Running in environment: $ENV"

# Selecionar arquivo .env apropriado com base no ENVIRONMENT
if [ "$ENV" = "production" ]; then
  export ENV_FILE=.env.production
elif [ "$ENV" = "staging" ]; then
  export ENV_FILE=.env.staging
else
  export ENV_FILE=.env.local
fi

echo "Using environment file: $ENV_FILE"

# Função para verificar a conexão com o banco de dados
function check_db_connection() {
    echo "Checking database connection..."
    python -c "
import sys
import time
import psycopg2
from app.infrastructure.core.config import settings

# Try to connect to the database
retries = 5
retry_interval = 5
for i in range(retries):
    try:
        conn = psycopg2.connect(
            host=settings.POSTGRES_SERVER,
            port=settings.POSTGRES_PORT,
            user=settings.POSTGRES_USER,
            password=settings.POSTGRES_PASSWORD,
            dbname=settings.POSTGRES_DB
        )
        conn.close()
        print('Successfully connected to the database!')
        sys.exit(0)
    except Exception as e:
        print(f'Failed to connect to database (attempt {i+1}/{retries}): {e}')
        if i < retries - 1:
            print(f'Retrying in {retry_interval} seconds...')
            time.sleep(retry_interval)

print('Could not connect to the database after several attempts. Exiting.')
sys.exit(1)
"
}

# Verificar conexão com o banco de dados
check_db_connection

# Aplicar migrações
echo "Running database migrations..."
alembic -c app/infrastructure/alembic.ini upgrade head

# Iniciar aplicação
echo "Starting application..."
exec uvicorn app.main:app --host 0.0.0.0 --port 8000 