# This Terraform configuration file sets up the infrastructure for the Pet Clinic application.
# It uses modules to create a VPC, IAM roles, an EKS cluster, and an RDS database.


module "vpc" {
  source               = "./modules/vpc"
  availability_zones   = var.availability_zones
  cidr_public_subnets  = var.cidr_public_subnets
  cidr_private_subnets = var.cidr_private_subnets
  cidr_vpc             = var.cidr_vpc
  cluster_name    = var.cluster_name
}

module "natgateway" {
  source               = "./modules/natgateway"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
}

module "iam" {
  source          = "./modules/iam"
  cluster_name    = var.cluster_name
  oidc_issuer_url = module.eks.oidc_issuer_url
  aws_account_id  = var.aws_account_id
}

module "eks" {
  source               = "./modules/eks"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  public_subnet_ids   = module.vpc.public_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  cluster_name         = var.cluster_name
  workernodes_iam_role_arn = module.iam.workernodes_iam_role_arn
  amazon_eks_worker_node_role_policy_attachment = module.iam.amazon_eks_worker_node_role_policy_attachment
  amazon_eks_cni_role_policy_attachment = module.iam.amazon_eks_cni_role_policy_attachment
  amazon_ec2_container_registry_read_only_role_policy_attachment = module.iam.amazon_ec2_container_registry_read_only_role_policy_attachment
  aws_certificate_manager_read_only_eks_role_policy_attachment = module.iam.aws_certificate_manager_read_only_eks_role_policy_attachment
}

module "rds" {
  source               = "./modules/rds"
  petclinic_user       = var.petclinic_user
  petclinic_mysql_pwd  = var.petclinic_mysql_pwd
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  cidr_private_subnets = var.cidr_private_subnets
}

############ Monitoring with CloudWatch ##################

module "cloudwatch" {
  source = "./modules/cloudwatch"
  sns_topic_arn = var.sns_topic_arn
}
