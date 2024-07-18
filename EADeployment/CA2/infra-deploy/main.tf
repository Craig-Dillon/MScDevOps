resource "azurerm_container_registry" "acr" {
  name                = "akstestacr04024"
  resource_group_name = var.rg
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

##### Lets try AKS with Cilium instead, Istio ingress is having issues with Cert-manager


#resource "azurerm_virtual_network" "azurecilium" {
#  name                = "azurecilium-vnet"
#  address_space       = ["192.168.10.0/24"]
#  location            = var.location
#  resource_group_name = var.rg
#}
#
#resource "azurerm_subnet" "azurecilium" {
#  name                 = "azurecilium-subnet"
#  resource_group_name  = var.rg
#  virtual_network_name = azurerm_virtual_network.azurecilium.name
#  address_prefixes     = ["192.168.10.0/24"]
#}
#
#resource "azurerm_kubernetes_cluster" "azurecilium" {
#  name                = "akscilium"
#  location            = var.location
#  resource_group_name = var.rg
#  dns_prefix          = "azurecilium"
#  node_resource_group = "${var.rg}-aks"
#  
#  default_node_pool {
#    name           = "azurecilium"
#    node_count     = 2
#    vm_size        = "Standard_DS2_v2"
#    vnet_subnet_id = azurerm_subnet.azurecilium.id
#  }
#  identity {
#    type = "SystemAssigned"
#  }
#  network_profile {
#    network_plugin = "none"
#  }
#}
#
resource "azurerm_log_analytics_workspace" "analytics_workspace" {
    name                = "cdillon-devops-loganalytics"
    location            = var.location
    resource_group_name = var.rg
    sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "aks" {
  location              = var.location
  resource_group_name   = var.rg
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.analytics_workspace.name
  workspace_resource_id = azurerm_log_analytics_workspace.analytics_workspace.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster"
  location            = var.location
  resource_group_name = var.rg
  dns_prefix          = "aks-cluster"
  kubernetes_version  = "1.28.5"
  node_resource_group = "${var.rg}-aks"

  default_node_pool {
    min_count  = 1
    max_count  = 3
    name       = "nodepool"
    vm_size    = "standard_d8ds_v5"
    enable_auto_scaling = true
    os_disk_type = "Managed"
    os_disk_size_gb = 30
    type       = "VirtualMachineScaleSets"
    zones      = ["1", "2", "3"]
  }


  oms_agent {
		log_analytics_workspace_id = azurerm_log_analytics_workspace.analytics_workspace.id
    }

  identity {
    type = "SystemAssigned"
  }

  http_application_routing_enabled = true

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
  network_profile {
    network_plugin = "none"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw

  sensitive = true
}
