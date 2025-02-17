# Getting Started with Camunda 7

## Prerequisites
- Docker and Docker Compose installed
- Basic understanding of BPMN
- Git (optional, for version control)

## Quick Start with Docker Compose

1. **Start the Environment**
```bash
cd resources
docker-compose up -d
```

2. **Access the Applications**
- Camunda Platform: http://localhost:8080/camunda
  - Default credentials: demo/demo
- Adminer (Database Management): http://localhost:8081
  - System: PostgreSQL
  - Server: db
  - Username: camunda
  - Password: camunda
  - Database: camunda

## Components Overview

### 1. Camunda BPM Platform
- Running on Tomcat
- Exposed on port 8080
- Includes:
  - Camunda Cockpit (monitoring)
  - Camunda Tasklist (task management)
  - Camunda Admin (user management)

### 2. PostgreSQL Database
- Persistent storage for:
  - Process definitions
  - Process instances
  - Task data
  - History data

### 3. Adminer
- Database management interface
- Useful for:
  - Viewing data structures
  - Debugging
  - Database administration

## Next Steps
1. Log into Camunda Platform
2. Explore Cockpit interface
3. Create your first BPMN process
4. Deploy and run the process
