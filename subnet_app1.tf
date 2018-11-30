###### VARIABLES ######
variable "app1_aws_pub_cidrs" {
  type = "list"
  description = "List of app1 aws public subnet CIDR's"
}

variable "app1_aws_prv_cidrs" {
  type = "list"
  description = "List of app1 aws private subnet CIDR's"
}

variable "app1_k8s_prv_cidrs" {
  type = "list"
  description = "List of app1 k8s private subnet CIDR's"
}

###### SUBNETS ######
module "app1_aws_pub" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_app1_aws"
  cidrs = "${var.app1_aws_pub_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "pub"
  public = true
  region = "${var.aws_region}"
  tags = "${
     map(
      "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
     )
  }"
}

module "app1_aws_prv" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_app1_aws"
  cidrs = "${var.app1_aws_prv_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "prv"
  public = false
  region = "${var.aws_region}"
  tags = "${
      map(
       "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
      )
  }"
}

module "app1_k8s_prv" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_app1_k8s"
  cidrs = "${var.app1_k8s_prv_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "prv"
  public = false
  region = "${var.aws_region}"
  tags = "${
    map(
     "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
    )
  }"
}

# /*
resource "aws_route_table_association" "app1_aws_prv" {
  count = "${var.private_zones_count}"
  subnet_id = "${element(module.app1_aws_prv.ids, count.index)}"
  route_table_id = "${element(module.nat_gateway.ids, count.index)}"
}

resource "aws_route_table_association" "app1_k8s_prv" {
  count = "${var.private_zones_count}"
  subnet_id = "${element(module.app1_k8s_prv.ids, count.index)}"
  route_table_id = "${element(module.nat_gateway.ids, count.index)}"
}
# */
