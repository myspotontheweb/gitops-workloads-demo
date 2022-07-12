
SEQ=1
NAME=scoil
SUBSCRIPTION=XXXXXXXXXXXX
REGION=eastus
NODES=2

RESOURCE_GROUP=$(NAME)-${LOGNAME}-$(SEQ)
REGISTRY_NAME=$(NAME)${LOGNAME}$(SEQ)
REGISTRY=$(REGISTRY_NAME).azurecr.io
CLUSTER=$(NAME)-$(SEQ)

#
# Targets
#
default: creds

#
# Auth
#
creds: creds-cluster creds-registry

creds-cluster:
	az aks get-credentials --resource-group $(RESOURCE_GROUP) --name $(CLUSTER) --overwrite-existing

creds-registry:
	az acr login --name $(REGISTRY)

#
# Cluster provisioning targets
#
provision: provision-aks-cluster

provision-setup:
	az account set --subscription $(SUBSCRIPTION)
	az group create --name $(RESOURCE_GROUP) --location $(REGION)

provision-registry: provision-setup
	az acr create --resource-group $(RESOURCE_GROUP) --name $(REGISTRY_NAME) --sku Basic

provision-aks-cluster: provision-registry
	az aks create --resource-group $(RESOURCE_GROUP) --name $(CLUSTER) --node-count $(NODES) --attach-acr $(REGISTRY_NAME)

#
# Purge infrastructure
#
purge:
	az group delete --name $(RESOURCE_GROUP) --no-wait --subscription $(SUBSCRIPTION)

