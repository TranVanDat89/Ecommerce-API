#!/bin/sh
sleep 10
curl -X PUT http://elasticsearch:9200/_ilm/policy/log-retention-policy -H 'Content-Type: application/json' -d ilm.json
curl -X PUT http://elasticsearch:9200/_index_template/logs-template -H 'Content-Type: application/json' -d index_template.json
