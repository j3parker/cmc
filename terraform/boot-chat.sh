#!/bin/bash

set -euo pipefail

echo "Creating the synapse user"
id -u synapse &>/dev/null || useradd -u 1337 synapse

echo "Dropping permissions"
su - synapse

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
