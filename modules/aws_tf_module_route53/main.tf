terraform {
  required_version = ">= 0.11"
}

resource "aws_route53_zone" "main" {
  vpc_id = "${var.vpc_id}"
  name = "${var.domain_name}"
  tags = "${merge(var.tags, map("Tier",var.tier))}"
}
