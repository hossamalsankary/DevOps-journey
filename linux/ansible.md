

# Content 
 <img src="/images/ansiblebg.jpg" alt="Permissions" width="200" align="right" />

- ##### [ANSIBLE MODULES, LABS – MODULES – PACKAGES](https://github.com/hossamalsankary/Notes-for-devops/blob/main/linux/ansible.md#ansible-modules-labs--modules--packages-1)  
- ##### [ANSIBLE MODULES, LABS – MODULES – SERVICES](https://github.com/hossamalsankary/Notes-for-devops/blob/main/linux/ansible.md#ansible-modules-labs--modules--services-1)  
- ##### [ANSIBLE MODULES, LABS – MODULES – FILECONTENT](https://github.com/hossamalsankary/Notes-for-devops/blob/main/linux/ansible.md#ansible-modules-labs--modules--filecontent-1)  
- ##### [ANSIBLE MODULES, LABS – MODULES – ARCHIVING](https://github.com/hossamalsankary/Notes-for-devops/blob/main/linux/ansible.md#ansible-modules-labs--modules--archiving-1)  
- ##### []()  
- ##### []()  
- ##### []()  

# ----------------------------------------------------  ^__^ ------------

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

 ## ANSIBLE MODULES, LABS – MODULES – FILECONTENT

- ##### Create a playbook ~/playbooks/perm.yml to create a blank file /opt/data/perm.txt with 0640 permissions on web1 node.

```diff 
---
- name: Create file perm.txt
  hosts: web1
  tasks:
   - name: Create file perm.txt
     file: path=/opt/data/perm.txt mode=0640 state=touch
```

- ##### Using a playbook ~/playbooks/index1.yml create /var/www/html/index.html file on web1 node with content This line was added using Ansible lineinfile module!.

```diff 
---
- name: Create index.html on web1
  hosts: web1
  tasks:
  - lineinfile:
      path: /var/www/html/index.html
      line: 'This line was added using Ansible lineinfile module!'
      create: yes
```
- ##### We have a playbook ~/playbooks/find.yml that recursively finds files in /opt/data directory older than 2 minutes and equal or greater than 1 megabyte in size. It also copies those files under /opt directory. However it has some missing parameters so its not working as expected, take a look into it and make appropriate changes.


```diff 
---
- hosts: web1
  tasks:
    - name: Find files
      find:
        paths: /opt/data
        age: 2m
        size: 1m
        recurse: yes
      register: file

    - name: Copy files
      command: "cp {{ item.path }} /opt"
      with_items: "{{ file.files }}"

```

- ###### In /var/www/html/index.html file on web1 node add some additional content using blockinfile module. Below is the content:Welcome to KodeKloudb This is Ansible Lab. Make sure user owner and group owner of the file is apache, also make sure the block is added at beginning of the file. Create a new playbook for this ~/playbooks/index2.yml

```diff 
---
- name: Add block to index.html
  hosts: web1
  tasks:
   - blockinfile:
      owner: apache
      group: apache
      insertbefore: BOF
      path: /var/www/html/index.html
      block: |
       Welcome to KodeKloud!
       This is Ansible Lab.
```

- ###### On web1 node we want to run our httpd server on port 8080. Create a playbook ~/playbooks/httpd.yml to change port 80 to 8080 in /etc/httpd/conf/httpd.conf file using replace module. Also make sure Ansible restarts httpd service after making the change.Listen 80 is the parameter that need to be changed in /etc/httpd/conf/httpd.conf

```diff 
---
- name: replace port 80 to 8080
  hosts: web1
  tasks:
  - replace:
      path: /etc/httpd/conf/httpd.conf
      regexp: 'Listen 80'
      replace: 'Listen 8080'
  - service: name=httpd state=restarted
```

## ANSIBLE MODULES, LABS – MODULES – ARCHIVING
- ##### Create an inventory file under ~/playbooks directory on Ansible controller host and add web1 as managed node. IP address of the web1 node is 172.20.1.100, SSH user is root and password is Passw0rd.Create a playbook ~/playbooks/zip.yml to make a zip archive opt.zip of /opt directory on web1 node and save it under /root directory on web1 node itself.

```diff 
---
- name: Zip archive opt.zip
  hosts: web1
  tasks:
   - archive:
       path: /opt
       dest: /root/opt.zip
       format: zip

```
- ##### On Ansible controller, we have a zip archive local.zip. We want to extract its contents on web1 under /tmp directory. Create a playbook local.yml under ~/playbooks directory to complete the task.

``` diff 
---
- name: extract local.zip to web1
  hosts: web1
  tasks:
  - unarchive:
      src: local.zip
      dest: /tmp

```

