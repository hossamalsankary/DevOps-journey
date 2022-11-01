# Content

- #### [Create, delete, and modify local user accounts]()


## Create, delete, and modify local user accounts
- #### Create new used 
```diff 
--  usermod [options] username

# Short form
+ sudo useradd hossam

# Add ner user with anther shell and directory
+ useradd --shell /bin/bash  --groups root --home-dir /home/bob/ bob

+ useradd --system nginx 

# System account creates no home directory just for the apps

# Useradd command will add new user to the system 
-- name: hossam 
-- Group : hossam 
-- home : /home
-- inactive : -1 # that's mean user password won't expire
-- SHELL=/bin/bash #the default shell 
--  SKEL=/etc/skel  # all the files here will drop to the user home 
--  CREATE_MAIL_SPOOL=yes
```

- #### Create passwd for the new user hossam

```diff
+ sudo passwd hossam 
 ```

 - #### modify user hossam 
```diff

# Modify user hossam change username 
+ sudo usermod --login new_hossam hossam


# Modify user hossam  change home dir
+ sudo usermod --home /home/new_directory --move-home hossam
 
# Change user default shell
+ sudo usermod --shell /bin/sh hossam 

# Change password 
+ sudo passwd hossam  

 ```

 - #### locked and expire user account 
 ```diff 
# With Locked user can't login into the system but with SSH key still connecting
#  --lock     lock the user account
+ sudo usermod --lock hossamalsankary

# Now display this user status
+ sudo usermod --lock hossamalsankary
#Result
-- hossamalsankary LK 2022-10-31 0 99999 7 -1 (Password locked.)

 
#  --unlock     unlock the user account
+ usemod --unlocked  hossam 

# Expiredate will block all access methods that use PAM to authenticate a user. 
# Set  expiredate for user
+ usermod --expiredate  2021-12-10 hossam

#OR
+ chagn --expiredate  2021-12-10 hossam

# To make user account expire now
+  sudo usermod --expiredate 0 hossamalsankary

# To make passwd expire
+ sudo passwd --expire 0 hossamalsankary


# To see all change happen to this user
+  sudo chage --list hossamalsankary 

 ```

 - #### Groups 
 
```diff
# Crate new group 
+ sudo groupadd dev

# Append user to group
+ sudo usermod --groups dev hossam 
#or
+ sudo gpasswd -a hossam dev

# Force use GROUP as new primary group

app

#  Remove USER from GROUP
+ sudo gpasswd --delete dev hossam
# resale
+ usermod --gid  dev  hossam
-- hossama : dev
# update  group name 
+ groupmod ---new-name dev developers

# delete group 
+ sudo groupdel developers
 ```