#To install and configure modsecurity with default rule set for apache server
#!/bin/bash

# format : 
# docker <docker param> <docker id>
# docker exec -it <docker id> <command to run within docker>

docker exec -it 1abd1c2cd12e apt update
docker exec -it 1abd1c2cd12e apt install libapache2-mod-security2 -y
docker exec -it 1abd1c2cd12e cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
docker exec -it 1abd1c2cd12e sed -i "s/\(SecRuleEngine *\).*/\1On/" /etc/modsecurity/modsecurity.conf
docker restart 1abd1c2cd12e

# verify modsecurity is installed and logging
docker exec -it 1abd1c2cd12e ls /var/log/apache2

rm -- "$0"