# k6 Performance Tests for Camunda 7

## Overview
This directory contains k6 performance tests for Camunda 7, focusing on the loan application process. k6 is chosen for its modern approach to performance testing and excellent developer experience.

## Test Scripts

### loan-process-test.js
Tests the complete loan application workflow:
1. Start process instance
2. Complete credit check task
3. Monitor process completion

## Prerequisites
1. Install k6:
```bash
winget install k6
```

2. Ensure Camunda is running:
```bash
cd ../../resources
docker-compose -f docker-compose.prod.yml up -d
```

## Running Tests

### Basic Test Run
```bash
k6 run loan-process-test.js
```

### With Custom Options
```bash
# Run with different VUs and duration
k6 run --vus 20 --duration 30m loan-process-test.js

# Run with output
k6 run --out json=results.json loan-process-test.js
```

## Test Configuration

### Load Stages
1. **Warm-up Phase**
   - Duration: 2 minutes
   - Users: Ramp to 10
   - Purpose: System warm-up

2. **Sustained Load**
   - Duration: 5 minutes
   - Users: 50
   - Purpose: Normal operation

3. **Peak Load**
   - Duration: 2 minutes
   - Users: 100
   - Purpose: Stress testing

4. **Cool-down**
   - Duration: 1 minute
   - Users: Ramp down to 0
   - Purpose: Graceful completion

### Thresholds
```javascript
thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% under 2s
    http_req_failed: ['rate<0.01'],    // Less than 1% failures
}
```

## Custom Metrics

### Process Metrics
1. `process_instances_started`
   - Type: Counter
   - Tracks successful process starts

2. `tasks_completed`
   - Type: Counter
   - Tracks completed tasks

## Test Data

### Generated Data
```javascript
{
    applicantName: `Test User ${Math.random()}`,
    loanAmount: Math.floor(Math.random() * 100000) + 10000,
    email: `test${Math.random()}@example.com`,
    employmentStatus: 'employed'
}
```

## Analysis

### Performance Targets
1. Response Times
   - Process Start: < 500ms
   - Task Completion: < 1s

2. Success Rates
   - Process Start: > 99%
   - Task Completion: > 99%

### Viewing Results
1. Console Output
   ```bash
   k6 run --console-output=results.txt loan-process-test.js
   ```

2. JSON Output
   ```bash
   k6 run --out json=results.json loan-process-test.js
   ```

3. Grafana Dashboard
   ```bash
   k6 run --out influxdb=http://localhost:8086/k6 loan-process-test.js
   ```

## Troubleshooting

### Common Issues
1. Connection Errors
   - Check Camunda is running
   - Verify network settings
   - Check resource limits

2. High Response Times
   - Monitor system resources
   - Check database performance
   - Review concurrent users

### Debug Mode
```bash
K6_DEBUG=true k6 run loan-process-test.js
```

## Best Practices

### 1. Test Execution
- Run tests from stable environment
- Clean state before each run
- Monitor system resources
- Collect all relevant metrics

### 2. Test Maintenance
- Regular script updates
- Version control
- Document changes
- Review thresholds

### 3. Result Analysis
- Compare with baselines
- Look for patterns
- Document findings
- Update thresholds

## Next Steps
1. Add more complex scenarios
2. Implement continuous testing
3. Create custom metrics
4. Automate analysis
5. Integration with CI/CD