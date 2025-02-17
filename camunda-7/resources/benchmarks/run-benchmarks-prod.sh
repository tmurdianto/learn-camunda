#!/bin/bash

# Configuration
DOCKER_COMPOSE="docker-compose -f docker-compose.benchmark.prod.yml"

# Environment Variables
export JMETER_INFLUXDB_HOST=influxdb
export JMETER_INFLUXDB_PORT=8086
export JMETER_INFLUXDB_DB=k6
export JMETER_INFLUXDB_USER=admin
export JMETER_INFLUXDB_PASSWORD=admin123

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
    local max_attempts=30  # Increased for production
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if docker-compose -f docker-compose.benchmark.prod.yml ps | grep $service | grep -q "healthy"; then
            return 0
        fi
        print_status "$YELLOW" "Waiting for $service to be healthy... (Attempt $attempt/$max_attempts)"
        sleep 10  # Increased wait time for production
        ((attempt++))
    done
    return 1
}

# Function to check resource availability
check_resources() {
    local required_memory=16  # GB, for both k6 and JMeter
    local available_memory=$(free -g | awk '/^Mem:/{print $7}')
    
    if [ $available_memory -lt $required_memory ]; then
        print_status "$RED" "Warning: Available memory ($available_memory GB) is less than recommended ($required_memory GB)"
        read -p "Do you want to continue anyway? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Check resources before starting
print_status "$YELLOW" "Checking system resources..."
check_resources

# Validate connections first
print_status "$YELLOW" "Validating connections..."
if ! ./validate-connection.sh prod; then
    print_status "$RED" "Connection validation failed. Please fix the issues and try again."
    exit 1
fi

# Start monitoring stack
print_status "$GREEN" "Starting monitoring stack..."
$DOCKER_COMPOSE up -d influxdb grafana

# Check health of monitoring services
if ! check_health "influxdb" || ! check_health "grafana"; then
    print_status "$RED" "Failed to start monitoring stack"
    exit 1
fi

print_status "$GREEN" "Monitoring stack is ready"

# Warm-up period
print_status "$YELLOW" "Waiting for 30 seconds warm-up period..."
sleep 30

# Run k6 tests with production configuration
print_status "$GREEN" "Starting k6 tests..."
print_status "$YELLOW" "This will take approximately 30 minutes..."
$DOCKER_COMPOSE run k6

# Short pause between tests
print_status "$YELLOW" "Waiting 1 minute before starting JMeter test..."
sleep 60

# Run JMeter tests with production configuration
print_status "$GREEN" "Starting JMeter tests..."
print_status "$YELLOW" "This will take approximately 30 minutes..."
$DOCKER_COMPOSE run --rm jmeter

print_status "$GREEN" "Benchmarks completed!"
print_status "$GREEN" "Results available in Grafana Dashboard (http://localhost:3000)"
print_status "$YELLOW" "Note: Production metrics will be preserved in InfluxDB volume"

# Optional: Stop services
read -p "Do you want to stop the monitoring stack? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "$YELLOW" "Stopping monitoring stack..."
    print_status "$RED" "Warning: This will preserve the InfluxDB data volume"
    read -p "Do you also want to remove all data volumes? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $DOCKER_COMPOSE down -v
        print_status "$YELLOW" "All services and volumes removed"
    else
        $DOCKER_COMPOSE down
        print_status "$YELLOW" "Services stopped, data volumes preserved"
    fi
fi
