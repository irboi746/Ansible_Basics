#To install and configure modsecurity with default rule set for apache server
# Run as sudo
#!/bin/bash

apt update
apt install libapache2-mod-security2 -y
cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i "s/\(SecRuleEngine *\).*/\1On/" /etc/modsecurity/modsecurity.conf
systemctl restart apache2

# verify modsecurity is installed and logging
ls /var/log/apache2 

rm -- "$0"