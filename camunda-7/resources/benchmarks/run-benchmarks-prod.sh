#!/bin/bash

# Configuration
DOCKER_COMPOSE="docker-compose -f docker-compose.benchmark.prod.yml"
RESULTS_DIR="./jmeter/results"
REPORT_DIR="./jmeter/report"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if a service is healthy
check_health() {
    local service=$1
    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if docker-compose -f docker-compose.benchmark.prod.yml ps | grep $service | grep -q "healthy"; then
            return 0
        fi
        print_status "$YELLOW" "Waiting for $service to be healthy... (Attempt $attempt/$max_attempts)"
        sleep 5
        ((attempt++))
    done
    return 1
}

# Function to check system resources
check_resources() {
    print_status "$YELLOW" "Checking system resources..."
    
    # Check available memory
    local available_mem=$(free -g | awk '/^Mem:/{print $7}')
    if [ $available_mem -lt 8 ]; then
        print_status "$RED" "Warning: Less than 8GB of available memory ($available_mem GB)"
        print_status "$RED" "Production benchmarks require at least 8GB of available memory"
        return 1
    fi

    # Check available disk space
    local available_disk=$(df -BG . | awk 'NR==2 {print $4}' | sed 's/G//')
    if [ $available_disk -lt 20 ]; then
        print_status "$RED" "Warning: Less than 20GB of available disk space ($available_disk GB)"
        print_status "$RED" "Production benchmarks require at least 20GB of free disk space"
        return 1
    fi

    return 0
}

# Check system resources
if ! check_resources; then
    read -p "Continue despite resource warnings? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create results directory
mkdir -p $RESULTS_DIR $REPORT_DIR

# Start monitoring stack
print_status "$GREEN" "Starting monitoring stack..."
$DOCKER_COMPOSE up -d influxdb grafana

# Check health of monitoring services
if ! check_health "influxdb" || ! check_health "grafana"; then
    print_status "$RED" "Failed to start monitoring stack"
    exit 1
fi

print_status "$GREEN" "Monitoring stack is ready"

# Run k6 tests with production configuration
print_status "$GREEN" "Starting k6 tests..."
$DOCKER_COMPOSE run k6

# Run JMeter tests with production configuration
print_status "$GREEN" "Starting JMeter tests..."
$DOCKER_COMPOSE run --rm jmeter -n \
    -t /jmeter/loan-process-test.jmx \
    -l /results/results.jtl \
    -e -o /results/report

# Generate combined report
print_status "$GREEN" "Generating combined report..."
$DOCKER_COMPOSE run --rm jmeter -g /results/results.jtl -o /results/report

print_status "$GREEN" "Benchmarks completed!"
print_status "$GREEN" "Results available in:"
print_status "$GREEN" "- k6: Grafana Dashboard (http://localhost:3000)"
print_status "$GREEN" "- JMeter: ./jmeter/results/report"

# Optional: Stop services
read -p "Do you want to stop the monitoring stack? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "$YELLOW" "Stopping monitoring stack..."
    $DOCKER_COMPOSE down -v
fi
