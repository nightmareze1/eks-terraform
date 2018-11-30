variable "cidr" {
  description = "CIDR [ A.B.C.D/Z ]"
}

# DNS 
variable "enable_dns_hostnames" {
  description = "Enable DNS Hostnames [ true | false ]"
}

variable "enable_dns_support" {
  description = "Enable DNS Support [ true | false ]"
}

# DHCP
variable "domain_name" {
  description = "dhcp domain name"
}

# General
variable "tags" {
  type = "map"
  description = "Tags [ MAP ]"
}

variable "name" {
  description = "Name [ STR ]"
}
