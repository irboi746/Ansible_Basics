# Ansible_Basics
* This is a personal documentation on how to use ansible to automate certain processes.
* It will include : 
   * [how to set up control and managed node](#Setting-Up)
   * [install packages on managed node](#Installing-Packages-on-Managed-Node)
       * [ad-hoc commands](#Using-ad-hoc-commands)
       * [playbook basics](#Playbook-Basics)
       * [playbook advanced](#Playbook-Advanced) 
   * change configurations in managed node. 

# Setting Up
* In my set-up I will be using Fedora as Fedora's upsteam is REHL where Ansible is a REHL automation platform and it is easier to install Ansible on Fedora or Centos than Ubuntu (what I am used to) and I will also be using Ansible to control a Ubuntu Server.
* Any machine with Python 3.8 or newer installed can be the control node. This includes Red Hat, Debian, CentOS, macOS, any of the BSDs, and so on. Windows is not supported for the control node
* Additionally, ansible operation requires python on the target node except the raw and script modules, hence it is recommended to get Python installed on the managed Node using Ansible.
* For most managed nodes, Ansible makes a connection over SSH and transfers modules using SFTP. If SSH works but SFTP is not available on some of your managed nodes, you can switch to SCP

### Steps 
#### 1. Set up Fedora (Desktop or Server)
* start sshd service
```
/bin/systemctl start sshd.service
```

#### 2. Install ansible
```
sudo dnf install ansible
```

#### 3. Adding host into inventory
* Ansible reads information about which machines you want to manage from your inventory.
* Basic Inventory can be created by editing the `/etc/ansible/host` file. 
* IP addresses and domain names (FQDN) can be added into the inventory.
* By default, Ansible uses native OpenSSH and connects to remote machines using your current user name.
* Method 2 will allow you to use a different username to login
 
```
# by adding [group name] we can call
echo '[group name]' >> /etc/ansible/hosts

# method 1
echo '{Managed Node IP or FQDN}' >> /etc/ansible/hosts

# method 2
echo '{Managed Node IP} ansible_connection=ssh ansible_user={managed-node username}' >> /etc/ansible/hosts
```
* check is hosts are added 
```
# method 1
ansible --list-host all

# method 2
ansible --list-host {group name}
```

#### 4. Connecting to remote nodes
* Ansible communicates with remote machines over the SSH protocol. 
* Thus we will need to set-up a ssh key-pair for connection.
* On Managed Node
   1. Connect to Ansible machine via ssh
* On ansible control node: 
```
# create ssh key and go to the folder
ssh-keygen -t rsa
cd ~/.ssh/

# once ssh connection has been established from managed node 
ssh-copy-id [username]@[ip addres of node]

# to test connection
ansible all -m ping
```

### Script to put all the above together
* Run this and connect all the managed node to control node
```
/bin/systemctl start sshd.service
```
* After using managed node to connect to Control Node
```
#!/bin/sh
dnf install ansible
echo '[group name]' >> /etc/ansible/hosts
echo 'host IP or FQDN' >> /etc/ansible/hosts
ssh-keygen -t rsa
ssh-copy-id [username]@[ip addres of node]
ansible [groupname] -m ping
```

### References : 
* [Ansible Installation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* [Ansbile Control Node Set Up](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
* [Connecting to Remote Node 1](https://docs.ansible.com/ansible/latest/user_guide/connection_details.html#connections)
* [Connecting to Remote Node 2](https://www.youtube.com/watch?v=d6jTzve7mFY)

# Installing Packages on Managed Node
## Using ad-hoc commands
* An Ansible ad hoc command uses the /usr/bin/ansible command-line tool to automate a single task on one or more managed nodes.
* ad hoc commands are quick and easy, but they are not reusable.
### Basic Usage : 
```
# format
ansible {group name} -m {module} -a {arguments}

# example : the below will open a shell and list /home
ansible webserver -m shell -a 'ls /home' 

# running as root
*** Password prompt will appear
# format 
ansible {group name} -m {module} -a {arguments} -b -K 

# example : the below will prompt for a password for root and open a root shell after authentication and list /etc 
ansible webserver -m shell -a 'ls /etc'-b -K
```
### Creating Users
```
# create password hash on control node 
mkpasswd --method=sha-256 

# create user with ansible ad-hoc command
# format 
ansible {group name} -m user -a 'name={username} password="{hash generated}"' -b -K 

#example
ansible webserver -m user -a 'name=test password="$5$u2Ns.7JsOoPUCBfh$jpVxnZ66AkWqd9yIGyUgIsvFbJA1I/jlWsq3FpawyE4"' -b -K 
```

### Installing packages with "apt"
* below is an example of installing packages. Commands to remove and update packages are in the reference link provided.
```
#example
ansible webserver -m apt -a "name=mlocate state=present" -b -K
```

### References : 
* [ad-hoc command basics](https://www.middlewareinventory.com/blog/ansible-ad-hoc-commands/#ex5)
* [ad-hoc command create users 1](https://www.middlewareinventory.com/blog/ansible-ad-hoc-commands)
* [ad-hoc command create users 2](https://www.youtube.com/watch?v=pr0ZA6pw-jU)
* [managing packages](https://docs.ansible.com/ansible/2.5/user_guide/intro_adhoc.html#managing-packages)

## Using Playbook
* At a basic level, playbooks can be used to manage configurations of and deployments to remote machines.
* It is a set of instructions to tell ansible what to do much like a bash script.
* Playbooks are in YAML format. Wihtin one playbook it can contain multiple plays.

### Playbook Basics 
#### Format
```
- 
   name : {name of playbook}
   become : {true or false}
   hosts : {group name, IP addresses or FQDN}
   tasks :
      - name : {name for task} 
      - {task : command, script, apt, service} : {parameters needed}
```
#### Example 
```
- 
   name : install LAMP stack
   become : true
   hosts : webserver
   tasks : 
      - name : install apache2
        apt : 
           name : apache2
           state : present
      
      - name : allow apache in ufw
        command : ufw allow in "Apache"
```

### Executing Playbook
1. `YAML` file can be saved anywhere.
2. Commands to run playbook: 
```
anisble-playbook {path to `yaml`} -K 
```

### Playbook Advanced
#### Roles
#### Vars

### References : 
* [Playbook Basics](https://www.youtube.com/watch?v=Z01b9QZG0D0)
* [Intro to Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)

