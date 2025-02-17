# Camunda 7 Installation Guide

## Local Installation
1. System Requirements:
   - Java 8+ Runtime
   - 4GB+ RAM
   - 2+ CPU cores
2. Download from [Camunda Download Page](https://camunda.com/download/)
3. Start Server:
```bash
unzip camunda-bpm-tomcat-7.19.0.zip
cd camunda-bpm-tomcat-7.19.0
./start-camunda.sh
```

## Docker Installation
```bash
docker run -d --name camunda7 -p 8080:8080 camunda/camunda-bpm-platform:7.19.0
```

Access at: http://localhost:8080/camunda
