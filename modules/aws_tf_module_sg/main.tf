terraform {
  required_version = ">= 0.11"
}


resource "aws_security_group" "main" {
  name = "${var.name}"
  description = "${var.name}"
  vpc_id = "${var.vpc_id}"
  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
  lifecycle {
    ignore_changes = "tags"
  }
}

resource "aws_security_group_rule" "main" {
  count = "${length(var.rules)}"
  security_group_id = "${aws_security_group.main.id}"
  type = "${lookup(var.rules[count.index], "type")}"
  protocol = "${lookup(var.rules[count.index], "protocol")}"
  from_port = "${lookup(var.rules[count.index], "from_port")}"
  to_port = "${lookup(var.rules[count.index], "to_port")}"
  cidr_blocks = "${split("|", lookup(var.rules[count.index], "cidr_blocks"))}"
  description = "${lookup(var.rules[count.index], "description")}"
}
