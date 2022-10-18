1. [Read and Use System Documentation]([https://github.com/hossamalsankary/DevOps-journey/edit/main/linux/LinuxCommands.md#Essential--Commands](https://github.com/hossamalsankary/DevOps-journey/edit/main/linux/LinuxCommands.md#read-and-use-system-documentation))
2. [Search For Files ](https://github.com/hossamalsankary/DevOps-journey/edit/main/linux/LinuxCommands.md#search-for-files)
3. [Search for txt inside flies](https://github.com/hossamalsankary/DevOps-journey/edit/main/linux/LinuxCommands.md#search-for-txt-inside-flies)
4. [Change File Permissions](https://github.com/hossamalsankary/DevOps-journey/edit/main/linux/LinuxCommands.md#change-file-permissions)


### -------------------------------------------------------------------------------------------------------------------------------------

### Read and Use System Documentation

- ##### Read and Use System Documentation
```diff
# for simple help we can used this command 
+ ls --help

# Manual Pages With man Command
+ man ls

# Searching For Commands - apropos serching about command you don't know
+ apropos "copy file"

# Using TAB  you can used TAB to auto suggestion
+ mkd (than press TAB) >> auto suggestion will show (mkdir) command
```
- ##### Working With Files and Directories 

```diff
# show help
+ ls --help
# Listing Files and Directories
+ ls 

# Listing all
+ ls -a

# Listing all with use a long listing format and sort by file size, largest first 
+ ls -alSh

```
- #####  Move Around In The System

```diff
# The root directory in linux is  /  let's move to  root 
+ cd /

# show 
+ ls -al

# print name of curren
+ pwd

# Now move to home
+ cd /home

# Then go back again to root
+ cd ..

```
- ##### Creating Files and Directories

```diff
# Create directory  name moon 
+ mkdir moon

# Creating Files
+ touch note.txt

```
- #####  Copy and move files

```diff
! cp [source] [dest] 
# Copy File to home 
+ cp note.txt ~/

# copy the moon directory to home
+ cp -R moon ~/

# notice f to want to copy folder you have to used -R 
#  -R, -r, --recursive          copy directories recursively

# -------------------------------------------------------------

! mv [source] [dest] 
# Move Files and Directory 

+ mv note.txt ~/

# Move the moon directory to home
+ mv -R moon ~/

```

### -------------------------------------------------------------------------------------------------------------------------------------
### Search for Files
```diff
! find [/path/to/directory] [search_parameters] 
# lookup for exact name
! find [/path/to/directory] -name [name] 

+ find /bin/ -name 'ssh'

# looking for  and file contain "ss" in the first of the file name
+ find /bin/ -name '*ss'

# looking for  and file contain "ss" in the last of the file name
+ find /bin/ -name 'ss*'

# looking for file or directory with Modification time 
! find [/path/to/directory] -mmin [minute] 

# we need to do some set-up to test modification run this code
+ mkdir modification && touch modification/test modification/tus modification/ret && echo 'hello' > modification/test 

# now let's have fun
+ find modification/ -mmin 1  #get all files that last modified in Exactly  1 minute
+ find modification/ -mmin -1  #get all files that last modified between now and last 1 minute
+ find modification/ -mmin +1  #get all files that last modified before   1 minute

! notice 
! Modification = Create or Edit
! Modified Time != Change Time

+  find modification/ -mtime 2

# Change Time
+  find modification/ -cmin 2 


# Search ParametersModified Time

# Search Parameters – File Size
! find -size [size]

! c bytes
! k kilobytes
! M megabytes
! G gigabytes

# Exactly 512 kb
+ find -size 512k 

# Greater than 512 kb
+ find -size +512k 

+ find -size -512k # Less than 512 kb
# Search for file name != test
+ find  modification/ -type f -not -name "test" 


! Permissions: 664 = u+rw,g+rw,o+r
# find files with exactly 664 permissions
+ find /usr/bin/ -perm 664

# find files with at least 664 permissions
+ find /usr/bin/ -perm -664

# find files with any of these permissions
+ find /usr/bin/ -perm /664

# find files with exactly 664 permissions
+ find /usr/bin/ -perm u=rw,g=rw,o=r

# find files with at least 664 permissions
+ find /usr/bin/ -perm –u=rw,g=rw,o=r

# find files with any of these permissions
+ find /usr/bin/ -perm /u=rw,g=rw,o=r
```
### -------------------------------------------------------------------------------------------------------------------------------------
### Search for txt inside flies
 - ###### Searching With Grep
 ```diff 
 ! grep [options] ‘search_pattern’ file

 # if you are using CentOS Linux  try this
 + grep 'CentOS' /etc/os-release
 
 # with --ignore-case or -i  now  ignore case distinctions
  + grep --ignore-case 'CentOS' /etc/os-release

 # with  --recursive  or -r  search in all files inside directories
  + grep --recursive   'CentOS' /etc/

 # with --invert-match  or -v       select non-matching lines
  + grep --invert-match  'CentOS' /etc/os-release

 # with -w, --word-regexp         force PATTERN to match only whole words
 grep --word-regexp  'CentOS' /etc/os-release

 ```
 - ###### Analyze Text With Regular Expressions

 ```diff
# ^ “The line begins with”
+ grep -i '^CentOS' /etc/os-release

# $ “The line ends with”
+ grep  -e '"' /etc/os-release

# . “Match any ONE character”
+ grep   'ce.t' /etc/os-release

# result going to be like this centos >> with . any character could be 
+ grep  -wr 's.h' /etc/

# *: Match The Previous Element 0 Or More Times in this example we tell grep if you found last character its grep it if not grep the word match with "le"
+ grep -r 'let*' /etc/

#'egrep' means 'grep -E'.
# {}: Previous Element Can Exist “this many” Times
! 0{min,max}
 
+ egrep -r '0{3,}' /etc/
! or
+ grep -Er '0{3,}' /etc/

# ?: Make The Previous Element Optional
+ egrep -r 'centos?' /etc/

# {}: Previous Element Can Exist “this many” Times
+ egrep -r '0{3,5}' /etc/ 

# |: Match One Thing Or The Other
+ egrep -ir 'enabled?|disabled?' /etc/

# []: Ranges Or Sets
+ egrep -r 'c[au]t' /etc/
+ egrep -r '/dev/.*' /etc/
+ egrep -r '/dev/[a-z]*[0-9]' /etc/

  ```

#### -------------------------------------------------------------------------------------------------------------------------------------
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

