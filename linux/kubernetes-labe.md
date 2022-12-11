# content
- #### [Setup Kubernetes lab (1)]()
- #### [Setup Kubernetes lab (2)]()
- #### [Setup Kubernetes lab (3)]()


## Setup Kubernetes lab  - lab(1)
#### - Create a Persistent Volume called log-volume. It should make use of a storage class name manual. It should use RWX as the access mode and have a size of 1Gi. The volume should use the hostPath /opt/volume/nginx Next, create a PVC called log-claim requesting a minimum of 200Mi of storage. This PVC should bind to log-volume.Mount this in a pod called logger at the location /var/www/nginx. This pod should use the image nginx:alpine. log-volume created with correct parameters?
```diff
# Create a Persistent Volume called log-volume. It should make use of a storage class name manual. It should use RWX as the access mode and have a size of 1Gi.The volume should use the hostPath /opt/volume/nginx 
apiVersion: v1
kind: PersistentVolume
metadata:
  name: log-volume
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  storageClassName:  manual
  hostPath: 
     path: /opt/volume/nginx

# create a PVC called log-claim requesting a minimum of 200Mi of storage.
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: log-claim
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: manual  
  resources:
    requests:
      storage: 200Mi

apiVersion: v1
kind: Pod
metadata:
  name: loger
spec:
  containers:
    - name: nginx
      image: nginx:alpine
      volumeMounts:
      - mountPath: /var/www/nginx
        name: myloger-claim
  volumes:
    - name: myloger-claim
      persistentVolumeClaim:
        claimName: log-claim


# This PVC should bind to log-volume.Mount this in a pod called logger at the location /var/www/nginx. This pod should use the image nginx:alpine.
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  containers:
  - args:
    - logger
    image: nginx:alpine
    name: pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

```
## Setup Kubernetes lab (2)

#### - We have deployed a new pod called secure-pod and a service called secure-service. Incoming or Outgoing connections to this pod are not working.Troubleshoot why this is happening. Make sure that incoming connection from the pod webapp-color are successful.Important: Don't delete any current objects deployed.Important: Don't Alter Existing Objects! Connectivity working?
```diff
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      run: secure-pod
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchLabels:
               name: webapp-color
      ports:
        - protocol: TCP
          port: 80

          
```
## Setup Kubernetes lab (3)
#### - Create a pod called time-check in the dvl1987 namespace. This pod should run a container called time-check that uses the busybox image.Create a config map called time-config with the data TIME_FREQ=10 in the same namespace. The time-check container should run the command: while true; do date; sleep $TIME_FREQ;done and write the result to the location /opt/time/time-check.log. The path /opt/time on the pod should mount a volume that lasts the lifetime of this pod. Pod time-check configured correctly?
```diff
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: time-check
  name: time-check
  namespace: dvl1987
spec:
  volumes:
  - name: log-volume
    emptyDir: {}
  containers:
  - image: busybox
    name: time-check
    env:
    - name: TIME_FREQ
      valueFrom:
            configMapKeyRef:
              name: time-config
              key: TIME_FREQ
    volumeMounts:
    - mountPath: /opt/time
      name: log-volume
    command:
    - "/bin/sh"
    - "-c"
```
#### - Create a new deployment called nginx-deploy, with one single container called nginx, image nginx:1.16 and 4 replicas. The deployment should use RollingUpdate strategy with maxSurge=1, and maxUnavailable=2. Next upgrade the deployment to version 1.17. Finally, once all pods are updated, undo the update and go back to the previous version. Deployment created correctly? Was the deployment created with nginx:1.16? Was it upgraded to 1.17? Deployment rolled back to 1.16?
```diff 
-- kubectl create deployment nginx-deploy --image=nginx:1.16 --replicas=4 --dry-run=client -oyaml > nginx-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-deploy
  name: nginx-deploy
  namespace: default
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx-deploy
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - image: nginx:1.16
        imagePullPolicy: IfNotPresent
        name: nginx
-- kubectl set image deployment nginx-deploy nginx=nginx:1.17
-- kubectl rollout undo deployment nginx-deploy


```
#### - Create a redis deployment with the following parameters: Name of the deployment should be redis using the redis:alpine image. It should have exactly 1 replica. The container should request for .2 CPU. It should use the label app=redis. It should mount exactly 2 volumes. a. An Empty directory volume called data at path /redis-master-data. b. A configmap volume called redis-config at path /redis-master. c. The container should expose the port 6379. The configmap has already been created. Deployment created correctly?
```diff    
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: redis
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      volumes:
      - name: data
        emptyDir: {}
      - name: redis-config
        configMap:
          name: redis-config
      containers:
      - image: redis:alpine
        name: redis
        volumeMounts:
        - mountPath: /redis-master-data
          name: data
        - mountPath: /redis-master
          name: redis-config
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "0.2"

apiVersion: v1
data:
  TIME_FREQ: "10"
kind: ConfigMap
metadata:
  name: time-config
  namespace: dvl1987





 ```