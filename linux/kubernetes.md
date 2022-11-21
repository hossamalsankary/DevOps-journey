# content
- #### [Setup Kubernetes lab](https://github.com/hossamalsankary/DevOps-journey/blob/master/linux/kubernetes.md#setup-kubernetes-lab-1)
- #### [Kubernetes architecture](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/kubernetes.md#kubernetes-architecture-1)
- #### [Pods Again](https://github.com/hossamalsankary/DevOps-journey/edit/main/linux/kubernetes.md#pods-again-1)
- #### [Replica set](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/kubernetes.md#replica-set-1)
- #### [Replica Set Commands](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/kubernetes.md#replica-set-commands-1)
- #### [Kubernetes Deployments.](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/kubernetes.md#kubernetes-deployments-1)
- #### [Kubernetes Deployments Commands](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/kubernetes.md#kubernetes-deployments--commands)

- #### [Kubernetes Service](https://github.com/hossamalsankary/DevOps-journey/blob/main/linux/kubernetes.md#kubernetes-service-1)

- #### [Certification Tip – Imperative Commands!]()

### -------------------------------------------------------------------------------------------------------------------------------------

## Setup Kubernetes lab

#### Using minikube to setup our lab
##### What you’ll need
- ###### 2 CPUs or more
- ##### 2GB of free memory
- ##### 20GB of free disk space
- ##### Internet connection
- ##### VirtualBox, 
- ##### flow this gide line to setup our lab

#### [minikube Installation ](https://minikube.sigs.k8s.io/docs/start/)
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

## PODs Again!
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

### Create Pod With YUML file [link](/template/pod_wth_yuml.yml)
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

### -------------------------------------------------------------------------------------------------------------------------------------


## Replica set
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

### Define Replica set [link](/template/replica_set.yml)

```diff
apiVersion: apps/v1 #The apiVersion though is a bit different. It is apps/v1 which is different from
                    #what we had before for replication controller
kind: ReplicaSet
metadata:
  name: replicasetppp
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

```diff 
# now run this template 

+ kubectl create -f replica_set.yml 

# result should be like that
! replicaset.apps/replicasetppp created

# let's inspect how many pods we have
+ kubectl get pods
```
<p align="left">
 <img src="/images/replacasete.png" alt="Permissions" width="100%%" height="100%%" />
</p>

```diff 
# result replicasetppp-425wj       1/1     Running   0          27m
# we have 3 pods  and if you try to delete any pod replicaset going to create 
# new one for you and thats what High Availability mean 

+ kubectl delete pod replicasetppp-425wj 

#result
! replicasetppp-bt824       0/1     ContainerCreating   0          3s
```
<p align="left">
 <img src="/images/repsetDEL.png" alt="Permissions" width="100%%" height="100%%" />
</p>


### edit replicaset file

```diff 
# now let's open replicaset  replicasetppp file
+ kubectl edit replicaset  replicasetppp

# now scale   replicas: to  4 nd  press :wq
! this will out update the replicaset pods

#  another way to do that
! open the file replica_set.yml  with any editor 
! and change replicaset and save it
+  kubectl replace -f  replica_set.yml 


```
<p align="left">
 <img src="/images/scale rep.png" alt="Permissions" width="100%%" height="100%%" />
</p>

### -------------------------------------------------------------------------------------------------------------------------------------

## Replica set Commands 

```diff 
# create replicaset
> kubectl create –f replica_set.yml 

# list of all replica in the 
> kubectl get replicaset

# to edit  the  replica file
> kubectl edit  replicaset replicasetppp
 
# delete replicaset
> kubectl delete replicaset replicasetppp

# update replica_set.yml  af
> kubectl replace -f  replica_set.yml 

# scale on fly 
> kubectl scale –replicas=6 -f  replica_set.yml 
```
### -------------------------------------------------------------------------------------------------------------------------------------

##  Kubernetes Deployments.

say for example you would like to make multiple changes to your environment
You do not want to
apply each change immediately after the command is run, instead you would like to
apply a pause to your environment, make the changes and then resume so that all
changes are rolled-out together.
All of these capabilities are available with the kubernetes Deployments.
So far in this course we discussed about PODs, which deploy single instances of our
application such as the web application in this case. Each container is encapsulated in
PODs. Multiple such PODs are deployed using Replication Controllers or Replica Sets.
And then comes Deployment which is a kubernetes object that comes higher in the
hierarchy. The deployment provides us with capabilities to upgrade the underlying
instances seamlessly using rolling updates, undo changes, and pause and resume
changes to deployments.

### Deployment Strategy
<p align="left">
 <img src="/images/deploy.png" alt="Permissions" width="100%" height="80%" />
</p>

- #### Recreate : the application is down and inaccessible to users. This strategy is known as the Recreate strategy

- #### Rolling Update : we do not destroy all of them at once. Instead we take down the older version and bring up a newer version one by one. This way the application never goes down and the upgrade is seamless.

### Define Kubernetes Deployments [link](/template/myapp-deployment.yml)
```diff 
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp

