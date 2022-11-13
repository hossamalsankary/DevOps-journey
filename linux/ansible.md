
## ANSIBLE MODULES, LABS – MODULES – PACKAGES

- ##### install httpd package on web1 node using Ansible’s yum module.
```diff 
---
- hosts: web1
  tasks:
  - name: Install httpd package
    yum: name=httpd state=installed
    
```
- ##### We have an rpm available for wget package on URL http://mirror.centos.org/centos/7/os/x86_64/Packages/wget-1.14-18.el7_6.1.x86_64.rpm. Create a playbook with name wget.yml under ~/playbooks to install that rpm on web1 node using yum module.

```diff 
---
- hosts: web1
  tasks:
  - yum:
      name: http://mirror.centos.org/centos/7/os/x86_64/Packages/wget-1.14-18.el7_6.1.x86_64.rpm
      state: present

```

- ##### nstall unzip package on web1 node. We want to install unzip-5.52 version of this package so before running the playbook make the required changes.

```diff 
---
- hosts: all
  tasks:
    - name: Install unzip package
      yum:
        name: unzip-5.52
        state: present

```
- #####  to install the latest version of iotop package keeps failing. Please fix the issue so that playbook can work.

```diff 

---
- hosts: all
  tasks:
    - name: Install iotop package
      yum:
        name: iotop
        state: latest
```
- ##### We want to install some more packages on web1 node. Create a playbook ~/playbooks/multi-pkgs.yml to install the latest version of sudo package, moreover we already have vsftpd v3.0.2 installed but due to some compatibility issues we want to install vsftpd v2.2.2 so add a task in same playbook to do so.

```diff 

---
- hosts: web1
  tasks:
  - yum: name=sudo state=latest
  - yum: name=vsftpd-2.2.2 state=present allow_downgrade=yes

```

## ANSIBLE MODULES, LABS – MODULES – SERVICES

- ##### make sure httpd service is started on web1 node. You can use

```diff 
---
- name: Start httpd
  hosts: all
  gather_facts: no
  tasks:
    - name: Start httpd service
      service:
        name: httpd
        state: started

```
- ##### We have a playbook ~/playbooks/file.yml to copy a file with a welcome message under httpd server's document root on web1 node. Make changes in the playbook so that httpd server reloads after copying the file, make sure it does not restart the httpd server.

```diff 
---
- hosts: all
  gather_facts: no
  tasks:
    - name: Copy Apache welcome file
      copy:
        src: index.html
        dest: /var/www/html/index.html
    - service:
        name: httpd
        state: reloaded

```

- ##### We would like the httpd service on web1 node to always start automatically after the system reboots. Update the httpd.yml playbook you created earlier with the required changes.


```diff
---
- name: Start httpd
  hosts: all
  gather_facts: no
  tasks:
    - name: Start httpd service
      service:
        name: httpd
        state: started
        enabled: true

 ```
 
 - ##### We created a playbook ~/playbooks/config.yml to enable port 443 for httpd on web1 node as we want to run nginx on the default port 80 so port 80 needs to be free. Make changes in the playbook so that httpd service restarts after making these change.

 ```diff 
 ---
- hosts: all
  gather_facts: no
  tasks:
    - name: Make changes in Apache config
      replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: "^Listen 80"
        replace: "Listen 443"

    - name: Restart Apache
      service:
        name: httpd
        state: restarted
 
 ```

 - ##### Create a playbook ~/playbooks/nginx.yml to install nginx on web1 node and make sure nginx service is started and should always start even after the system reboots.

 ``` diff
 
 ---
- hosts: all
  gather_facts: no
  tasks:
    - name: Install nginx
      yum:
        name: nginx
        state: present

    - name: Start and enable Nginx
      service:
        name: nginx
        state: started
        enabled: yes
        
  ```