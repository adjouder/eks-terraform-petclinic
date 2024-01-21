output "endpoint" {
  value = aws_eks_cluster.petclinic.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.petclinic.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.petclinic.id
}
output "cluster_endpoint" {
  value = aws_eks_cluster.petclinic.endpoint
}
output "cluster_name" {
  value = aws_eks_cluster.petclinic.name
}