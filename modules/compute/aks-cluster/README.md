# compute/aks-cluster

Creates a private-by-default AKS cluster with Azure AD/RBAC integration, the Key Vault Secrets
Provider add-on and optional Container Insights via `oms_agent`. Additional user node pools are
created from a map so workloads with different sizing or isolation requirements can be scheduled
onto dedicated pools.

## Usage

```hcl
module "aks" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/aks-cluster?ref=v1.0.0"

  name                = "platform-aks"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  dns_prefix          = "platform-aks"

  default_node_pool = {
    vm_size              = "Standard_D4s_v5"
    enable_auto_scaling  = true
    min_count            = 3
    max_count            = 6
    vnet_subnet_id       = module.subnet.subnet_id
  }

  log_analytics_workspace_id = module.log_analytics.workspace_id
  admin_group_object_ids     = [var.aks_admins_group_id]

  additional_node_pools = {
    workloads = {
      vm_size    = "Standard_D8s_v5"
      node_count = 2
      mode       = "User"
    }
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
