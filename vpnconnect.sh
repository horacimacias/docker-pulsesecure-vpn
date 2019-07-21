#!/bin/bash
# check if docker is running
VERSION=0.0.1
IMAGE=horacimacias/docker-vpn-proxy

if ! docker info > /dev/null ; then
    echo "Looks like docker is not even running."
    echo "Please either start docker or run \"eval \$(minikube docker-env)\" if you plan on using minikube's docker"
    exit 1
fi

echo -------------------------------
echo 
echo "Setting git config to use proxy: http://127.0.0.1:8888"
echo
echo "Use the same proxy settings in your browser if you want to browse through the vpn"
echo
echo -------------------------------
git config --global http.proxy http://127.0.0.1:8888
if [ ! -z "$DOCKER_HOST" ]; then
    echo
    echo
    echo "Looks like you're not running native docker."
    echo "The vpn proxy is listening on the docker host so you need to forward ports from you host to your docker host"
    echo "You need to run something like:"
    echo
    echo 'ssh -i ~/.minikube/machines/minikube/id_rsa -N -L8888:localhost:8888 -L2222:localhost:2222 -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" docker@$(minikube ip)'
    echo 
    echo 
    echo "Run that on a separate shell and leave it running while you use the vpn connection"
    echo
    echo -------------------------------
    echo
fi
docker run -e AUTHORIZED_KEYS="$AUTHORIZED_KEYS" -e VPN_USER=$VPN_USER -e VPN_PIN=$VPN_PIN -e VPN_URL="$VPN_URL" -e OPENCONNECT_OPTIONS="$OPENCONNECT_OPTIONS" -e AUTH_GROUP="$AUTH_GROUP" --name pulsevpn --privileged=true -p 127.0.0.1:8888:8888 -p 127.0.0.1:2222:22 --rm -it $IMAGE:$VERSION
echo Unsetting git proxy
git config --global --unset http.proxy
wait
