######  GENERAL ######
aws_region = "us-east-1" #configure your account region
aws_profile = "your-aws-profile" #configure your boto profile
product = "itshellws"
env = "dev"
availability_zones = [
  "a",
  "b",
  "c"
]
key = "example" # real key in your .ssh/example.pem , write without .pem 

######  VPC  ######
vpc-cidr = "10.100.0.0/16" 
domain_name = "dev.itshellws-k8s.com"
reverse_zone = "100.10.in-addr.arpa"
enable_dns_hostnames = "true"
enable_dns_support = "true"

######  SUBNETS GENERAL ######
general_aws_pub_cidrs = [
  "10.100.0.0/24",
  "10.100.1.0/24",
  "10.100.2.0/24"
]

general_aws_prv_cidrs = [
  "10.100.4.0/24",
  "10.100.5.0/24",
  "10.100.6.0/24"
]

######  SUBNETS KUBERNETES ######
kubernetes_k8s_prv_cidrs = [
  "10.100.12.0/24",
  "10.100.13.0/24",
  "10.100.14.0/24"
]

######  SUBNETS APP1 ######
app1_aws_pub_cidrs = [
  "10.100.16.0/25",
  "10.100.16.128/25",
  "10.100.17.0/25"
]

app1_aws_prv_cidrs = [
  "10.100.18.0/25",
  "10.100.18.128/25",
  "10.100.19.0/25"
]

app1_k8s_prv_cidrs = [
  "10.100.20.0/24",
  "10.100.21.0/24",
  "10.100.22.0/24"
]

######  SUBNETS TRAEFIK ######
traefik_aws_pub_cidrs = [
  "10.100.48.0/25",
  "10.100.48.128/25",
  "10.100.49.0/25"
]

traefik_aws_prv_cidrs = [
  "10.100.50.0/25",
  "10.100.50.128/25",
  "10.100.51.0/25"
]

traefik_k8s_prv_cidrs = [
  "10.100.52.0/24",
  "10.100.53.0/24",
  "10.100.54.0/24"
]

###### SECURITY GROUPS - RULES  ######
eks_masters_sg_rules = [
  { type = "ingress", protocol = "tcp", from_port = 443, to_port = 443, cidr_blocks = "0.0.0.0/0", description = "" },
  { type = "ingress", protocol = "udp", from_port = 1194, to_port = 1194, cidr_blocks = "0.0.0.0/0", description = "" },
  { type = "egress", protocol = "all", from_port = 0, to_port = 0, cidr_blocks = "0.0.0.0/0", description = "" },
]

eks_nodes_sg_rules = [
   { type = "ingress", protocol = "tcp", from_port = 1025, to_port = 65535, cidr_blocks = "0.0.0.0/0", description =   "" },
   { type = "ingress", protocol = "all", from_port = 0, to_port = 65535, cidr_blocks = "0.0.0.0/0", description    =   "" },
   { type = "ingress", protocol = "udp", from_port = 1194, to_port = 1194, cidr_blocks = "0.0.0.0/0", description   = "" },
   { type = "egress", protocol = "all", from_port = 0, to_port = 0, cidr_blocks = "0.0.0.0/0", description = "" },
]
