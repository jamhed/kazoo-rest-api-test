#!/bin/bash
ACC_ID=$1
OWNER=$2
ID=$3
D1=$(
curl -s -X PUT \
    -H "X-Auth-Token: $AUTH" \
    -H "Content-Type: application/json" \
    -d "{\"data\":{\"name\":\"Conf ${ID}\", \"owner_id\":\"$OWNER\"}}" \
    http://$SERVER/v2/accounts/$ACC_ID/conferences
)
echo $D1 | jq -r '.data.id'
