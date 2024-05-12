# EKS TERRAFORM PETCLINIC

## Description
Ce projet Terraform vise à déployer une application petclinic sur AWS EKS. L'application est déployée avec un pipeline gitlab CI/CD. Le pipeline est configuré pour déployer l'application sur le cluster EKS.
L'application est déployée sur un espace de noms appelé petclinic.
L'application est déployée avec une base de données mysql sur RDS.
## Prérequis :
- Terraform
- AWS CLI
- Kubectl
- Un compte AWS 

To configure AWS, run the following command:

```bash
aws configure # permet de configure rla connexion aws en suivant les trois étapes
```

## Getting Started
Crér une fichier de variable terraform.tfvars et ajouter les valeurs suivantes 

```bash
petclinic_user = "petclinic" # L'utilisateur de l'application
petclinic_mysql_pwd = "password" # Password de application
cidr_vpc = "10.0.0.0/16" # CIDR Block for AWS VPC
availability_zones = ["eu-west-3a", "eu-west-3b"] # AWS Availability zones
cidr_public_subnets = ["10.0.0.0/24", "10.0.1.0/24"] # CIDR Blocks for public subnets
cidr_private_subnets = ["10.0.2.0/24", "10.0.3.0/24"] # CIDR Blocks for private subnets
aws_account_id = "1234567789" # l'identifiant du compte aws
cluster_name = "petclinic" # le nom du cluster
```

To build this terraform project, run the following command:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

Pour détruire l'infrastructure il faut exécuter la commande suivante
```bash
terraform destroy -auto-approve
```

To get the Kubernetes cluster config:

```bash
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

Pour utiliser bien notre cluster en local il faut dérouler les commandes suivantes:

```bash
export KUBECONFIG=~/.kube/config:~/.kube/config-$(terraform output -raw cluster_name)
```

ajouter a configuration Kube  pour que le pipeline de déploiement fonctionne correctement. copier le résultat dans la variable
```bash
cat ~/.kube/config | base64
```


To setup https on the application, you have to go to the AWS console and select the ALB created by the application. Then, you have to go to the Listeners tab and add a new listener on the port 443. You have to select the certificate created by the application.
Don't forget to setup the security group of the ALB to allow the port 443.

backups on EKS Cluster:

```bash
TODO
```
