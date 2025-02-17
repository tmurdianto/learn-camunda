# First Steps with Camunda 7

## 1. Creating Your First Process

### Using Camunda Modeler
1. Open Camunda Modeler
2. Create new BPMN diagram
3. Save as `my-first-process.bpmn`

### Basic Elements
```
Start Event → User Task → End Event
```

### Example Process
See [Basic Process Example](../examples/01-basic-process)

## 2. Deploying Processes

### Via Camunda Modeler
1. Click "Deploy"
2. Select local engine
3. Configure deployment name

### Via REST API
```bash
curl -X POST http://localhost:8080/engine-rest/deployment/create \
  -F "deployment-name=my-process" \
  -F "process.bpmn=@my-first-process.bpmn"
```

## 3. Starting Process Instances

### Via Tasklist
1. Open Tasklist
2. Click "Start Process"
3. Select your process
4. Fill start form (if any)

### Via REST API
```bash
curl -X POST http://localhost:8080/engine-rest/process-definition/key/my-process/start \
  -H "Content-Type: application/json" \
  -d '{}'
```

## 4. Working with Tasks

### Claiming Tasks
1. Open Tasklist
2. Find your task
3. Click "Claim"
4. Complete task form

### Monitoring
1. Open Cockpit
2. Navigate to process definition
3. Check running instances
4. View process history

## 5. Common Operations

### Process Variables
```javascript
execution.setVariable("approved", true);
execution.getVariable("amount");
```

### Task Forms
- Embedded Forms
- Generated Forms
- Custom Forms

## Next Steps
1. Try [User Tasks Example](../examples/02-user-tasks)
2. Explore [Service Tasks](../examples/03-service-tasks)
3. Learn about [BPMN Elements](./04-bpmn-basics.md)
