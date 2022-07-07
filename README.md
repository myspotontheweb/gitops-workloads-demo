# gitops-workloads-demo

Demonstrate how Argo ApplicationSets work

# Software

The following tool dependencies

* kubectl
* kubectx
* kubens
* argocd cli

# QuickStart

Start a kubernetes cluster. The Makefile has logic to spinup a cluster on Azure (Can use other clouds or even minikube)

```
make provision SUBSCRIPTION=1234567890
make creds
````

Perform a "core" install of ArgoCD 

````
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml
```

Bootstrap workloads

```
kubectl -n argocd apply -f projects/dev.yaml
kubectl -n argocd apply -f projects/test.yaml
kubectl -n argocd apply -f projects/prod.yaml
```

Start the admin UI

```
kubens argocd
argocd admin dashboard
```

Argo CD UI is available at http://localhost:8080