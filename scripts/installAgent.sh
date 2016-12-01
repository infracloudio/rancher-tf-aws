#!/bin/bash
RANCH_SVR_PUB_IP=$1;
RANCH_PROJECT_ID=$2;
function jsonval {
    temp=`echo $json | sed 's/\\\\\//\//g' | sed 's/[{}]//g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}' | sed 's/\"\:\"/\|/g' | sed 's/[\,]/ /g' | sed 's/\"//g' | grep -w $prop`
    echo ${temp##*|}
}

json=$(curl http://${RANCH_SVR_PUB_IP}:8080/v2-beta/registrationtokens?projectId=${RANCH_PROJECT_ID})
prop='command'
cmd2run=`jsonval`
echo "Value of command to run is $cmd2run";
$cmd2run;