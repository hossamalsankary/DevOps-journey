### -------------------------------------------------------------------------------------------------------------------------------------

### Setup Kubernetes lab

#### Using minikube to setup our lab
##### What you’ll need
- ###### 2 CPUs or more
- ##### 2GB of free memory
- ##### 20GB of free disk space
- ##### Internet connection
- ##### VirtualBox, 
- ##### flow this gide line to setup our lab
```diff 
! https://minikube.sigs.k8s.io/docs/start/

```
### -------------------------------------------------------------------------------------------------------------------------------------

### PODs Again!
Here we see the simplest of simplest cases were you have a single node kubernetes
cluster with a single instance of your application running in a single docker container
encapsulated in a POD. What if the number of users accessing your application
increase and you need to scale your application? You need to add additional
instances of your web application to share the load. Now, were would you spin up
additional instances? Do we bring up a new container instance within the same
POD? No! We create a new POD altogether with a new instance of the same
application. As you can see we now have two instances of our web application
running on two separate PODs on the same kubernetes system or node.
What if the user base FURTHER increases and your current node has no sufficient
capacity? Well THEN you can always deploy additional PODs on a new node in the
cluster. You will have a new node added to the cluster 
- ###### How to run a pods using kubectl
```diff
# lunch pod with nginx container insane 
+ kubectl run nginx –-image nginx

# list all pods 
+ kubectl get pods

```
