###### VARIABLES ######

variable "eks_nodes_sg_rules" {
   type = "list"
   description = "eks nodes SG rules"
}


###### MODULES ######

module "eks_nodes" {
  source = "./modules/aws_tf_module_sg"
  name = "${replace(local.name,"-","_")}_eks_nodes_sg"
  vpc_id = "${module.vpc.vpc_id}"
  rules = "${var.eks_nodes_sg_rules}"
  tags = "${local.tags}"
}

locals {
  eks-nodes-userdata = <<USERDATA
#!/bin/bash -xe
CA_CERTIFICATE_DIRECTORY=/etc/kubernetes/pki
CA_CERTIFICATE_FILE_PATH=$CA_CERTIFICATE_DIRECTORY/ca.crt
mkdir -p $CA_CERTIFICATE_DIRECTORY
echo "${aws_eks_cluster.eks-cluster.certificate_authority.0.data}" | base64 -d >  $CA_CERTIFICATE_FILE_PATH
INTERNAL_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
sed -i s,MASTER_ENDPOINT,${aws_eks_cluster.eks-cluster.endpoint},g /var/lib/kubelet/kubeconfig
sed -i s,CLUSTER_NAME,${var.cluster_defaults["name"]},g /var/lib/kubelet/kubeconfig
sed -i s,REGION,${var.aws_region},g /etc/systemd/system/kubelet.service
sed -i s,MAX_PODS,30,g /etc/systemd/system/kubelet.service
sed -i s,MASTER_ENDPOINT,${aws_eks_cluster.eks-cluster.endpoint},g /etc/systemd/system/kubelet.service
sed -i s,INTERNAL_IP,$INTERNAL_IP,g /etc/systemd/system/kubelet.service
DNS_CLUSTER_IP=10.100.0.10
if [[ $INTERNAL_IP == 10.* ]] ; then DNS_CLUSTER_IP=172.20.0.10; fi
sed -i s,DNS_CLUSTER_IP,$DNS_CLUSTER_IP,g /etc/systemd/system/kubelet.service
sed -i '/--node-ip/ a \ \ --node-labels group=node \\' /etc/systemd/system/kubelet.service
sed -i s,CERTIFICATE_AUTHORITY_FILE,$CA_CERTIFICATE_FILE_PATH,g /var/lib/kubelet/kubeconfig
sed -i s,CLIENT_CA_FILE,$CA_CERTIFICATE_FILE_PATH,g  /etc/systemd/system/kubelet.service
systemctl daemon-reload
systemctl restart kubelet kube-proxy
USERDATA
}

resource "aws_launch_configuration" "config" {
  associate_public_ip_address = false
  iam_instance_profile        = "${aws_iam_instance_profile.eks-nodes.name}"
  image_id                    = "${var.nodes_defaults["ami_id"]}"
  instance_type               = "${var.nodes_defaults["instance_type"]}"
  key_name                    = "${var.nodes_defaults["key_name"]}"
  name_prefix                 = "eks-config"
  security_groups             = ["${module.eks_nodes.id}"]
  user_data_base64            = "${base64encode(local.eks-nodes-userdata)}"
  ebs_optimized               = "${var.nodes_defaults["ebs_optimized"]}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "autoscaling-group" {
  desired_capacity     = "${var.nodes_defaults["asg_desired_capacity"]}"
  launch_configuration = "${aws_launch_configuration.config.id}"
  max_size             = "${var.nodes_defaults["asg_max_size"]}"
  min_size             = "${var.nodes_defaults["asg_min_size"]}"
  name                 = "${var.nodes_defaults["name"]}-asg"

  vpc_zone_identifier = [
       "${module.app1_aws_prv.ids}"
  ]

  tag {
    key                 = "Name"
    value               = "${var.nodes_defaults["name"]}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_defaults["name"]}"
    value               = "owned"
    propagate_at_launch = true
  }
}


###### IAM-ROLE ######

resource "aws_iam_instance_profile" "eks-nodes" {
  name = "${var.nodes_defaults["name"]}"
  role = "${aws_iam_role.eks-nodes.name}"
}

resource "aws_iam_role" "eks-nodes" {
  name               = "${var.nodes_defaults["name"]}"
  path               = "/"
  assume_role_policy = "${file("./json/nodes-role-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.eks-nodes.name}"
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.eks-nodes.name}"
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.eks-nodes.name}"
}
