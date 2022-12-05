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
- #### While you would be working mostly the declarative way – using definition files, imperative commands can help in getting one time tasks done quickly, as well as generate a definition template easily. This would help save considerable amount of time during your exams.

Before we begin, familiarize with the two options that can come in handy while working with the below commands:

--dry-run: By default as soon as the command is run, the resource will be created. If you simply want to test your command , use the --dry-run=client option. This will not create the resource, instead, tell you whether the resource can be created and if your command is right.

-o yaml: This will output the resource definition in YAML format on screen.

 

Use the above two in combination to generate a resource definition file quickly, that you can then modify and create resources as required, instead of creating the files from scratch.

```diff
#POD
#Create an NGINX Pod

+ kubectl run nginx --image=nginx

# Generate POD Manifest YAML file (-o yaml). Don’t create it(–dry-run)


+ kubectl run nginx --image=nginx --dry-run=client -o yaml
```


 

Deployment
```diff 
#Create a deployment

+ kubectl create deployment --image=nginx nginx

#Generate Deployment YAML file (-o yaml). Don’t create it(–dry-run)

+ kubectl create deployment --image=nginx nginx --dry-run -o yaml

#Generate Deployment with 4 Replicas

+ kubectl create deployment nginx --image=nginx --replicas=4

#You can also scale a deployment using the kubectl scale command.
 
+ kubectl scale deployment nginx --replicas=4
``` 




 

Another way to do this is to save the YAML definition to a file and modify

kubectl create deployment nginx --image=nginx--dry-run=client -o yaml > nginx-deployment.yaml

 

You can then update the YAML file with the replicas or any other field before creating the deployment.

 

Service
Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379

kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml

(This will automatically use the pod’s labels as selectors)

Or

kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml (This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

 

Create a Service named nginx of type NodePort to expose pod nginx’s port 80 on port 30080 on the nodes:

kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml

(This will automatically use the pod’s labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

Or

kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml

(This will not use the pods labels as selectors)

Both the above commands have their own challenges. While one of it cannot accept a selector the other cannot accept a node port. I would recommend going with the `kubectl expose` command. If you need to specify a node port, generate a definition file using the same command and manually input the nodeport before creating the service.

 

Reference:

https://kubernetes.io/docs/reference/kubectl/conventions/
=======
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

## serviceaccount 
```diff 
# first create service account with token 
kubectl create serviceaccouut jenkins 

# then create token for this account 
kubectl create token jenkins 

# then  link this service account with  container 
You shouldn't have to copy and paste the token each time. The Dashboard application is programmed to read token from the secret mount location. However currently, the default service account is mounted. Update the deployment to use the newly created ServiceAccount

Edit the deployment to change ServiceAccount from default to dashboard-sa.

Use the kubectl edit command for the deployment and specify the serviceAccountName field inside the pod spec.

OR

Make use of the kubectl set command. Run the following command to use the newly created service account: - kubectl set serviceaccount deploy/web-dashboard dashboard-sa

apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-dashboard
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      name: web-dashboard
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        name: web-dashboard
    spec:
      serviceAccountName: dashboard-sa
      containers:
      - image: gcr.io/kodekloud/customimage/my-kubernetes-dashboard
        imagePullPolicy: Always
        name: web-dashboard
        ports:
        - containerPort: 8080
          protocol: TCP

```
## Taints and Tolerations
-  Create a taint on node01 with key of spray, value of mortein and effect of NoSchedule
```diff 
kubectl taint nodes node01 spray=mortein:NoSchedule

```
## nodeAffinity

```diff 

apiVersion: v1
kind: Pod
metadata:
  name: with-node-affinity
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: topology.kubernetes.io/zone
            operator: In
            values:
            - antarctica-east1
            - antarctica-west1
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
  containers:
  - name: with-node-affinity

```

## Kubernetes CKAD – Multi Container PODs
- Create a multi-container pod with 2 containers.
Use the spec given below.
If the pod goes into the crashloopbackoff then add the command sleep 1000 in the lemon container.

```diff 
apiVersion: v1
kind: Pod
metadata:
  name: yellow
spec:
  containers:
  - name: lemon
    image: busybox
    command:
      - sleep
      - "1000"

  - name: gold
    image: redis

```
- how to exc inside pod 
```diff 
-- kubectl -n elastic-stack exec -it app -- cat /log/app.log

-- kubectl exec --namespace=kube-public curl -- sh -c 
```

- Edit the pod to add a sidecar container to send logs to Elastic Search. Mount the log volume to the sidecar container.Only add a new container. Do not modify anything else. Use the spec provided below.Note: State persistence concepts are discussed in detail later in this course. For now please make use of the below documentation link for updating the concerning pod.https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/

```diff 
apiVersion: v1
kind: Pod
metadata:
  name: app
  namespace: elastic-stack
  labels:
    name: app
spec:
  containers:
  - name: app
    image: kodekloud/event-simulator
    volumeMounts:
    - mountPath: /log
      name: log-volume

  - name: sidecar
    image: kodekloud/filebeat-configured
    volumeMounts:
    - mountPath: /var/log/event-simulator/
      name: log-volume

  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log/webapp
      # this field is optional
      type: DirectoryOrCreate

```
## Init Containers
- In a multi-container pod, each container is expected to run a process that stays alive as long as the POD’s lifecycle. For example in the multi-container pod that we talked about earlier that has a web application and logging agent, both the containers are expected to stay alive at all times. The process running in the log agent container is expected to stay alive as long as the web application is running. If any of them fails, the POD restarts.
But at times you may want to run a process that runs to completion in a container. For example a process that pulls a code or binary from a repository that will be used by the main web application. That is a task that will be run only one time when the pod is first created. Or a process that waits for an external service or database to be up before the actual application starts. That’s where initContainers comes in.An initContainer is configured in a pod like all other containers, except that it is specified inside a initContainers section, like this:

```diff
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'git clone <some-repository-that-will-be-used-by-application> ;']

-- ---------------------------------------------------------------------------------------------
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']

```
## readinessProbe
- Update the newly created pod 'simple-webapp-2' with a readinessProbe using the given specSpec is given on the below. Do not modify any other properties of the pod.
Pod Name: simple-webapp-2
Image Name: kodekloud/webapp-delayed-start
Readiness Probe: httpGet
Http Probe: /ready
Http Port: 8080

```diff
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2021-08-01T04:55:35Z"
  labels:
    name: simple-webapp
  name: simple-webapp-2
  namespace: default
spec:
  containers:
  - env:
    - name: APP_START_DELAY
      value: "80"
    image: kodekloud/webapp-delayed-start
    imagePullPolicy: Always
    name: simple-webapp
    ports:
    - containerPort: 8080
      protocol: TCP
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
 ```
 ## livenessProbe
 - Update both the pods with a livenessProbe using the given spec

Delete and recreate the PODs.

CheckCompleteIncomplete
Pod Name: simple-webapp-1

Image Name: kodekloud/webapp-delayed-start

Liveness Probe: httpGet

Http Probe: /live

Http Port: 8080

Period Seconds: 1

Initial Delay: 80

Pod Name: simple-webapp-2

Image Name: kodekloud/webapp-delayed-start

Liveness Probe: httpGet

Http Probe: /live

Http Port: 8080

Initial Delay: 80

Period Seconds: 1
```diff
apiVersion: v1
kind: Pod
metadata:
  labels:
    name: simple-webapp
  name: simple-webapp-1
  namespace: default
spec:
  containers:
  - env:
    - name: APP_START_DELAY
      value: "80"
    image: kodekloud/webapp-delayed-start
    imagePullPolicy: Always
    name: simple-webapp
    ports:
    - containerPort: 8080
      protocol: TCP
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
    livenessProbe:
      httpGet:
        path: /live
        port: 8080
      periodSeconds: 1
      initialDelaySeconds: 80

  -- ---------------------------------------------------------------
  To recreate the pod, run the command:
kubectl replace -f simple-webapp-1.yaml --force

And do the same for simple-webapp-2, use the following YAML file:

apiVersion: v1
kind: Pod
metadata:
  labels:
    name: simple-webapp
  name: simple-webapp-2
  namespace: default
spec:
  containers:
  - env:
    - name: APP_START_DELAY
      value: "80"
    image: kodekloud/webapp-delayed-start
    imagePullPolicy: Always
    name: simple-webapp
    ports:
    - containerPort: 8080
      protocol: TCP
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
    livenessProbe:
      httpGet:
        path: /live
        port: 8080
      periodSeconds: 1
      initialDelaySeconds: 80
To recreate the pod, run the command:
kubectl replace -f simple-webapp-2.yaml --force



 ```
 ## kubernetes metrics Server montring
 ```diff 
+ how to get  loges
-- kubectl logs -f  (pod name) (container name inside the pod)

-- matrics server 
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git

kubectl create -f .


-- Identify the node that consumes the most CPU.

+ kubectl top node --sort-by='cpu' --no-headers | head -1                   
node01         234m   2%    515Mi   2%    


-- Identify the POD that consumes the most Memory.

+ kubectl top pod --sort-by='memory' --no-headers | head -1 

 ```

 ## POD DESIGN
  - lables
```diff 
-- kubectl get pods --selector env=dev --no-headers | wc -l


```
## Updating a Deployment
- Summarize Commands about deployment
```diff 

> kubectl rollout status deployment/myapp-deployment
> kubectl rollout history deployment/myapp-deployment
> kubectl create –f deployment-definition.yml
> kubectl get deployments
> kubectl apply –f deployment-definition.yml
> kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1
> kubectl rollout undo deployment/myapp-deployment

```

Here are some handy examples related to updating a Kubernetes Deployment:

Creating a deployment, checking the rollout status and history:
In the example below, we will first create a simple deployment and inspect the rollout status and the rollout history:

controlplane $ kubectl create deployment nginx --image=nginx:1.16
deployment.apps/nginx created

controlplane $ kubectl rollout status deployment nginx
Waiting for deployment "nginx" rollout to finish: 0 of 1 updated replicas are available...
deployment "nginx" successfully rolled out

controlplane $

```diff
controlplane $ kubectl rollout history deployment nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         <none>

controlplane $
Using the – -revision flag:
Here revision 1 is the first version where the deployment was created.

You can check the status of each revision individually by using the – -revision flag:

controlplane $ kubectl rollout history deployment nginx --revision=1
deployment.apps/nginx with revision #1
Pod Template:
Labels:       app=nginx
pod-template-hash=78449c65d4
Containers:
nginx:
Image:      nginx:1.16
Port:       <none>
Host Port:  <none>
Environment: <none>
Mounts:      <none>
Volumes:     


```
Using the – -record flag:
You would have noticed that the “change-cause” field is empty in the rollout history output. We can use the – -record flag to save the command used to create/update a deployment against the revision number.

```diff
ontrolplane $ kubectl set image deployment nginx nginx=nginx:1.17 --record
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/nginx image updated

controlplane $

controlplane $ kubectl rollout history deployment nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl set image deployment nginx nginx=nginx:1.17 --record=true

```

You can now see that the change-cause is recorded for the revision 2 of this deployment.

Lets make some more changes. In the example below, we are editing the deployment and changing the image from nginx:1.17 to nginx:latest while making use of the –record flag.

```diff 
controlplane $ kubectl edit deployments.apps nginx --record
Flag --record has been deprecated, --record will be removed in the future
deployment.apps/nginx edited

controlplane $ kubectl rollout history deployment nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl set image deployment nginx nginx=nginx:1.17 --record=true
3         kubectl edit deployments.apps nginx --record=true



controlplane $ kubectl rollout history deployment nginx --revision=3
deployment.apps/nginx with revision #3
Pod Template:
  Labels:       app=nginx
        pod-template-hash=787f54657b
  Annotations:  kubernetes.io/change-cause: kubectl edit deployments.apps nginx --record=true
  Containers:
   nginx:
    Image:      nginx
    Port:       <none>
    Host Port:  <none>
    Environment:  <none>      
    Mounts:     <none>
  Volumes:      

  controlplane $
Undo a change:
Lets now rollback to the previous revision:

controlplane $ kubectl rollout history deployment nginx
deployment.apps/nginx 
REVISION  CHANGE-CAUSE
1         
3         kubectl edit deployments.apps nginx --record=true
4         kubectl set image deployment nginx nginx=nginx:1.17 --record=true



controlplane $ kubectl rollout history deployment nginx --revision=3
deployment.apps/nginx with revision #3
Pod Template:
  Labels:       app=nginx
        pod-template-hash=787f54657b
  Annotations:  kubernetes.io/change-cause: kubectl edit deployments.apps nginx --record=true
  Containers:
   nginx:
    Image:      nginx:latest
    Port:       
    Host Port:  
    Environment:        
    Mounts:     
  Volumes:      

controlplane $ kubectl describe deployments. nginx | grep -i image:
    Image:        nginx:1.17

controlplane $
With this, we have rolled back to the previous version of the deployment with the image = nginx:1.17.

controlplane $ kubectl rollout history deployment nginx --revision=1
deployment.apps/nginx with revision #1
Pod Template:
  Labels:       app=nginx
        pod-template-hash=78449c65d4
  Containers:
   nginx:
    Image:      nginx:1.16
    Port:       <none> 
    Host Port:  <none>
    Environment: <none>     
    Mounts:     <none>
  Volumes:      

controlplane $ kubectl rollout undo deployment nginx --to-revision=1
deployment.apps/nginx rolled back
To rollback to specific revision we will use the --to-revision flag.
With --to-revision=1, it will be rolled back with the first image we used to create a deployment as we can see in the rollout history output.

controlplane $ kubectl describe deployments. nginx | grep -i image:
Image: nginx:1.16

```
## > JOBS

- Update the job definition to run as many times as required to get 3 successful 6's.Delete existing job and create a new one with the given spec. Monitor and wait for the job to succeed.
```diff 

apiVersion: batch/v1
kind: Job
metadata:
  name: throw-dice-job
spec:
  completions: 3
  backoffLimit: 25 # This is so the job does not quit before it succeeds.
  template:
    spec:
      containers:
      - name: throw-dice
        image: kodekloud/throw-dice
      restartPolicy: Never

```
##  Cron Jobs
- Once the file is ready run the kubectl create command to create the cron-job and run the kubectl get cronjob command to see the newly created job. It would inturn create the required jobs and pods.
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure

```

## network Policy
##### - example 1

```diff 
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"networking.k8s.io/v1","kind":"NetworkPolicy","metadata":{"annotations":{},"name":"payroll-policy","namespace":"default"},"spec":{"ingress":[{"from":[{"podSelector":{"matchLabels":{"name":"internal"}}}],"ports":[{"port":8080,"protocol":"TCP"}]}],"podSelector":{"matchLabels":{"name":"payroll"}},"policyTypes":["Ingress"]}}
  creationTimestamp: "2022-12-03T00:17:48Z"
  generation: 1
  name: payroll-policy
  namespace: default
  resourceVersion: "829"
  uid: b93f9989-ee57-417c-a47e-58622c4d9210
spec:
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: internal
    ports:
    - port: 8080
      protocol: TCP
  podSelector:
    matchLabels:
      name: payroll
  policyTypes:
  - Ingress
```

##### - example 2
Create a network policy to allow traffic from the Internal application only to the payroll-service and db-service.

Use the spec given below. You might want to enable ingress traffic to the pod to test your rules in the UI.

```diff
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: internal-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      name: internal
  policyTypes:
  - Egress
  - Ingress
  ingress:
    - {}
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: mysql
    ports:
    - protocol: TCP
      port: 3306

  - to:
    - podSelector:
        matchLabels:
          name: payroll
    ports:
    - protocol: TCP
      port: 8080

  - ports:
    - port: 53
      protocol: UDP
    - port: 53
      protocol: TCP
 ```
 ## Ingress networking
 #### - ingress controler
 Let us now deploy the Ingress Controller. Create a deployment using the file given.

The Deployment configuration is given at /root/ingress-controller.yaml. There are several issues with it. Try to fix them.

```diff 
  ---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ingress-controller
  namespace: ingress-space
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      serviceAccountName: ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
          args:
            - /nginx-ingress-controller
            - --configmap=$(POD_NAMESPACE)/nginx-configuration
            - --default-backend-service=app-space/default-http-backend
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443

  ---
  ---
apiVersion: v1
kind: Service
metadata:
  name: ingress
  namespace: ingress-space
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    nodePort: 30080
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress^C

```
 #### - create ingres
 ```diff
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
  creationTimestamp: "2022-12-03T17:56:02Z"
  generation: 1
  name: ingress-wear-watch
  namespace: app-space
  resourceVersion: "724"
  uid: dfde3f4d-14a6-4286-9074-1f5caa551bba
spec:
  rules:
  - http:
      paths:
      - backend:
          service:
            name: wear-service
            port:
              number: 8080
        path: /wear
        pathType: Prefix
      - backend:
          service:
            name: video-service
            port:
              number: 8080
        path: /watch
        pathType: Prefix
      - backend:
          service: 
            name: video-service
            port:
              number: 8080
        path: /stream
        pathType: Prefix
status:
  loadBalancer:
    ingress:
    - ip: 10.108.174.123 
  ```

  ```diff 
  
  ---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /wear
        pathType: Prefix
        backend:
          service:
           name: wear-service
           port: 
            number: 8080
      - path: /watch
        pathType: Prefix
        backend:
          service:
           name: video-service
           port:
            number: 8080
  ```
## presestin volumes 
```diff 
kind: Pod
metadata:
  name: webapp
spec:
  containers:
  - name: event-simulator
    image: kodekloud/event-simulator
    env:
    - name: LOG_HANDLERS
      value: file
    volumeMounts:
    - mountPath: /log
      name: log-volume

  volumes:
  - name: log-volume
    hostPath:
      # directory location on host
      path: /var/log/webapp
      # this field is optional
      type: Directory
``` 
##### - Create a Persistent Volume with the given specification.

```diff 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  persistentVolumeReclaimPolicy: Retain
  accessModes:
    - ReadWriteMany
  capacity:
    storage: 100Mi
  hostPath:
    path: /pv/log
```
