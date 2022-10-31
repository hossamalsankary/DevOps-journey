# Content

- #### [Create, delete, and modify local user accounts]()


## Create, delete, and modify local user accounts
- #### Create new used 
```diff 
--  usermod [options] username

# short form
+ sudo useradd hossam

# add ner user with anther shell and directory
+ useradd --shell /bin/bash  --groups root --home-dir /home/bob/ bob

+ useradd --system nginx 

# system account creates no home directory just for the apps

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

# modify user hossam change username 
+ sudo usermod --login new_hossam hossam


# modify user hossam  change home dir
+ sudo usermod --home /home/new_directory --move-home hossam
 
# change user default shell
+ sudo usermod --shell /bin/sh hossam 

# Change password 
+ sudo passwd hossam  

 ```

 - #### locked user account
 ```diff 
#  --lock     lock the user account
+ usemod --locked  hossam 
 
#  --unlock     unlock the user account
+ usemod --unlocked  hossam 
 
# set  expiredate for user
+ usermod --expiredate  2021-12-10 hossam


 ```
