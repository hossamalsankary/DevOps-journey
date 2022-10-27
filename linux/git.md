# Git command

```diff
-------------------- remote repository -----------------------
|                                                            |
|                                                            |
|                                                            |
|              git push origin master                        |  
|                                                            |
|                                                            |
-------------------------------------------------------------
-------------------------------------------------------------
|                   |                   |                   |
|                   |                   |                   |
|                   |                   |                   |
|     Working       |     Staging       |    Committed      |
|     Area          |     Area          |    Filles         |
|                   |   git add .       | git commit -m " " |    
|  (Edit Files)     |  (git add file)   |                   |
|                   |                   |                   |
-------------------------------------------------------------
 ```

- ###### Initialize Git Repo

```diff 
>  git init

```

- ###### $ Git status

```diff 
>   git status

```

- ###### Add  file to local repo

```diff 
>   git add file_name

# git add change files 
>   git add .  
!  Now we move file from working area to  staging area
```
- ###### Commit add . files

```diff 
> git commit  -m "Add new file "

!  Now we move file from staging area to  Committed filles 

```

- ###### Git all logs  

```diff 

> git logs


```

- ###### Git all logs  in online  

```diff

> git log --oneline

```
- ###### Git remote add origin

```diff

> git remote add origin $url


 ```

 - ######  Push all filles

```diff

> git push origin master
 
!  Now we move file from  Committed Filles to Remote repository

 ```

 - ######  Clone repo

```diff

> git  clone 
 
 ```

- ###### move to clone directory

```diff 
> cd remote-repo

```

- ###### Crate now branch

```diff 
>  git checkout -b go_ branch 

! Switched to a new branch 'go_ branch'

```

```diff 
>  git checkout -b go_ branch 

! Switched to a new branch 'go_ branch'

```

