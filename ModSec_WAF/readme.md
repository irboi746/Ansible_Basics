# Modsecurity WAF
* The below guide will teach us how to install modsecurity for both Apache and Nginx web servers. 
* For the Apache set-up I will be installing DVWA into it.

## Apache Set-Up
### DVWA set up
* The reference below was used to setup DVWA.

### Modsecurity Set-Up: 
* Installing Modsecurity 
```
sudo apt install libapache2-mod-security2
cp /etc/modsecurity/modsecurity.conf.recommended /etc/modsecurity/modsecurity.conf

```

* Mod Security Logs are located in var/log/apache2/modsec_audit.log
* To test if it is logging : 
```
sudo tail -f var/log/apache2/modsec_audit.log
```
   * refresh webpage and we should see that request is logged

### References : 
[DVWA set-up](https://medium.datadriveninvestor.com/setup-install-dvwa-into-your-linux-distribution-d76dc3b80357)
[Set-Up ModSecurity](https://phoenixnap.com/kb/setup-configure-modsecurity-on-apache)
[Setting Up DVWA with Modsecurity](https://digi.ninja/blog/modsecurity_lab.php)

## Nginx Set-Up


## Ansible Playbook


