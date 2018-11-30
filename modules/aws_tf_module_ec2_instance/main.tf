terraform {
  required_version = ">= 0.11"
}

resource "aws_instance" "main" {
  count = "${var.count}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  key_name = "${var.key_name}"
  associate_public_ip_address = "${var.public}"
  volume_tags = "${merge(var.tags, map("Name", format("%s-%02d",replace(var.role, "_", "-"), count.index + 1)))}"
  tags = "${merge(var.tags, map("Name", format("%s-%02d",replace(var.role, "_", "-"), count.index + 1)),map("Role",var.role))}"
 
  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
  }
}
