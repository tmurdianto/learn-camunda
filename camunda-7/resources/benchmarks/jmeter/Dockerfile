FROM justb4/jmeter:latest

# Create directory for plugins
RUN mkdir -p /opt/apache-jmeter/lib/ext/

# Install required plugins
WORKDIR /opt/apache-jmeter/lib/ext

# Download InfluxDB Backend Listener and dependencies
RUN wget -q https://repo1.maven.org/maven2/com/github/venkatesan255/JmeterInfluxDBBackendListenerClient/1.3/JmeterInfluxDBBackendListenerClient-1.3.jar && \
    wget -q https://repo1.maven.org/maven2/org/influxdb/influxdb-java/2.23/influxdb-java-2.23.jar && \
    wget -q https://repo1.maven.org/maven2/com/squareup/okhttp3/okhttp/3.14.9/okhttp-3.14.9.jar && \
    wget -q https://repo1.maven.org/maven2/com/squareup/okio/okio/1.17.2/okio-1.17.2.jar && \
    wget -q https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.32/slf4j-api-1.7.32.jar && \
    wget -q https://repo1.maven.org/maven2/com/squareup/moshi/moshi/1.8.0/moshi-1.8.0.jar

# Set back to default workdir
WORKDIR /
