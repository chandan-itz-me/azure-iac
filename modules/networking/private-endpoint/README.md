# networking/private-endpoint

Creates one or more private endpoints attached to a single subnet from a map of
endpoint definitions, each targeting a private link resource by ID and subresource
name. Supports manual connection approval and wiring an optional private DNS zone
group per endpoint.

## Usage

```hcl
module "private_endpoints" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/private-endpoint?ref=v1.0.0"

  name                = "platform"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  subnet_id           = module.subnets.subnet_ids["data"]

  endpoints = {
    storage = {
      private_connection_resource_id = azurerm_storage_account.this.id
      subresource_names              = ["blob"]
      private_dns_zone_ids           = [module.private_dns_blob.zone_id]
    }

    sql = {
      private_connection_resource_id = azurerm_mssql_server.this.id
      subresource_names              = ["sqlServer"]
      private_dns_zone_ids           = [module.private_dns_sql.zone_id]
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
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_location"></a> [location](#input\_location) | Azure region the private endpoints are deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Prefix applied to every private endpoint created by this module. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the private endpoints are created in. | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID of the subnet the private endpoints are attached to. | `string` | n/a | yes |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | Map of private endpoints to create, keyed by a logical name. | <pre>map(object({<br/>    private_connection_resource_id = string<br/>    subresource_names              = optional(list(string), [])<br/>    is_manual_connection           = optional(bool, false)<br/>    request_message                = optional(string, null)<br/>    private_dns_zone_ids           = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_network_interface_ids"></a> [network\_interface\_ids](#output\_network\_interface\_ids) | Map of logical endpoint name to its network interface ID. |
| <a name="output_private_endpoint_ids"></a> [private\_endpoint\_ids](#output\_private\_endpoint\_ids) | Map of logical endpoint name to its private endpoint resource ID. |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | Map of logical endpoint name to its private IP address. |
<!-- END_TF_DOCS -->
