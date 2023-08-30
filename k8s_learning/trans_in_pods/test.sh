#!/bin/bash
set -e

sudo -i

kubectl apply -f r-deployment.yaml
kubectl get pods -o wide

