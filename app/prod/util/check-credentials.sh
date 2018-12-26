#!/bin/bash
# Cubic UI
if [ ! "$(docker secret ls | grep nexus-cubic-key)" ]; then
  pwgen -s 64 1 > nexus-cubic-key
  pwgen -s 64 1 > nexus-cubic-secret
  docker secret create nexus-cubic-key nexus-cubic-key
  docker secret create nexus-cubic-secret nexus-cubic-secret
  echo "* Generated cubic client credentials."
fi

# Warframe OCR Bot/WFM order tracker
if [ ! "$(docker secret ls | grep nexus-warframe-bot-key)" ]; then
  pwgen -s 64 1 > nexus-warframe-bot-key
  pwgen -s 64 1 > nexus-warframe-bot-secret
  docker secret create nexus-warframe-bot-key nexus-warframe-bot-key
  docker secret create nexus-warframe-bot-secret nexus-warframe-bot-secret
  echo "* Generated warframe bot credentials."
fi
