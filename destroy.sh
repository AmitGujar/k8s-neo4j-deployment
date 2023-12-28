#!/bin/bash

helm uninstall my-neo4j

helm uninstall ingress-nginx -n public-ingress

helm uninstall cert-manager

helm uninstall rp 

kubectl delete -f ../issuer.yaml

kubectl delete -f ../demoingress.yaml

watch -n1 kubectl get all -n public-ingress

kubectl get all