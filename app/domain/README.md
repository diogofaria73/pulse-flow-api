# Domain-Driven Structure

This project follows a domain-driven design approach where the codebase is organized around business domains rather than technical layers.

## Organization

Each domain contains its own:

- **models**: Database models/entities for the domain
- **schemas**: Pydantic schemas for validation and API responses
- **repositories**: Data access patterns for the models
- **services**: Business logic for the domain

## Available Domains

- **user**: User management (authentication, profiles, etc.)
- **sector**: Hospital sectors management
- **auth**: Authentication-related schemas and services
- **common**: Shared components like base repository patterns

## Benefits

1. **Improved code organization**: Related code is grouped together
2. **Better maintainability**: Changes to one domain minimally impact others
3. **Clearer responsibilities**: Each domain has its own clear boundary
4. **Easier to understand**: New developers can more easily understand the system
5. **Testability**: Domains can be tested in isolation 