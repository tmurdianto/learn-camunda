# Camunda 7 Benchmark Tests

This directory contains benchmark tests for Camunda 7 using k6 and JMeter. The tests focus on the loan application process, which is typically the most resource-intensive due to its complex workflow and service task integrations.

## Prerequisites

### Required Tools
- Docker and Docker Compose
- k6 (for standalone tests)
- JMeter (for standalone tests)
- Git Bash (for Windows users)
- Camunda Modeler (for viewing/editing BPMN)

### Process Deployment

Before running the benchmarks, you need to deploy the loan application process:

1. **Using REST API**:
```bash
# For Development Environment
curl -X POST -F "deployment-name=loan-application" \
     -F "deploy-changed-only=true" \
     -F "loan_application_process.bpmn=@processes/loan_application_process.bpmn" \
     http://localhost:8080/engine-rest/deployment/create

# For Production Environment
curl -X POST -F "deployment-name=loan-application" \
     -F "deploy-changed-only=true" \
     -F "loan_application_process.bpmn=@processes/loan_application_process.bpmn" \
     http://localhost:8081/engine-rest/deployment/create
```

2. **Using Camunda Modeler**:
   - Open `processes/loan_application_process.bpmn` in Camunda Modeler
   - Click "Deploy" button
   - Configure deployment:
     - REST Endpoint: 
       - Development: `http://localhost:8080/engine-rest`
       - Production: `http://localhost:8081/engine-rest`
     - Deployment Name: `loan-application`

3. **Verify Deployment**:
   - Open Camunda Cockpit
     - Development: `http://localhost:8080/camunda/app/cockpit`
     - Production: `http://localhost:8081/camunda/app/cockpit`
   - Navigate to Processes
   - Verify "Loan Application Process" is listed

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

## Directory Structure
```
benchmarks/
├── environments/
│   ├── development/
│   │   └── README.md
│   └── production/
│       └── README.md
├── processes/
│   └── loan_application_process.bpmn
├── k6/
│   ├── loan-process-test.js
│   └── README.md
├── jmeter/
│   ├── loan-process-test.jmx
│   └── README.md
└── README.md
```

## Getting Started

1. **Deploy Process**:
   - Follow the process deployment steps above
   - Verify deployment in Camunda Cockpit

2. **Validate Environment**:
```bash
cd resources/benchmarks
./validate-connection.sh dev  # or prod for production
```

3. **Run Benchmarks**:
```bash
# Development Environment
./run-benchmarks-dev.sh

# Production Environment
./run-benchmarks-prod.sh
```

4. **View Results**:
   - k6: Grafana Dashboard (http://localhost:3000)
   - JMeter: `./jmeter/results/report`

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