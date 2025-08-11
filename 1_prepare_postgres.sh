#!/bin/bash
echo "Chuẩn bị bảng 'customers' và cấu hình replication trong PostgreSQL..."
docker compose exec -T postgres psql -U myuser -d mydatabase << "EOSQL"
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE
);

ALTER TABLE customers REPLICA IDENTITY FULL;
EOSQL
echo "Hoàn thành!"
