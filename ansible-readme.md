## Let's learn the Ansible
## Table of Contents

* [What is it](#what-is-it)
* [How it works](#how-it-works)
* [How to install](#how-to-install)
* [Directory structure](#directory-structure)
* [How to execute ansible](#how-to-execute-ansible)
	- [using ad-hoc commands](#using-commands)
		- examples:
	- [using playbooks](#using-playbooks)
		- examples:
* [Inventory file](#inventory-file)
	- What is it?
	- examples
* [Ansible playbook keywords](#ansible-playbook-keywords)
	- name:
	- hosts:
	- vars:
	- vars_file:
	- vars_prompt:
	- remote_user
	- become
	- become_user
	- become_method
	- ignore_errors
	- include_vars:
	- include_tasks:
	- include:
	- import_tasks:
	- import_playbook:
	- tasks:
* Loops:
	- what are loops?
	- types:
		- examples
* Condition:
* [Variables](#variables)
	- types
	- where we can define
	- how to call
* Handler
* Template
* Roles

### What is it<a name="what-is-it"></a>
Ansible is a configuration tool. It is used to automate the daily tasks on multiple servers.
### How it work<a name="how-it-works"></a>
It is agent free tool. It works via ssh. It copy its modules to remote server, execute them and wipe them after execution.
### How to install<a name="how-to-install"></a>
Install on Ubuntu ```apt install ansible```

Install on CentOS ```sudo dnf install ansible```
	
### Directory structure<a name="directory-structure"></a>
Main configurations are written in /etc/ansib/ansible.cfg file

### How to execute ansible<a name="how-to-execute-ansible"></a>
---
**Using ad-hoc commands**<a name="using-commands"></a>

We can directly execute simple tasks via runing the ansible commands like, see the uptime, disk space, ram etc 

***syntax***

```ansible <target host> -m <module> -a '<arguments>'```

***Examples***

* ansible localhost  -m ping
* ansible qa -i invenrory -m shell -a 'df -h'
* ansible qa -i invenrory -m shell -a 'ls /opt' -u munawar --become --ask-become-pass
* ansible qa -i inventory -m copy -a 'src=/home/munawar/ansible/modules/files-modules/copy/file1.txt dest=/home/munawar/test/'
* ansible qa -i inventory -m fetch -a 'src=/home/munawar/date.sh dest=/home/munawar/remote-ansible/'

---
**Using playbooks**<a name="using-playbooks"></a>

We can run multiple tasks at same time on multiple servers using a .yml file called playbook.

***Examples***

sudo vim first-playbook.yml

```
---
- name: This is my first playbook
  hosts: qa
  tasks:
  - name: "copy file to remote server"
    copy:
     src: ./index.html
	 dest: /tmp/
```
---

**Inventory File**<a name="inventory-file"></a>

Inventory file is the file where we define the target's details where we have to execute our playbook. In this we can define IP address of target machine or we can define FQDNS and we also can give multiple arguments like ansible_ssh_port=3333, ansible_ssh_user=ansible etc

***Examples***

Following is very very basic file.

sudo vim inventory_file
```
[qa]
webserver1
webserver2
webserver3
```
**Ansible playbook keywords**<a name="ansible-playbook-keywords"></a>

There are multiple keywords which can be define in any playbook according to the requirements. Some are below

- ***name:*** Identifier. Can be used for documentation, or in tasks/handlers.
- ***hosts:*** A list of groups, hosts or host pattern that translates into a list of hosts that are the play’s target.
- ***vars:*** Dictionary/map of variables
- ***vars_files:*** List of files that contain vars to include in the play.
- ***vars_prompt:*** list of variables to prompt for
- ***remote_user:*** User used to log into the target via the connection plugin. This user will be used for ssh from Control machine to Managed machine. E.g when we execute an ansible command/ansible playbook, remote_user will be used to ssh the remote_server. By default ansible expect kerta ha k jis user ny command ya playbook run ki ha wo hi user remote machine p bhi ho ga. is liye remote_user use kerty hain. e.g Ma playbook execute ker raha hon munawar user sy lekin target machine p munawar user nai ha to jo user hum remote_user man den gy us user sy ssh ho ga.
- ***becom:*** Boolean that controls if privilege escalation is used or not on Task execution. Ager hum yes den gy to iska mtlab ha k remote machine p tasks sudo rights ky sath execute hon gy. Its means switch your user from remote_user to root user (by default when we use become: yes our ssh user will be switched to root user )
- ***become_user:*** User that you ‘become’ after using privilege escalation. The remote/login user must have permissions to become this user. Its mean when we execute ansible playbook from control node, its ssh connection will be established with remote_user and all the tasks will be performed through that remote_user but I want to change the user, I want that a specific task should be perfromed with different user so I will use become_user: username
- ***become_method:*** Which method of privilege escalation to use (such as sudo or su). e.g become_method: sudo, with this our remote_user will be switched to root user with sudo method. eg. as we do sudo -s to switch our normal user as root user

**Variables**<a name="variables"></a>

Variables are used to make the things dynamic, to store the values and use that value at multiple places to avoid hard coded.

***Types of variables***

Two types of variables

	- built-in variables
		e.g inventory_hostname, groups, group_names etc
	- user defined variables
		e.g var=1.2, var2=4
		
***where we can define***

	1- in playbooks
	2- pass via command lines
	3- in inventory files

* ***Types of variables***

	- String Type
	
			- var1: Munawar Raza
			- var2: Hello how are you?
		
	- list/array type variable
	
			var:
			- Munawar
			- Haseeb
			- Shami
		
	- mapping/dictionary type variable
		
			users:
			- name: munawar
			  pwd: test
			  uid: 1011
			- name: haseeb
			  pwd: test2
			  uid: 1012

* ***How to call variables***

	- How to call string variable
	
			- msg: "{{ var1 }}"
			- msg: "{{ var2 }}"

	- How to call list/array variables
	
			- msg: "{{ var[0] }}"
			- msg: "{{ var[1] }}"

	- How to call dictionary variable

			- msg: "{{ users['name'] }}"
			- msg: "{{ users['uid'] }}"
			
* ***How import variables file***

	```
	vars_files:
	- ~/ansible-practice/my_variables.yml
	```

***Examples calling variables***

* ***list/array variables***

		---
		- name: Examples of list/array variables
		  hosts: all
		  vars:
			myvars:
			  - nginx
			  - zsh
			  - sshd
		  tasks:
		  - name: List the variables
			debug:
			  msg: "{{ myvars }}"
		  - name: use of array
			debug:
			  msg: "{{ myvars[1] }}"


* ***map/dictionay variables***

		---
		- name: Examples of Mapping/dictionary variables
		  hosts: all
		  tasks:
		  - name: Create user using user module
			user:
			  name: "{{ item.name }}"
			  uid: "{{ item.uid }}"
			  group: "{{ item.group }}"
			  state: present
			loop:
			- name: test3
			  uid: 1011
			  group: wheel
			- name: test4
			  uid: 1012
			  group: wheel
