 resource "aws_eip" "main" {
   count         = "3"
   vpc = true

   lifecycle {
     create_before_destroy = true
   }
  
   tags = "${var.tags}"
 }

 resource "aws_nat_gateway" "main" {
   count         = "3"
   allocation_id = "${element(aws_eip.main.*.id, count.index)}"
   subnet_id     = "${element(var.public_subnets, count.index)}"

   tags = "${var.tags}"
 
   lifecycle {
     create_before_destroy = true
   }
 }

 resource "aws_route_table" "main" {
   count         = "3"
   vpc_id = "${var.vpc}"
   route {
     cidr_block = "0.0.0.0/0"
     nat_gateway_id = "${element(aws_nat_gateway.main.*.id, count.index)}"
   }

   tags = "${var.tags}"
 }

