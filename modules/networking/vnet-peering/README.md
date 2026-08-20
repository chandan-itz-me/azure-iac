# networking/vnet-peering

Creates a peering from a local virtual network to a remote virtual network, and
optionally the reverse peering back from the remote virtual network. `virtual_network_id`
must be supplied even though the local peering resource only needs the local
virtual network name, because it becomes the `remote_virtual_network_id` of the
reverse peering.

## Usage

```hcl
module "hub_to_spoke" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet-peering?ref=v1.0.0"

  name                  = "hub-to-spoke"
  resource_group_name   = azurerm_resource_group.hub.name
  virtual_network_name  = module.hub_vnet.vnet_name
  virtual_network_id    = module.hub_vnet.vnet_id

  remote_virtual_network_id = module.spoke_vnet.vnet_id

  allow_gateway_transit = true

  create_reverse_peering     = true
  peer_resource_group_name   = azurerm_resource_group.spoke.name
  peer_virtual_network_name  = module.spoke_vnet.vnet_name
  reverse_use_remote_gateways = true
}
```

### Cross-subscription peering

`create_reverse_peering` only works when the remote virtual network is reachable
through this module's default `azurerm` provider configuration (same subscription,
or a subscription the default provider is authorized against). This module
deliberately does not declare `configuration_aliases` or a `provider` block, so it
stays a plain single-provider module. For peerings across subscriptions, set
`create_reverse_peering = false` here and instantiate this module a second time
against the remote subscription, passing an aliased provider from the root module:

```hcl
provider "azurerm" {
  alias           = "peer"
  subscription_id = "<remote-subscription-id>"
  features {}
}

module "spoke_to_hub" {
  source = "git::https://github.com/chandan-itz-me/azure-iac.git//modules/networking/vnet-peering?ref=v1.0.0"

  providers = {
    azurerm = azurerm.peer
  }

  name                       = "spoke-to-hub"
  resource_group_name        = azurerm_resource_group.spoke.name
  virtual_network_name       = module.spoke_vnet.vnet_name
  virtual_network_id         = module.spoke_vnet.vnet_id
  remote_virtual_network_id  = module.hub_vnet.vnet_id
  use_remote_gateways        = true
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
| [azurerm_virtual_network_peering.reverse](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input\_name) | Name of the peering created from the local virtual network to the remote virtual network. | `string` | n/a | yes |
| <a name="input_remote_virtual_network_id"></a> [remote\_virtual\_network\_id](#input\_remote\_virtual\_network\_id) | ID of the remote virtual network to peer with. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group the local virtual network lives in. | `string` | n/a | yes |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | ID of the local virtual network. Required as the remote\_virtual\_network\_id of the reverse peering when create\_reverse\_peering is true. | `string` | n/a | yes |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Name of the local virtual network to create the peering from. | `string` | n/a | yes |
| <a name="input_allow_forwarded_traffic"></a> [allow\_forwarded\_traffic](#input\_allow\_forwarded\_traffic) | Whether forwarded traffic from outside the remote virtual network is allowed in. | `bool` | `false` | no |
| <a name="input_allow_gateway_transit"></a> [allow\_gateway\_transit](#input\_allow\_gateway\_transit) | Whether the local virtual network's gateway is used by the remote virtual network. | `bool` | `false` | no |
| <a name="input_allow_virtual_network_access"></a> [allow\_virtual\_network\_access](#input\_allow\_virtual\_network\_access) | Whether resources in the local virtual network can access resources in the remote virtual network. | `bool` | `true` | no |
| <a name="input_create_reverse_peering"></a> [create\_reverse\_peering](#input\_create\_reverse\_peering) | Whether to also create the reverse peering, from the remote virtual network back to the local one. Requires peer\_resource\_group\_name and peer\_virtual\_network\_name. Only valid when the remote virtual network is reachable through this module's default azurerm provider configuration; for cross-subscription peering, leave this false and instantiate this module a second time against the remote subscription with providers = { azurerm = azurerm.peer } instead. | `bool` | `false` | no |
| <a name="input_peer_resource_group_name"></a> [peer\_resource\_group\_name](#input\_peer\_resource\_group\_name) | Name of the resource group the remote virtual network lives in. Required when create\_reverse\_peering is true. | `string` | `null` | no |
| <a name="input_peer_virtual_network_name"></a> [peer\_virtual\_network\_name](#input\_peer\_virtual\_network\_name) | Name of the remote virtual network. Required when create\_reverse\_peering is true. | `string` | `null` | no |
| <a name="input_reverse_allow_forwarded_traffic"></a> [reverse\_allow\_forwarded\_traffic](#input\_reverse\_allow\_forwarded\_traffic) | Whether forwarded traffic from outside the local virtual network is allowed in, for the reverse peering. | `bool` | `false` | no |
| <a name="input_reverse_allow_gateway_transit"></a> [reverse\_allow\_gateway\_transit](#input\_reverse\_allow\_gateway\_transit) | Whether the remote virtual network's gateway is used by the local virtual network, for the reverse peering. | `bool` | `false` | no |
| <a name="input_reverse_allow_virtual_network_access"></a> [reverse\_allow\_virtual\_network\_access](#input\_reverse\_allow\_virtual\_network\_access) | Whether resources in the remote virtual network can access resources in the local virtual network, for the reverse peering. | `bool` | `true` | no |
| <a name="input_reverse_peering_name"></a> [reverse\_peering\_name](#input\_reverse\_peering\_name) | Name of the reverse peering. Defaults to "<name>-reverse" when not set. | `string` | `null` | no |
| <a name="input_reverse_use_remote_gateways"></a> [reverse\_use\_remote\_gateways](#input\_reverse\_use\_remote\_gateways) | Whether the remote virtual network uses the local virtual network's gateway, for the reverse peering. | `bool` | `false` | no |
| <a name="input_use_remote_gateways"></a> [use\_remote\_gateways](#input\_use\_remote\_gateways) | Whether the local virtual network uses the remote virtual network's gateway. | `bool` | `false` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_peering_id"></a> [peering\_id](#output\_peering\_id) | ID of the peering from the local virtual network to the remote virtual network. |
| <a name="output_peering_state"></a> [peering\_state](#output\_peering\_state) | Reserved for the peering's connectivity state. Always null: the azurerm provider no longer exports this attribute, query the peering with the azurerm\_virtual\_network\_peering data source if needed. |
| <a name="output_reverse_peering_id"></a> [reverse\_peering\_id](#output\_reverse\_peering\_id) | ID of the reverse peering, when create\_reverse\_peering is true. |
<!-- END_TF_DOCS -->
