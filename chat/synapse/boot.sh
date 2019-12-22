#!/bin/bash

set -euo pipefail

REG_SECRET=$(cat /dev/urandom | head -c63 | base64)

echo "The shared registration secret for this boot is $REG_SECRET ... keep it a secret! :)"

echo "registration_shared_secret: $REG_SECRET" >> ~/homeserver.yml

python3 -B -m synapse.app.homeserver -c homeserver.yaml
