# Data Pipeline: PostgreSQL -> Kafka -> MongoDB

Demo này thiết lập một data pipeline sử dụng Kafka Connect với Debezium để bắt các thay đổi dữ liệu (CDC) từ PostgreSQL và đồng bộ sang MongoDB.

## Điều kiện tiên quyết
- Docker và Docker Compose được cài đặt trên Ubuntu.
- jq (để hiển thị JSON đẹp hơn): Cài đặt bằng `sudo apt-get install jq`.

## Cấu trúc thư mục
- `docker-compose.yml`: Cấu hình các dịch vụ (Zookeeper, Kafka, PostgreSQL, MongoDB, Kafka Connect, Kafka UI).
- `connect/Dockerfile`: Build image Kafka Connect với các connector cần thiết.
- `1_prepare_postgres.sh`: Tạo bảng và cấu hình replication trong PostgreSQL.
- `2_create_source_connector.sh`: Đăng ký Debezium PostgreSQL Source Connector.
- `3_create_sink_connector.sh`: Đăng ký MongoDB Sink Connector.
- `4_test_insert_data.sh`: Chèn dữ liệu mẫu vào PostgreSQL và kiểm tra đồng bộ sang MongoDB.

## Hướng dẫn thử nghiệm

1. **Di chuyển vào thư mục dự án**:

   cd data-pipeline

2. **Khởi chạy các dịch vụ**:

   docker compose up -d --build
Chờ 1-2 phút để các dịch vụ khởi động.
- Kiểm tra trạng thái: `docker compose ps`.

3. **Cấu hình pipeline**:
Chạy các script theo thứ tự:
./1_prepare_postgres.sh
./2_create_source_connector.sh
./3_create_sink_connector.sh

4. **Thử nghiệm đồng bộ dữ liệu**:
./4_test_insert_data.sh
- Script sẽ chèn dữ liệu vào PostgreSQL và kiểm tra trong MongoDB.
- Dự kiến output hiển thị document JSON trong MongoDB.

5. **Giám sát**:
- Truy cập Kafka UI tại `http://localhost:8888` để xem topic `pg-server-01.public.customers` và trạng thái connector.
- Kiểm tra log Kafka Connect: `docker compose logs connect`.
- Kiểm tra dữ liệu trong MongoDB thủ công:
docker compose exec mongo mongosh
use synced_db
db.customers.find().pretty()
text7. **Dừng hệ thống**:
docker compose down -v

## Xử lý lỗi thường gặp
- **Connector không chạy**: Kiểm tra trạng thái bằng `curl -s http://localhost:8083/connectors/<connector-name>/status | jq .`.
- **Không có dữ liệu trong topic**: Kiểm tra log PostgreSQL (`docker compose logs postgres`) và đảm bảo `wal_level=logical`.
- **Lỗi kết nối MongoDB**: Đảm bảo container `mongo` chạy và kết nối từ `connect`: `docker compose exec connect ping mongo`.

## Phiên bản công cụ
- Confluent Platform: 7.9.2
- Debezium PostgreSQL Connector: latest
- MongoDB Kafka Sink Connector: latest
- PostgreSQL: 17
- MongoDB: 8.0

