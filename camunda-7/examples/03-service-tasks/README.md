# Service Tasks and External Integration Example

This example demonstrates how to integrate Camunda with external services using different types of service tasks.

## Implementation Types

### 1. Java Delegate
```java
public class ValidateInputDelegate implements JavaDelegate {
    @Override
    public void execute(DelegateExecution execution) throws Exception {
        String applicantId = (String) execution.getVariable("applicantId");
        // Validation logic here
    }
}
```

### 2. External Task
```java
@Component
public class CreditCheckWorker {
    @ExternalTaskSubscription(topicName = "creditCheck")
    public void checkCredit(ExternalTask task, ExternalTaskService service) {
        // Implement credit check logic
        service.complete(task);
    }
}
```

## Process Features

1. **Input Validation (Java Delegate)**
   - Validates input parameters
   - Throws validation exceptions
   - Sets process variables

2. **External Credit Check (External Task)**
   - Calls external credit API
   - Handles timeouts
   - Processes response

3. **Error Handling**
   - BPMN error events
   - Compensation handling
   - Retry mechanisms

## Project Structure
```
03-service-tasks/
├── credit-check-service.bpmn
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── org/
│   │   │       └── camunda/
│   │   │           └── example/
│   │   │               ├── ValidateInputDelegate.java
│   │   │               ├── ProcessCreditResultDelegate.java
│   │   │               └── HandleErrorDelegate.java
│   │   └── resources/
│   │       └── application.yaml
│   └── test/
│       └── java/
│           └── org/
│               └── camunda/
│                   └── example/
│                       └── CreditCheckProcessTest.java
```

## How to Run

1. **Build the Project**
```bash
mvn clean package
```

2. **Deploy to Camunda**
```bash
# Start Camunda
cd ../../resources
docker-compose -f docker-compose.dev.yml up -d
```

3. **Start External Task Worker**
```bash
java -jar credit-check-worker.jar
```

## Implementation Details

### 1. Service Task Types
- Java Delegate
- External Task
- Expression
- Delegate Expression

### 2. Error Handling
```java
try {
    // Service task logic
} catch (Exception e) {
    execution.setVariable("errorCode", "CREDIT_CHECK_ERROR");
    throw new BpmnError("CREDIT_CHECK_ERROR", e.getMessage());
}
```

### 3. External Task Configuration
```yaml
camunda.bpm.client:
  base-url: http://localhost:8080/engine-rest
  async-response-timeout: 20000
  worker-id: credit-check-worker
```

## Testing

### Unit Testing
```java
@Test
public void testCreditCheckProcess() {
    ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(
        "credit_check_service",
        Variables.createVariables()
            .putValue("applicantId", "12345")
            .putValue("requestType", "full")
    );

    // Assert process state
    assertThat(processInstance).isStarted();
}
```

### Integration Testing
```java
@Test
public void testExternalTaskIntegration() {
    // Create external task
    ExternalTask task = externalTaskService.createExternalTask()
        .topicName("creditCheck")
        .variables(variables)
        .execute();

    // Complete task
    externalTaskService.complete(task.getId(), workerId);
}
```

## Next Steps
1. Implement more complex service integrations
2. Add retry mechanisms
3. Implement compensation handling
4. Add business monitoring
5. Create custom metrics
