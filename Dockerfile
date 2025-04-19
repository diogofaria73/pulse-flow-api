FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry==1.6.1

# Copy poetry configuration files
COPY pyproject.toml poetry.lock* ./

# Configure poetry to not create virtual environments
RUN poetry config virtualenvs.create false

# Install dependencies including dev dependencies
RUN poetry install --no-root

# Copy application code
COPY . .

# Ensure the scripts directory exists
RUN mkdir -p /app/scripts

# Make the startup script executable
RUN chmod +x /app/scripts/start.sh

# Expose port
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app

# Command to run the application
CMD ["/app/scripts/start.sh"]
