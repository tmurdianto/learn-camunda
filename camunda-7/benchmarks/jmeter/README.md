# JMeter Performance Tests for Camunda 7

## Overview
This directory contains Apache JMeter test plans for Camunda 7, focusing on the loan application process. JMeter is chosen for its comprehensive testing capabilities and extensive reporting features.

## Test Plan Structure

### loan-process-test.jmx
1. **Thread Group Configuration**
   - 50 threads (users)
   - 300 seconds ramp-up
   - 1800 seconds duration

2. **Test Steps**
   - Start process instance
   - Get task
   - Complete task
   - Verify responses

## Prerequisites

1. Install JMeter:
```bash
# Download JMeter
https://jmeter.apache.org/download_jmeter.cgi

# Add to PATH
set PATH=%PATH%;C:\apache-jmeter\bin
```

2. Start Camunda:
```bash
cd ../../resources
docker-compose -f docker-compose.prod.yml up -d
```

## Running Tests

### GUI Mode (Development)
```bash
jmeter -t loan-process-test.jmx
```

### Non-GUI Mode (Production)
```bash
# Basic run
jmeter -n -t loan-process-test.jmx -l results.jtl

# With custom properties
jmeter -n -t loan-process-test.jmx -l results.jtl -Jusers=100 -Jduration=3600
```

## Test Components

### 1. HTTP Header Manager
```
Content-Type: application/json
Accept: application/json
```

### 2. HTTP Requests
- Start Process
  ```
  POST /engine-rest/process-definition/key/loan_application_process/start
  ```
- Get Task
  ```
  GET /engine-rest/task?processInstanceId=${processInstanceId}
  ```
- Complete Task
  ```
  POST /engine-rest/task/${taskId}/complete
  ```

### 3. JSON Extractors
- Process Instance ID
- Task ID

## Test Data

### Variables
```json
{
  "applicantName": "Test User ${__Random(1000,9999)}",
  "loanAmount": ${__Random(10000,100000)},
  "email": "test${__Random(1000,9999)}@example.com",
  "employmentStatus": "employed"
}
```

## Listeners & Reports

### 1. View Results Tree
- Real-time results
- Response data
- Request headers
- Response codes

### 2. Summary Report
- Average response time
- Error rate
- Throughput
- KB/sec

### 3. Aggregate Report
- Median
- 90% line
- 95% line
- 99% line

## Performance Monitoring

### 1. Backend Listener
```xml
<BackendListener>
  <classname>org.apache.jmeter.visualizers.backend.influxdb.InfluxdbBackendListenerClient</classname>
  <arguments>
    <argument>influxdb://localhost:8086/jmeter</argument>
  </arguments>
</BackendListener>
```

### 2. System Resource Monitoring
- CPU Usage
- Memory Usage
- Network I/O
- Disk I/O

## Results Analysis

### 1. Generate HTML Report
```bash
jmeter -n -t loan-process-test.jmx -l results.jtl -e -o ./report
```

### 2. Key Metrics
- Response Times
  - Average
  - Percentiles
  - Distribution
- Throughput
  - Requests/sec
  - Bytes/sec
- Errors
  - Error %
  - Error types

## Troubleshooting

### Common Issues
1. Memory Issues
   ```bash
   # Increase JMeter memory
   set HEAP=-Xms1g -Xmx2g
   ```

2. Connection Issues
   - Check firewall settings
   - Verify proxy settings
   - Test endpoint availability

### Debug Logging
```bash
# Enable debug logging
jmeter -L DEBUG -t loan-process-test.jmx
```

## Best Practices

### 1. Test Design
- Use thread groups appropriately
- Include think times
- Handle correlation properly
- Use assertions

### 2. Execution
- Run in non-GUI mode
- Monitor resource usage
- Save raw results
- Generate reports

### 3. Analysis
- Review all error logs
- Check response times
- Analyze throughput
- Compare with baselines

## Next Steps
1. Add more complex scenarios
2. Create custom listeners
3. Implement distributed testing
4. Automate report generation
5. CI/CD integration