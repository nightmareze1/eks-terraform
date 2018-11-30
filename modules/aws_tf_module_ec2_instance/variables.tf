variable "count" {
  description = "Instances Count [ integer ]"
}

variable "ami" {
  description = "AWS AMI ID [ string ]"
}

variable "instance_type" {
  description = "AWS Instance Type [ string ]"
}

variable "subnet_ids" {
  type = "list"
  description = "Subnet ID [ list ]"
}

variable "vpc_security_group_ids" {
  type = "list"
  description = "VPC Security Group IDs [ list ]"
}

variable "key_name" {
  description = "AWS Key Pair [ string ]"
}

variable "tags" {
  type = "map"
  description = "Resource Tags [ map ]"
}

variable "role" {
  description = "Role Name [ role ]"
}

variable "public" {
  description = "Public IP [ true | false ]"
}

variable "volume_size" {
  description = "Volume Size"
  default = "8"
}

variable "volume_type" {
  description = "Volume Size"
  default = "gp2"
}
