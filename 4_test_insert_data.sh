TIMESTAMP=$(date +%s)
EMAIL="jane.doe.$TIMESTAMP@example.com"

echo "Chèn dữ liệu mẫu vào PostgreSQL với email: $EMAIL..."
docker compose exec -T postgres psql -U myuser -d mydatabase -c \
"INSERT INTO customers (first_name, last_name, email) VALUES ('Jane', 'Doe', '$EMAIL') ON CONFLICT (email) DO NOTHING;"

echo "Kiểm tra dữ liệu trong MongoDB (đợi 10 giây để dữ liệu được đồng bộ):"
sleep 10
docker compose exec -T mongo mongosh --quiet --eval "print(JSON.stringify(db.getSiblingDB('synced_db').customers.find({'email': '$EMAIL'}).toArray()))" | jq . || echo "Lỗi: Không thể lấy dữ liệu từ MongoDB. Kiểm tra log Kafka Connect: docker compose logs connect"
echo "Hoàn thành!"