# This Terraform file defines the resources for an Amazon EKS cluster and its addons.
# It creates an EKS cluster with the specified name and VPC configuration.
# The cluster is associated with three addons: kube-proxy, coredns, and vpc-cni.
# Each addon is configured with a specific version and resolves conflicts on create and update.
# The addons are tagged with the "eks_addon" label.
# The addons depend on the EKS cluster resource.

resource "aws_eks_cluster" "petclinic_eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

# Create worker nodes for the EKS cluster
resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-eks-node-group"
  node_role_arn   = var.workernodes_iam_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = ["t3a.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    var.amazon_eks_worker_node_role_policy_attachment,
    var.amazon_eks_cni_role_policy_attachment,
    var.amazon_ec2_container_registry_read_only_role_policy_attachment,
    var.aws_certificate_manager_read_only_eks_role_policy_attachment
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.petclinic_eks_cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = "v1.28.4-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags = {
    "eks_addon" = "kube-proxy"
  }
  depends_on = [
    aws_eks_cluster.petclinic_eks_cluster
  ]
}

resource "aws_eks_addon" "core_dns" {
  cluster_name                = aws_eks_cluster.petclinic_eks_cluster.name
  addon_name                  = "coredns"
  addon_version               = "v1.10.1-eksbuild.6"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags = {
    "eks_addon" = "coredns"
  }
  depends_on = [
    aws_eks_cluster.petclinic_eks_cluster
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.petclinic_eks_cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.16.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  tags = {
    "eks_addon" = "vpc-cni"
  }
  depends_on = [
    aws_eks_cluster.petclinic_eks_cluster
  ]
}