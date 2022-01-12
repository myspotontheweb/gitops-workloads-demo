# gitops-workloads-demo

Demonstrate how Argo ApplicationSets work

# QuickStart

Run the following commands 

```
minikube start --cpus=2 --memory=4g
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/applicationset/stable/manifests/install.yaml
kubectl apply -f bootstrap/bootstrap.yaml
```

Start Proxy expose UI

```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Retrieve the argocd password

```
PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -ogo-template='{{.data.password | base64decode}}')
echo $PASS
```

Login to UI

* http://localhost:8080/

or login with CLI

```
argocd login localhost:8080 --insecure --username=admin --password=$PASS
```

