###### AWS Provider ######
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

terraform {
  backend "s3" {
    bucket  = "your_s3_bucket" # example bucket.dev.itshellws-k8s.com
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "virginia-kubernetes" #your keys in .ssh/virginia-kubernetes.pem , write here without .pem
  }
}

###### VARIABLES ######
variable "aws_region" {
  description = "AWS Region"
}

variable "aws_profile" {
  description = "AWS Profile"
}

variable "product" {
  description = "Product Name"
}

variable "env" {
  description = "Environment"
}

variable "key" {
  description = "Key for ssh"
}

variable "availability_zones" {
  type = "list"
  description = "List of AZ's"
}

variable "private_zones_count" {
  description = "number about private zones"
  default = "3"
}

variable "public_zones_count" {
  description = "number about public zones"
  default = "3"
}

locals {
  name = "${var.product}_${var.env}"

  tags = {
    Env     = "${var.env}"
    Product = "${var.product}"
  }
}
 
variable "external-ip" {
  default = "201.211.207.87/32" #your public ip to access KUBERNETES API
}

variable "cluster_defaults" {
  description = "Default values for target groups as defined by the list of maps."
  type        = "map"

  default = {
    name = "eks-cluster" # Name for the eks cluster.
  }
}

###### ASG_PROPERTIES ######

variable "nodes_defaults" {
  description = "Default values for target groups as defined by the list of maps."
  type        = "map"

  default = {
    name                 = "eks-nodes"    # Name for the eks workers.
    ami_id               = "ami-dea4d5a1" # AMI ID for the eks workers. If none is provided, Terraform will searchfor the latest version of their EKS optimized worker AMI.
    asg_desired_capacity = "2"            # Desired worker capacity in the autoscaling group.
    asg_max_size         = "3"            # Maximum worker capacity in the autoscaling group.
    asg_min_size         = "2"            # Minimum worker capacity in the autoscaling group.
    instance_type        = "t2.small"     # Size of the workers instances.
    key_name             = "virginia-kubernetes"      # The key name that should be used for the instances in the autoscaling group
    ebs_optimized        = false          # sets whether to use ebs optimization on supported types.
    public_ip            = false          # Associate a public ip address with a worker
  }
}
