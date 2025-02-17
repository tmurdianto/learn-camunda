# Camunda 7 Benchmark Tests

This directory contains benchmark tests for Camunda 7 using k6 and JMeter. The tests focus on the loan application process, which is typically the most resource-intensive due to its complex workflow and service task integrations.

## Test Scenarios

### Loan Application Process
The benchmark tests simulate the complete loan application workflow:
1. Start process instance with applicant data
2. Perform credit check (service task)
3. Complete user tasks
4. Process completion

## Tools

### 1. k6 Tests
Located in `/k6` directory:
- Modern, developer-centric performance testing tool
- JavaScript-based test scripts
- Excellent metrics and reporting
- Easy to integrate with CI/CD

#### Running k6 Tests
```bash
# Install k6
winget install k6

# Run the test
k6 run k6/loan-process-test.js
```

#### Test Configurations
- Ramp-up: 2 minutes to 10 users
- Sustained load: 5 minutes at 50 users
- High load: 2 minutes at 100 users
- Ramp-down: 1 minute to 0

### 2. JMeter Tests
Located in `/jmeter` directory:
- Traditional, comprehensive testing tool
- GUI-based test creation
- Extensive reporting capabilities
- Wide range of plugins available

#### Running JMeter Tests
```bash
# Run in GUI mode (for test development)
jmeter -t jmeter/loan-process-test.jmx

# Run in non-GUI mode (for actual testing)
jmeter -n -t jmeter/loan-process-test.jmx -l results.jtl
```

#### Test Configurations
- Number of Threads: 50
- Ramp-up Period: 300 seconds
- Test Duration: 1800 seconds (30 minutes)

## Metrics Collected

### Performance Metrics
1. Response Times
   - Average response time
   - 95th percentile
   - 99th percentile

2. Throughput
   - Requests per second
   - Process instances started
   - Tasks completed

3. Error Rates
   - Failed requests
   - Process errors
   - Task failures

### Resource Usage
1. System Metrics
   - CPU usage
   - Memory consumption
   - Disk I/O
   - Network traffic

2. Database Metrics
   - Connection pool usage
   - Query response times
   - Transaction throughput

## Best Practices

### 1. Test Environment
- Use production-like environment
- Clean database before tests
- Monitor resource usage
- Isolate test environment

### 2. Test Execution
- Start with low load
- Gradually increase load
- Monitor for errors
- Collect all metrics

### 3. Analysis
- Compare with baselines
- Identify bottlenecks
- Check error patterns
- Review resource usage

## Troubleshooting

### Common Issues
1. Connection Timeouts
   - Check network settings
   - Verify service availability
   - Review connection pools

2. Database Bottlenecks
   - Monitor query performance
   - Check connection pools
   - Optimize indexes

3. Memory Issues
   - Review JVM settings
   - Check for memory leaks
   - Monitor GC activity

## Results Analysis

### Performance Targets
1. Response Times
   - Process Start: < 500ms
   - Task Completion: < 1s
   - Service Tasks: < 2s

2. Throughput
   - Sustained: 50 processes/minute
   - Peak: 100 processes/minute

3. Error Rates
   - < 1% error rate
   - Zero critical failures

### Reporting
Generate comprehensive reports including:
1. Summary statistics
2. Detailed metrics
3. Error analysis
4. Resource usage patterns

## Next Steps
1. Add more complex scenarios
2. Implement continuous testing
3. Create custom metrics
4. Automate analysis