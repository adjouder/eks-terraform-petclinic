output "cluster_id" {
  value = aws_eks_cluster.petclinic_eks_cluster.id
}

output "cluster_name" {
  value = aws_eks_cluster.petclinic_eks_cluster.name
}

output "oidc_issuer_url" {
  value = aws_eks_cluster.petclinic_eks_cluster.identity[0].oidc[0].issuer
}
