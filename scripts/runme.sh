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
   terraform apply -target=aws_route_table_association.public -target=aws_security_group.web -target=aws_instance.rancher[0]
fi

if [ "$step" = "2" ] || [ "$step" = "all" ]

 then

masterIP=$(terraform show | grep "rancher.0.ip" | cut -d"=" -f2 | tr -d '[:space:]' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
echo "Master IP is '$masterIP'";

#
# Checking if rancher server is UP or not after every 5 * n seconds for 10 iterations
#
for n in 1 2 3 4 5 6 7 8 9 10
do
   curl http://${masterIP}:8080/v2-beta/
   if [ $? -ne 0 ]; then
      echo "Connecting Rancher Server Attempt $n (Max 10) : Sleeping for $(( $n * 5 )) seconds";
      sleep $(( $n * 5 ));
   else
	  break;
   fi
done
#
# Now that k8s master is UP, fetch project ID for kubernetes
#
k8spid=$(curl "http://${masterIP}:8080/v2-beta/projectTemplates?name=kubernetes" | jq '.data[0].id');

cat <<EOF> scripts/curlstuff.sh
#
# Command to create new environment with kubernetes
#
curl \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d '{"description":"rancher k8s project", "name":"rancherk8s", "projectTemplateId":${k8spid}, "allowSystemRole":false, "members":[], "virtualMachine":false, "servicesPortRange":null}' \
"http://${masterIP}:8080/v2-beta/projects"
sleep 10;
echo "====================  Separator ==========================";
#
# Finding the project ID that was created 
#
ranchPid=\$(curl http://${masterIP}:8080/v2-beta/projects/?name=rancherk8s  | jq '.data[0].id');
#
# removing doublequotes from ranchPid
#
ranchPid=\$(echo \$ranchPid | sed 's#\"##g');
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
"http://${masterIP}:8080/v2-beta/projects/\${ranchPid}/registrationtokens"

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
