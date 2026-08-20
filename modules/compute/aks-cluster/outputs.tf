output "cluster_id" {
  description = "ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "kube_config" {
  description = "Kube config block used to authenticate to the cluster."
  value       = azurerm_kubernetes_cluster.this.kube_config
  sensitive   = true
}

output "identity_principal_id" {
  description = "Principal ID of the cluster's managed identity."
  value       = try(azurerm_kubernetes_cluster.this.identity[0].principal_id, null)
}

output "kubelet_identity_object_id" {
  description = "Object ID of the cluster's kubelet identity, used to grant image pull and other node-level permissions."
  value       = try(azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id, null)
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL used for workload identity federation."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "node_resource_group" {
  description = "Name of the auto-generated resource group containing cluster infrastructure."
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
