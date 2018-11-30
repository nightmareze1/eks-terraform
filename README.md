                                                  ### eks-terraform ###
                                                     
                                                     
![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/amazon-eks-logo.png)


Terraform module to install Kubernetes using EKS multi-az in AWS with autoscaling groups(tags) for Workers.

# Properties:
###EKS Cluster: Control Plane in multi AZ.

###Autoscaling Groups for Workers with NODEGROUP/PLACEMENT_CONSTRAINT.

###Iam Roles and Policies.

###Aws Integration to create a ELB,NLB,ALB in public subnets.

###VPC, Multiple subnets, public subnets, private subnets, internet gateway and nat gateways.

# Architecture

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/eks-art.png)

# VPC-EXAMPLE:
![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/vpc-example.png)

Installation:

1- You need configure :
s3 bucket for tfstate in main.tf
aws_region,aws_profile,key,domain_name,reverse_zone,vpc-cidr,subnets in terraform.tfvars

2- Launch Terraform:
terraform init 
terraform plan
terraform apply -auto-approve

3- Wait 10 minutes and save the first part of output in file :

eks-config-auth.yml
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::881653854182:role/eks-nodes
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
```

4- Load cluster configuration in .kube/config to access the cluster.

```
aws eks update-kubeconfig --name eks-cluster --profile virginia-kubernetes
```

5- Apply eks-config-auth to permit workers registration in EKS-CLUSTER.
```
kubectl craete -f eks-config-auth.yml
```
6- Check nodes registration
```
➜  eks-up-and-running k get nodes --label-columns group
NAME                            STATUS    ROLES     AGE       VERSION   GROUP
ip-10-100-18-161.ec2.internal   Ready     <none>    4s        v1.10.3   node
ip-10-100-18-97.ec2.internal    Ready     <none>    0s        v1.10.3   node
ip-10-100-50-11.ec2.internal    Ready     <none>    3s        v1.10.3   traefik
ip-10-100-50-235.ec2.internal   Ready     <none>    1s        v1.10.3   traefik
```

7- Test autoscaling workers groups changing desired and max.

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/asg-desired.png)

wait 1 minute and check nodes to look the correctly registration.

```
➜  eks-up-and-running k get nodes --label-columns group
NAME                            STATUS    ROLES     AGE       VERSION   GROUP
ip-10-100-18-161.ec2.internal   Ready     <none>    14m       v1.10.3   node
ip-10-100-18-97.ec2.internal    Ready     <none>    14m       v1.10.3   node
ip-10-100-19-49.ec2.internal    Ready     <none>    9m        v1.10.3   node
ip-10-100-50-11.ec2.internal    Ready     <none>    14m       v1.10.3   traefik
ip-10-100-50-235.ec2.internal   Ready     <none>    14m       v1.10.3   traefik
ip-10-100-51-22.ec2.internal    Ready     <none>    9m        v1.10.3   traefik
```

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/asg-nodes.png)

8- Check dns-service is success. 
```
➜  eks-up-and-running k get po --all-namespaces
NAMESPACE     NAME                        READY     STATUS              RESTARTS   AGE
kube-system   aws-node-2lg6j              1/1       Running             0          10s
kube-system   aws-node-d98q2              1/1       Running             0          6s
kube-system   aws-node-n9lhz              1/1       Running             0          7s
kube-system   aws-node-ngwfb              1/1       Running             0          9s
kube-system   kube-dns-64b69465b4-js5km   0/3       ContainerCreating   0          6m
kube-system   kube-proxy-kqs7f            1/1       Running             0          10s
kube-system   kube-proxy-mmn2l            1/1       Running             0          9s
kube-system   kube-proxy-rjjnq            1/1       Running             0          6s
kube-system   kube-proxy-vssqc            1/1       Running             0          7s
```
9- Install helm and tiller.
```
cd eks-up-and-running
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller --upgrade
```

10- Install HPA-metrics server.
```
https://github.com/kubernetes-incubator/metrics-server.git

