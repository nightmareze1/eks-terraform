###### VARIABLES ######
variable "traefik_aws_pub_cidrs" {
  type = "list"
  description = "List of traefik aws public subnet CIDR's"
}

variable "traefik_aws_prv_cidrs" {
  type = "list"
  description = "List of traefik aws private subnet CIDR's"
}

variable "traefik_k8s_prv_cidrs" {
  type = "list"
  description = "List of traefik k8s private subnet CIDR's"
}

###### SUBNETS ######
module "traefik_aws_pub" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_traefik_aws"
  cidrs = "${var.traefik_aws_pub_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "pub"
  public = true
  tags = "${local.tags}"
  region = "${var.aws_region}"
}

module "traefik_aws_prv" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_traefik_aws"
  cidrs = "${var.traefik_aws_prv_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "prv"
  public = false
  tags = "${local.tags}"
  region = "${var.aws_region}"
}

module "traefik_k8s_prv" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_traefik_k8s"
  cidrs = "${var.traefik_k8s_prv_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "prv"
  public = false
  region = "${var.aws_region}"

  tags = "${
         map(
          "Name", "${var.env}_traefik_k8s",
          "Environment", "${var.env}",
          "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
         )
    }"
}

# /*
resource "aws_route_table_association" "traefik_aws_prv" {
  count =  "${var.private_zones_count}"
  subnet_id = "${element(module.traefik_aws_prv.ids, count.index)}"
  route_table_id = "${element(module.nat_gateway.ids, count.index)}"
}

resource "aws_route_table_association" "traefik_k8s_prv" {
  count =  "${var.private_zones_count}"
  subnet_id = "${element(module.traefik_k8s_prv.ids, count.index)}"
  route_table_id = "${element(module.nat_gateway.ids, count.index)}"
}

# */
