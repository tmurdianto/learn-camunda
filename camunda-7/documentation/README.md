# Camunda 7 Documentation

## Documentation Structure

1. **Getting Started**
   - [Installation and Setup](./01-installation-setup.md)
   - [Development Environment](./02-development-environment.md)
   - [First Steps](./03-first-steps.md)

2. **Process Implementation**
   - [Basic BPMN Elements](./04-bpmn-basics.md)
   - [Working with Forms](./05-forms-guide.md)
   - [Service Integration](./06-service-integration.md)

3. **Examples**
   See the [examples](../examples) directory for practical implementations:
   - Basic Process Example
   - User Tasks with Forms
   - Service Task Integration

4. **Deployment**
   - Development Environment: `docker-compose.dev.yml`
   - Production Environment: `docker-compose.prod.yml`

## Quick Start

1. **Start Development Environment**
```bash
cd resources
docker-compose -f docker-compose.dev.yml up -d
```

2. **Access Camunda**
- Web Interface: http://localhost:8080/camunda
- Default credentials: demo/demo

3. **Try Examples**
- Navigate to [examples](../examples)
- Follow README in each example directory

## Additional Resources
- [Official Camunda 7 Documentation](https://docs.camunda.org/manual/7.20/)
- [BPMN 2.0 Reference](https://docs.camunda.org/manual/7.20/reference/bpmn20/)
- [Camunda Forum](https://forum.camunda.org/)
