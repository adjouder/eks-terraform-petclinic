output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_iam_role.arn
}

output "workernodes_iam_role_arn" {
  value = aws_iam_role.workernodes.arn
}

# IAM Role Policy Attachments

output "amazon_eks_worker_node_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy
}

output "amazon_eks_cni_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
}

output "amazon_ec2_container_registry_read_only_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
}

output "aws_certificate_manager_read_only_eks_role_policy_attachment" {
  value = aws_iam_role_policy_attachment.AWSCertificateManagerReadOnly-EKS
}