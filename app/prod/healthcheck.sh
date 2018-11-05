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


# IMPORTANT: We only really check for core responses because we assume that the
# healthcheck already times out by that point if the site isn't up at all,
# meaning no further checks for api nodes are required.
check_url () {
  status_code=$(curl -L --silent --output /dev/stderr --write-out "%{http_code}" $1)

  if [[ $core == true ]]; then
    [[ $status_code -lt 400 ]] && exit 0 || exit 1
  else
    exit 0
  fi
}

# UI and Auth nodes connect to their own API
if [[ $ui == true ]]; then
  check_url http://ui_api:3000

# Same for auth node
elif [[ $auth == true ]]; then
  check_url http://auth_api:3030

# Warframe worker
elif [[ $warframe == true ]]; then
  check_url http://main_api:3003/warframe/foo

# Nodes connected to main api
else
  check_url http://main_api:3003
fi
