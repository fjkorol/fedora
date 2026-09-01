#!/bin/bash


#instalacion de arkade
curl -sLS https://get.arkade.dev | sudo sh
echo; echo "Instalación de Tilt, jq, mkcert"; echo
arkade get tilt
arkade get jq
arkade get mkcert
arkade get docker-compose
sudo mv ~/.arkade/bin/* /usr/local/bin

#kubectl
arkade get kubectl --version=v1.36.3 
sudo mv ~/.arkade/bin/kubectl /usr/local/bin/


# Instalar Helm
arkade get helm
sudo mv ~/.arkade/bin/helm /usr/local/bin/

# Configurar repositorios
helm repo add metallb https://metallb.github.io/metallb
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add openebs https://openebs.github.io/charts
helm repo update
