# Camunda 7 Benchmark Tests

This directory contains benchmark tests for Camunda 7 using k6 and JMeter. The tests focus on the loan application process, which is typically the most resource-intensive due to its complex workflow and service task integrations.

## Test Scenarios

### Loan Application Process
The benchmark tests simulate the complete loan application workflow:
1. Start process instance with applicant data
2. Perform credit check (service task)
3. Complete user tasks
4. Process completion

## Environment Options

We provide two distinct environments for benchmarking:

### [Development Environment](environments/development/README.md)
- Quick iterations and validations
- Lightweight configuration
- H2 in-memory database
- Suitable for test development

### [Production Environment](environments/production/README.md)
- Full performance testing
- Production-grade configuration
- PostgreSQL and Elasticsearch
- Suitable for benchmarking

## Tools

### 1. k6
- Modern, developer-centric performance testing tool
- JavaScript-based test scripts
- Real-time metrics
- Cloud integration

### 2. JMeter
- Traditional load testing tool
- Comprehensive test plans
- Detailed reporting
- Rich plugin ecosystem

## Metrics Collection

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

## Directory Structure
```
benchmarks/
├── environments/
│   ├── development/
│   │   └── README.md
│   └── production/
│       └── README.md
├── k6/
│   ├── loan-process-test.js
│   └── README.md
├── jmeter/
│   ├── loan-process-test.jmx
│   └── README.md
└── README.md
```

## Getting Started

1. Choose your environment:
   - [Development Environment Guide](environments/development/README.md)
   - [Production Environment Guide](environments/production/README.md)

2. Follow the environment-specific setup instructions

3. Run the benchmarks using provided scripts

4. Monitor and analyze results

## Contributing

### Adding New Tests
1. Create test scripts in appropriate tool directory
2. Update environment configurations
3. Test in development first
4. Document changes

### Best Practices
1. Start with development environment
2. Validate test scripts
3. Use production for actual benchmarks
4. Document findings

## Support

### Documentation
- Tool-specific documentation in respective directories
- Environment guides in `environments/`
- Infrastructure details in `resources/benchmarks/`

### Issues
Report issues with:
1. Environment used
2. Steps to reproduce
3. Expected vs actual results
4. Relevant logs