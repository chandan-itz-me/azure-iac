# networking/vnet

Creates a virtual network with optional custom DNS servers, BGP community and DDoS
protection plan association. Subnets, route tables and NAT gateways are deliberately
kept in separate modules so they can be composed per environment.

## Usage

```hcl
module "vnet" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet?ref=v1.0.0"

  name                = "platform-vnet"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  address_space       = ["10.0.0.0/16"]

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
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | List of IPv4/IPv6 address ranges for the virtual network. | `list(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region the virtual network is deployed to. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the virtual network and prefix applied to associated resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the virtual network is created in. | `string` | n/a | yes |
| <a name="input_bgp_community"></a> [bgp\_community](#input\_bgp\_community) | BGP community attached to the virtual network, in the format 12076:xxxxx. | `string` | `null` | no |
| <a name="input_ddos_protection_plan_id"></a> [ddos\_protection\_plan\_id](#input\_ddos\_protection\_plan\_id) | ID of an existing DDoS protection plan to associate with the virtual network. | `string` | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Custom DNS server IP addresses used by the virtual network. Uses Azure-provided DNS when empty. | `list(string)` | `[]` | no |
| <a name="input_enable_ddos_protection"></a> [enable\_ddos\_protection](#input\_enable\_ddos\_protection) | Whether the DDoS protection plan association is enabled. Only used when ddos\_protection\_plan\_id is set. | `bool` | `false` | no |
| <a name="input_flow_timeout_in_minutes"></a> [flow\_timeout\_in\_minutes](#input\_flow\_timeout\_in\_minutes) | UDP idle timeout in minutes applied to the virtual network, between 4 and 30. | `number` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to every resource created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_address_space"></a> [address\_space](#output\_address\_space) | Address space of the virtual network. |
| <a name="output_guid"></a> [guid](#output\_guid) | GUID of the virtual network. |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of the virtual network. |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | Name of the virtual network. |
<!-- END_TF_DOCS -->
