https://github.com/horacimacias/docker-vpn-proxy.git

git config --global -l

git config --global --set http.proxy=

git config --global --unset http.proxy=

networksetup -getdnsservers Wi-Fi

networksetup -setdnsservers Wi-Fi 127.0.0.1

networksetup -setdnsservers Wi-Fi Empty

docker run --name \
	pulsevpn \
	-e "VPN_URL=<vpn_connect_url>" \
	-e "VPN_USER=<user>" \
	-e "VPN_PASSWORD=<password>" \
	-e "OPENCONNECT_OPTIONS=<openconnect_extra_options>" \
	-v /full/path/<user>.pem:/root/<user>.pem:ro \
	--privileged=true \
        --authgroup VPN_REALM
