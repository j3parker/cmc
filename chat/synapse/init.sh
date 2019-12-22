#!/bin/bash

set -euo pipefail

echo "Generating secret"
REG_SECRET=$(head -c63 /dev/urandom | base64)
echo "The shared registration secret for this boot is $REG_SECRET ... keep it a secret! :)"
echo "registration_shared_secret: $REG_SECRET" >> ~/homeserver.yaml
