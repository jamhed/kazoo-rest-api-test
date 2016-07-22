#!/bin/sh
ACC_ID=$1
CONF_ID=$2
NUMBER=$3
D1=$(
curl -s -X PUT \
    -H "X-Auth-Token: $AUTH" \
    -H "Content-Type: application/json" \
    -d "{\"data\":{\"flow\":{\"data\":{\"id\":\"$CONF_ID\"},\"module\":\"conference\"},\"numbers\":[\"$NUMBER\"]}}" \
    http://$SERVER/v2/accounts/$ACC_ID/callflows
)
echo $D1 | jq -r '.data.id'
