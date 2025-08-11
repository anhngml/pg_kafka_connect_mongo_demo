# Image cơ sở của Confluent cho Kafka Connect
FROM confluentinc/cp-kafka-connect:7.9.2

# Cài đặt Debezium PostgreSQL Connector
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:latest

# Cài đặt MongoDB Kafka Sink Connector
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:latest
