# Content

- #### [Create, delete, and modify local user accounts]()


## Create, delete, and modify local user accounts
- #### Create new used 
```diff 
+ sudo useradd hossam

# Useradd command will add new user to the system 
-- name: hossam 
-- Group : hossam 
-- home : /home
-- inactive : -1 # that's mean user password won't expire
-- SHELL=/bin/bash #the default shell 
--  SKEL=/etc/skel  # all the files here will drop to the user home 
--  CREATE_MAIL_SPOOL=yes
```