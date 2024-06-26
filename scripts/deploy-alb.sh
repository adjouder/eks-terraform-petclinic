#!/bin/bash

if [ -f ".env" ]; then
  export $(cat .env | xargs)
fi

echo "Déploiement de l'infrastructure..."

MAX_RETRIES=2
COUNTER=0

# Fonction pour déployer avec Terraform
apply_terraform() {
  echo "Tentative de déploiement: $((COUNTER+1))"
  terraform apply -auto-approve
  return $?
}

while [ $COUNTER -lt $MAX_RETRIES ]; do
  apply_terraform
  if [ $? -eq 0 ]; then
    echo "Déploiement réussi !"
    break
  else
    echo "Échec du déploiement, tentative de nouveau..."
    COUNTER=$((COUNTER+1))
  fi
done

# Vérifier si le déploiement a finalement échoué après toutes les tentatives
if [ $COUNTER -eq $MAX_RETRIES ]; then
  echo "Échec du déploiement après $MAX_RETRIES tentatives."
  exit 1
fi

# Mettre à jour le kubeconfig
rm -rf ~/.kube/config
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
export KUBECONFIG=~/.kube/config:~/.kube/config-$(terraform output -raw cluster_name)

# Récupérer les informations de l'infrastructure
cluster_name=$(terraform output -raw cluster_name)
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
echo $cluster_name
echo $oidc_id

# Déployer le load balancer controller
echo "Déploiement du load balancer controller..."
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
eksctl utils associate-iam-oidc-provider --region $(terraform output -raw region) --cluster $(terraform output -raw cluster_name) --approve
aws_lb_controller_iam_role_name=$cluster_name-alb-controller
aws_account_id=$(aws sts get-caller-identity --query Account --output text)
cat >aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::$aws_account_id:role/$aws_lb_controller_iam_role_name
EOF
kubectl apply -f aws-load-balancer-controller-service-account.yaml
rm aws-load-balancer-controller-service-account.yaml

# Déployer le load balancer controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$cluster_name --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

echo "Déploiement terminé !"

# Mise à jour des variables CI/CD gitlab pour le déploiement
echo "Mise à jour des variables CI/CD gitlab pour le déploiement..."


DB_URL_CUSTOMERS=$(terraform output -raw customer_db_endpoint_main)
DB_URL_VISITS=$(terraform output -raw visit_db_endpoint_main)
DB_URL_VETS=$(terraform output -raw vets_db_endpoint_main)
DB_PASSWORD_CUSTOMERS=$(terraform output -raw customer_db_password_main)
DB_PASSWORD_VISITS=$(terraform output -raw visit_db_password_main)
DB_PASSWORD_VETS=$(terraform output -raw vet_db_password_main)
echo "DB_URL_CUSTOMERS:$DB_URL_CUSTOMERS"
echo "DB_URL_VISITS:$DB_URL_VISITS"
echo "DB_URL_VETS:$DB_URL_VETS"
echo "DB_PASSWORD_CUSTOMERS:$DB_PASSWORD_CUSTOMERS"
echo "DB_PASSWORD_VISITS:$DB_PASSWORD_VISITS"
echo "DB_PASSWORD_VETS:$DB_PASSWORD_VETS"

# Update du kubeconfig
KUBE_CONFIG_CONTENT=$(cat ~/.kube/config)  | base64
echo "KUBE_CONFIG_CONTENT : $KUBE_CONFIG_CONTENT"

# Trigger le pipeline de déploiement
echo "Trigger le pipeline de déploiement..."
#curl -X POST \
#     --fail \
#     -F token=$GITLAB_CI_TOKEN \
 #    -F ref=master \
  #   https://gitlab.com/api/v4/projects/$GITLAB_PROJECT_ID/trigger/pipeline


# Sleep pour laisser le temps au pipeline de se terminer
echo ""
echo "Sleep 5 minutes pour laisser le temps au pipeline de se terminer..."
#sleep 300

  # Paramètres de retry du load balancer
  maxAttempts=10
  delay=30

  # Récupérer l'URL du Load Balancer pour API Gateway
  attempt=1
  while [ $attempt -le $maxAttempts ]; do
      echo "Tentative $attempt sur $maxAttempts pour obtenir l'URL du Load Balancer pour API Gateway..."
      apiGatewayLoadBalancerURL=$(kubectl get ingress api-gateway -n spring-petclinic -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

      if [ -n "$apiGatewayLoadBalancerURL" ]; then
          echo "URL du Load Balancer pour API Gateway trouvée: $apiGatewayLoadBalancerURL"
          break
      else
          echo "URL du Load Balancer pour API Gateway non trouvée, nouvelle tentative dans $delay secondes..."
          sleep $delay
      fi

      ((attempt++))
  done

  # Vérifier si l'URL est récupérée
  if [ -z "$apiGatewayLoadBalancerURL" ]; then
      echo "<Échec a>près $maxAttempts tentatives pour API Gateway."
      exit 1
  fi
echo "Déploiement terminé !"