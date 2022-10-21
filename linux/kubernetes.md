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
# result
! nginx                             1/1     Running   0          85s

# now delete this pod
+ kubectl delete pod nginx

```
<p align="left">
 <img src="/images/pod1.png" alt="Permissions" width="100%%" height="100%%" />
</p>

### Create Pod With YUML file
```diff 
@@@
#For now since we are working on
#PODs, we will set the apiVersion as v1. Few other possible values for this field are
#apps/v1beta1, extensions/v1beta1 etc
apiVersion: v1 
kind: Pod
metadata:
  name: myapp-pod # the pod name
  labels: # this can be any thing we used labels to define the pods
          # labe help us to control all pods have the same name
    app: myapp  
    type: front-end
spec: 
  containers: # define the container name and the image
    - name: nginx-container
      image: nginx

# this the same like (kubectl run nginx –-image nginx)
@@@
# now run 
+ kubectl create -f filename.yuml 

# resale
! pod/myapp-pod created
```
### - you can find this template here [link](templatets/pod_wth_yuml.yml)


### Replica set
###### So what is a replica and why do we need a replication controller?
 we had a single POD running our application. What if for some
reason, our application crashes and the POD fails? Users will no longer be able to
access our application. To prevent users from losing access to our application, we
would like to have more than one instance or POD running at the same time. That
way if one fails we still have our application running on the other one. The replication
controller helps us run multiple instances of a single POD in the kubernetes cluster
thus providing High Availability.
So does that mean you can’t use a replication controller if you plan to have a single
POD? No! Even if you have a single POD, the replication controller can help by
automatically bringing up a new POD when the existing one fails.
###### replica can help us in
- ###### Load Balancing & Scaling
- ###### High Availability

<p align="left">
 <img src="/images/replica.jpg" alt="Permissions" width="100%%" height="100%%" />
</p>

### Define Replica set

```diff
apiVersion: apps/v1 #The apiVersion though is a bit different. It is apps/v1 which is different from
                    #what we had before for replication controller
kind: ReplicaSet
metadata:
  name: replicationcontroller
  labels:
    app: myapp
    type: front-end
spec:
  template: # there we provide the pod template to tell replicaset 
            # used this temple in case any pod goes down
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end # notice we will give tis label to selector to identify  
    spec:
      containers:
        - name: nginx-container
          image: nginx

  replicas: 3 
  selector:
   matchLabels:
       type: front-end  # by givin this selector label. we tell replicasets if you fond and 
                        # pods have this label join it to our replicasets


```
### - you can find this template here [link](templatets/replica_set.yml)
```diff 
# now run this template 
+ kubectl create -f replica_set.yml 

# result should be like that
! replicaset.apps/replicationcontroller created

# let's inspect how many pods we have
+ kubectl get pods
```
<p align="left">
 <img src="/images/replacasete.png" alt="Permissions" width="100%%" height="100%%" />
</p>

```diff 
# result replicationcontroller-425wj       1/1     Running   0          27m
# we have 3 pods  and if you try to delete any pod replicaset going to create 
# new one for you and thats what High Availability mean 

+ kubectl delete pod replicationcontroller-425wj 

#result
! replicationcontroller-bt824       0/1     ContainerCreating   0          3s
```
<p align="left">
 <img src="/images/repsetDEL.png" alt="Permissions" width="100%%" height="100%%" />
</p>
