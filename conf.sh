#!/bin/sh

WG_INTERFACE="wg0"
SERVER_ADDR="example.com:51820"
SERVER_CONFIG="/etc/wireguard/${WG_INTERFACE}.conf"
SERVER_PUB_KEY=`cat /etc/wireguard/public.key`

CLIENTS_DIR="$(dirname "$0")/clients"
