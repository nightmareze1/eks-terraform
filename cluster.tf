###### VARIABLES ######

variable "eks_masters_sg_rules" {
  type = "list"
  description = "eks masters SG rules"
}


###### MODULES ######
module "eks_cluster_sg" {
  source = "./modules/aws_tf_module_sg"
  name = "${replace(local.name,"-","_")}_eks_cluster"
  vpc_id = "${module.vpc.vpc_id}"
  rules = "${var.eks_masters_sg_rules}"
  tags = "${local.tags}"
}

resource "aws_eks_cluster" "eks-cluster" {
  name     = "${var.cluster_defaults["name"]}"
  role_arn = "${aws_iam_role.eks-cluster.arn}"

  vpc_config {
    security_group_ids = ["${module.eks_cluster_sg.id}"]

    subnet_ids = ["${module.kubernetes_k8s_prv.ids}", "${module.general_aws_pub.ids}" ]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.k8s-cluster-AmazonEKSServicePolicy",
  ]
}

###### IAM-ROLE ######

resource "aws_iam_role" "eks-cluster" {
  name               = "${var.cluster_defaults["name"]}"
  path               = "/"
  assume_role_policy = "${file("./json/cluster-role-policy.json")}"
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "k8s-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks-cluster.name}"
}
