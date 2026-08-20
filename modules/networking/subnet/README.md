# networking/subnet

Creates one or more subnets within an existing virtual network from a map of subnet
definitions. Each subnet can optionally declare service endpoints, a service
delegation, and an association to an existing network security group and/or route
table.

## Usage

```hcl
module "subnets" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/subnet?ref=v1.0.0"

  resource_group_name  = azurerm_resource_group.platform.name
  virtual_network_name = module.vnet.vnet_name

  subnets = {
    app = {
      address_prefixes           = ["10.0.1.0/24"]
      network_security_group_id  = module.nsg_app.nsg_id
      service_endpoints          = ["Microsoft.Storage"]
    }

    data = {
      address_prefixes = ["10.0.2.0/24"]
      route_table_id    = azurerm_route_table.private.id
    }

    web = {
      address_prefixes = ["10.0.3.0/24"]

      delegation = {
        name = "webapp-delegation"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    }
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
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the virtual network lives in. | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create, keyed by subnet name. | <pre>map(object({<br/>    address_prefixes  = list(string)<br/>    service_endpoints = optional(list(string), [])<br/>    delegation = optional(object({<br/>      name = string<br/>      service_delegation = object({<br/>        name    = string<br/>        actions = optional(list(string), [])<br/>      })<br/>    }), null)<br/>    private_endpoint_network_policies             = optional(string, "Disabled")<br/>    private_link_service_network_policies_enabled = optional(bool, true)<br/>    network_security_group_id                     = optional(string, null)<br/>    route_table_id                                = optional(string, null)<br/>  }))</pre> | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the existing virtual network to create subnets in. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_subnet_address_prefixes"></a> [subnet\_address\_prefixes](#output\_subnet\_address\_prefixes) | Map of subnet name to its address prefixes. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Map of subnet name to subnet ID. |
<!-- END_TF_DOCS -->
