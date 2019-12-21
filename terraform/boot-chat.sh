#!/bin/bash

set -euo pipefail

echo "Hello, world!"

if [ ! -f GCSFUSE_IS_INSTALLED ]; then
  echo "Installing gcsfuse"
  GCSFUSE_REPO=gcsfuse-$(lsb_release -c -s)
  echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

  apt-get update
  apt-get install -y gcsfuse
  touch GCSFUSE_IS_INSTALLED
fi

if [ ! -f DOCKER_COMPOSE_IS_INSTALLED ]; then
  echo "Installing docker-compose"
  apt-get install -y docker-compose
  touch DOCKER_COMPOSE_IS_INSTALLED
fi

if ! id -u synapse > /dev/null 2>&1; then
  echo "Creating the synapse user"
  groupadd -g 1337 synapse
  useradd -m -u 1337 -g synapse synapse
fi

echo "Creating the mount point for keys"
mkdir -p ~/synapse/keys
chown synapse:synapse ~/synapse/keys

echo "Dropping permissions"
sudo -u synapse -- /bin/bash -c <<EOF

echo "Mounting the keys bucket"
gcsfuse --file-mode 600 cmc-chat-keys ~/keys

export GIT_SSH_COMMAND='ssh -i ~/keys/github/deploy_key'
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts # YOLO
if [ -d "cmc" ]; then
  echo "Repo directory exists; pulling"
  cd cmc
  git pull origin master
else
  echo "Cloning repo"
  git clone ssh://git@github.com/j3parker/cmc
  cd cmc
fi 

echo "Starting containers"
cd chat
docker-compose up

EOF
