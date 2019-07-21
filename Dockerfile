FROM alpine:3.6
#Forked from jamgocoop/docker-pulsesecure-vpn

# Install required packages
WORKDIR /tmp
RUN set -x && \
   	apk update && \
	apk add --no-cache autoconf automake binutils build-base curl g++ gcc gettext git gnutls-dev libtool libxml2-dev linux-headers make openssh openssl perl tinyproxy zlib && \
    	git clone --depth 1 https://github.com/jasonm23/cowsay.git && \
    	cd cowsay && ./install.sh /usr/local && \
	cd .. && \
	git clone --depth 1 https://github.com/openconnect/openconnect.git && \
	cd openconnect && \
	./autogen.sh && \
	./configure --with-vpnc-script=/etc/vpnc/vpnc-script && \
	make && \
	make install && \
	apk del --no-cache autoconf automake binutils build-base g++ gcc git libtool linux-headers make && \
	cd .. && \
	rm -rf ./*

COPY VERSION /

COPY tinyproxy.conf /etc/tinyproxy

# add ssh key so we can connect over ssh
RUN mkdir /root/.ssh && chmod -R 600 /root/.ssh && ssh-keygen -A && mkdir -p /usr/local/share/ca-certificates/
# COPY *.crt /usr/local/share/ca-certificates/
COPY sshd_config /etc/ssh/

COPY startup.sh /root/startup.sh
COPY vpnconnect.sh /root/
COPY connect.sh /root/
RUN update-ca-certificates

CMD ["/root/startup.sh"]
