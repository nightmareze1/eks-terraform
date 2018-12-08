terraform {
  required_version = ">= 0.11"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
  tags = "${merge(var.tags, map("Name", "${var.name}_vpc"))}"
}

# IGW
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = "${merge(var.tags, map("Name", "${var.name}_igw"))}"
}

# Default Route 
resource "aws_route" "main" {
  route_table_id = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.main.id}"
}

# DHCP
resource "aws_vpc_dhcp_options" "main" {
  domain_name = "${var.domain_name_dhcp}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = "${merge(var.tags, map("Name", "${var.name}_dhcp"))}"
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
}
