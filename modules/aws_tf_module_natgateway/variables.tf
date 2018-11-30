variable "public_subnets" {
  type = "list"
  description = "Public subnets ID's [ list ]"
}

variable "tags" { 
  type = "map"
  description = "Tags [ map ]"
}

variable "vpc" {
  description = "VPC ID [ string ]"
}

