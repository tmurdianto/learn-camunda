# Production Environment Benchmarks

## Overview
This guide covers running benchmarks in the production environment, which is designed for:
- Performance testing
- Load testing
- Stress testing
- Capacity planning

## Environment Features
- PostgreSQL database
- Elasticsearch for history
- Prometheus & Grafana monitoring
- Production-grade configurations

## Setup Instructions

### 1. Start Camunda
```bash
cd resources
docker-compose -f docker-compose.prod.yml up -d

# Verify Camunda is running
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs -f camunda
```

### 2. Start Benchmark Infrastructure
```bash
cd ../resources/benchmarks
docker-compose -f docker-compose.benchmark.prod.yml up -d
```

## Resource Configuration

### Container Limits
- **k6**: 4GB memory
- **JMeter**: 4GB memory
- **InfluxDB**: 2GB memory
- **Grafana**: 1GB memory

### Test Parameters
```bash
# k6
K6_ITERATIONS=1000
K6_VUS=50
K6_DURATION=30m

# JMeter
JMETER_THREADS=50
JMETER_RAMPUP=300
JMETER_DURATION=1800
```

## Running Tests

### Standalone Tests

#### k6
```bash
k6 run -e CAMUNDA_URL=http://localhost:8081 k6/loan-process-test.js
```

#### JMeter
```bash
jmeter -n -t jmeter/loan-process-test.jmx -l results.jtl -JCAMUNDA_URL=http://localhost:8081
```

### Docker-based Tests
```bash
cd resources/benchmarks
./run-benchmarks-prod.sh
```

## Access Points
- Camunda: http://localhost:8081
- Grafana: http://localhost:3000
  - k6 Dashboard: http://localhost:3000/d/k6-performance
  - JMeter Dashboard: http://localhost:3000/d/jmeter-performance
- JMeter Reports: `./jmeter/results/report`
- Prometheus: http://localhost:9090
- Elasticsearch: http://localhost:9200

## Performance Targets

### Response Times
- Process Start: < 500ms
- Task Completion: < 1s
- Service Tasks: < 2s

### Throughput
- Sustained: 50 processes/minute
- Peak: 100 processes/minute

### Error Rates
- < 1% error rate
- Zero critical failures

## Monitoring

### Metrics Collection
1. **Application Metrics**
   - Process instance count
   - Task completion rate
   - Service task duration
   - Error rates

2. **System Metrics**
   - CPU usage
   - Memory consumption
   - Disk I/O
   - Network traffic

3. **Database Metrics**
   - Query performance
   - Connection pool usage
   - Transaction throughput
   - Index performance

### Dashboards
1. **Grafana**
   - Load test metrics
   - System resources
   - Database performance
   - Error tracking

2. **Prometheus**
   - Raw metrics
   - Alert rules
   - Query interface

## Troubleshooting

### Check Services
```bash
# Camunda and Supporting Services
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs camunda
docker-compose -f docker-compose.prod.yml logs postgres
docker-compose -f docker-compose.prod.yml logs elasticsearch

# Benchmark Infrastructure
docker-compose -f docker-compose.benchmark.prod.yml ps
docker-compose -f docker-compose.benchmark.prod.yml logs
```

### Common Issues
1. **Database Performance**
   - Check PostgreSQL logs
   - Monitor connection pool
   - Review query performance
   - Check index usage

2. **Memory Issues**
   - Monitor container stats: `docker stats`
   - Check JVM heap usage
   - Review GC logs
   - Adjust memory limits

3. **Network Issues**
   - Check service connectivity
   - Monitor network latency
   - Review firewall rules
   - Check DNS resolution

4. **Elasticsearch Issues**
   - Check cluster health
   - Monitor index size
   - Review shard allocation
   - Check disk usage
