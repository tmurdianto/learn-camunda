# Development Environment Benchmarks

## Overview
This guide covers running benchmarks in the development environment, which is optimized for:
- Test script development
- Quick validations
- CI/CD pipeline tests
- Local development

## Environment Features
- H2 in-memory database
- Lightweight configurations
- Quick startup time
- Lower resource requirements

## Setup Instructions

### 1. Start Camunda
```bash
cd resources
docker-compose -f docker-compose.dev.yml up -d

# Verify Camunda is running
docker-compose -f docker-compose.dev.yml ps
docker-compose -f docker-compose.dev.yml logs -f camunda
```

### 2. Start Benchmark Infrastructure
```bash
cd ../resources/benchmarks
docker-compose -f docker-compose.benchmark.dev.yml up -d
```

## Resource Configuration

### Container Limits
- **k6**: 1GB memory
- **JMeter**: 1GB memory
- **InfluxDB**: 1GB memory
- **Grafana**: 512MB memory

### Test Parameters
```bash
# k6
K6_ITERATIONS=10
K6_VUS=5
K6_DURATION=5m

# JMeter
JMETER_THREADS=5
JMETER_RAMPUP=60
JMETER_DURATION=300
```

## Running Tests

### Standalone Tests

#### k6
```bash
k6 run -e CAMUNDA_URL=http://localhost:8080 k6/loan-process-test.js
```

#### JMeter
```bash
jmeter -n -t jmeter/loan-process-test.jmx -l results.jtl -JCAMUNDA_URL=http://localhost:8080
```

### Docker-based Tests
```bash
cd resources/benchmarks
./run-benchmarks-dev.sh
```

## Access Points
- Camunda: http://localhost:8080
- Grafana: http://localhost:3000
  - k6 Dashboard: http://localhost:3000/d/k6-performance
  - JMeter Dashboard: http://localhost:3000/d/jmeter-performance
- JMeter Reports: `./jmeter/results/report`

## Performance Targets

### Response Times
- Process Start: < 1s
- Task Completion: < 2s
- Service Tasks: < 3s

### Throughput
- Sustained: 10 processes/minute
- Peak: 20 processes/minute

### Error Rates
- < 1% error rate
- Zero critical failures

## Troubleshooting

### Check Services
```bash
# Camunda
docker-compose -f docker-compose.dev.yml ps
docker-compose -f docker-compose.dev.yml logs camunda

# Benchmark Infrastructure
docker-compose -f docker-compose.benchmark.dev.yml ps
docker-compose -f docker-compose.benchmark.dev.yml logs
```

### Common Issues
1. **Connection Refused**
   - Verify Camunda is running
   - Check if ports are available
   - Ensure no firewall blocking

2. **Out of Memory**
   - Check container stats: `docker stats`
   - Reduce test parameters
   - Clear Docker cache

3. **Slow Response Times**
   - Check CPU usage
   - Monitor memory usage
   - Verify no other resource-intensive processes
