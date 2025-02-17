#!/bin/bash

# Configuration
DOCKER_COMPOSE="docker-compose -f docker-compose.benchmark.dev.yml"
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
    local max_attempts=15
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if docker-compose -f docker-compose.benchmark.dev.yml ps | grep $service | grep -q "healthy"; then
            return 0
        fi
        print_status "$YELLOW" "Waiting for $service to be healthy... (Attempt $attempt/$max_attempts)"
        sleep 5
        ((attempt++))
    done
    return 1
}

# Validate connections first
print_status "$YELLOW" "Validating connections..."
if ! ./validate-connection.sh dev; then
    print_status "$RED" "Connection validation failed. Please fix the issues and try again."
    exit 1
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

# Run k6 tests with development configuration
print_status "$GREEN" "Starting k6 tests..."
$DOCKER_COMPOSE run k6

# Run JMeter tests with development configuration
print_status "$GREEN" "Starting JMeter tests..."
$DOCKER_COMPOSE run --rm jmeter -n \
    -t /jmeter/loan-process-test.jmx \
    -l /results/results.jtl \
    -e -o /results/report

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
