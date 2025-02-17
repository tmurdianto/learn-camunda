# Docker Environment Guide for Camunda 7

## Docker Compose Setup

### Environment Components
```yaml
services:
  camunda:      # Camunda BPM Platform
  db:           # PostgreSQL Database
  adminer:      # Database Management
```

### Configuration Details

1. **Camunda Platform (camunda)**
   ```yaml
   image: camunda/camunda-bpm-platform:7.19.0-tomcat
   ports:
     - "8080:8080"    # Web interface
   environment:
     - DB_DRIVER=org.postgresql.Driver
     - DB_URL=jdbc:postgresql://db:5432/camunda
     - DB_USERNAME=camunda
     - DB_PASSWORD=camunda
   ```

2. **PostgreSQL Database (db)**
   ```yaml
   image: postgres:13
   environment:
     - POSTGRES_USER=camunda
     - POSTGRES_PASSWORD=camunda
     - POSTGRES_DB=camunda
   volumes:
     - pg_data:/var/lib/postgresql/data  # Persistent storage
   ```

3. **Adminer (adminer)**
   ```yaml
   image: adminer
   ports:
     - "8081:8080"    # Web interface
   ```

## Management Commands

### Starting the Environment
```bash
docker-compose up -d
```

### Checking Status
```bash
docker-compose ps
```

### Viewing Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs camunda
```

### Stopping the Environment
```bash
docker-compose down
```

### Cleaning Up
```bash
# Remove containers and networks
docker-compose down

# Remove containers, networks, and volumes
docker-compose down -v
```

## Troubleshooting

### Common Issues
1. **Port Conflicts**
   - Error: "port is already allocated"
   - Solution: Change ports in docker-compose.yml or stop conflicting services

2. **Database Connection**
   - Check if PostgreSQL is running: `docker-compose ps`
   - Verify connection details in Adminer
   - Check Camunda logs: `docker-compose logs camunda`

3. **Performance Issues**
   - Increase Docker resources (CPU/Memory)
   - Monitor container stats: `docker stats`

## Data Persistence
- Database data is stored in `pg_data` volume
- Volume persists across container restarts
- Back up volume data regularly
