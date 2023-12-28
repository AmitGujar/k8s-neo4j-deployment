#!/bin/bash

source req-check.sh

install_neo4j() {
    helm repo update
    echo "Initiating the neo4j deployment..."
    sleep 4
    kubectl apply -f storage-class-std-hdd.yaml
    helm upgrade --install my-neo4j neo4j/neo4j --values values.yml
}

setting_ingress() {
    # kubectl create namespace public-ingress
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
    watch -n1 kubectl get pods
    helm upgrade --install rp neo4j/neo4j-reverse-proxy -f ingress-values.yaml
    watch -n1 kubectl get ing
    kubectl delete -f ingress.yaml
}

install_neo4j
setting_ingress
install_cert_manager
apply_ingress_tls
config_revproxy
