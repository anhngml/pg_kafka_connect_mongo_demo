#!/bin/bash
echo "Gửi yêu cầu tạo Source Connector (PostgreSQL -> Kafka)..."
curl -s -X POST -H "Content-Type: application/json" --data @- http://localhost:8083/connectors/ << 'JSON'
{
  "name": "postgres-source-connector",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "myuser",
    "database.password": "mypassword",
    "database.dbname": "mydatabase",
    "topic.prefix": "pg-server-01",
    "table.include.list": "public.customers",
    "plugin.name": "pgoutput",
    "publication.autocreate.mode": "filtered",
    "slot.name": "debezium_slot"
  }
}
JSON
echo -e "\nKiểm tra trạng thái connector..."
sleep 2
curl -s http://localhost:8083/connectors/postgres-source-connector/status | jq .
echo -e "\nHoàn thành!"
