# compute/container-app

Creates an Azure Container App, optionally provisioning its Container Apps environment with VNet
integration and Log Analytics wiring. Containers, secrets and Dapr are configured from maps so
the same module backs single-container APIs and multi-container sidecar workloads.

## Usage

```hcl
module "container_app" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/compute/container-app?ref=v1.0.0"

  name                        = "checkout-api"
  resource_group_name         = azurerm_resource_group.app.name
  location                    = azurerm_resource_group.app.location
  log_analytics_workspace_id  = module.log_analytics.workspace_id
  infrastructure_subnet_id    = module.subnet.subnet_id

  containers = {
    api = {
      image  = "myregistry.azurecr.io/checkout-api:1.4.0"
      cpu    = 0.5
      memory = "1Gi"
      env = {
        ASPNETCORE_ENVIRONMENT = "Production"
      }
    }
  }

  ingress = {
    external_enabled = true
    target_port      = 8080
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
| [azurerm_container_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app) | resource |
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_containers"></a> [containers](#input\_containers) | Map of containers to run in the container app, keyed by a unique container name. | <pre>map(object({<br/>    image      = string<br/>    cpu        = number<br/>    memory     = string<br/>    env        = optional(map(string), {})<br/>    secret_env = optional(map(string), {})<br/>    liveness_probe = optional(object({<br/>      transport = string<br/>      port      = number<br/>      path      = optional(string)<br/>    }))<br/>    readiness_probe = optional(object({<br/>      transport = string<br/>      port      = number<br/>      path      = optional(string)<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the container app is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the container app. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the container app is created in. | `string` | n/a | yes |
| <a name="input_container_app_environment_id"></a> [container\_app\_environment\_id](#input\_container\_app\_environment\_id) | ID of an existing Container Apps environment. Required when create\_environment is false. | `string` | `null` | no |
| <a name="input_create_environment"></a> [create\_environment](#input\_create\_environment) | Whether a Container Apps environment is created by this module. Set to false to attach to an existing environment via container\_app\_environment\_id. | `bool` | `true` | no |
| <a name="input_dapr"></a> [dapr](#input\_dapr) | Dapr configuration for the container app. Dapr is disabled when null. | <pre>object({<br/>    app_id       = string<br/>    app_port     = number<br/>    app_protocol = optional(string, "http")<br/>  })</pre> | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs. Required when identity\_type includes UserAssigned. | `list(string)` | `[]` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | Type of managed identity assigned to the container app. | `string` | `"SystemAssigned"` | no |
| <a name="input_infrastructure_subnet_id"></a> [infrastructure\_subnet\_id](#input\_infrastructure\_subnet\_id) | ID of the subnet the Container Apps environment integrates with for VNet integration. Only used when create\_environment is true. | `string` | `null` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | Ingress configuration for the container app. Ingress is disabled when null. | <pre>object({<br/>    external_enabled = optional(bool, false)<br/>    target_port      = number<br/>    transport        = optional(string, "auto")<br/>    traffic_weight = optional(list(object({<br/>      latest_revision = optional(bool, true)<br/>      percentage      = number<br/>    })), [{ latest_revision = true, percentage = 100 }])<br/>  })</pre> | `null` | no |
| <a name="input_internal_load_balancer_enabled"></a> [internal\_load\_balancer\_enabled](#input\_internal\_load\_balancer\_enabled) | Whether the Container Apps environment is only accessible from within its virtual network. Only used when create\_environment is true. | `bool` | `false` | no |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | ID of the Log Analytics workspace used by the Container Apps environment. Required when create\_environment is true. | `string` | `null` | no |
| <a name="input_max_replicas"></a> [max\_replicas](#input\_max\_replicas) | Maximum number of replicas the container app scales to. | `number` | `10` | no |
| <a name="input_min_replicas"></a> [min\_replicas](#input\_min\_replicas) | Minimum number of replicas the container app scales to. | `number` | `0` | no |
| <a name="input_revision_mode"></a> [revision\_mode](#input\_revision\_mode) | Revision mode of the container app, Single or Multiple. | `string` | `"Single"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Map of secret name to value, referenced by containers via secret\_env. | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_id"></a> [app\_id](#output\_app\_id) | ID of the container app. |
| <a name="output_environment_id"></a> [environment\_id](#output\_environment\_id) | ID of the Container Apps environment the app runs in. |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | Fully qualified domain name of the container app's ingress endpoint, if ingress is enabled. |
| <a name="output_identity_principal_id"></a> [identity\_principal\_id](#output\_identity\_principal\_id) | Principal ID of the container app's system-assigned managed identity, if enabled. |
<!-- END_TF_DOCS -->
