#! /usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

WG_INTERFACE="wg0"
SERVER_CONFIG="/etc/wireguard/${WG_INTERFACE}.conf"
SERVER_PUB_KEY=`cat /etc/wireguard/public.key`

SCRIPT_DIR=`dirname "$0"`
CLIENTS_DIR="${SCRIPT_DIR}/clients"

mkdir -p "${CLIENTS_DIR}"

read -p "Client name:" clientName
clientPrivKey=`wg genkey`
clientPubKey=`echo ${clientPrivKey} | wg pubkey`

echo "Used IPs:"
grep AllowedIPs "${SERVER_CONFIG}"
read -p "Enter client IP you want to assign:" clientIP

cat wg0-client.template \
| sed -e "s|:CLIENT_IP:|$clientIP|" \
| sed -e "s|:CLIENT_KEY:|$clientPrivKey|" \
| sed -e "s|:SERVER_PUB_KEY:|$SERVER_PUB_KEY|" > "${CLIENTS_DIR}/${clientName}.conf"

echo >> "${SERVER_CONFIG}"

cat wg0-peer.template \
| sed -e "s|:PEER_NAME:|$clientName|" \
| sed -e "s|:PEER_KEY:|$clientPubKey|" \
| sed -e "s|:PEER_IP:|$clientIP|" >> "${SERVER_CONFIG}"

systemctl restart wg-quick@${WG_INTERFACE}

qrencode -t ansiutf8 < "${CLIENTS_DIR}/${clientName}.conf"
