#!/bin/bash
# install the controller in the ingress-nginx namespace, creating that namespace if it doesn't already exist.
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml

# wait for 2 min till controller is running
sleep 2m

# check status of ingress nginx controller
kubectl get pods --namespace=ingress-nginx

# deploy juice-shop
kubectl create deployment demo --image=bkimminich/juice-shop --port=3000

# wait for 2 min till juice-shop is running
sleep 3m

# check status of juice-shop
kubectl get pods

# expose deploy inside the cluster
kubectl expose deployment demo --port=80 --target-port=3000

# remove the nginx ingress webhook, it cause an issue when create ingress
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

# create ingress resource
kubectl create ingress demo-localhost --class=nginx --rule="demo.localdev.me/*=demo:80" --default-backend=demo:80

# forward local port to the ingress controller
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80 & disown

curl http://demo.localdev.me:8080/