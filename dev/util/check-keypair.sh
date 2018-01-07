#!/bin/bash
# Generate keypair for API tokens
# The private key is used on auth modules to sign the user tokens
# The public key is used on api modules where we confirm the validity of each user's token
if [ ! "$(docker secret ls | grep nexus-private-key)" ]; then
  echo ""
  echo "* Generating RSA keypair for API token signatures."
  echo "* The Public key MUST be the same on all API and Auth instances."
  echo "* The Private key MUST be the same on Auth instances only."
  make keypair
  echo "* Keypair generated at /app/config/certs/"
  echo "* The private key encryption password can be found in /app/config/certs/secret"
  echo ""
fi