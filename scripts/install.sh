#!/bin/bash


echo "Value of Param1 is $1"
echo "Value of Param2 is $2"
#
# Installing Docker first 
#
apt-get update
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb http://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-cache policy docker-engine
apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
apt-get update
apt-get install -y docker-engine=1.10.3-0~trusty

service docker start
docker run hello-world
if [[ "$1" == "0" ]]; then
docker run -d --restart=unless-stopped -p 8080:8080 --name rancherserver rancher/server
docker logs rancherserver
#
# Run curl to create project with kubernetes
#
else
#
# Agent ADD command here, capture Master IP in $2
#
chmod 755 /tmp/installAgent.sh && /tmp/installAgent.sh $2 1a7
fi
