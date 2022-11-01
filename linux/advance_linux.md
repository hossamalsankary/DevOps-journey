# Content

- #### [Create, delete, and modify local user accounts]()
- #### [Change File Permissions](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/advance_linux.md#change-file-permissions-1)

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
+ usermod --gid  dev  hossam
-- hossama : dev

#  Remove USER from GROUP
+ sudo gpasswd --delete dev hossam
# resale
# update  group name 
+ groupmod ---new-name dev developers

# delete group 
+ sudo groupdel developers
 ```
 #### 
-------------------------------------------------------------------------------------------------------------------------------------
### Change File Permissions
<p align="left">
 <img src="/images/Files-permissions.png" alt="Permissions" width="50%" height="40%" />
</p>

```diff
# Let's understand what is prmissions in linux
# if you try to get into file or read file and you don't have permission to do that 
# you will face this problem Permission denied
! try this with me 
# mkdir with permission red only
+ mkdir denied && chmod u=r , g=r , o=r denied

# now let's try to get into this file 
+ cd denied
# it will show this  Permission denied 
```
<p align="left">
 <img src="/images/perm1.png" alt="Permissions" width="80%" height="50%" />
</p>

```diff
# now let's understand what just happen

! r > read
! w > write
! x > execute
! u > user permission
! g > group permission
! o > other permission

! chmod [OPTION] [MODE]  [FILE]
# give permission execute to   denied  directory excute  permission
+ chmod u+x denied/

# now you can  get in to directory
```

<p align="left">
 <img src="/images/perm2.png" alt="Permissions" width="50%" height="38%" />
</p>

```diff
! useing = mean that you wnat give this permission only for user and group and other
+ chmod u+rw,g-r,o=r denied 

! useing - mean that you wnat remove this permission  from user and group and other
+ chmod u-r,g-r,o-r denied 

! useing + mean that you wnat add this permission  for user and group and other
+ chmod u+r,g+r,o+r denied 

! adding +r means that you want to add execute prem for all
+ chmod +x denied 

```
##### Octal Permissions
<p align="left">
 <img src="/images/Octal Permissions.png" alt="Permissions" width="50%" height="40%" />
</p>

```diff
! r = 4
! w = 2
! x = 1

# so we can used Octal Permissions
+ chmod u+rw,g-r,o=r denied  =>>  chmod 641 denied
+ chmod u+x denied  ==> chmod 100 denied


```
<p align="left">
 <img src="/images/last.png" alt="Permissions" width="50%" height="50%" />
</p>



