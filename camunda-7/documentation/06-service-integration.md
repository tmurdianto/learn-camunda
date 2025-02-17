# Service Integration Guide

## Integration Types

### 1. Java Delegate
```java
@Named("creditCheckDelegate")
public class CreditCheckDelegate implements JavaDelegate {
    @Override
    public void execute(DelegateExecution execution) {
        // Service integration logic
        String applicantId = (String) execution.getVariable("applicantId");
        // Call external service
        execution.setVariable("creditScore", result.getScore());
    }
}
```

### 2. External Task
```java
@Component
public class CreditCheckWorker {
    @ExternalTaskSubscription(topicName = "creditCheck")
    public void handleCreditCheck(ExternalTask task, ExternalTaskService service) {
        // Implement service logic
        service.complete(task);
    }
}
```

### 3. REST Integration
```java
@Component
public class RestServiceDelegate implements JavaDelegate {
    @Autowired
    private RestTemplate restTemplate;
    
    @Override
    public void execute(DelegateExecution execution) {
        ResponseEntity<CreditScore> response = restTemplate.getForEntity(
            "/api/credit-score/{id}",
            CreditScore.class,
            execution.getVariable("applicantId")
        );
    }
}
```

## Implementation Patterns

### 1. Synchronous Integration
```xml
<bpmn:serviceTask id="Task_CheckCredit"
    camunda:class="org.example.CreditCheckDelegate">
</bpmn:serviceTask>
```

### 2. Asynchronous Integration
```xml
<bpmn:serviceTask id="Task_CheckCredit"
    camunda:type="external"
    camunda:topic="creditCheck">
</bpmn:serviceTask>
```

### 3. Error Handling
```xml
<bpmn:serviceTask id="ServiceTask_1">
    <bpmn:boundaryEvent id="BoundaryEvent_1">
        <bpmn:errorEventDefinition errorRef="Error_1" />
    </bpmn:boundaryEvent>
</bpmn:serviceTask>
```

## Configuration

### 1. External Task
```yaml
camunda.bpm.client:
  base-url: http://localhost:8080/engine-rest
  async-response-timeout: 20000
  lock-duration: 10000
  worker-id: credit-check-worker
```

### 2. REST Template
```java
@Configuration
public class RestConfig {
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplateBuilder()
            .setConnectTimeout(Duration.ofSeconds(10))
            .setReadTimeout(Duration.ofSeconds(10))
            .build();
    }
}
```

## Best Practices

### 1. Error Handling
```java
try {
    // Service integration
} catch (Exception e) {
    throw new BpmnError("SERVICE_ERROR", e.getMessage());
}
```

### 2. Retry Mechanism
```xml
<bpmn:serviceTask id="Task_RetryExample">
    <bpmn:extensionElements>
        <camunda:failedJobRetryTimeCycle>R3/PT5M</camunda:failedJobRetryTimeCycle>
    </bpmn:extensionElements>
</bpmn:serviceTask>
```

### 3. Timeout Handling
```xml
<bpmn:serviceTask id="Task_TimeoutExample">
    <bpmn:boundaryEvent id="TimerEvent_1">
        <bpmn:timerEventDefinition>
            <bpmn:timeDuration>PT30S</bpmn:timeDuration>
        </bpmn:timerEventDefinition>
    </bpmn:boundaryEvent>
</bpmn:serviceTask>
```

## Security

### 1. Authentication
```java
@Configuration
public class SecurityConfig {
    @Bean
    public RestTemplate secureRestTemplate() {
        return new RestTemplateBuilder()
            .basicAuthentication("username", "password")
            .build();
    }
}
```

### 2. SSL Configuration
```java
@Bean
public SSLContext sslContext() {
    // SSL configuration
}
```

## Monitoring

### 1. Metrics
```java
@Component
public class ServiceMetrics {
    private final Counter serviceCallCounter;
    private final Timer serviceCallTimer;
    
    // Implement metrics
}
```

### 2. Logging
```java
@Slf4j
public class ServiceDelegate implements JavaDelegate {
    @Override
    public void execute(DelegateExecution execution) {
        log.info("Starting service call for {}", execution.getProcessInstanceId());
        // Service logic
        log.info("Service call completed");
    }
}
```

## Examples

### 1. REST Service
See [Service Tasks Example](../examples/03-service-tasks)

### 2. Message Correlation
```java
runtimeService.createMessageCorrelation("PaymentReceived")
    .processInstanceId(processInstanceId)
    .correlate();
```

## Troubleshooting

### 1. Common Issues
- Connection timeouts
- Authentication failures
- Data format mismatches
- Missing configurations

### 2. Solutions
- Check network connectivity
- Verify credentials
- Validate request/response
- Review logs

## Next Steps
1. Implement complex integrations
2. Add error handling
3. Set up monitoring
4. Implement security measures
