variable "name" {
  description = "Resource Name [ string ]"
}

variable "tags" {
  type = "map"
  description = "Module Tags [ map ]"
}

variable "vpc_id" {
  description = "VPC ID [ string ]"
}

variable "rules" {
  type = "list"
  description = "A list of Rules [ list ]"
}
