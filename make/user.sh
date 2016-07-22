#!/bin/bash
ACC_ID=$1
ID=$2
CN=$3
U=$(
curl -s -X PUT \
    -H "X-Auth-Token: $AUTH" \
    -H "Content-Type: application/json" \
    -d "{\"data\":{\"name\":\"User $ID\", \"first_name\":\"User\", \"last_name\":\"$ID\", \"username\":\"user$ID@${CN}.kazoo\", \"password\":\"user${ID}pas\"}}" \
    http://$SERVER/v2/accounts/$ACC_ID/users
)
U_ID=`echo $U | jq -r '.data.id'`
echo $U_ID
