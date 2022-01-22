# Ansible_Basics
* This is a personal documentation on how to use ansible to automate certain processes.
* It will include how to set up control and managed node, install packages on managed node, change configurations in managed node. 

# Setting Up
## Control Node
* In my set-up I will be using Fedora as Fedora's upsteam is REHL where Ansible is a REHL automation platform and it is easier to install Ansible on Fedora or Centos than Ubuntu (what I am used to). 
* Any machine with Python 3.8 or newer installed can be the control node. This includes Red Hat, Debian, CentOS, macOS, any of the BSDs, and so on. Windows is not supported for the control node

### Steps 
### TL;DR
1. Install Ansible  `sudo dnf install ansible`
2. Add nodes into inventory `echo [host IP or FQDN] ansible_connection=ssh ansible_user=[username] >> /etc/ansible/hosts`
3. Check if host are added `ansible --list-host all`
4. Connect to remote nodes

#### 1. Set up Fedora (Desktop or Server)
#### 2. Install ansible
```
sudo dnf install ansible
```

#### 3. Adding host into inventory
* Ansible reads information about which machines you want to manage from your inventory.
* Basic Inventory can be created by editing the `/etc/ansible/host` file. 
* IP addresses and domain names (FQDN) can be added into the inventory.
```
echo 'host IP or FQDN' >> /etc/ansible/hosts
```
* check is hosts are added 
```
ansible --list-host all
```

#### 4. Connecting to remote nodes
* Ansible communicates with remote machines over the SSH protocol. 
* By default, Ansible uses native OpenSSH and connects to remote machines using your current user name, just as SSH does.
* However, the above way of adding user in step 3 will allow ansible to use that specific username to connect to the ssh. 


### References : 
[Ansible Installation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
[Ansbile Control Node Set Up](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
[Connecting to Remote Node](https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#connections)

## Managed Node
* In my set-up, I will be using Ansible to control a Ubuntu Server.
* For most managed nodes, Ansible makes a connection over SSH and transfers modules using SFTP. If SSH works but SFTP is not available on some of your managed nodes, you can switch to SCP
*  Any ansible operation requires python on the target node except the raw and script modules, hence it is recommended to get Python installed on the managed Node using Ansible.

### Steps 


# Task to do 
## Linux
1. Ad-hoc installation
2. Using a playbook

## Windows
* To be researched when there is a need to.
