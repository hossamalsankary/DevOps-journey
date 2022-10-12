# Notes_for_linux
```diff
# users
@@ create eexpir date for user jane @@
+ sudo usermod --expiredate  March 1, 2030   jane 
```
```diff

@@ Create a system account called apachedev @@
+ sudo useradd --system apachedev
```
```diff

@@ Jane's account i.e jane is expired.Unexpire the same and make sure it never expires again. -e, --expiredate EXPIRE_DATE  set account expiration date to EXPIRE_DATE @@
+ sudo usermod -e "" jane
```
```diff

@@ Create a user account called jack and set its default login shell to be /bin/csh. @@
+ sudo useradd --shell /bin/csh jack

```
```diff

@@ Delete the user account called jack and ensure his home directory is removed. @@
+ sudo userdel --remove jack

```
```diff

@@ Mark the password for jane as expired to force her to immediately change it the next time she logs in. @@
+ sudo chage -d '0' jane

```
```diff

@@ Add the user jane to the group called developers. @@
+ sudo usermod -a -G developers jane

```
```diff

@@ Create a group named cricket and set its GID to 9875 @@
+sudo groupadd --gid 9875 cricket

```
```diff


@@ You already created group cricket in the previous question, now rename this group to soccer while preserving the same GID. @@

+ sudo groupmod -n soccer cricket

```
```diff

@@ Create a user sam with UID 5322, also make it a member of soccer group. @@
+ sudo useradd -G soccer sam  --uid 5322

```
```diff

@@ Update primary group of user sam and set it to rugby @@
+ sudo usermod -g rugby sam

```
```diff

@@ Lock the user account called sam @@
+ sudo usermod --lock sam

```
```diff

@@ appdevsDelete the group called appdevs. @@
+ sudo groupdel appdevs

```
```diff

@@ Make sure the user jane gets a warning at least 2 days before the password expires@@ 
+ sudo chage -W 2 jane

```