#! /usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

. "$(dirname "$0")/conf.sh"

echo "Current clients:"
sed -n "s|^\[Peer\] # \(.*\)|\1|p" "${SERVER_CONFIG}"
read -p "Client name to remove: " clientName

sed -i "" -e "s|^\[Peer\] # {$clientName}$|,+4 d" "${SERVER_CONFIG}"
