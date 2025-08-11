#!/bin/bash
echo "Gửi yêu cầu tạo Sink Connector (Kafka -> MongoDB)..."
curl -s -X POST -H "Content-Type: application/json" --data @- http://localhost:8083/connectors/ << 'JSON'
{
  "name": "mongodb-sink-connector",
  "config": {
    "connector.class": "com.mongodb.kafka.connect.MongoSinkConnector",
    "tasks.max": "1",
    "topics": "pg-server-01.public.customers",
    "connection.uri": "mongodb://mongo:27017",
    "database": "synced_db",
    "collection": "customers",
    "change.data.capture.handler": "com.mongodb.kafka.connect.sink.cdc.debezium.rdbms.postgres.PostgresHandler",
    "key.converter": "org.apache.kafka.connect.json.JsonConverter",
    "key.converter.schemas.enable": "false",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false"
  }
}
JSON
echo -e "\nKiểm tra trạng thái connector..."
sleep 2
curl -s http://localhost:8083/connectors/mongodb-sink-connector/status | jq .
echo -e "\nHoàn thành!"
