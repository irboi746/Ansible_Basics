#/!bin/bash
# Script for WAF Installation on Nginx 
# logs are located in /var/log/modsec_audit.log
# !!! Run as root

#Debug Trap
set -e 
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\${last_command}\" command filed with exit code $?."' EXIT

# Install Dependencies
apt update && apt install wget git make gcc build-essential autoconf automake libtool libfuzzy-dev ssdeep gettext pkg-config libcurl4-openssl-dev liblua5.3-dev libpcre3 libpcre3-dev libxml2 libxml2-dev libyajl-dev doxygen libcurl4 libgeoip-dev libssl-dev zlib1g-dev libxslt-dev liblmdb-dev libpcre++-dev libgd-dev -y

# Download and Build ModSecurity (works)
cd /opt && git clone https://github.com/SpiderLabs/ModSecurity && cd ModSecurity
git submodule init && git submodule update
./build.sh && ./configure && make && make install

# Download and Build ModSecurity-Nginx Connector (test)
cd /opt && git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git
nginxvnumber=$(nginx -v 2>&1 | grep -o '[0-9.]*')
cd /opt && wget http://nginx.org/download/nginx-"$nginxvnumber".tar.gz && tar zxvf nginx-"$nginxvnumber".tar.gz
cd nginx-"$nginxvnumber"
./configure --with-compat --add-dynamic-module=/opt/ModSecurity-nginx && make modules && cp objs/"ngx_http_modsecurity_module.so" /etc/nginx/modules-available/"ngx_http_modsecurity_module.so"
nginx -t

# Load Module into nginx.conf (works)
cp /etc/nginx/nginx.conf ~/nginx.conf
sed -i -e '1iload_module /etc/nginx/modules-available/"ngx_http_modsecurity_module.so";\' ~/nginx.conf
cp -f ~/nginx.conf /etc/nginx/nginx.conf
rm -rf ~/nginx.conf

# Download and acivate configuration (works)
mkdir /etc/nginx/modsec
wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
wget -P /etc/nginx/modsec/ https://github.com/SpiderLabs/ModSecurity/blob/49495f1925a14f74f93cb0ef01172e5abc3e4c55/unicode.mapping
mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf

# Download and load Ruleset (works)
git clone https://github.com/coreruleset/coreruleset /usr/share/modsecurity-crs
mv /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf
mv /usr/share/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example /usr/share/modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf

# Load Rules (works)
echo -e "# From https://github.com/SpiderLabs/ModSecurity/blob/master/\n# modsecurity.conf-recommended\n#\n# Edit to set SecRuleEngine On\nInclude \"/etc/nginx/modsec/modsecurity.conf\"\nInclude \"/usr/share/modsecurity-crs/crs-setup.conf\"\nInclude \"/usr/share/modsecurity-crs/rules/*.conf\"\n" > /etc/nginx/modsec/main.conf

# Enable modsecurity for all sites (works)
for file in /etc/nginx/sites-available/*; do
     sed '/^server.*/a \\tmodsecurity on;\n\tmodsecurity_rules_file /etc/nginx/modsec/main.conf;\n' "${file}" > "${file}1"
     rm "${file}"
     mv "${file}1" "${file}"
done

# restart nginx (to test)
systemctl reload nginx

rm -- "$0"