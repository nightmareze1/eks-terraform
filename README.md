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
