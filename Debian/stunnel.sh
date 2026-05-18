#!/bin/bash
#auto install deb

# details
country=ZA
state=South Africa
locality=Johannesburg
organization=hugossh
organizationalunit=hugossh
commonname=hugossh.indevs.in
email=hugoxd2919@gmail.com

# install stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[dropbear]
accept = 443
connect = 127.0.0.1:143
[dropbear]
accept = 222
connect = 127.0.0.1:22
[dropbear]
accept = 444
connect = 127.0.0.1:44
[dropbear]
accept = 777
connect = 127.0.0.1:77
END

echo "=================  Creating Cert OpenSSL ======================"
echo "========================================================="
#Creating Certificate
openssl genrsa -out key.pem 2048 >/dev/null 2>&1
openssl req -new -x509 -key key.pem -out cert.pem -days 1050 >/dev/null 2>&1
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat cert.pem key.pem >>/etc/stunnel/stunnel.pem
rm key.pem cert.pem >/dev/null 2>&1
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

#auto install stunnel debian
rm -rf stunnel.sh
