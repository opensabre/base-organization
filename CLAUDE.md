# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Spring Boot-based organization management service that provides user, role, group, position, and resource management capabilities. It's part of the OpenSabre framework ecosystem.

## Build and Development

### Build Commands
- `mvn clean compile` - Compile the project
- `mvn package` - Build the JAR package
- `mvn spring-boot:run` - Run the application locally
- `mvn test` - Run unit tests

### Docker Build
- `mvn compile jib:build` - Build and push Docker image using Jib
- The project uses Jib for containerization (no Docker daemon required)

### Native Build (Experimental)
- `mvn -Pnative package` - Build native executable using GraalVM

## Architecture

### Core Entities
- **User** - User management with authentication fields
- **Role** - Role-based access control with resource associations
- **Group** - Organizational group hierarchy
- **Position** - Job positions within the organization
- **Menu** - Navigation menu structure
- **Resource** - API and UI resource permissions

### Data Layer
- **MyBatis Plus** - ORM with table prefix `base_org_`
- **MySQL** - Primary database (configured via environment variables)
- **Redis** - Caching layer (configured via environment variables)
- **JetCache** - Method-level caching annotations

### Service Layer Pattern
- Interface-based service design (e.g., `IUserService`)
- Implementation classes in `service.impl` package
- Form/Param pattern for request/response data transfer

### REST API Structure
- Controllers in `rest` package with OpenAPI 3 annotations
- Standard CRUD operations with pagination support
- Form validation using Jakarta Validation
- Global exception handling via `GlobalExceptionHandlerAdvice`

## Configuration

### Environment Variables
- `SERVER_PORT` - Application port (default: 8010)
- `DATASOURCE_HOST`, `DATASOURCE_PORT`, `DATASOURCE_USERNAME`, `DATASOURCE_PASSWORD` - Database configuration
- `REDIS_HOST`, `REDIS_PORT` - Redis configuration

### Application Configuration
- `application.yml` - Main configuration with database, Redis, and OpenSabre framework settings
- `bootstrap.yml` - Spring Cloud bootstrap configuration
- `WebSecurityConfig` - Security configuration (currently commented out)

## Dependencies

### OpenSabre Framework
- `opensabre-starter-persistence` - Database and MyBatis Plus integration
- `opensabre-starter-register` - Service registration and discovery
- `opensabre-starter-cache` - Caching with JetCache

### Key Technologies
- Spring Boot 3.x
- Java 17
- MyBatis Plus
- Redis with Lettuce
- OpenAPI 3 (Swagger)
- Lombok

## Database Schema

### Key Tables
- `base_org_user` - User accounts with authentication fields
- `base_org_role` - Role definitions
- `base_org_user_role` - User-role relationships
- `base_org_resource` - API and UI resources
- `base_org_role_resource` - Role-resource permissions
- `base_org_group` - Organizational groups
- `base_org_position` - Job positions
- `base_org_menu` - Navigation menus

### Schema Management
- DDL scripts in `src/main/resources/db/os-base-org-ddl.sql`
- Sample data in `src/main/resources/db/os-base-org-db.sql`

## Testing

### Test Configuration
- H2 in-memory database for tests
- Test configuration in `src/test/resources/application.yml`
- Integration tests with `@SpringBootTest`

### Running Tests
- `mvn test` - Run all tests
- `mvn test -Dtest=ClassName` - Run specific test class

## Deployment

### GitHub Actions
- Automated Docker builds on push to master
- Uses Jib to build and push to Tencent Cloud Container Registry
- Requires secrets: `TENCENT_CLOUD_SECRET_ID`, `TENCENT_CLOUD_SECRET_KEY`, `TENCENT_CLOUD_NAMESPACE`

### Manual Deployment
- Build JAR: `mvn clean package`
- Run: `java -jar target/base-organization-0.0.1.jar`
- Docker: Use provided Dockerfile with JAR_FILE argument

## Code Conventions

### Package Structure
- `entity.po` - Persistent objects (database entities)
- `entity.vo` - View objects (API responses)
- `entity.form` - Form objects (API requests)
- `entity.param` - Query parameters
- `service` - Business logic interfaces
- `service.impl` - Service implementations
- `dao` - Data access objects (MyBatis mappers)
- `rest` - REST controllers
- `config` - Configuration classes

### Naming Conventions
- Service interfaces prefixed with `I` (e.g., `IUserService`)
- Form classes suffixed with `Form` (e.g., `UserForm`)
- Query parameter classes suffixed with `Param` (e.g., `UserQueryParam`)
- View objects suffixed with `Vo` (e.g., `UserVo`)

## Common Development Tasks

### Adding New Entity
1. Create PO in `entity.po`
2. Create Form in `entity.form`
3. Create Param in `entity.param`
4. Create Service interface and implementation
5. Create Controller in `rest`
6. Add MyBatis mapper in `dao`
7. Update database schema if needed

### Adding New API Endpoint
1. Add method to existing controller
2. Use OpenAPI annotations for documentation
3. Implement service method
4. Add validation annotations to form objects
5. Update tests if applicable