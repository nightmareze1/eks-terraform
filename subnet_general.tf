###### VARIABLES ######
variable "general_aws_pub_cidrs" {
  type = "list"
  description = "List of general aws public subnet CIDR's"
}

variable "general_aws_prv_cidrs" {
  type = "list"
  description = "List of general aws private subnet CIDR's"
}

###### SUBNETS ######
module "general_aws_pub" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_general_aws"
  cidrs = "${var.general_aws_pub_cidrs}"
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

module "general_aws_prv" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_general_aws"
  cidrs = "${var.general_aws_prv_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "prv"
  public = false
  region = "${var.aws_region}"
  tags = "${
      map(
       "Name", "${var.env}",
       "Environment", "${var.env}",
       "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
      )
  }"
}

# /*
resource "aws_route_table_association" "general_aws_prv" {
  count = "${var.private_zones_count}"
  subnet_id = "${element(module.general_aws_prv.ids, count.index)}"
  route_table_id = "${element(module.nat_gateway.ids, count.index)}"
}

module "nat_gateway" {
  source ="./modules/aws_tf_module_natgateway"
  public_subnets = "${module.general_aws_pub.ids}"
  vpc = "${module.vpc.vpc_id}"
  tags = "${local.tags}"
}
# */
