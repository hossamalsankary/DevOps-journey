# Essential Commands

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
- #####  Creating Files and Directories

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
- #####  Change File Permissions
<p align="left">
 <img src="/images/premissions.jpg" alt="Permissions" width="100%" height="50%" />
</p>

```diff
! cp [source] [dest] 
# Copy File to home 
+ cp note.txt ~/

# copy the moon directory to home
+ cp -R moon ~/

# notice f to want to copy folder you have to used -R 
#  -R, -r, --recursive          copy directories recursively


! mv [source] [dest] 
# Move Files and Directory 

+ mv note.txt ~/

# Move the moon directory to home
+ mv -R moon ~/

```