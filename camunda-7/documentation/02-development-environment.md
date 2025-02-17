# Development Environment Guide

## Environment Components

### 1. Docker Setup
```yaml
services:
  camunda:    # Process Engine
  db:         # Database
  adminer:    # DB Management
```

### 2. Development Tools
- Camunda Modeler
- Java IDE (Eclipse/IntelliJ)
- Database Tool (Adminer/DBeaver)

## Local Development

### Starting the Environment
```bash
cd resources
docker-compose -f docker-compose.dev.yml up -d
```

### Basic Commands
```bash
# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Restart services
docker-compose -f docker-compose.dev.yml restart

# Stop environment
docker-compose -f docker-compose.dev.yml down
```

### Development Workflow
1. Design process in Modeler
2. Deploy to local engine
3. Test in Tasklist
4. Monitor in Cockpit

## Best Practices
1. Use version control
2. Follow naming conventions
3. Document process models
4. Test thoroughly
5. Use separate environments

## Troubleshooting
1. Check container logs
2. Verify database connection
3. Validate BPMN files
4. Check network connectivity

## Next Steps
1. Try [example processes](../examples)
2. Implement custom forms
3. Create service tasks
4. Add business rules
