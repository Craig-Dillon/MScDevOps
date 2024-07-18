# EADeployment



## Getting started

Project runs in a DAG (Directed Acyclic Graph) pipeline. Infrastructure deploys happen when changes are made to that folder. Application deploys happen when changes are made to that folder. This streamlines the pipeline process into tasks that are routinely run and tasks less often run.

## Caveats

Due to my subscription, I do not have permissions to create a service principle with RBAC rights to create another service principal for certain functions. As a result, some tasks that would otherwise be automated are manual in this repository.

* When the cluster deploys, a second resource group is created with the name aks_test-aks. This creates a number of resources that can be used by AKS. One of which is the DNS zone, a service principal needs to be granted access to this for signing LetsEncrypt certificates later.
* The transient nature of the zone means that all domain records in the ingress/certificate configuration files need to be updated. Again, in a production environment this would be static.
