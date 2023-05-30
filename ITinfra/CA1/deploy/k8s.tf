resource "azurerm_log_analytics_workspace" "analytics_workspace" {
    name                = "cdillon-devops-loganalytics"
    location            = var.location
    resource_group_name = var.resource_group
    sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "aks" {
  location              = var.location
  resource_group_name   = var.resource_group
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.analytics_workspace.name
  workspace_resource_id = azurerm_log_analytics_workspace.analytics_workspace.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_kubernetes_cluster" "control_plane" {
  name                = "control-plane"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "aks-controlplane"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.aks_version.latest_version
  node_resource_group = "${var.resource_group}-aks"

  default_node_pool {
    min_count  = 1
    max_count  = 3
    name       = "nodepool"
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    os_disk_type = "Managed"
    os_disk_size_gb = 30
    type       = "VirtualMachineScaleSets"
    zones      = ["1", "2", "3"]
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "172.16.0.10"
    docker_bridge_cidr = "172.18.0.1/16"
    service_cidr       = "172.16.0.0/16"
    load_balancer_sku  = "standard"
    outbound_type      = "userAssignedNATGateway"
    nat_gateway_profile {
      idle_timeout_in_minutes = 4
    }
  }
  
    oms_agent {
		log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
    }
	ingress_application_gateway  {
	    subnet_id                  = azurerm_subnet.pods_subnet.id
		gateway_name               = "control-plane-AGIC"
		}

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      network_profile[0].nat_gateway_profile
    ]
  }
}

resource "azurerm_kubernetes_cluster" "production_cluster" {
  name                = "production_cluster"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "aks-production-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.aks_version.latest_version
  node_resource_group = "${var.resource_group}-prod"

  default_node_pool {
    min_count  = 1
    max_count  = 3
    name       = "prodpool"
    vm_size    = "Standard_B2s"
    enable_auto_scaling = true
    os_disk_type = "Managed"
    os_disk_size_gb = 30
    type       = "VirtualMachineScaleSets"
    zones      = ["1", "2", "3"]
    vnet_subnet_id = azurerm_subnet.production_subnet.id
  }
  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "172.16.0.10"
    docker_bridge_cidr = "172.18.0.1/16"
    service_cidr       = "172.16.0.0/16"
    load_balancer_sku  = "standard"
    outbound_type      = "userAssignedNATGateway"
    nat_gateway_profile {
      idle_timeout_in_minutes = 4
    }
  }
  
    oms_agent {
		log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
    }
	ingress_application_gateway  {
	    subnet_id                  = azurerm_subnet.pods_subnet.id
		gateway_name               = "production-AGIC"
		}

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      network_profile[0].nat_gateway_profile
    ]
  }
}

#resource "azurerm_kubernetes_cluster" "staging_cluster" {
#  name                = "staging_cluster"
#  location            = var.location
#  resource_group_name = var.resource_group
#  dns_prefix          = "aks-staging-cluster"
#  kubernetes_version  = data.azurerm_kubernetes_service_versions.aks_version.latest_version
#  node_resource_group = "${var.resource_group}-staging"

#  default_node_pool {
#    min_count  = 1
#    max_count  = 3
#    name       = "stagingpool"
#    vm_size    = "Standard_B2s"
#    enable_auto_scaling = true
#    os_disk_type = "Managed"
#    os_disk_size_gb = 30
#    type       = "VirtualMachineScaleSets"
#    zones      = ["1", "2", "3"]
#    vnet_subnet_id = azurerm_subnet.staging_subnet.id
#  }
#  network_profile {
#    network_plugin     = "azure"
#    network_policy     = "azure"
#    dns_service_ip     = "172.16.0.10"
#    docker_bridge_cidr = "172.18.0.1/16"
#    service_cidr       = "172.16.0.0/16"
#    load_balancer_sku  = "standard"
#    outbound_type      = "userAssignedNATGateway"
#    nat_gateway_profile {
#      idle_timeout_in_minutes = 4
#    }
#  }
  
#    oms_agent {
#		log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
#    }
#	ingress_application_gateway  {
#	    subnet_id                  = azurerm_subnet.pods_subnet.id
#		gateway_name               = "staging-AGIC"
#		}

#  identity {
#    type = "SystemAssigned"
#  }

#  lifecycle {
#    ignore_changes = [
#      network_profile[0].nat_gateway_profile
#    ]
#  }
#}

#resource "azurerm_kubernetes_cluster" "dev_cluster" {
#  name                = "dev-cluster"
#  location            = var.location
#  resource_group_name = var.resource_group
#  dns_prefix          = "aks-dev-cluster"
#  kubernetes_version  = data.azurerm_kubernetes_service_versions.aks_version.latest_version
#  node_resource_group = "${var.resource_group}-dev"

#  default_node_pool {
#    min_count  = 1
#    max_count  = 3
#    name       = "devpool"
#    vm_size    = "Standard_B2s"
#    enable_auto_scaling = true
#    os_disk_type = "Managed"
#    os_disk_size_gb = 30
#    type       = "VirtualMachineScaleSets"
#    zones      = ["1", "2", "3"]
#    vnet_subnet_id = azurerm_subnet.dev_subnet.id
#  }
#  network_profile {
#    network_plugin     = "azure"
#    network_policy     = "azure"
#    dns_service_ip     = "172.16.0.10"
#    docker_bridge_cidr = "172.18.0.1/16"
#    service_cidr       = "172.16.0.0/16"
#    load_balancer_sku  = "standard"
#    outbound_type      = "userAssignedNATGateway"
#    nat_gateway_profile {
#      idle_timeout_in_minutes = 4
#    }
#  }
  
#    oms_agent {
#		log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
#    }
#	ingress_application_gateway  {
#	    subnet_id                  = azurerm_subnet.pods_subnet.id
#		gateway_name               = "dev-AGIC"
#		}

#  identity {
#    type = "SystemAssigned"
#  }

#  lifecycle {
#    ignore_changes = [
#      network_profile[0].nat_gateway_profile
#    ]
#  }
#}
