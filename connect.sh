#!/bin/bash

# SSH authorized keys, in case you want to ssh through docker
export AUTHORIZED_KEYS="CHANGEME"
# vpn user
export VPN_USER="CHANGEME"
# vpn MFA pin (fixed part)
export VPN_PIN="CHANGEME"
export VPN_URL="CHANGEME"
export AUTH_GROUP="CHANGE ME"

# if needed, specify server cert here
export OPENCONNECT_OPTIONS="--servercert pin-sha256:11111111111111111111111111111111111111111111"

./vpnconnect.sh
