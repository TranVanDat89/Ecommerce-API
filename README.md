# Ecommerce-API

Ecommerce API built with **Spring Boot**, **PostgreSQL**, **Kafka**, **Kafka Connect**, and the **ELK stack** (Elasticsearch, Logstash, Kibana). This project demonstrates how to build a modern ecommerce backend with real-time data synchronization and log aggregation.
---

## Features

- RESTful API for ecommerce functionalities using Spring Boot.
- PostgreSQL as the main relational database.
- Kafka for real-time messaging and streaming.
- Kafka Connect with Debezium for change data capture (CDC) from PostgreSQL to Kafka.
- Kafka Connect Elasticsearch Sink for pushing data from Kafka to Elasticsearch.
- ELK stack for centralized logging, monitoring, and search.
- Docker Compose setup for easy local development and testing.
---

## Architecture

```bash
PostgreSQL (Debezium Source Connector)
          │
          ▼
        Kafka ──────────▶ Elasticsearch (Sink Connector)
          │
          ▼
     Spring Boot API
          │
          ▼
     Logstash ───▶ Elasticsearch ───▶ Kibana
```

## Folder Structure
- logstash/: Contains Logstash configuration files for ingesting logs into Elasticsearch.
- plugins/: Contains Kafka Connect plugins: Debezium PostgreSQL connector, Elasticsearch sink connector. These are external plugins required for Kafka Connect to work properly.
- create-connectors.sh: Shell script to register Kafka Connect connectors via REST API.
- docker-compose.yml: Docker Compose file to spin up all necessary services (Kafka, Zookeeper, Kafka Connect PostgreSQL, Elasticsearch, Logstash, Kibana, etc.).
- src/: Spring Boot source code for the ecommerce API.
