variable "vpc_id" {
  type = "string"
  description = "VPC Id [ string ]"
}

variable "cidrs" {
  type = "list"
  description = "A CIDRs list [ list ]"
}

variable "tags" {
  type = "map"
  description = "Resources Tags [ map ]"
}

variable "name" {
  type = "string"
  description = "Name [ string ]"
}

variable "tier" {
  type = "string"
  description = "Tier [ string ]"
}

variable "region" {
  type = "string"
  description = "AWS Region [ string ]"
}

variable "availability_zones" {
  type = "list"
  description = "AWS Availability Zones [ list ]"
}

variable "public" {
  type = "string"
  description = "Public or Private subnet"
}
