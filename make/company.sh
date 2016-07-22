#!/bin/bash
CN=$1
ACC=$(
curl -s -X PUT \
    -H "X-Auth-Token: $AUTH" \
    -H "Content-Type: application/json" \
    -d "{\"data\":{\"name\":\"${CN}\", \"realm\":\"${CN}.kazoo\"}}" \
    http://$SERVER/v2/accounts
)
ACC_ID=`echo $ACC | jq -r '.data.id'`
echo COMPANY: $CN $ACC_ID

U1=$(./user.sh $ACC_ID 1 $CN)
echo USER-1 $U1
D1=$(./device.sh $ACC_ID $U1 1)
echo DEVICE-1 $D1
CF1=$(./callflow_user.sh $ACC_ID $U1 1001)
echo CALLFLOW-1 $CF1

U2=$(./user.sh $ACC_ID 2 $CN)
echo USER-2 $U2
D2=$(./device.sh $ACC_ID $U2 2)
echo DEVICE-2 $D2
CF2=$(./callflow_user.sh $ACC_ID $U1 1002)
echo CALLFLOW-2 $CF2

C=$(./conference.sh $ACC_ID $U1 1)
echo CONF-1 $C
CF3=$(./callflow_conference.sh $ACC_ID $C 2001)
echo CALLFLOW-3 $CF3
