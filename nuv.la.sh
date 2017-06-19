#preinstall 


#!/bin/bash -xe

apt-get update

# remove any existing docker packages so that they do no interfere
apt-get remove -y docker docker-engine || true

# packages required to access and use the docker repository
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# import the GPG key for the repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key update

# actually add the configuration for the repository
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# update the cached repository information
apt-get update

#postinstall


!/bin/bash -xe

# ensure docker is enabled at boot time
systemctl enable docker
systemctl restart docker

# verify that docker works
docker -v

# pull in the docker-compose executable
curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose

# verify that docker-compose works
docker-compose -v

#!/bin/bash -x
apt-get update
apt-get install -y git

#deployment

#!/bin/bash -x


#get the preconfigured keycloak Dockerfile
mkdir /root/moodleRepo
cd /root/moodleRepo
git clone https://github.com/burcinbaykan01/moodledocker
cd moodledocker
#start docker as daemon
service docker start

#cleanup existing containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker build -t burcin/moodle .
# build and deploy with docker-compose
docker-compose build
docker-compose up -d



