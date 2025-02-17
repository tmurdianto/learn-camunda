#!/bin/bash

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

# Function to check if a URL is accessible
check_url() {
    local url=$1
    local max_attempts=$2
    local attempt=1
    local wait_time=5

    print_status "$YELLOW" "Checking connection to $url..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s -f "$url/engine-rest/version" > /dev/null; then
            print_status "$GREEN" "✓ Successfully connected to Camunda at $url"
            return 0
        fi
        print_status "$YELLOW" "Attempt $attempt/$max_attempts: Cannot connect to $url. Waiting ${wait_time}s..."
        sleep $wait_time
        ((attempt++))
    done
    
    print_status "$RED" "✗ Failed to connect to $url after $max_attempts attempts"
    return 1
}

# Function to check Docker network
check_docker_network() {
    local network=$1
    
    print_status "$YELLOW" "Checking Docker network '$network'..."
    
    if docker network inspect "$network" >/dev/null 2>&1; then
        print_status "$GREEN" "✓ Docker network '$network' exists"
        return 0
    else
        print_status "$RED" "✗ Docker network '$network' does not exist"
        return 1
    fi
}

# Function to check if Docker host.docker.internal is accessible
check_host_docker_internal() {
    print_status "$YELLOW" "Checking host.docker.internal resolution..."
    
    docker run --rm alpine ping -c 1 host.docker.internal >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_status "$GREEN" "✓ host.docker.internal is accessible"
        return 0
    else
        print_status "$RED" "✗ host.docker.internal is not accessible"
        return 1
    fi
}

# Main validation logic
main() {
    local env=$1
    local camunda_url
    local compose_file
    local max_attempts=12  # 1 minute total (5s * 12)
    local exit_code=0

    if [ "$env" == "dev" ]; then
        camunda_url="http://host.docker.internal:8080"
        compose_file="docker-compose.benchmark.dev.yml"
    elif [ "$env" == "prod" ]; then
        camunda_url="http://host.docker.internal:8081"
        compose_file="docker-compose.benchmark.prod.yml"
    else
        print_status "$RED" "Invalid environment. Use 'dev' or 'prod'"
        exit 1
    fi

    print_status "$YELLOW" "Starting connection validation for $env environment..."
    echo

    # Check Docker network
    if ! check_docker_network "benchmark-network"; then
        print_status "$YELLOW" "Creating Docker network 'benchmark-network'..."
        docker network create benchmark-network
    fi

    # Check host.docker.internal
    if ! check_host_docker_internal; then
        print_status "$RED" "Please ensure your Docker installation supports host.docker.internal"
        exit_code=1
    fi

    # Check Camunda connection
    if ! check_url "$camunda_url" "$max_attempts"; then
        print_status "$RED" "Please ensure Camunda is running and accessible at $camunda_url"
        exit_code=1
    fi

    echo
    if [ $exit_code -eq 0 ]; then
        print_status "$GREEN" "✓ All connection checks passed! You can now run the benchmarks."
    else
        print_status "$RED" "✗ Some connection checks failed. Please fix the issues before running benchmarks."
    fi

    return $exit_code
}

# Check if environment argument is provided
if [ -z "$1" ]; then
    print_status "$RED" "Please specify environment: dev or prod"
    exit 1
fi

main "$1"
