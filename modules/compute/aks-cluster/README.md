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
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.90.0, < 4.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.117.1 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | Configuration for the cluster's default (system) node pool. | <pre>object({<br/>    vm_size                      = string<br/>    node_count                   = optional(number)<br/>    enable_auto_scaling          = optional(bool, false)<br/>    min_count                    = optional(number)<br/>    max_count                    = optional(number)<br/>    os_disk_size_gb              = optional(number)<br/>    only_critical_addons_enabled = optional(bool, true)<br/>    vnet_subnet_id               = optional(string)<br/>    zones                        = optional(list(string), [])<br/>  })</pre> | n/a | yes |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | DNS prefix used when creating the managed cluster's FQDN. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the cluster is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the AKS cluster. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the cluster is created in. | `string` | n/a | yes |
| <a name="input_additional_node_pools"></a> [additional\_node\_pools](#input\_additional\_node\_pools) | Map of additional node pools to create, keyed by a unique node pool name. | <pre>map(object({<br/>    vm_size             = string<br/>    node_count          = optional(number)<br/>    enable_auto_scaling = optional(bool, false)<br/>    min_count           = optional(number)<br/>    max_count           = optional(number)<br/>    mode                = optional(string, "User")<br/>    zones               = optional(list(string), [])<br/>    vnet_subnet_id      = optional(string)<br/>    node_taints         = optional(list(string), [])<br/>    node_labels         = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_admin_group_object_ids"></a> [admin\_group\_object\_ids](#input\_admin\_group\_object\_ids) | List of Azure AD group object IDs granted cluster admin access. | `list(string)` | `[]` | no |
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | List of CIDR ranges allowed to access the API server. Allows all when empty. | `list(string)` | `[]` | no |
| <a name="input_automatic_channel_upgrade"></a> [automatic\_channel\_upgrade](#input\_automatic\_channel\_upgrade) | Automatic upgrade channel for the cluster, patch, rapid, node-image, stable or null to disable. | `string` | `null` | no |
| <a name="input_azure_rbac_enabled"></a> [azure\_rbac\_enabled](#input\_azure\_rbac\_enabled) | Whether Azure RBAC is used for Kubernetes authorization in addition to Azure AD authentication. | `bool` | `true` | no |
| <a name="input_dns_service_ip"></a> [dns\_service\_ip](#input\_dns\_service\_ip) | IP address within service\_cidr used for cluster DNS. | `string` | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs. Required when identity\_type is UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to the cluster, SystemAssigned or UserAssigned. | `string` | `"SystemAssigned"` | no |
| <a name="input_key_vault_secrets_provider_enabled"></a> [key\_vault\_secrets\_provider\_enabled](#input\_key\_vault\_secrets\_provider\_enabled) | Whether the Azure Key Vault Secrets Provider add-on is enabled. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use. Uses the latest recommended version supported by AKS when null. | `string` | `null` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | ID of the Log Analytics workspace the oms\_agent add-on sends container insights to. Add-on is disabled when null. | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window allowed periods for cluster upgrades. | <pre>object({<br/>    allowed = list(object({<br/>      day   = string<br/>      hours = list(number)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Network plugin used by the cluster, azure or kubenet. | `string` | `"azure"` | no |
| <a name="input_network_policy"></a> [network\_policy](#input\_network\_policy) | Network policy used by the cluster, azure, calico or null to disable. | `string` | `null` | no |
| <a name="input_outbound_type"></a> [outbound\_type](#input\_outbound\_type) | Outbound routing method used by the cluster, userDefinedRouting or loadBalancer. | `string` | `"userDefinedRouting"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Whether the cluster's API server is only accessible from within the virtual network. | `bool` | `true` | no |
| <a name="input_secret_rotation_enabled"></a> [secret\_rotation\_enabled](#input\_secret\_rotation\_enabled) | Whether secret rotation is enabled for the Key Vault Secrets Provider add-on. Only used when key\_vault\_secrets\_provider\_enabled is true. | `bool` | `true` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | CIDR used for the Kubernetes service address range. Must not overlap with any subnet ranges. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the AKS cluster. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the cluster's managed identity. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kube config block used to authenticate to the cluster. |
| <a name="output_kubelet_identity_object_id"></a> [kubelet\_identity\_object\_id](#output\_kubelet\_identity\_object\_id) | Object ID of the cluster's kubelet identity, used to grant image pull and other node-level permissions. |
| <a name="output_name"></a> [name](#output\_name) | Name of the AKS cluster. |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | Name of the auto-generated resource group containing cluster infrastructure. |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | OIDC issuer URL used for workload identity federation. |
<!-- END_TF_DOCS -->
