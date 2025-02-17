# Local Development Setup for Camunda 7

## Prerequisites
- Docker and Docker Compose installed
- Git (optional)
- Java IDE (recommended: Eclipse or IntelliJ IDEA)

## Quick Start

1. **Start Camunda Environment**
```bash
cd camunda-7/resources
docker-compose -f docker-compose.dev.yml up -d
```

2. **Access the Applications**
- Camunda Platform: http://localhost:8080/camunda
  - Username: demo
  - Password: demo
- Adminer (Database UI): http://localhost:8081
  - System: PostgreSQL
  - Server: db
  - Username: camunda
  - Password: camunda
  - Database: camunda

## Development Environment

### Components
1. **Camunda BPM Platform**
   - Running on port 8080
   - Includes Cockpit, Tasklist, and Admin applications

2. **PostgreSQL Database**
   - Running on port 5432
   - Persistent storage for process data

3. **Adminer**
   - Database management interface
   - Running on port 8081

### Basic Commands
```bash
# Start services
docker-compose -f docker-compose.dev.yml up -d

# Check logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop services
docker-compose -f docker-compose.dev.yml down

# Remove volumes (clean start)
docker-compose -f docker-compose.dev.yml down -v
```

## Next Steps
1. Install Camunda Modeler
2. Create your first BPMN process
3. Deploy and test the process
4. Explore the examples folder
