# Infrastructure Layer

This directory contains infrastructure-related code that supports the application but is not directly part of the business domain logic.

## Structure

- **db**: Database session management and connection handling
  - `session.py`: Database session and connection setup
  - `base.py`: Imports all models for Alembic migrations
  
- **migrations**: Database migration files using Alembic
  - `versions/`: Contains all migration version files
  - `env.py`: Alembic environment configuration
  - `script.py.mako`: Template for migration scripts

## Usage

### Database Migrations

To run migrations:

```shell
# Generate a new migration (after model changes)
alembic -c app/infrastructure/alembic.ini revision --autogenerate -m "description of changes"

# Apply migrations
alembic -c app/infrastructure/alembic.ini upgrade head

# Roll back one migration
alembic -c app/infrastructure/alembic.ini downgrade -1
```

### Database Access

For database access within the application, use the session dependency:

```python
from app.infrastructure.db.session import get_db

@app.get("/example")
def example_endpoint(db: Session = Depends(get_db)):
    # Use db for database operations
    pass
``` 