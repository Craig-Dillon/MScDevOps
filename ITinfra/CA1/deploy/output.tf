output "cluster_name" {
  value = azurerm_kubernetes_cluster.control_plane.name
}

output "control_ip" {
    value = azurerm_public_ip_prefix.control_prefix.ip_prefix
}

output "production_ip" {
    value = azurerm_public_ip_prefix.production_prefix.ip_prefix
}

#output "staging_ip" {
#    value = azurerm_public_ip_prefix.staging_prefix.ip_prefix
#}
#
#output "dev_ip" {
#    value = azurerm_public_ip_prefix.dev_prefix.ip_prefix
#}

resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.control_plane]
  filename     = "kubeconfig"
  content      = azurerm_kubernetes_cluster.control_plane.kube_config_raw
}