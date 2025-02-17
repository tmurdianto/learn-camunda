# Camunda 7 Examples

This directory contains practical examples for learning Camunda 7. Each example is self-contained and demonstrates specific features of Camunda.

## Examples Structure

### 1. Basic Process
- Simple BPMN process
- Basic deployment
- Process instance starting
- Location: [01-basic-process](./01-basic-process)

### 2. User Tasks
- Form implementation
- Task assignment
- User interaction
- Location: [02-user-tasks](./02-user-tasks)

### 3. Service Tasks
- External service integration
- REST API calls
- Error handling
- Location: [03-service-tasks](./03-service-tasks)

## How to Use Examples

1. Start the local development environment:
```bash
cd ../resources
docker-compose -f docker-compose.dev.yml up -d
```

2. Open Camunda Modeler
3. Navigate to the example you want to try
4. Follow the README in each example folder

## Example Contents
Each example folder contains:
- BPMN diagram file
- README with instructions
- Sample data (if needed)
- Source code (if required)
