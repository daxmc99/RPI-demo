#!/bin/bash

# EUID only works in bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

. $(dirname ${BASH_SOURCE})/../util.sh

desc " start k3s server "
run  "k3s server --no-deploy traefik --no-deploy servicelb &"

# desc "There are no running pods"
# run "kubectl --namespace=demos get pods"

# desc "Create a pod"
# run "cat $(relative pod.yaml)"
# run "kubectl --namespace=demos create -f $(relative pod.yaml)"

# desc "Hey look, a pod!"
# run "kubectl --namespace=demos get pods"

# setup metallb 
desc "Setup metallb"
run "k3s kubectl apply -f $(relative metallb.yaml)"

# watch deployment for pods to come up
run "k3s kubectl get pods -n metallb-system"

run "cat $(relative metallbConfig.yaml)"

run "k3s kubectl logs -l component=speaker -n metallb-system" 

run "k3s kubectl apply -f $(relative nginxDeploy.yaml)"
run "k3s kubectl get service nginx"

desc "See if that works, feel free to curl that IP!"



# desc "Let's cleanup and delete that pod"
# run "kubectl --namespace=demos delete pod pods-demo-pod" 
# desc "Thanks!"
