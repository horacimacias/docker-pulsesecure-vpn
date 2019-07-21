#!/bin/sh
set -echo

echo "Running version" `cat /VERSION`

usage() {
    echo "Please invoke me with a script similar to these:"
    echo "connect.sh:"
    echo "---------------------------------------------------"
    cat /root/connect.sh
    echo
    echo
    echo "---------------------------------------------------"
    echo
    echo
    echo "vpnconnect.sh:"
    echo "---------------------------------------------------"
    cat /root/vpnconnect.sh
}
# check minimum vars are set

if [ -z "$VPN_URL" ]; then
    echo "VPN_URL variable not provided. Quitting now."
    usage
    exit 1
fi

if [ -z "$AUTH_GROUP" ]; then
    echo "AUTH_GROUP variable not provided. Quitting now."
    usage
    exit 1
fi

if [ -z "$AUTHORIZED_KEYS" ]; then
    echo "AUTHORIZED_KEYS variable not passed so not starting sshd"
else
    echo
    echo
    echo "Adding the following public ssh keys as authorized"
    echo
    echo $AUTHORIZED_KEYS
    echo
    echo $AUTHORIZED_KEYS >/root/.ssh/authorized_keys
    echo "---------------------------------------------------"
    echo
    echo
    chmod -R 600 /root/.ssh
    echo Starting sshd
    /usr/sbin/sshd
fi

while [ -z "$VPN_USER" ]; do
    echo "Type in your VPN_USER"
    read VPN_USER
done

if [ -z "$VPN_PIN" ]; then
    echo "Type in your VPN_PIN + code"
    # https://stackoverflow.com/questions/1923435/how-do-i-echo-stars-when-reading-password-with-read
    while [ -z "$pincode" ]; do
        prompt=""
        while IFS= read -p "$prompt" -r -s -n 1 char; do
            if [ "$char" = $'\0' ]; then
                break
            fi
            prompt='*'
            pincode="${pincode}${char}"
        done
    done
else
    echo "Got your VPN_PIN. Type in your code"
    while [ -z "$code" ]; do
        prompt=""
        while IFS= read -p "$prompt" -r -s -n 1 char; do
            if [ "$char" = $'\0' ]; then
                break
            fi
            prompt='*'
            code="${code}${char}"
        done
        pincode=${VPN_PIN}${code}
    done
fi

echo
echo "Trying to login...."
echo Starting openconnect
echo $pincode | openconnect -b $OPENCONNECT_OPTIONS --authgroup="$AUTH_GROUP" --protocol=nc --os=linux $VPN_URL -u $VPN_USER --passwd-on-stdin
if [ $? -eq 0 ]; then
    cowsay -f tux "Looks like you\'re connected :)" &&
        cowsay -f tux "Press ctrl-c to finish and disconnect" &&
        tinyproxy -d
else
    cowsay -d "Something ain't right. Please check the credentials supplied" &&
        cowsay -d "If you passed VPN_USER and VPN_PIN already all I need is the random MFA pin"
fi
