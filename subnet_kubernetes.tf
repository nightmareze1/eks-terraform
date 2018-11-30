###### VARIABLES ######
variable "kubernetes_k8s_prv_cidrs" {
  type = "list"
  description = "List of kubernetes k8s private subnet CIDR's"
}

###### SUBNETS ######
module "kubernetes_k8s_prv" {
  source = "./modules/aws_tf_module_subnet"
  vpc_id = "${module.vpc.vpc_id}"
  name = "${local.name}_kubernetes_k8s"
  cidrs = "${var.kubernetes_k8s_prv_cidrs}"
  availability_zones = "${var.availability_zones}"
  tier = "prv"
  public = false
  region = "${var.aws_region}"

  tags = "${
        map(
         "Name", "${var.env}_kubernetes_k8s",
         "Environment", "${var.env}",
         "kubernetes.io/cluster/${var.cluster_defaults["name"]}", "shared"
        )
   }"
}

# /*
resource "aws_route_table_association" "kubernetes_k8s_prv" {
  count =  "${var.private_zones_count}"
  subnet_id = "${element(module.kubernetes_k8s_prv.ids, count.index)}"
  route_table_id = "${element(module.nat_gateway.ids, count.index)}"
}
# */
