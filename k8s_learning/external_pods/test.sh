kubectl apply -f nginx.yaml
kubectl apply -f nginx-svc.yaml

kubectl get pods -o wide
kubectl get svc -o wide

kubectl exec -it nginx-deployment-7848d4b86f-kp6nm -- /bin/bash
