#!/bin/sh
HOST=${1:-localhost}
curl -s -X PUT \
     -H "Content-Type: multipart/mixed" \
     -F "content=@fax.json; type=application/json" \
     -F "content=@fax.tif; type=image/tiff" \
     -H "X-Auth-Token: $AUTH" \
     http://$HOST:8000/v2/accounts/$ACC/faxes
