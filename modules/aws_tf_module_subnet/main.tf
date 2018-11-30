terraform {
  required_version = ">= 0.11"
}

resource "aws_subnet" "main" {
  count = "${length(var.cidrs)}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(var.cidrs,count.index)}"
  map_public_ip_on_launch = "${var.public}"
  availability_zone = "${var.region}${element(var.availability_zones,count.index)}"
  tags = "${merge(var.tags, map("Name", format("%s_%s_%s",var.name,var.tier,element(var.availability_zones,count.index))),map("Tier",var.tier))}"
  lifecycle {
    ignore_changes = ["tags.kubernetes","tags.%","tags.SubnetType"]
  }
}

