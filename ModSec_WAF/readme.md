# Modsecurity WAF
* The below guide will teach us how to install modsecurity for both Apache and Nginx web servers. 
   * [Apache](#Apache-Set-Up)
   * [Nginx](#Nginx-Set-Up)
   * [Ansible Playbook](#Ansible-Playbook)

## Apache Set-Up
### Step 1 : DVWA set up
* Check References. 
* There might be some differences due to different version of Ubuntu used, but it is largely the same.

### Step 2 : Modsecurity Set-Up: 
* Installing Modsecurity 
```
sudo apt install libapache2-mod-security2
```
* Turning on Modsecurity
```
cp /etc/modsecurity/modsecurity.conf.recommended /etc/modsecurity/modsecurity.conf
nano /etc/modsecurity/modsecurity.conf
# change SecRuleEngine DetectionOnly ---> SecRuleEngine On
```

* Mod Security Logs are located in var/log/apache2/modsec_audit.log
* To test if it is logging : 
```
sudo tail -f var/log/apache2/modsec_audit.log
```
   * refresh webpage and we should see that request is logged

### Step 3 : Setting Up Owasp CRS on top of Modsecurity
* to be continued : [Set-Up ModSecurity](https://phoenixnap.com/kb/setup-configure-modsecurity-on-apache)

### References : 
[DVWA set-up](https://medium.datadriveninvestor.com/setup-install-dvwa-into-your-linux-distribution-d76dc3b80357)
[Set-Up ModSecurity](https://phoenixnap.com/kb/setup-configure-modsecurity-on-apache)
[Setting Up DVWA with Modsecurity](https://digi.ninja/blog/modsecurity_lab.php)

## Nginx Set-Up


### References : 
[DVWA+Modsecurity on Nginx and Apache](https://ranggaputrapertamapp.medium.com/modsecurity-for-securing-dvwa-served-by-apache2-or-nginx-in-ubuntu-20-04-8e8ce58222a0)
[Set-Up Modsecurity](https://www.tecmint.com/install-modsecurity-nginx-debian-ubuntu/)

## Ansible Playbook


