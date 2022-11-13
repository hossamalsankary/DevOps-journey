
## ANSIBLE MODULES, LABS – MODULES – PACKAGES

- ##### install httpd package on web1 node using Ansible’s yum module.
```diff 
---


  - name: Install httpd package
    yum: name=httpd state=installed
    
```
- ##### We have an rpm available for wget package on URL http://mirror.centos.org/centos/7/os/x86_64/Packages/wget-1.14-18.el7_6.1.x86_64.rpm. Create a playbook with name wget.yml under ~/playbooks to install that rpm on web1 node using yum module.

```diff 
---


  - yum:
      name: http://mirror.centos.org/centos/7/os/x86_64/Packages/wget-1.14-18.el7_6.1.x86_64.rpm
      state: present

```

- ##### nstall unzip package on web1 node. We want to install unzip-5.52 version of this package so before running the playbook make the required changes.

```diff 
---
- hosts: all

    - name: Install unzip package
      yum:
        name: unzip-5.52
        state: present

```
- #####  to install the latest version of iotop package keeps failing. Please fix the issue so that playbook can work.

```diff 

---
- hosts: all

    - name: Install iotop package
      yum:
        name: iotop
        state: latest
```
- ##### We want to install some more packages on web1 node. Create a playbook ~/playbooks/multi-pkgs.yml to install the latest version of sudo package, moreover we already have vsftpd v3.0.2 installed but due to some compatibility issues we want to install vsftpd v2.2.2 so add a task in same playbook to do so.

```diff 

---


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
  - ##### Using an Ansible playbook install firewalld on web1 node, start and enable its service as well. Name the playbook as firewall.yml and keep it under ~/playbooks.

 ```diff 
  ---


   - yum: name=firewalld state=installed
   - service: name=firewalld state=started
  
  ```

  - ##### We have a requirement on web1 node to white list web2 node's IP address 172.20.1.101 in firewall. Create and run a playbook ~/playbooks/whitelist.yml to do so.

```diff 
---

    
   - firewalld:
      source: 172.20.1.101
      state: enabled
      zone: internal
      permanent: yes
      immediate: yes

``` 
- ##### We want to block 161/udp port on web1 node permanently. Make a playbook block.yml under ~/playbooks/ directory to do so.

```diff 
--- 

  - name: Add firewall rule for Apache
     
    firewalld:        
        port: 161/udp
        zone: block
        permanent: yes
        immediate: yes
        state: enabled
```

- ##### On web1 node add firewall rule in internal zone to enable https connection from Ansible controller machine and make sure that rule must persist even after system reboot. You can create a playbook https.yml under ~/playbooks/ directory.

```diff 
---


    - name: Enable HTTPS for ansible controller
      firewalld:
        source: 172.20.1.2
        service: https
        zone: internal
        state: enabled
        permanent: yes

    - service:
        name: firewalld
        state: reloaded

```

- ###### 

```diff 
---


    - name: Enable HTTPS for ansible controller
      firewalld:
        source: 172.20.1.2
        service: https
        zone: internal
        state: enabled
        permanent: yes

    - service:
        name: firewalld
        state: reloaded

```

- ##### A. Add an entry in ~/playbooks/inventory for web2 node, IP address of web2 node is 172.20.1.101 and ssh password and username are same as of web1 (username = root and password = Passw0rd). B. Update web2-config.yml to install httpd before updating its port in config, also start/enable its service. C. Install firewalld package and start/enable its service. D. As now Apache will listen on port 8082 so edit the playbook to add firewall rule in public zone so that Apache can allow all incoming traffic.

```diff
---
- hosts: web2
  tasks:
    - name: Install pkgs
      yum:
        name: httpd, firewalld
        state: present

    - name: Start/Enable services
      service:
        name: "{{ item }}"
        state: started
        enabled: yes
      with_items:
        - httpd
        - firewalld

    - name: Change Apache port
      replace:
        path: /etc/httpd/conf/httpd.conf
        regexp: "Listen 80"
        replace: "Listen 8082"

    - name: restart Apache
      service:
        name: httpd
        state: restarted

    - name: Add firewall rule for Apache
      firewalld:
        port: 8082/tcp
        zone: public
        permanent: yes
        state: enabled
        immediate: true
 ```