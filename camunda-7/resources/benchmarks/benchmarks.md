# Camunda 7 Benchmark Infrastructure

## Overview
This directory contains the infrastructure setup for running performance benchmarks on Camunda 7 using k6 and JMeter. The setup includes a monitoring stack with InfluxDB and Grafana for real-time metrics visualization.

## Architecture

```
                                     ┌─────────────┐
                                     │   Grafana   │
                                     │  Dashboard  │
                                     └──────┬──────┘
                                            │
                                     ┌──────┴──────┐
                                     │  InfluxDB   │
                                     │   Metrics   │
                                     └──────┬──────┘
                                            │
                              ┌─────────────┴─────────────┐
                              │                           │
                         ┌────┴────┐               ┌──────┴─────┐
                         │   k6    │               │  JMeter    │
                         │  Tests  │               │   Tests    │
                         └────┬────┘               └──────┬─────┘
                              │                           │
                              └─────────────┬─────────────┘
                                           │
                                    ┌──────┴──────┐
                                    │  Camunda 7  │
                                    │  Platform   │
                                    └─────────────┘
```

## Components

### 1. Monitoring Stack
- **InfluxDB**: Time-series database for metrics
  - Port: 8086
  - Database: k6

- **Grafana**: Metrics visualization
  - Port: 3000
  - Anonymous access enabled
  - Pre-configured dashboards

### 2. Load Generators
- **k6**:
  - Modern performance testing
  - JavaScript-based tests
  - Real-time metrics

- **JMeter**:
  - Traditional load testing
  - Comprehensive test plans
  - Detailed reports

## Directory Structure
```
benchmarks/
├── docker-compose.benchmark.yml
├── run-benchmarks.sh
├── grafana/
│   ├── dashboards/
│   └── provisioning/
└── jmeter/
    └── results/
```

## Running Benchmarks

### Prerequisites
1. Docker and Docker Compose
2. Bash shell (Git Bash on Windows)
3. Running Camunda instance

### Quick Start
```bash
# Make script executable
chmod +x run-benchmarks.sh

# Run benchmarks
./run-benchmarks.sh
```

### Manual Execution

1. Start monitoring stack:
```bash
docker-compose -f docker-compose.benchmark.yml up -d influxdb grafana
```

2. Run k6 tests:
```bash
docker-compose -f docker-compose.benchmark.yml run k6
```

3. Run JMeter tests:
```bash
docker-compose -f docker-compose.benchmark.yml run jmeter
```

## Configuration

### k6 Settings
```yaml
k6:
  environment:
    - K6_OUT=influxdb=http://influxdb:8086/k6
```

### JMeter Settings
```yaml
jmeter:
  environment:
    - HEAP=-Xms1g -Xmx2g
```

## Monitoring

### Grafana Dashboards
1. k6 Performance Metrics
   - URL: http://localhost:3000/d/k6
   - Metrics:
     - VUs
     - Request Rate
     - Response Times
     - Error Rate

2. JMeter Results
   - URL: http://localhost:3000/d/jmeter
   - Metrics:
     - Throughput
     - Response Times
     - Errors
     - Active Threads

### Results Location
- k6: Grafana Dashboard
- JMeter: `./jmeter/results/report`

## Best Practices

### 1. Test Execution
- Start with low load
- Monitor resource usage
- Check error rates
- Save test results

### 2. Resource Management
- Monitor container health
- Check disk space
- Watch memory usage
- Clean up old results

### 3. Analysis
- Compare with baselines
- Check all metrics
- Review error logs
- Document findings

## Troubleshooting

### Common Issues
1. Container Health
```bash
docker-compose -f docker-compose.benchmark.yml ps
```

2. View Logs
```bash
docker-compose -f docker-compose.benchmark.yml logs -f
```

3. Resource Issues
```bash
# Check disk space
df -h

# Check container stats
docker stats
```

## Next Steps
1. Add more test scenarios
2. Create custom dashboards
3. Implement alerting
4. Automate cleanup
5. Add CI/CD integration
