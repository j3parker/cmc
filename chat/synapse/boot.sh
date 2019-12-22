#!/bin/bash

set -euo pipefail

echo "Generating secret"
REG_SECRET=$(head -c33 /dev/urandom | base64)
echo "registration_shared_secret: $REG_SECRET" >> ~/homeserver.yaml

echo "Starting Synapse"
python3 -B -m synapse.app.homeserver -c homeserver.yaml
