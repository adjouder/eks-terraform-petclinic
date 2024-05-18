#!/bin/bash

rm -rf ~/.kube/config
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
export KUBECONFIG=~/.kube/config:~/.kube/config-$(terraform output -raw cluster_name)

echo "Déploiement terminé !"

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
