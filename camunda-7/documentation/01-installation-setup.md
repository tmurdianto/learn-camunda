# Installation and Setup

## Prerequisites
- Docker and Docker Compose
- Java Development Kit (JDK) 8 or higher
- Camunda Modeler

## Development Environment Setup

### Using Docker Compose
1. Navigate to the resources directory:
```bash
cd resources
```

2. Start the environment:
```bash
docker-compose -f docker-compose.dev.yml up -d
```

### Components
- Camunda BPM Platform (http://localhost:8080/camunda)
- PostgreSQL Database
- Adminer (Database Management)

## Access Information

### Camunda Platform
- URL: http://localhost:8080/camunda
- Username: demo
- Password: demo

### Database
- System: PostgreSQL
- Host: localhost
- Port: 5432
- Database: camunda
- Username: camunda
- Password: camunda

### Adminer
- URL: http://localhost:8081
- System: PostgreSQL
- Server: db
- Username: camunda
- Password: camunda

## Verification Steps
1. Access Camunda Web Interface
2. Login with demo/demo
3. Navigate to Cockpit
4. Verify no errors in logs:
```bash
docker-compose -f docker-compose.dev.yml logs -f
```

## Next Steps
1. Install [Camunda Modeler](https://camunda.com/download/modeler/)
2. Try the [Basic Process Example](../examples/01-basic-process)
3. Explore [BPMN Basics](./04-bpmn-basics.md)
