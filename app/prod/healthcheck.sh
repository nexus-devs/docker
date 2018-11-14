#!/bin/sh
# Helper function for wildcard match
contains() {
  string="$1"
  substring="$2"
  if test "${string#*$substring}" != "$string"
  then
    return 0    # $substring is in $string
  else
    return 1    # $substring is not in $string
  fi
}

# Check if core or api node. If api node -> simply check if host is up at all,
# regardless of response status. For cores, check if response status is < 400.
contains "${NEXUS_TARGET_NODE}" "-core" && core=true || core=false
contains "${NEXUS_TARGET_NODE}" "auth-" && auth=true || auth=false
contains "${NEXUS_TARGET_NODE}" "ui-" && ui=true || ui=false
contains "${NEXUS_TARGET_NODE}" "warframe-" && warframe=true || warframe=false

echo "core: $core"
echo "auth: $auth"
echo "ui: $ui"

# Core node healthchecks
if [[ $core == true ]]; then
  if grep -Fxq "1" /app/nexus-stats/.health; then
    exit 0
  else
    exit 1
  fi

# API node healtchecks
else
  check_url () {
    status_code=$(curl -L --silent --output /dev/stderr --write-out "%{http_code}" $1)
    exit 0
  }
  if [[ $ui == true ]]; then
    check_url http://localhost:3000/healthcheck
  elif [[ $auth == true ]]; then
    check_url http://localhost:3030/healthcheck
  else
    check_url http://localhost:3003/healthcheck
  fi
fi
