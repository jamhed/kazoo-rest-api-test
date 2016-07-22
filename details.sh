#!/bin/sh
HOST=${1:-localhost}
curl -s -X GET -H "Accept: application/json" -H "Content-Type: application/json" -H "X-Auth-Token: $AUTH" \
	http://$HOST:8000/v2/accounts/$ACC/conferences/$CONF \
	| jq '.'
