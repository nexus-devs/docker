#!/bin/bash
# Generate keypair for API tokens
# The private key is used on auth modules to sign the user tokens
# The public key is used on api modules where we confirm the validity of each user's token
if [ ! "$(docker secret ls | grep nexus-private-key)" ]; then
  echo ""
  echo "* Generating RSA keypair for API token signatures."
  make keypair
  echo "* Keypair generated as docker secret 'nexus-private-key' and 'nexus-public-key'"
  echo ""
fi