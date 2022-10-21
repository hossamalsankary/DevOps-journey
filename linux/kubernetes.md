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

#### =====> [minikube Installation ](https://minikube.sigs.k8s.io/docs/start/)
### -------------------------------------------------------------------------------------------------------------------------------------

## kubernetes architecture
<p align="center">
 <img src="/images/Kub.png" alt="Permissions" width="100%%" height="100%%" />
</p>

### When you install Kubernetes on a system, you're actually installing the following components. In the master

-  kubelet API service:  Kubelet is the agent that runs on each node in the cluster.
-  etcd service: it's the database key value store used by Kubernetes to store all data used to manage the cluster. etcd stores all that information bout all the worker 
-  Schedulers: The Scheduler is responsible for distributing work or containers It looks for newly created containers and assigns them to nodes. 
-  Controllers: They are responsible for noticing and responding when nodes, containers or end points goes down The controllers make decisions to bring up new containers 
- Container Runtime: in such cases. The Container Runtime is the underlying software that is used to run containers.

  
###  following components will install in every nodes or worker
- kubelet agent: this that is responsible for interacting with kubelet API server in the   master to provide   health information of the worker node and carry out actions requested by the Master on the
- Container Runtime: in such cases. The Container Runtime is the underlying software that is used to run containers.
- and other components we talk about it later

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
cluster. You will have a new node added to the cluster.

#### that`s enough now let's have some fun and write command 
###### we assume that you did install minikube and you have kubectl installed
- ###### How to run a pods using kubectl
```diff
# lunch pod with nginx container inside it 
+ kubectl run nginx –-image nginx

# list all pods 
+ kubectl get pods

```
