### install httpd package on web1 node using Ansible’s yum module.
```diff 
---
- hosts: web1
  tasks:
  - name: Install httpd package
    yum: name=httpd state=installed
    
```
### We have an rpm available for wget package on URL http://mirror.centos.org/centos/7/os/x86_64/Packages/wget-1.14-18.el7_6.1.x86_64.rpm. Create a playbook with name wget.yml under ~/playbooks to install that rpm on web1 node using yum module.

```diff 
---
- hosts: web1
  tasks:
  - yum:
      name: http://mirror.centos.org/centos/7/os/x86_64/Packages/wget-1.14-18.el7_6.1.x86_64.rpm
      state: present

```

### nstall unzip package on web1 node. We want to install unzip-5.52 version of this package so before running the playbook make the required changes.

```diff 
---
- hosts: all
  tasks:
    - name: Install unzip package
      yum:
        name: unzip-5.52
        state: present

```
###  to install the latest version of iotop package keeps failing. Please fix the issue so that playbook can work.

```diff 

---
- hosts: all
  tasks:
    - name: Install iotop package
      yum:
        name: iotop
        state: latest
```
### We want to install some more packages on web1 node. Create a playbook ~/playbooks/multi-pkgs.yml to install the latest version of sudo package, moreover we already have vsftpd v3.0.2 installed but due to some compatibility issues we want to install vsftpd v2.2.2 so add a task in same playbook to do so.

```diff 

---
- hosts: web1
  tasks:
  - yum: name=sudo state=latest
  - yum: name=vsftpd-2.2.2 state=present allow_downgrade=yes

```