# gitops-workloads-demo

This repository demonstrates how Helm based work loads can be managed by ArgoCD. 

## Application setup

The configuration for each application is stored under the [apps](apps) directory. There is a [chart](apps/demo1/chart) directory to store the helm chart of the application and an [envs](apps/demo1/envs) directory to record the helm values file to be used when deploying to the "dev", "test" or "prod" environments.

    apps
    ├── demo1
        ├── chart
        │   ├── Chart.yaml
        │   └── ..
        └── envs
            ├── values-dev.yaml
            ├── values-prod.yaml
            └── values-test.yaml

## Testing the helm chart

You can test the helm chart generation as follows.

    helm dependency build apps/demo1/chart
    helm template apps/demo1/chart -f apps/demo1/envs/values-dev.yaml

## ArgoCD configuration

The ArgoCD configuration for each environment is recorded in the following files.

* [projects/dev.yaml](projects/dev.yaml)
* [projects/test.yaml](projects/test.yaml)
* [projects/prod.yaml](projects/prod.yaml)

If you investigate you'll discover each file configures two things, an ArgoCD project and an ApplicationSet to deploy the helm charts.
Assuming each cluster is running ArgoCD you can bootstrap any of the workload sets as follows

    kubectl -n argocd apply -f projects/dev.yaml

# Software

The following tool dependencies

* kubectl
* kubectx
* kubens
* argocd cli

# QuickStart

Start a kubernetes cluster. The Makefile has logic to spinup a cluster on Azure (Can use other clouds or even minikube)

    make provision SUBSCRIPTION=1234567890
    make creds

Perform a "core" install of ArgoCD 

    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml

Bootstrap workloads

    kubectl -n argocd apply -f projects/dev.yaml
    kubectl -n argocd apply -f projects/test.yaml
    kubectl -n argocd apply -f projects/prod.yaml

Start the admin UI

    kubens argocd
    argocd admin dashboard

Argo CD UI is available at http://localhost:8080

# Cleanup

The following command will delete the Azure resource group created by this tutorial 

    make provision SUBSCRIPTION=1234567890

