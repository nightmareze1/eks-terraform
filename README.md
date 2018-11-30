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

![alt text](https://raw.githubusercontent.com/nightmareze1/eks-terraform/master/img/aws-eks.jpeg)

