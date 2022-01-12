CLUSTER_NAME   := fargate-cluster1
CLUSTER_CONFIG := bootstrap/eks/$(CLUSTER_NAME).yaml
CLUSTER_REGION := eu-west-1

UNAME_S        := $(shell uname -s)

default: bootstrap-minikube bootstrap-services

#
# Create Kubernetes cluster
#
create: create-eks

create-eks: bootstrap-eks bootstrap-services

create-minikube: bootstrap-minikube bootstrap-services

bootstrap-eks:
	eksctl create cluster -f $(CLUSTER_CONFIG)

bootstrap-minikube:
	minikube start --cpus=2 --memory=4g

bootstrap-services:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/applicationset/stable/manifests/install.yaml
	kubectl apply -f bootstrap/bootstrap.yaml

#
# Install targets
#
install: install-aws-cli install-eksctl install-arkade install-tools

install-aws-cli:
ifeq ($(UNAME_S), Linux)
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
else
	curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
	sudo installer -pkg AWSCLIV2.pkg -target /
endif

install-eksctl:
	curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(UNAME_S)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/local/bin

install-arkade:
	curl -sLS https://dl.get-arkade.dev | sudo sh

install-tools:
	ark get minikube
	ark get kubectl
	ark get helm
	ark get kustomize
	ark get kubectx
	ark get kubens
	ark get argocd
	ark get yq

#
# Remove everything
#
clean: clean-eks

clean-files:
	rm -rf aws
	rm -f awscliv2.zip
	rm -f AWSCLIV2.pkg

clean-eks: clean-files
	eksctl delete cluster $(CLUSTER_NAME) --region $(CLUSTER_REGION)

clean-minikube: clean-files
	minikube delete

