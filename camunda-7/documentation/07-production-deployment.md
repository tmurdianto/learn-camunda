# Production Deployment Guide

## Production Architecture

### Components
```
                                   ┌─────────────┐
                                   │   Nginx     │
                                   │   Proxy     │
                                   └─────┬───────┘
                                         │
                 ┌─────────────┬─────────┴────────┬─────────────┐
                 │             │                   │             │
        ┌────────┴───────┐ ┌───┴───┐      ┌──────┴─────┐  ┌────┴─────┐
        │    Camunda     │ │ Kibana│      │ Prometheus │  │ Grafana  │
        │    Platform    │ └───────┘      └────────────┘  └──────────┘
        └────────┬───────┘
                 │
        ┌────────┴───────┐
        │   PostgreSQL   │
        └────────┬───────┘
                 │
        ┌────────┴───────┐
        │ Elasticsearch  │
        └────────────────┘
```

## Production Docker Setup

### 1. Environment Configuration
```bash
# .env file
POSTGRES_USER=camunda
POSTGRES_PASSWORD=your-secure-password
CAMUNDA_ADMIN_USER=admin
CAMUNDA_ADMIN_PASSWORD=your-admin-password
ELASTIC_PASSWORD=your-elastic-password
```

### 2. Docker Compose Structure
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  # Reverse Proxy
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/conf:/etc/nginx/conf.d
      - ./nginx/certs:/etc/nginx/certs
    depends_on:
      - camunda

  # Process Engine
  camunda:
    image: camunda/camunda-bpm-platform:7.20.0
    environment:
      - DB_DRIVER=org.postgresql.Driver
      - DB_URL=jdbc:postgresql://db:5432/camunda
      - DB_USERNAME=${POSTGRES_USER}
      - DB_PASSWORD=${POSTGRES_PASSWORD}
      - WAIT_FOR=db:5432
      - TZ=Asia/Jakarta
      - JAVA_OPTS=-Xmx2g -Xms512m -XX:+UseG1GC
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8080/camunda/actuator/health"]
      interval: 30s
      timeout: 5s
      retries: 3

  # Database
  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=camunda
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Monitoring
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=true
      - ELASTIC_PASSWORD=${ELASTIC_PASSWORD}
    volumes:
      - elastic_data:/usr/share/elasticsearch/data
    healthcheck:
      test: ["CMD-SHELL", "curl -s http://localhost:9200/_cluster/health"]

  kibana:
    image: docker.elastic.co/kibana/kibana:7.17.0
    depends_on:
      - elasticsearch
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus:/etc/prometheus
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  grafana:
    image: grafana/grafana:latest
    depends_on:
      - prometheus
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana

volumes:
  postgres_data:
  elastic_data:
  prometheus_data:
  grafana_data:
```

## Security Configurations

### 1. Nginx SSL Setup
```nginx
# /nginx/conf/camunda.conf
server {
    listen 443 ssl;
    server_name your-domain.com;

    ssl_certificate /etc/nginx/certs/your-domain.crt;
    ssl_certificate_key /etc/nginx/certs/your-domain.key;

    location / {
        proxy_pass http://camunda:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 2. Database Security
- Strong passwords
- Limited access
- Regular backups
- SSL connections

### 3. Monitoring Security
- Protected endpoints
- Authentication required
- Encrypted communications

## Performance Optimization

### 1. JVM Settings
```yaml
JAVA_OPTS: >
  -Xmx2g
  -Xms512m
  -XX:+UseG1GC
  -XX:MaxGCPauseMillis=200
  -XX:+UseStringDeduplication
  -XX:+ParallelRefProcEnabled
```

### 2. Database Tuning
```yaml
db:
  command: postgres -c max_connections=200 -c shared_buffers=512MB
```

### 3. Connection Pooling
```yaml
camunda:
  environment:
    - DB_CONN_POOL_MIN_POOL_SIZE=10
    - DB_CONN_POOL_MAX_POOL_SIZE=50
```

## Monitoring Setup

### 1. Elasticsearch Indices
```yaml
elasticsearch:
  environment:
    - cluster.routing.allocation.disk.threshold_enabled=true
    - cluster.routing.allocation.disk.watermark.low=93%
    - cluster.routing.allocation.disk.watermark.high=95%
```

### 2. Prometheus Metrics
```yaml
# prometheus/prometheus.yml
scrape_configs:
  - job_name: 'camunda'
    metrics_path: '/actuator/prometheus'
    static_configs:
      - targets: ['camunda:8080']
```

### 3. Grafana Dashboards
- Process metrics
- JVM metrics
- Database metrics
- System metrics

## Backup Strategy

### 1. Database Backup
```bash
#!/bin/bash
# backup-db.sh
docker exec camunda-db pg_dump -U $POSTGRES_USER camunda > backup_$(date +%Y%m%d).sql
```

### 2. Volume Backup
```bash
#!/bin/bash
# backup-volumes.sh
docker run --rm \
  -v camunda_postgres_data:/source \
  -v /backup:/backup \
  alpine tar czf /backup/postgres_$(date +%Y%m%d).tar.gz /source
```

## Deployment Steps

1. **Prepare Environment**
```bash
# Create necessary directories
mkdir -p nginx/{conf,certs} prometheus grafana
```

2. **Configure SSL**
```bash
# Generate or copy SSL certificates
cp your-domain.crt nginx/certs/
cp your-domain.key nginx/certs/
```

3. **Start Services**
```bash
# Start all services
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps
```

4. **Verify Deployment**
```bash
# Check logs
docker-compose -f docker-compose.prod.yml logs -f

# Check health
curl -k https://your-domain.com/camunda/actuator/health
```

## Maintenance

### 1. Regular Tasks
- Log rotation
- Database vacuum
- Backup verification
- Security updates

### 2. Monitoring Checks
- Resource usage
- Process metrics
- Error rates
- Response times

### 3. Update Strategy
- Test updates in staging
- Schedule maintenance windows
- Backup before updates
- Rolling updates when possible

## Troubleshooting

### 1. Common Issues
- Memory pressure
- Connection issues
- Slow queries
- High CPU usage

### 2. Debug Tools
```bash
# Check container stats
docker stats

# View specific logs
docker-compose -f docker-compose.prod.yml logs camunda

# Check database
docker exec -it camunda-db psql -U $POSTGRES_USER camunda
```

## Next Steps
1. Set up CI/CD pipeline
2. Implement automated testing
3. Configure alerts
4. Document recovery procedures
