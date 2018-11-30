variable "reverse_zone" {
  description = "PTR Zone"
}

module "route53_reverse_zone" {
  source = "./modules/aws_tf_module_route53"
  vpc_id = "${module.vpc.vpc_id}"
  domain_name = "${var.reverse_zone}"
  tags = "${local.tags}"
  tier = "reverse"
}

/*
module "route53_private_zone" {
  source = "./modules/aws_tf_module_route53"
  vpc_id = "${module.vpc.vpc_id}"
  domain_name = "${var.domain_name}"
  tags = "${local.tags}"
  tier = "private"
}

module "route53_public_zone" {
  source = "./modules/aws_tf_module_route53"
  domain_name = "${var.domain_name}"
  tags = "${local.tags}"
  tier = "public"
}
*/
