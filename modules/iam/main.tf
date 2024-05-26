# This Terraform file defines IAM roles and policies for an EKS cluster and worker nodes.
resource "aws_iam_role" "eks_iam_role" {
  name = "${var.cluster_name}-eks-role"

  path = "/"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    name = "eks-cluster-iam-role"
  }
}

# Attach policies to EKS cluster IAM role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AWSCertificateManagerReadOnly-EKS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerReadOnly"
  role       = aws_iam_role.eks_iam_role.name
}

# Create IAM role and policies for worker nodes
resource "aws_iam_role" "workernodes" {
  name = "${var.cluster_name}-worker-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workernodes.name
}

resource "aws_iam_role_policy_attachment" "AWSCertificateManagerReadOnly-EKS2" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerReadOnly"
  role       = aws_iam_role.workernodes.name
}
# Create IAM role and policy for Kubernetes ALB controller
resource "aws_iam_policy" "kubernetes_alb_controller" {
  name        = "${var.cluster_name}-alb-controller-policy"
  path        = "/"
  description = "Policy for load balancer controller service"

  policy = file("modules/iam/policy/alb_iam_policy.json")
}

resource "aws_iam_role" "kubernetes_alb_controller" {
  name = "${var.cluster_name}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/${replace(var.oidc_issuer_url, "https://", "")}"
        },
        Condition = {
          StringEquals = {
            "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller",
            "${replace(var.oidc_issuer_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kubernetes_alb_controller" {
  role       = aws_iam_role.kubernetes_alb_controller.name
  policy_arn = aws_iam_policy.kubernetes_alb_controller.arn
}
