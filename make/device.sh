#!/bin/bash
ACC_ID=$1
OWNER=$2
ID=$3
D1=$(
curl -s -X PUT \
    -H "X-Auth-Token: $AUTH" \
    -H "Content-Type: application/json" \
    -d "{\"data\":{\"name\":\"Desk ${ID}\", \"owner_id\":\"$OWNER\", \
		\"sip.number\":\"100${ID}\", \"sip.username\":\"sip$ID\", \"sip.password\":\"sip${ID}pas${ID}\"}}" \
    http://$SERVER/v2/accounts/$ACC_ID/devices
)
echo $D1 | jq -r '.data.id'
