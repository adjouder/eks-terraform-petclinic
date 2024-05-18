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

echo "Déploiement terminé !"