spec:
  replicas: 3
  selector:
    matchLabels:
      name: busybox-pod
  template:
    metadata:
      labels:
        name: busybox-pod
    spec:
      containers:
      - name: busybox-container
        image: busybox
        command:
        - sh
        - "-c"
        - echo Hello Kubernetes! && sleep 3600

```
```diff
# Run deployment 
> kubectl create -f myapp-deployment.yml 
```
<p align="left">
 <img src="/images/appd1.png" alt="Permissions" width="100%" height="80%" />
</p>

```diff 
# show the deployment status
> kubectl rollout status deployment/myapp-deployment

#list all 
> kubectl get deployments

#result
! myapp-deployment   3/3     3            3           6m29s


# now let's change the image to nginx
> vi myapp-deployment.yml 

# than save the file

#  apply changes
+ kubectl apply –f  myapp-deployment.yml 

```
 - ##### now open  describe any pod to see changes

 ```diff
! kubectl rollout history deployment

! kubectl desribe pod myapp-deployment-5474c5bbdc-h7dxz

# 
 ```
<p align="left">
 <img src="/images/madin.png" alt="Permissions" width="100%" height="80%" />
</p>


## Rollback
```diff 
# with deployment you can undo changes easily if something went wrong  
# Rollback
+ kubectl rollout undo deployment/myapp-deployment
```
- ### Rollback and undo 
<p align="left">
 <img src="/images/rollyback.png" alt="Permissions" width="100%" height="80%" />
</p>

## Kubernetes Deployments  Commands
``` diff 
> kubectl create –f myapp-deployment.yml 

> kubectl apply –f myapp-deployment.yml 

> kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1

> kubectl rollout status deployment/myapp-deployment

> kubectl rollout history deployment/myapp-deployment

> kubectl rollout undo deployment/myapp-deployment
```
## Kubernetes Service
- #####  What are the types of Kubernetes services? 
Kubernetes services connect a set of pods to an abstracted service name and IP address. Services provide discovery and routing between pods. For example, services connect an application front-end to its backend, each of which running in separate deployments in a cluster. Services use labels and selectors to match pods with other applications. The core attributes of a Kubernetes service are:
```diff
-------------------------------------------------------------------------------------------
      ClusterIP           |       NodePort         |   LoadBalancer
-------------------------------------------------------------------------------------------
 Exposes a service        | Exposes a service via  |  Exposes the service via the cloud 
 which is only accessible | a static port on each  |   provider’s load balancer.
 from within the cluster. | node’s IP.             |
                          |                        |
                          |                        |                            
--------------------------------------------------------------------------------------------
```
- #####  So how can we implement?

- ###### ClusterIP [link](/kubernetes/deploy/service/redis_services.yml)
```diff 
# this example for ClusterIP service for redis database
apiVersion: v1
kind: Service
metadata:
  name: db
spec:
  ports:
    - targetPort: 5432
      port: 5432
   
  selector:
    name: db

```

- ###### NodePort [link](/kubernetes/deploy/service/result_app_service.yml)

```diff 

apiVersion: v1
kind: Service
metadata:
  name: voting-app
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
      nodePort: 30004
  selector:
    app: votingApp

```
## Certification Tip – Imperative Commands!
- ##### While you would be working mostly the declarative way – using definition files, imperative commands can help in getting one time tasks done quickly, as well as generate a definition template easily. This would help save considerable amount of time during your exams.

Before we begin, familiarize with the two options that can come in handy while working with the below commands:

--dry-run: By default as soon as the command is run, the resource will be created. If you simply want to test your command , use the --dry-run=client option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.

-o yaml: This will output the resource definition in YAML format on screen.

 

Use the above two in combination to generate a resource definition file quickly, that you can then modify and create resources as required, instead of creating the files from scratch.

 
### POD
+ Create an NGINX Pod
```diff

kubectl run nginx --image=nginx

#Generate POD Manifest YAML file (-o yaml). Don’t create it(–dry-run)

kubectl run nginx --image=nginx --dry-run=client -o yaml

```



## Deployment
+ Create a deployment
```diff 
kubectl create deployment --image=nginx nginx

 

# Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run)

kubectl create deployment --image=nginx nginx --dry-run -o yaml

## Generate Deployment with 4 Replicas

kubectl create deployment nginx --image=nginx --replicas=4

 
kubectl scale deployment nginx --replicas=4

# Another way to do this is to save the YAML definition to a file and modify

