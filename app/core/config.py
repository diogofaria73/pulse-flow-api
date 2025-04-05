import os
import socket
from typing import Any, Dict, Optional

from pydantic import PostgresDsn, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


def is_docker():
    """
    Check if running inside a Docker container.
    Returns True if in Docker container, False otherwise.
    """
    path = '/proc/self/cgroup'
    return os.path.exists('/.dockerenv') or (
        os.path.isfile(path) and any('docker' in line for line in open(path))
    )


def get_host_ip():
    """
    Get the host IP address from a Docker container.
    In development, returns the Docker host (host.docker.internal on Mac/Windows, 172.17.0.1 on Linux).
    """
    try:
        if os.environ.get('DOCKER_HOST_IP'):
            return os.environ.get('DOCKER_HOST_IP')
        
        # For MacOS and Windows
        host_ip = socket.gethostbyname('host.docker.internal')
        return host_ip
    except socket.gaierror:
        # For Linux
        try:
            # Connect to something outside to get the default route
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            host_ip = s.getsockname()[0].split('.')
            host_ip[3] = '1'  # Usually the Docker host is .1
            return '.'.join(host_ip)
        except Exception:
            return '172.17.0.1'  # Docker default bridge


def get_env_file():
    """Get the appropriate .env file based on environment variables."""
    env_file = os.getenv("ENV_FILE", "")
    if env_file:
        return env_file
    
    # Check deployment environment
    environment = os.getenv("ENVIRONMENT", "").lower()
    if environment == "production":
        return ".env.production"
    elif environment == "docker":
        return ".env.docker"
    
    # If using docker-compose, use the default .env
    if is_docker():
        return ".env"
    
    # For local development outside Docker
    return ".env.local"


class Settings(BaseSettings):
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "Pulse Flow API"
    
    POSTGRES_SERVER: str
    POSTGRES_USER: str
    POSTGRES_PASSWORD: str
    POSTGRES_DB: str
    POSTGRES_PORT: str = "5432"
    
    SQLALCHEMY_DATABASE_URI: Optional[PostgresDsn] = None

    @field_validator("SQLALCHEMY_DATABASE_URI", mode="before")
    def assemble_db_connection(cls, v: Optional[str], values: Dict[str, Any]) -> Any:
        if isinstance(v, str):
            return v
        
        server = values.data.get("POSTGRES_SERVER")
        
        # Automatically adjust the host if running outside docker but DB is inside
        if not is_docker() and server in ["db_dev", "db_docker", "db_production"]:
            server = "localhost"
        
        # Get the correct port when running locally
        port = values.data.get("POSTGRES_PORT", "5432")
        if not is_docker():
            # Map the Docker service names to their exposed ports
            port_mappings = {
                "db_dev": "5435",      # Mapped in docker-compose.yml
                "db_docker": "5433",   # Mapped in docker-compose.yml
                "db_production": "5434" # Mapped in docker-compose.yml
            }
            
            if values.data.get("POSTGRES_SERVER") in port_mappings:
                port = port_mappings[values.data.get("POSTGRES_SERVER")]
        
        return PostgresDsn.build(
            scheme="postgresql+psycopg2",
            username=values.data.get("POSTGRES_USER"),
            password=values.data.get("POSTGRES_PASSWORD"),
            host=server,
            port=int(port),
            path=f"{values.data.get('POSTGRES_DB') or ''}",
        )

    model_config = SettingsConfigDict(
        env_file=get_env_file(), 
        case_sensitive=True
    )


settings = Settings()
