####Virtual network, everything can reside in subnets on this
resource "azurerm_virtual_network" "aks_network" {
    name = "aks-network"
    address_space = ["10.0.0.0/10"]
    resource_group_name = var.resource_group
    location = var.location
}
####Subnet for the AKS clusters, does not face ingress gateway
resource "azurerm_subnet" "aks_subnet" {
    name = "aks-subnet"
    resource_group_name = var.resource_group
    virtual_network_name = azurerm_virtual_network.aks_network.name
    address_prefixes = ["10.10.0.0/22"]  
}
resource "azurerm_subnet" "production_subnet" {
    name = "production-subnet"
    resource_group_name = var.resource_group
    virtual_network_name = azurerm_virtual_network.aks_network.name
    address_prefixes = ["10.20.0.0/22"]  
}
#resource "azurerm_subnet" "staging_subnet" {
#    name = "staging-subnet"
#    resource_group_name = var.resource_group
#    virtual_network_name = azurerm_virtual_network.aks_network.name
#    address_prefixes = ["10.30.0.0/22"]  
#}
#resource "azurerm_subnet" "dev_subnet" {
#    name = "dev-subnet"
#    resource_group_name = var.resource_group
#    virtual_network_name = azurerm_virtual_network.aks_network.name
#    address_prefixes = ["10.40.0.0/22"]  
#}
####Subnet for ingress gateway
resource "azurerm_subnet" "pods_subnet" {
    name = "pods-subnet"
    resource_group_name = var.resource_group
    virtual_network_name = azurerm_virtual_network.aks_network.name
    address_prefixes = ["10.10.4.0/22"]  
}
####IP prefix for egress gateway
resource "azurerm_public_ip_prefix" "control_prefix" {
    name = "control-nat-prefix"
    resource_group_name = var.resource_group
    location = var.location
    ip_version = "IPv4"
    prefix_length = 29
    sku = "Standard"
    zones = ["1"]
}
resource "azurerm_public_ip_prefix" "production_prefix" {
    name = "production-nat-prefix"
    resource_group_name = var.resource_group
    location = var.location
    ip_version = "IPv4"
    prefix_length = 29
    sku = "Standard"
    zones = ["1"]
}
#resource "azurerm_public_ip_prefix" "staging_prefix" {
#    name = "staging-nat-prefix"
#    resource_group_name = var.resource_group
#    location = var.location
#    ip_version = "IPv4"
#    prefix_length = 29
#    sku = "Standard"
#    zones = ["1"]
#}
#resource "azurerm_public_ip_prefix" "dev_prefix" {
#    name = "dev-nat-prefix"
#    resource_group_name = var.resource_group
#    location = var.location
#    ip_version = "IPv4"
#    prefix_length = 29
#    sku = "Standard"
#   zones = ["1"]
#}
####Nat gateway to allow traffic out
resource "azurerm_nat_gateway" "control_gateway" {
    name = "control-gateway"
    resource_group_name = var.resource_group
    location = var.location
    sku_name = "Standard"
    idle_timeout_in_minutes = 10
    zones = ["1"]
}
resource "azurerm_nat_gateway" "production_gateway" {
    name = "production-gateway"
    resource_group_name = var.resource_group
    location = var.location
    sku_name = "Standard"
    idle_timeout_in_minutes = 10
    zones = ["1"]
}
#resource "azurerm_nat_gateway" "staging_gateway" {
#    name = "staging-gateway"
#    resource_group_name = var.resource_group
#    location = var.location
#    sku_name = "Standard"
#    idle_timeout_in_minutes = 10
#    zones = ["1"]
#}
#resource "azurerm_nat_gateway" "dev_gateway" {
#    name = "dev-gateway"
#    resource_group_name = var.resource_group
#    location = var.location
#    sku_name = "Standard"
#    idle_timeout_in_minutes = 10
#    zones = ["1"]
#}

####Assosciate the public IP and NAT IP
resource "azurerm_nat_gateway_public_ip_prefix_association" "control_ip" {
    nat_gateway_id = azurerm_nat_gateway.control_gateway.id
    public_ip_prefix_id = azurerm_public_ip_prefix.control_prefix.id
}
resource "azurerm_nat_gateway_public_ip_prefix_association" "production_ip" {
    nat_gateway_id = azurerm_nat_gateway.production_gateway.id
    public_ip_prefix_id = azurerm_public_ip_prefix.production_prefix.id
}
#resource "azurerm_nat_gateway_public_ip_prefix_association" "staging_ip" {
#    nat_gateway_id = azurerm_nat_gateway.staging_gateway.id
#    public_ip_prefix_id = azurerm_public_ip_prefix.staging_prefix.id
#}
#resource "azurerm_nat_gateway_public_ip_prefix_association" "dev_ip" {
#    nat_gateway_id = azurerm_nat_gateway.dev_gateway.id
#    public_ip_prefix_id = azurerm_public_ip_prefix.dev_prefix.id
#}
#####Assosciate nat gateway with the proper subnet
resource "azurerm_subnet_nat_gateway_association" "control_gateway" {
    subnet_id = azurerm_subnet.aks_subnet.id
    nat_gateway_id = azurerm_nat_gateway.control_gateway.id
}
resource "azurerm_subnet_nat_gateway_association" "production_gateway" {
    subnet_id = azurerm_subnet.production_subnet.id
    nat_gateway_id = azurerm_nat_gateway.production_gateway.id
}
#resource "azurerm_subnet_nat_gateway_association" "staging_gateway" {
#    subnet_id = azurerm_subnet.staging_subnet.id
#    nat_gateway_id = azurerm_nat_gateway.staging_gateway.id
#}
#resource "azurerm_subnet_nat_gateway_association" "dev_gateway" {
#    subnet_id = azurerm_subnet.dev_subnet.id
#    nat_gateway_id = azurerm_nat_gateway.dev_gateway.id
#}
####Exclude preview versions from latest for AKS cluster
data "azurerm_kubernetes_service_versions" "aks_version" {
    location = var.location
    include_preview = false
}