- ###### On web1 node we have an archive data.tar.gz under /root directory, extract it under /srv directory by developing a playbook ~/playbooks/data.yml and make sure data.tar.gz archive is removed after that.

```diff 
---
- name: Extract data.tar.gz on web1
  hosts: web1
  tasks:
  - unarchive:
      src: /root/data.tar.gz
      dest: /srv
      remote_src: yes

  - file: path=/root/data.tar.gz state=absent


```

- ###### Create a playbook download.yml under ~/playbooks directory to download and extract the https://github.com/kodekloudhub/Hello-World/archive/master.zip zip archive under /root directory on the web1 node.

```diff 
---
- name: Download and extract from URL
  hosts: web1
  tasks:
  -   unarchive:
       src: https://github.com/kodekloudhub/Hello-World/archive/master.zip
       dest: /root
       remote_src: yes
```
- ###### We have three files on web1 node /root/file1.txt, /usr/local/share/file2.txt and /var/log/lastlog. Create a bz2 archive of all these files and save it under /root directory, name the archive as files.tar.bz2. You can create ~/playbooks/files.yml playbook for it.

```diff 
- name: Compress multiple files
  hosts: web1
  tasks:
  - archive:
     path:
      - /root/file1.txt
      - /usr/local/share/file2.txt
      - /var/log/lastlog
     dest: /root/files.tar.bz2
     format: bz2

```
- ###### We want to setup nginx on web1 node with some sample html code. Create a playbook ~/playbooks/nginx.yml to do so. Below are the details about the task:a. Install nginx package and start/enable its service.b. Extract /root/nginx.zip archive under /usr/share/nginx/html directory.c. Inside /usr/share/nginx/html/index.html replace line This is sample html code with line This is KodeKloud Ansible lab.

```diff 

- name: Install and configure nginx on web1
  hosts: web1
  tasks:
  - name: Install nginx
    yum: name=nginx state=installed
  - name: Start nginx
    service: name=nginx state=started enabled=yes

  - name: Extract nginx.zip
    unarchive: src=/root/nginx.zip dest=/usr/share/nginx/html remote_src=yes

  - name: Replace line in index.html
    replace:
     path: /usr/share/nginx/html/index.html
     regexp: This is sample html code
     replace: This is KodeKloud Ansible lab
```

## ANSIBLE MODULES, LABS – MODULES – SCHEDULED TASKS

- ###### Create a playbook ~/playbooks/lastlog.yml to add a cron job Clear Lastlog on node00 to empty the /var/log/lastlog logs file. The job must run at 12am everyday.You can use the command echo “” > /var/log/lastlog to empty the lastlog file and schedule should be 0 0 * * *.

```diff 
---
- name: Create a cron job to clear last log
  hosts: node00
  tasks:
   - name: Create cron job
     cron:
       name: "Clear Lastlog"
       minute: "0"
       hour: "0"
       job: echo "" > /var/log/lastlog
```

- ##### We have a script /root/free.sh on node00 that is used to check the free system memory. We would like to create a cron Free Memory Check to execute this script after every 2 hour (i.e 12am, 2am, 4am etc), the command to execute the script is sh /root/free.sh and schedule should be 0 */2 * * *.You can create a playbook ~/playbooks/script_cron.yml for this.

```diff 
---
- name: Create a cron job to run free.sh script
  hosts: node00
  tasks:
   - name: Create cron job
     cron:
       name: "Free Memory Check"
       minute: "0"
       hour: "*/2"
       job: "sh /root/free.sh"
```

- #### Due to some disk space limitations, we want to cleanup the /tmp location on node00 host after every reboot. Create a playbook ~/playbooks/reboot.yml to add a cron named cleanup on node00 that will execute after every reboot and will clean /tmp location.The command should be rm -rf /tmp/*.

```diff 
---
- name: Cleanup /tmp after every reboot
  hosts: node00
  tasks:
   - cron:
      name: cleanup
      job: rm -rf /tmp/*
      special_time: reboot

```
- ###### On node00 we want to keep the installed packages up to date, so we would like to run yum updates regularly. Create a playbook ~/playbooks/yum_update.yml and create a cron job as described below:a. Do not add cron directly using crontab instead create a cron file /etc/cron.d/ansible_yum.b. The cron must run on every Sunday at 8:05 am.c. The name of the cron must be yum update.d. Cron should be added for user rootUse command yum -y update

```diff
---
- name: Create cron for yum
  hosts: node00
  gather_facts: no
  tasks:
    - name: Creates a cron
      cron:
        name: yum update
        weekday: 0
        minute: 5
        hour: 8
        user: root
        job: "yum -y update"
        cron_file: ansible_yum
 ```
 