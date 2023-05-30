# CA1

## About this repository

This repo will run a Terraform manifest that deploys several AKS clusters on Azure each with their own AGIC (Application Gateway Ingress Controller), which allows applications to be accessed from outside the cluster or resource group (usually from the internet). The state of this deployment is stored in an Azure blob which was deployed ahead of time.

An Azure Service Principal is required for this and must have the relevant permissions to create and destroy resources.

The CI pipeline runs on a docker container, installs necessary packages for Terraform, runs a validation and plan stage automatically. Once these stages pass, a manual trigger will then deploy to Azure.

All going well, the next part of the pipeline is also manual, although it could be triggered automatically if the deploy job completes successfully. This job will then connect to az cli using a Service Principal created beforehand and connects to the control plane AKS cluster and deploys ArgoCD and avails of the AGIC frontend as a means of external access.

## Next Steps

Next, you will need to obtain the username and password for ArgoCD. You'll need AZ Cli for this part and you should already be logged in to your tenancy/subscription. I would recommend using the Service Principal created.

Once you have logged in to Azure via cli, run the following;
az aks get-credentials -g k8s_testing -n control-plane
kubectl config use-context control-plane
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

which will display the argocd password, username is admin and you can find the public IP address under networking within the AKS cluster on the Azure UI.