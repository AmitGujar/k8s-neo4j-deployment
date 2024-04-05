#!/bin/bash

source req-check.sh

install_neo4j() {
    # applying secret which contains the certificate values of graph.akstest.tech
    kubectl apply -f neo4j-secret.yml | exit 1
    watch -n1 kubectl get secret
    helm repo add neo4j https://helm.neo4j.com/neo4j
    helm repo update
    echo "Initiating the neo4j deployment..."
    kubectl apply -f storage-class-std-hdd.yaml
    echo "creating persistant volume claim for the neo4j...."
    sleep 2
    kubectl apply -f pvc.yaml
    #helm upgrade --install my-neo4j neo4j/neo4j --values values.yml
    helm upgrade --install my-neo4j neo4j/neo4j-standalone --values values.yml --version 4.3.2
    watch -n1 kubectl get svc
    echo "paste the lb ip in dns records of graph.akstest.tech"
    # echo "re-applying the values with ssl block...."
    # helm upgrade --install my-neo4j neo4j/neo4j --values values.yml
}

setting_ingress() {
    kubectl create namespace public-ingress
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    echo "Installing ingress controller...."
    sleep 2
    helm upgrade --install ingress-nginx ingress-nginx \
        --repo https://kubernetes.github.io/ingress-nginx \
        --namespace public-ingress \
        --set controller.service.externalTrafficPolicy=Local
    watch -n1 kubectl get svc -n public-ingress

}

install_cert_manager() {
    echo "Hope you have updated the dns record of the domain..."
    sleep 4
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
    helm upgrade --install cert-manager jetstack/cert-manager --version v1.11.0
    kubectl apply -f issuer.yaml

}

apply_ingress_tls() {
    echo "It's showtime..."
    kubectl apply -f ingress.yaml
    sleep 50
    watch -n1 kubectl get ing
    watch -n1 kubectl get certificate
}

config_revproxy() {
    kubectl get svc
    echo "make sure to update this lb ip into the dns records"
    sleep 20
    helm upgrade --install rp neo4j/neo4j-reverse-proxy -f ingress-values.yaml
    watch -n1 kubectl get ing
    kubectl delete -f ingress.yaml
    helm upgrade my-neo4j neo4j/neo4j --values ssl_config_values.yml
    watch -n1 kubectl get pods
}

install_neo4j
# setting_ingress
# install_cert_manager
#apply_ingress_tls
#config_revproxy
