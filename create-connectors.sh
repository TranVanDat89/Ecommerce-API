#!/bin/bash

set -e

echo "🔧 Bắt đầu khởi tạo Kafka Connect..."

# Load biến môi trường từ file .env
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ Không tìm thấy file .env"
  exit 1
fi

# Parse thông tin từ SPRING_DATASOURCE_URL
if [[ $SPRING_DATASOURCE_URL =~ jdbc:postgresql://([^:/]+):([0-9]+)/([a-zA-Z0-9_]+) ]]; then
  POSTGRES_HOST="${BASH_REMATCH[1]}"
  POSTGRES_PORT="${BASH_REMATCH[2]}"
  POSTGRES_DB="${BASH_REMATCH[3]}"
else
  echo "❌ Không parse được SPRING_DATASOURCE_URL"
  exit 1
fi

# Debug thông tin lấy được
echo "📌 Đã lấy được thông tin:"
echo "    Host: $POSTGRES_HOST"
echo "    Port: $POSTGRES_PORT"
echo "    Database: $POSTGRES_DB"
echo "    User: $POSTGRES_USER"

# Định nghĩa biến Kafka Connect URL
KAFKA_CONNECT_URL="http://localhost:8083"

# Hàm tạo connector
create_connector() {
  local NAME=$1
  local PAYLOAD=$2

  echo "🔎 Kiểm tra connector [$NAME]..."

  if curl -s -o /dev/null -w "%{http_code}" ${KAFKA_CONNECT_URL}/connectors/${NAME} | grep -q "200"; then
    echo "❌ Connector [$NAME] đã tồn tại. Không thể tạo lại."
    exit 1
  fi

  echo "🚀 Đang tạo connector [$NAME]..."

  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
    -X POST ${KAFKA_CONNECT_URL}/connectors \
    -H "Content-Type: application/json" \
    -d "${PAYLOAD}")

  if [ "$HTTP_CODE" -ne 201 ]; then
    echo "❌ Lỗi khi tạo connector [$NAME] (HTTP $HTTP_CODE)"
    exit 1
  fi

  echo "✅ Connector [$NAME] tạo thành công."
}

# Payload Debezium PostgreSQL Source Connector
DEBEZIUM_PAYLOAD=$(cat <<EOF
{
  "name": "ecommerce-postgres-cdc",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "database.hostname": "${POSTGRES_HOST}",
    "database.port": "${POSTGRES_PORT}",
    "database.user": "${POSTGRES_USER}",
    "database.password": "${POSTGRES_PASSWORD}",
    "database.dbname": "${POSTGRES_DB}",
    "database.server.name": "ecommerce-server",
    "plugin.name": "pgoutput",
    "slot.name": "debezium",
    "table.include.list": "public.product",
    "decimal.handling.mode": "string",
    "topic.prefix": "ecommerce"
  }
}
EOF
)

# Payload Elasticsearch Sink Connector
ELASTICSEARCH_PAYLOAD=$(cat <<EOF
{
  "name": "elasticsearch-sink",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "topics": "ecommerce.public.product",
    "connection.url": "http://elasticsearch:9200",
    "key.ignore": true,
    "schema.ignore": true
  }
}
EOF
)

# Tạo các connectors
create_connector "ecommerce-postgres-cdc" "$DEBEZIUM_PAYLOAD"
create_connector "elasticsearch-sink" "$ELASTICSEARCH_PAYLOAD"

echo "🎉 Tất cả connectors đã tạo thành công."
