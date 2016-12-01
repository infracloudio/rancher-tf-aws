#!/bin/bash

if [ $(basename $PWD) != "scripts" ]; then
   echo "ERROR: Run this script from scripts directory. Exiting"
   exit 1
fi

#
# Adding tr to fix line ending issue of windows, relying on tr as dos2unix may not be available on all platforms.
#
for f in install*sh
do
tr -d '\015' <$f > ${f}_1
mv ${f}_1 ${f}
done


cd ..;

step=$1;
if [ "$step" = "1" ]|| [ "$step" = "all" ]
 then
   terraform apply -target=google_compute_firewall.default -target=google_compute_instance.rancher[0]
fi

if [ "$step" = "2" ] || [ "$step" = "all" ]

 then
echo "============== Sleeping 60 seconds =================";
sleep 60;
echo "============== Awake and on to next =============" 
masterIP=$(terraform show | grep "master.ip" | cut -d"=" -f2 | tr -d '[:space:]' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")

echo "Master IP is '$masterIP'";
cat <<EOF> scripts/curlstuff.sh
#
# Command to create new environment
#
curl \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"description":"rancher k8s project", "name":"rancherk8s", "projectTemplateId":"1pt1", "allowSystemRole":false, "members":[], "virtualMachine":false, "servicesPortRange":null}' \
"http://${masterIP}:8080/v2-beta/projects"
sleep 10;
echo "====================  Separator ==========================";
#
# Add current host as API master
#
curl \
-X PUT \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"activeValue":null, "id":"1as!api.host", "name":"api.host", "source":null, "value":"http://${masterIP}:8080"}' \
'http://${masterIP}:8080/v2-beta/activesettings/1as!api.host'

echo "====================  Separator ==========================";
sleep 20;
curl \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"description":"new token for k8sapitest", "name":"token_k8sapitest"}' \
"http://${masterIP}:8080/v2-beta/projects/1a7/registrationtokens"

echo "====================  Separator ==========================";
EOF

bash scripts/curlstuff.sh

fi

if [ "$step" = "5" ] || [ "$step" = "all" ]
 then
   terraform apply
fi

if [ "$step" = "del" ]; then
   terraform destroy
fi	
