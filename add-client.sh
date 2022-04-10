#! /usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

. "$(dirname "$0")/conf.sh"

mkdir -p "${CLIENTS_DIR}"

read -p "Client name:" clientName
clientPrivKey=`wg genkey`
clientPubKey=`echo ${clientPrivKey} | wg pubkey`

echo "Used IPs:"
grep "^AllowedIPs" "${SERVER_CONFIG}"
read -p "Enter client IP you want to assign:" clientIP

cat "$(dirname "$0")/client.template" \
| sed -e "s|:CLIENT_IP:|$clientIP|" \
| sed -e "s|:CLIENT_KEY:|$clientPrivKey|" \
| sed -e "s|:SERVER_PUB_KEY:|$SERVER_PUB_KEY|" \
| sed -e "s|:SERVER_ADDR:|$SERVER_ADDR|" > "${CLIENTS_DIR}/${clientName}.conf"

echo >> "${SERVER_CONFIG}"

cat "$(dirname "$0")/peer.template" \
| sed -e "s|:PEER_NAME:|$clientName|" \
| sed -e "s|:PEER_KEY:|$clientPubKey|" \
| sed -e "s|:PEER_IP:|$clientIP|" >> "${SERVER_CONFIG}"

systemctl restart wg-quick@${WG_INTERFACE}

qrencode -t ansiutf8 < "${CLIENTS_DIR}/${clientName}.conf"