kubectl create deployment nginx --image=nginx--dry-run=client -o yaml > nginx-deployment.yaml
 ```

## Service

```diff
Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379

kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml

(This will automatically use the pod’s labels as selectors)

# Or

kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml

 # This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

# Create a Service named nginx of type NodePort to expose pod nginx’s port 80 on port 30080 on the nodes:

kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml

# This will automatically use the pod’s labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

# Or

kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

# (This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the `kubectl expose` command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.

 ```
### labs
```diff
-- run redis pod with lable tier=db
kubectl run redis -l tier=db --image=redis:alpine 

-- Create a service redis-service to expose the redis application within the cluster on port 6379.Use imperative commands.@@
 kubectl expose pod redis --name=redis-service --port=6379 

-- Create a new pod called custom-nginx using the nginx image and expose it on container port 8080.
kubectl run custom-nginx  --image=nginx --port=8080


-- crate namespace calld hossam
kubectl create namespace hossam

-- Create a new deployment called redis-deploy in the hossam namespace with the redis image. It should have 2 replicas.

kubectl create deployment redis-deployment-in-hossam-namespace --image=redis --replicas=2 --namespace=hossam


-- run nginx pod port 80 and expose it with service 

kubectl run nginx --image=nginx --port=80 --namespace=default --expose


 ```
 
## Configmap 
```diff 
# Create a new ConfigMap for the webapp-color POD. Use the spec given below.
 
 kubectl create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --dy-run=client -o yaml

 # Update the environment variable on the POD to use the newly created ConfigMapNote: Delete and recreate the POD. Only make the necessary changes. Do not modify the name of the Pod.

apiVersion: v1
kind: Pod
metadata:
  labels:
    name: webapp-color
  name: webapp-color
  namespace: default
spec:
  containers:
  - envFrom:
    - configMapRef:
         name: webapp-config-map
    image: kodekloud/webapp-color
    name: webapp-color

```

## secret 

```diff 
## The reason the application is failed is because we have not created the secrets yet. Create a new secret named db-secret with the data given below.You may follow any one of the methods discussed in lecture to create the secret.


kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123

kubectl create secret generic prod-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
 

 # Configure webapp-pod to load environment variables from the newly created secret.
---
apiVersion: v1 
kind: Pod 
metadata:
  labels:
    name: webapp-pod
  name: webapp-pod
  namespace: default 
spec:
  containers:
  - image: kodekloud/simple-webapp-mysql
    imagePullPolicy: Always
    name: webapp
    envFrom:
    - secretRef:  # inject the secret file here 

        name: db-secret


apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: mycontainer
    image: redis
    env:
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: username
            optional: false # same as default; "mysecret" must exist
                            # and include a key named "username"
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: password
            optional: false # same as default; "mysecret" must exist
                            # and include a key named "password"
  restartPolicy: Never
```

# recap Security in Docker
```diff 
#linux capability
+ /usr/include/linux/capability.h

# By default Docker runs a container with a limited set of capabilities. And so the
#processes running within the container do not have the privileges to say, reboot the
#host or perform operations that can disrupt the host or other containers running on
#the same host. In case you wish to override this behavior and enable all privileges to
#the container use the privileged flag


# If you wish to override this behavior and provide additional privileges than what is
# available use the cap-add option in the docker run command

docker run --cap-add MAC_ADMIN

#Or in case you wish to run the container with all privileges enabled, use the privileged flag. Well that’s it on Docker Security for now. I will see you in the next lecture.
docker run --privileged ubuntu 

```

# Kubernetes Security Contexts

```diff 


# example 
# Let us start with a POD definition file. This pod runs an ubuntu image with the sleep command. To configure security context on the container, add a field called securityContext under the spec section of the pod. Use the runAsUser option to set the user ID for the POD.

apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
containers:
  - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
    securityContext:
    runAsUser: 1000
      capabilities:
        add: ["MAC_ADMIN"]

#To set the same configuration on the container level, move the whole section under
the container specification like this.
To add capabilities use the capabilities option and specify a list of capabilities to add
to the POD.
Well that’s all on Security Contexts. Head over to the coding exercises section and
practice viewing, configuring and troubleshooting issues related to Security contexts
in Kubernetes. That’s it for now and I will see you in the next lecture.
 ```       

 ```diff 
 
 apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  securityContext:
    runAsUser: 1001  # in the pod level will over the container laver
  containers:
  -  image: ubuntu
     name: web
     command: ["sleep", "5000"]
     securityContext:
      runAsUser: 1002
      capabilities:  # give premation for the user to do some  capabilities to the pod 
        add: ["SYS_TIME"]
  -  image: ubuntu
     name: sidecar
     command: ["sleep", "5000"]

 ```
