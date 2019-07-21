# docker-vpn-proxy

Based on jamgo/docker-pulsesecure-vpn, it adds ssh and socks proxy and configures git proxy to go through the docker/vpn so hosts can access the vpn through the docker proxy.

** This is currently work in progress **

## How to use

Run first without any parameters
```bash
    docker run -it --rm horacimacias/docker-vpn-proxy:latest
```

and follow onscreen instructions.

Basically you'll be provided with sample connect.sh and vpnconnect.sh scripts to use and invoke the docker container again, passing the right parameters.