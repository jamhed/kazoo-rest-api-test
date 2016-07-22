#!/bin/sh
LOGIN=${1:-admin}
PASS=${2:-admin}
ACCOUNT_NAME=${3:-admin_name}
HOST=${4:-localhost}
echo $LOGIN:$PASS
AUTH=$(echo -n $LOGIN:$PASS | md5sum | cut -f 1 -d " ")

DATA="{\"data\":{\"credentials\":\"$AUTH\",\"account_name\":\"$ACCOUNT_NAME\",\"ui_metadata\":{\"ui\":\"kazoo-ui\"}},\"verb\":\"PUT\"}"
JSON=`curl -s -XPUT -d $DATA -H "Content-Type: application/json" \
	http://$HOST:8000/v1/user_auth`

ACC=`echo $JSON | jq -r '.data.account_id'`
AUTH=`echo $JSON | jq -r '.auth_token'`
echo export ACC=$ACC
echo export AUTH=$AUTH