➜  eks-metrics k create -f metrics-server/deploy/1.8+
clusterrole.rbac.authorization.k8s.io "system:aggregated-metrics-reader" created
clusterrolebinding.rbac.authorization.k8s.io "metrics-server:system:auth-delegator" created
rolebinding.rbac.authorization.k8s.io "metrics-server-auth-reader" created
apiservice.apiregistration.k8s.io "v1beta1.metrics.k8s.io" created
serviceaccount "metrics-server" created
deployment.extensions "metrics-server" created
service "metrics-server" created
clusterrole.rbac.authorization.k8s.io "system:metrics-server" created
clusterrolebinding.rbac.authorization.k8s.io "system:metrics-server" created

```

11- Launch kubernetes-dashboard and 2 applications , 1 public application with ELB and 1 private application.

```
cd eks-up-and-running

➜  eks-up-and-running k create -f eks-app-autoscaling
horizontalpodautoscaler.autoscaling "nginx" created
deployment.extensions "nginx" created
service "nginx" created
deployment.extensions "nginx2" created
service "nginx2" created

➜  eks-app-autoscaling k get svc -owide
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE       SELECTOR
kubernetes   ClusterIP      172.20.0.1      <none>        443/TCP        42m       <none>
nginx        LoadBalancer   172.20.71.17    <pending>     80:30417/TCP   1m        app=nginx,env=stg
nginx2       ClusterIP      172.20.30.143   <none>        80/TCP         6m        app=nginx,env=stg

➜  eks-app-autoscaling k get svc -owide
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)        AGE       SELECTOR
kubernetes   ClusterIP      172.20.0.1      <none>                                                                    443/TCP        42m       <none>
nginx        LoadBalancer   172.20.71.17    afe917206f44011e8abc402ddbc5496a-1082087107.us-east-1.elb.amazonaws.com   80:30417/TCP   2m        app=nginx,env=stg
nginx2       ClusterIP      172.20.30.143   <none>                                                                    80/TCP         6m        app=nginx,env=stg
```

Open the url using the FQDN detailed in EXTERNAL-IP. 

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/app1.png)

12- Launch Kubernetes-dashboard and get token.
```
➜  eks-up-and-running k create -f eks-dashboard
secret "kubernetes-dashboard-certs" created
serviceaccount "kubernetes-dashboard" created
role.rbac.authorization.k8s.io "kubernetes-dashboard-minimal" created
rolebinding.rbac.authorization.k8s.io "kubernetes-dashboard-minimal" created
deployment.apps "kubernetes-dashboard" created
service "kubernetes-dashboard" created

kubectl proxy --port=8080 --address='0.0.0.0' --disable-filter=true &

➜  eks-dashboard  aws-iam-authenticator token -i eks-cluster
{"kind":"ExecCredential","apiVersion":"client.authentication.k8s.io/v1alpha1","spec":{},"status":{"token":"k8s-aws-v1.aHR0cHM6Ly9zdHMuYW1hem9uYXdzLmNvbS8_QWN0aW9uPUdldENhbGxlcklkZW50aXR5JlZlcnNpb249MjAxMS0wNi0xNSZYLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFKR05UNlRRMk9WSE1CMldRJTJGMjAxODExMzAlMkZ1cy1lYXN0LTElMkZzdHMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDE4MTEzMFQwMTU0NTZaJlgtQW16LUV4cGlyZXM9NjAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JTNCeC1rOHMtYXdzLWlkJlgtQW16LVNpZ25hdHVyZT1jNjBlNTljYzI2ZmY5MzIyMDJlZGYzMGRiODAzMzc5MzE4NjgwMjY3ZGQyMDNiYmE2NTBkM2I2NzBhOTM3OGQy"}}
```

Open dashboard url in your browser using kube-proxy in port 8080 and use the token auth.

http://127.0.0.1:8080/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/dash-token.png)

Look the dashboard.

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/dask-kube.png)

13- You can configure hpa and testing the applications with load average.

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/load.png)



