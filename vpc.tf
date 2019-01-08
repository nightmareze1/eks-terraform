###### VARIABLES ######
variable "vpc-cidr" {
  description = "Network CIDR [A.B.C.D/X]"
}
variable "domain_name_dhcp" {
   description = "Domain Name"
 
}
variable "enable_dns_hostnames" {
  description = "Enable DNS Hostnames [ true | false ]"
}
variable "enable_dns_support" {
  description = "Enable DNS Support [ true | false ]"
}
###### VPC #######
module "vpc" {
  source = "./modules/aws_tf_module_vpc"
  name = "${local.name}"
  cidr = "${var.vpc-cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  
  tags = "${
    map(
     "Name", "${var.env}-vpc",
     "Environment", "${var.env}",
     "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
    )
  }"
  domain_name_dhcp = "${var.domain_name_dhcp}"
}

