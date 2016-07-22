#!/bin/sh
ACC_ID=$1
USER_ID=$2
NUMBER=$3
D1=$(
curl -s -X PUT \
    -H "X-Auth-Token: $AUTH" \
    -H "Content-Type: application/json" \
    -d "{\"data\":{\"flow\":{\"data\":{\"id\":\"$USER_ID\",\"timeout\":\"20\",\"can_call_self\":false},\"module\":\"user\"},\"numbers\":[\"$NUMBER\"]}}" \
    http://$SERVER/v2/accounts/$ACC_ID/callflows
)
echo $D1 | jq -r '.data.id'
